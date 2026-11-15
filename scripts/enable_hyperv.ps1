<#
.SYNOPSIS
    Install / aktifkan Hyper-V & Windows Hypervisor secara otomatis.

.DESCRIPTION
    Skrip ini:
      1. Otomatis meminta hak Administrator (UAC).
      2. Memeriksa dukungan virtualization (firmware, SLAT, DEP).
      3. Mengaktifkan fitur Windows:
         - Microsoft-Hyper-V-All
         - VirtualMachinePlatform
         - HypervisorPlatform
      4. Memaksa hypervisorlaunchtype = auto (hypervisor aktif tiap boot).
      5. Opsional mematikan VBS / Memory Integrity yang bisa menghalangi.
      6. Restart (opsional).

    PENTING: Kalau "Virtualization Enabled In Firmware = No", Hyper-V tidak
    bisa dipaksa aktif murni dari Windows. Virtualization (Intel VT-x /
    AMD SVM) harus diaktifkan di BIOS/UEFI. Parameter -Force akan tetap
    mencoba (berisiko menyebabkan gagal boot/BSOD kalau firmware tidak
    mendukung).

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\scripts\enable_hyperv.ps1
    powershell -ExecutionPolicy Bypass -File .\scripts\enable_hyperv.ps1 -DisableVBS -Restart
#>

param(
    [switch]$Force,
    [switch]$DisableVBS,
    [switch]$Restart,
    [switch]$NoReboot
)

$ErrorActionPreference = "Stop"
$LogPath = Join-Path $PSScriptRoot "enable_hyperv_log.txt"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $line = "{0} [{1}] {2}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Level, $Message
    Write-Host $line
    Add-Content -Path $LogPath -Value $line -ErrorAction SilentlyContinue
}

# ------------------------------------------------------------ naik ke Admin
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
$isAdmin  = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Meminta hak Administrator (klik Yes pada UAC)..." -ForegroundColor Yellow
    $argLine = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    if ($Force)      { $argLine += " -Force" }
    if ($DisableVBS) { $argLine += " -DisableVBS" }
    if ($Restart)    { $argLine += " -Restart" }
    if ($NoReboot)   { $argLine += " -NoReboot" }

    try {
        Start-Process -FilePath "powershell.exe" -ArgumentList $argLine -Verb RunAs -Wait
    } catch {
        throw "UAC ditolak/dibatalkan. Skrip harus dijalankan sebagai Administrator."
    }
    exit
}

Write-Log "=== ENABLE HYPER-V ==="
Write-Log "User: $env:USERNAME"

# ------------------------------------------------------------ cek dukungan
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$firmwareVirt = $cpu.VirtualizationFirmwareEnabled
$slat         = $cpu.SecondLevelAddressTranslationExtensions
$dep          = $cpu.DataExecutionPrevention_Available
if ($null -eq $firmwareVirt) { $firmwareVirt = "Unknown" }

Write-Log "VirtualizationFirmwareEnabled : $firmwareVirt"
Write-Log "SecondLevelAddressTranslation  : $slat"
Write-Log "DataExecutionPrevention        : $dep"

$edition = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name EditionID -ErrorAction SilentlyContinue).EditionID
Write-Log "Windows Edition                : $edition"

if ($firmwareVirt -eq $false -and -not $Force) {
    Write-Log "Virtualization di firmware (BIOS/UEFI) NONAKTIF. Hyper-V tidak bisa dipaksa dari Windows." "ERROR"
    Write-Log "Aktifkan Intel VT-x / AMD SVM di BIOS, atau jalankan dengan -Force (berisiko)." "ERROR"
    exit 1
}
if ($firmwareVirt -eq $false -and $Force) {
    Write-Log "Virtualization firmware nonaktif, tapi -Force dipakai. Meneruskan (berisiko)." "WARN"
}

# ------------------------------------------------------------ aktifkan fitur
$features = @(
    "Microsoft-Hyper-V-All",
    "VirtualMachinePlatform",
    "HypervisorPlatform"
)

foreach ($f in $features) {
    Write-Log "Mengaktifkan fitur: $f ..."
    $out = & dism.exe /online /enable-feature /featurename:$f /all /norestart 2>&1
    $code = $LASTEXITCODE
    $out | ForEach-Object { Write-Log ("  " + $_) }
    if ($code -ne 0 -and $code -ne 3010) {
        Write-Log "Gagal mengaktifkan $f (exit code $code)." "WARN"
    } else {
        Write-Log "Fitur $f berhasil / perlu restart." "OK"
    }
}

# ------------------------------------------------------------ paksa hypervisor
Write-Log "Mengatur hypervisorlaunchtype = auto ..."
& bcdedit.exe /set "{current}" hypervisorlaunchtype auto
if ($LASTEXITCODE -ne 0) {
    Write-Log "bcdedit gagal mengatur hypervisorlaunchtype." "ERROR"
} else {
    Write-Log "hypervisorlaunchtype = auto berhasil." "OK"
}

# ------------------------------------------------------------ matikan VBS (opsional)
if ($DisableVBS) {
    Write-Log "Mematikan VBS / Memory Integrity ..."
    & reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 0 /f | Out-Null
    & reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /t REG_DWORD /d 0 /f | Out-Null
    Write-Log "VBS / Memory Integrity dimatikan." "OK"
}

# ------------------------------------------------------------ verifikasi
$bcd = & bcdedit.exe /enum "{current}" 2>&1
if ($bcd -match "hypervisorlaunchtype\s+(\w+)") {
    Write-Log "Verifikasi hypervisorlaunchtype = $($Matches[1])"
}

Write-Log "Selesai. Restart diperlukan agar hypervisor benar-benar aktif." "OK"

# ------------------------------------------------------------ restart
if ($Restart) {
    Write-Log "Restart dalam 10 detik ..."
    shutdown.exe /r /t 10 /c "Hyper-V diaktifkan"
} elseif (-not $NoReboot) {
    Write-Host "Restart sekarang? (Y/N): " -NoNewline -ForegroundColor Cyan
    $answer = Read-Host
    if ($answer -match '^[Yy]') {
        shutdown.exe /r /t 10 /c "Hyper-V diaktifkan"
    } else {
        Write-Log "Restart dilewati. Jalankan restart manual nanti." "WARN"
    }
}
