<#
.SYNOPSIS
  Skrip otomatis untuk Commit, Pull, dan Push ke 4 branch sekaligus serta kirim notifikasi ke Discord.

.DESCRIPTION
  Sinkronisasi 4 branch aktif:
  1. main
  2. chore/complete-mobile-tests-and-chat
  3. dependabot/npm_and_yarn/functions/npm_and_yarn-a18cab04ac
  4. v0/mobile-fullstack-ci
#>

param(
    [string]$Message = "",
    [string]$DiscordWebhook = ""
)

$ErrorActionPreference = "Stop"

# List 4 branch target
$branches = @(
    "main",
    "chore/complete-mobile-tests-and-chat",
    "dependabot/npm_and_yarn/functions/npm_and_yarn-a18cab04ac",
    "v0/mobile-fullstack-ci"
)

# Cek Webhook dari .env jika parameter kosong
if (-not $DiscordWebhook -and (Test-Path ".env")) {
    $envLines = Get-Content ".env"
    foreach ($line in $envLines) {
        if ($line -match "^DISCORD_WEBHOOK_URL=(.+)$") {
            $DiscordWebhook = $matches[1].Trim()
            break
        }
    }
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " SINKRONISASI PULL, COMMIT, DAN PUSH KE 4 BRANCH" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Simpan branch awal
$initialBranch = (git rev-parse --abbrev-ref HEAD).Trim()
Write-Host "Branch awal saat ini: $initialBranch" -ForegroundColor Yellow

# Periksa working tree
$status = (git status --porcelain)
if ($status) {
    if (-not $Message) {
        $Message = Read-Host "Ada perubahan belum di-commit. Masukkan pesan commit (default: chore: sync all 4 branches)"
        if (-not $Message) {
            $Message = "chore: sync all 4 branches"
        }
    }
    Write-Host "Menyimpan perubahan dengan commit: '$Message'..." -ForegroundColor Green
    git add -A
    git commit -m "$Message"
} else {
    Write-Host "Working tree bersih, tidak ada perubahan lokal yang perlu di-commit." -ForegroundColor Gray
}

# Pastikan git fetch terbaru dari remote
Write-Host "`nMengambil update remote (git fetch origin)..." -ForegroundColor Blue
git fetch origin

$successBranches = @()
$failedBranches = @()

# 1. Update dan pull main terlebih dahulu
Write-Host "`n--> Memperbarui branch 'main'..." -ForegroundColor Magenta
try {
    git checkout main
    git pull origin main --no-edit
    git push origin main
    $successBranches += "main"
    Write-Host "[OK] Branch 'main' berhasil di-pull dan di-push!" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Gagal memproses 'main': $_" -ForegroundColor Red
    $failedBranches += "main"
}

# 2. Update 3 branch lainnya dan sinkronkan dengan main
foreach ($b in $branches) {
    if ($b -eq "main") { continue }
    Write-Host "`n--> Memproses branch '$b'..." -ForegroundColor Magenta
    try {
        git checkout $b
        git pull origin $b --no-edit
        Write-Host "    Menggabungkan (merge) pembaruan dari 'main'..." -ForegroundColor Gray
        git merge main --no-edit
        git push origin $b
        $successBranches += $b
        Write-Host "[OK] Branch '$b' berhasil di-pull, di-merge dari main, dan di-push!" -ForegroundColor Green
    } catch {
        Write-Host "[FAIL] Gagal memproses branch '$b': $_" -ForegroundColor Red
        $failedBranches += $b
    }
}

# Kembalikan ke branch awal
Write-Host "`nKembali ke branch awal: $initialBranch..." -ForegroundColor Yellow
git checkout $initialBranch

Write-Host "`n======================= RINGKASAN =======================" -ForegroundColor Cyan
Write-Host "Berhasil disinkronkan dan di-push ($($successBranches.Count)): $($successBranches -join ', ')" -ForegroundColor Green
if ($failedBranches.Count -gt 0) {
    Write-Host "Gagal ($($failedBranches.Count)): $($failedBranches -join ', ')" -ForegroundColor Red
}
Write-Host "==========================================================" -ForegroundColor Cyan

# Kirim notifikasi ke Discord jika Webhook tersedia
if ($DiscordWebhook) {
    Write-Host "`nMengirim notifikasi ke Server Discord..." -ForegroundColor Magenta
    try {
        $lastCommit = (git log -1 --pretty=format:"%s (%h by %an)").Trim()
        $embedColor = if ($failedBranches.Count -eq 0) { 3066993 } else { 15158332 }
        $description = "**Hasil Sinkronisasi 4 Branch:**`n" +
            "Berhasil: $($successBranches -join ', ')`n" +
            (if ($failedBranches.Count -gt 0) { "Gagal: $($failedBranches -join ', ')`n" } else { "" }) +
            "`n**Commit Terakhir:** $lastCommit"

        $payloadObj = @{
            username = "GitHub Sync Bot"
            avatar_url = "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
            embeds = @(
                @{
                    title = "Git Sync: 4 Branch Berhasil Disinkronkan & Di-Push"
                    description = $description
                    color = $embedColor
                    footer = @{
                        text = "Timeless Florals"
                    }
                    timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
                }
            )
        }
        $payload = $payloadObj | ConvertTo-Json -Depth 5

        $response = Invoke-RestMethod -Uri $DiscordWebhook -Method Post -ContentType "application/json" -Body $payload
        Write-Host "[OK] Notifikasi berhasil terkirim ke Discord!" -ForegroundColor Green
    } catch {
        Write-Host "[WARN] Gagal mengirim notifikasi Discord: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host "`nTip: Untuk mengirim notifikasi otomatis ke Discord, tambahkan DISCORD_WEBHOOK_URL di file .env atau jalankan dengan parameter -DiscordWebhook <URL>" -ForegroundColor Gray
}
