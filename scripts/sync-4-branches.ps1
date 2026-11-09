<#
.SYNOPSIS
  Sync a source branch to target branches via Pull Requests + auto-merge (gh).

.DESCRIPTION
  Creates per-target sync branches from each target, merges the source into them,
  pushes the sync branches, opens PRs into the targets, and enables auto-merge
  (or merges immediately when allowed). Designed for protected branches where
  direct push/merge is blocked.

  Prerequisites:
  - git + GitHub CLI (`gh`) installed and authenticated (`gh auth status`)
  - push rights to the repo
  - repo/target rules may still block merge (e.g. verified signatures, required
    checks, "no merge commits"). Use -MergeMethod squash/rebase if merge commits
    are disallowed; signature/check requirements must be satisfied by repo policy.

  Default targets:
    main, chore/complete-mobile-tests-and-chat,
    dependabot/npm_and_yarn/functions/npm_and_yarn-a18cab04ac, v0/mobile-fullstack-ci
#>

[CmdletBinding()]
param(
  [string]$Source = "main",
  [string[]]$Targets = @(
    "main",
    "chore/complete-mobile-tests-and-chat",
    "dependabot/npm_and_yarn/functions/npm_and_yarn-a18cab04ac",
    "v0/mobile-fullstack-ci"
  ),
  [ValidateSet("merge", "squash", "rebase")]
  [string]$MergeMethod = "merge",
  [switch]$AutoMerge,   # gh pr merge --auto (merge when requirements pass)
  [switch]$MergeNow,    # gh pr merge immediately (may fail if checks required)
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Run([string]$cmd) {
  Write-Host ">> $cmd" -ForegroundColor DarkGray
  if ($DryRun) { return "" }
  $prev = $ErrorActionPreference; $ErrorActionPreference = "Continue"
  try {
    $out = (Invoke-Expression $cmd 2>&1 | Out-String)
    $code = $LASTEXITCODE
  } finally { $ErrorActionPreference = $prev }
  if ($code -ne 0) { throw $out }
  return $out
}

function TryRun([string]$cmd) {
  Write-Host ">> $cmd" -ForegroundColor DarkGray
  if ($DryRun) { return @{ ok = $true; out = "[dry-run]" } }
  $prev = $ErrorActionPreference; $ErrorActionPreference = "Continue"
  try {
    $out = (Invoke-Expression $cmd 2>&1 | Out-String)
    $code = $LASTEXITCODE
  } finally { $ErrorActionPreference = $prev }
  return @{ ok = ($code -eq 0); out = $out }
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { throw "gh CLI not found. Install GitHub CLI and run 'gh auth login'." }
$auth = TryRun "gh auth status"
if (-not $auth.ok) { Write-Warning "gh auth status reported an issue; continuing. Output:`n$($auth.out)" }

$initialBranch = (git rev-parse --abbrev-ref HEAD).Trim()
$repo = (gh repo view --json nameWithOwner -q .nameWithOwner 2>&1 | Out-String).Trim()
if (-not $repo) { $repo = "<unknown-repo>" }
$ts = Get-Date -Format "yyyyMMdd-HHmmss"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " SYNC VIA PR + AUTO-MERGE ($repo)" -ForegroundColor Cyan
Write-Host " Source: $Source | Targets: $($Targets -join ', ')" -ForegroundColor Cyan
Write-Host " Merge: $MergeMethod | AutoMerge=$AutoMerge MergeNow=$MergeNow DryRun=$DryRun" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

Run "git fetch origin --prune" | Out-Null
Run "git checkout $Source" | Out-Null
Run "git pull origin $Source --ff-only" | Out-Null
$sourceSha = (git rev-parse --short HEAD).Trim()

$results = @()
foreach ($target in $Targets) {
  Write-Host "`n--> Target '$target'" -ForegroundColor Magenta
  $item = [ordered]@{ target = $target; branch = ""; pr = ""; merge = ""; status = "" }
  try {
    if ($target -eq $Source) {
      $item.status = "skipped (same as source @ $sourceSha)"
      $results += [pscustomobject]$item
      continue
    }

    $safeTarget = ($target -replace '[^a-zA-Z0-9._-]', '-')
    $syncBranch = "sync/$safeTarget/$ts"
    $item.branch = $syncBranch

    Run "git checkout $target" | Out-Null
    TryRun "git pull origin $target --ff-only" | Out-Null

    # Check if source is already contained
    $contains = TryRun "git merge-base --is-ancestor $Source HEAD"
    if ($contains.ok) {
      $item.status = "up-to-date (target already contains $Source@$sourceSha)"
      $results += [pscustomobject]$item
      continue
    }

    Run "git checkout -b $syncBranch" | Out-Null
    $mergeRes = TryRun "git merge $Source --no-edit -m `"chore: sync $Source@$sourceSha into $target`""
    if (-not $mergeRes.ok) {
      $item.status = "merge conflict creating sync branch"
      $item.merge = ($mergeRes.out | Out-String).Trim()
      TryRun "git merge --abort" | Out-Null
      $results += [pscustomobject]$item
      continue
    }

    $pushRes = TryRun "git push -u origin $syncBranch"
    if (-not $pushRes.ok) {
      $item.status = "push failed"
      $item.merge = ($pushRes.out | Out-String).Trim()
      $results += [pscustomobject]$item
      continue
    }

    $title = "chore: sync $Source ($sourceSha) -> $target"
    $body = "Automated sync PR created by scripts/sync-4-branches.ps1`n`nSource: $Source@$sourceSha`nTarget: $target"
    # Reuse existing open PR from this head if any
    $existing = (& gh pr list --repo $repo --head $syncBranch --base $target --state open --json number,url -q '.[0].url' 2>&1 | Out-String).Trim()
    if ($LASTEXITCODE -eq 0 -and $existing) {
      $item.pr = $existing
    } else {
      Write-Host ">> gh pr create --repo $repo --head $syncBranch --base $target --title '$title'" -ForegroundColor DarkGray
      if ($DryRun) {
        $item.pr = "[dry-run-pr-url]"
      } else {
        $prOut = (& gh pr create --repo $repo --head $syncBranch --base $target --title $title --body $body 2>&1 | Out-String).Trim()
        if ($LASTEXITCODE -eq 0 -and $prOut) {
          $item.pr = $prOut
        } else {
          $item.status = "PR create failed"
          $item.merge = $prOut
          $results += [pscustomobject]$item
          continue
        }
      }
    }

    $prNum = ($item.pr -replace '.*/pull/(\d+).*', '$1')
    $methodFlag = "--$MergeMethod"
    if ($AutoMerge -and $prNum -match '^\d+$') {
      Write-Host ">> gh pr merge $prNum --repo $repo $methodFlag --auto" -ForegroundColor DarkGray
      if (-not $DryRun) {
        $amOut = (& gh pr merge $prNum --repo $repo $methodFlag --auto 2>&1 | Out-String).Trim()
        $item.merge = if ($LASTEXITCODE -eq 0) { "auto-merge enabled ($MergeMethod)" } else { "auto-merge failed: $amOut" }
      } else { $item.merge = "[dry-run] auto-merge ($MergeMethod)" }
    } elseif ($MergeNow -and $prNum -match '^\d+$') {
      Write-Host ">> gh pr merge $prNum --repo $repo $methodFlag" -ForegroundColor DarkGray
      if (-not $DryRun) {
        $amOut = (& gh pr merge $prNum --repo $repo $methodFlag 2>&1 | Out-String).Trim()
        $item.merge = if ($LASTEXITCODE -eq 0) { "merged ($MergeMethod)" } else { "merge failed: $amOut" }
      } else { $item.merge = "[dry-run] merged ($MergeMethod)" }
    } else {
      $item.merge = "PR created (merge manually or re-run with -AutoMerge/-MergeNow)"
    }
    $item.status = "ok"
  } catch {
    $item.status = "error: $($_.Exception.Message)"
  }
  $results += [pscustomobject]$item
}

TryRun "git checkout $initialBranch" | Out-Null

Write-Host "`n======================= RINGKASAN =======================" -ForegroundColor Cyan
$results | Format-Table -AutoSize | Out-String | Write-Host
Write-Host "Catatan: 'auto-merge/merge failed' sering berarti required checks/signature/branch rules belum terpenuhi. Sesuaikan -MergeMethod (merge|squash|rebase) dan aturan proteksi repo." -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
