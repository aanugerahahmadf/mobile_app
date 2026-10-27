# bump_weekly_version.ps1
#
# Menambah build number pubspec.yaml (1.0.0+N -> 1.0.0+N+1) sekali jalan.
# Dipanggil otomatis Task Scheduler tiap hari Sabtu (task:
# "WeddingApp-Mobile-Weekly-VersionBump") supaya versi aplikasi mobile selalu
# update mingguan. versionName "1.0.0.<N>" di HP di-derive otomatis oleh
# android/app/build.gradle.kts dari build number pubspec -- cukup edit satu file.
#
# Manual: powershell -ExecutionPolicy Bypass -File .\scripts\bump_weekly_version.ps1
# Dry run (tanpa menulis): tambahkan -DryRun

param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$PubspecPath = Join-Path $PSScriptRoot "..\pubspec.yaml"
$GradlePath  = Join-Path $PSScriptRoot "..\android\app\build.gradle.kts"
$LogPath     = Join-Path $PSScriptRoot "version_bump_log.txt"

# ---------------------------------------------------------------- baca versi
$Pubspec = Get-Content $PubspecPath -Raw

if ($Pubspec -notmatch '(?m)^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$') {
    throw "Format version tidak dikenali di pubspec.yaml. Harus 'major.minor.patch+build' (mis. 1.0.0+2)."
}

$Major = $Matches[1]
$Minor = $Matches[2]
$Patch = $Matches[3]
$Build = [int]$Matches[4]

# -------------------------------------------------------------- kunci minggu
# Jaga agar bump idempoten satu minggu: jika task jalan dua kali dalam minggu
# yang sama (rerun/catch-up), tidak naik ganda. Anchor = hari Minggu pekan ini.
$Now = Get-Date
$WeekAnchor = $Now.Date.AddDays([int]-[int]$Now.DayOfWeek)
$LastBumpFile = Join-Path $PSScriptRoot ".last_bump_week"
$LastBump = if (Test-Path $LastBumpFile) { Get-Content $LastBumpFile -ErrorAction SilentlyContinue } else { "" }

if ($LastBump -eq $WeekAnchor.ToString("yyyyMMdd")) {
    Write-Host "Build sudah naik minggu ini ($($Build) -> version 1.0.0.$Build). Lewati."
    exit 0
}

$NewBuild = $Build + 1
$NewLine = "version: $Major.$Minor.$Patch+$NewBuild"

if ($DryRun) {
    Write-Host "DRY RUN: $Major.$Minor.$Patch+$Build -> $Major.$Minor.$Patch+$NewBuild (versionName jadi `"$Major.$Minor.$Patch.$NewBuild`")"
    exit 0
}

# ------------------------------------------------------------------- tulis
# Regex menggantikan baris version: yang bukan komentar (a ^version).
$PubspecNew = [regex]::Replace($Pubspec, '(?m)^version:\s*\d+\.\d+\.\d+\+\d+', $NewLine)
if ($PubspecNew -eq $Pubspec) {
    throw "Baris version: tidak berhasil diganti di pubspec.yaml."
}
Set-Content -Path $PubspecPath -Value $PubspecNew -NoNewline

# Jaga-jaga: versionName literal lama (jika masih ada) ikut disinkronkan.
$Gradle = Get-Content $GradlePath -Raw
$GradleNew = [regex]::Replace(
    $Gradle,
    'versionName\s*=\s*"(\d+\.\d+\.\d+)(\.\d+)"',
    ('versionName = "1.0.0.' + $NewBuild + '"')
)
Set-Content -Path $GradlePath -Value $GradleNew -NoNewline

Set-Content -Path $LastBumpFile -Value $WeekAnchor.ToString("yyyyMMdd")

# -------------------------------------------------------------------- log
$Entry = "{0:yyyy-MM-dd HH:mm} | {1}+{2} -> {1}+{3} | versionName: {4}.{5}.{6}.{7}" -f `
    $Now, "$Major.$Minor.$Patch", $Build, $NewBuild, $Major, $Minor, $Patch, $NewBuild
Add-Content -Path $LogPath -Value $Entry

Write-Host "OK: $Entry"
Write-Host "Version di HP pada build berikutnya: `"$Major.$Minor.$Patch.$NewBuild`""
