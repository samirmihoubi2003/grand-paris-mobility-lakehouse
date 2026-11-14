# Grand Paris Mobility Lakehouse - Step 0
# READ-ONLY audit: does not install software or change system settings.
# Run from Windows PowerShell (not CMD).

$ErrorActionPreference = 'Continue'
$report = [System.Collections.Generic.List[string]]::new()

function Add-Line([string]$message) {
    $report.Add($message)
    Write-Host $message
}

function Check-Tool([string]$name, [string[]]$arguments) {
    $command = Get-Command $name -ErrorAction SilentlyContinue
    if ($null -eq $command) {
        Add-Line "[MISSING] $name"
        return
    }
    try {
        $output = @(& $name @arguments 2>&1)
        if ($LASTEXITCODE -eq 0) {
            $firstLine = ($output | ForEach-Object { "$($_)" } | Where-Object { $_.Trim() } | Select-Object -First 1)
            if (-not $firstLine) { $firstLine = 'command found' }
            Add-Line "[OK] $name : $firstLine"
        } else {
            Add-Line "[CHECK] $name : command found but version check returned exit code $LASTEXITCODE"
        }
    } catch {
        Add-Line "[CHECK] $name : command found but could not read version"
    }
}

Add-Line '=== GRAND PARIS MOBILITY LAKEHOUSE - ENVIRONMENT AUDIT ==='
Add-Line "Audit date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
    Add-Line "OS: $($os.Caption) | version $($os.Version) | build $($os.BuildNumber)"
    $memoryGB = [Math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
    Add-Line "RAM: $memoryGB GB"
} catch { Add-Line '[CHECK] Could not retrieve OS/RAM information' }

try {
    $cpu = Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop | Select-Object -First 1
    Add-Line "CPU: $($cpu.Name.Trim())"
    Add-Line "Logical processors: $($cpu.NumberOfLogicalProcessors)"
    Add-Line "Virtualization enabled in firmware: $($cpu.VirtualizationFirmwareEnabled)"
} catch { Add-Line '[CHECK] Could not retrieve processor/virtualization information' }

try {
    $drive = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" -ErrorAction Stop
    if ($drive) {
        Add-Line "C: free disk: $([Math]::Round($drive.FreeSpace / 1GB, 1)) GB"
    }
} catch { Add-Line '[CHECK] Could not retrieve disk information' }

Add-Line '--- Essential development tools ---'
Check-Tool 'git' @('--version')
Check-Tool 'python' @('--version')
Check-Tool 'py' @('--version')
Check-Tool 'code' @('--version')
Check-Tool 'docker' @('--version')

if (Get-Command docker -ErrorAction SilentlyContinue) {
    try {
        $composeOut = @(& docker compose version 2>&1)
        if ($LASTEXITCODE -eq 0) {
            Add-Line "[OK] Docker Compose: $(($composeOut | Select-Object -First 1) -join '')"
        } else { Add-Line '[CHECK] Docker Compose command failed' }
    } catch { Add-Line '[CHECK] Docker Compose could not be checked' }

    try {
        $serverOut = @(& docker info --format '{{.ServerVersion}}' 2>&1)
        if ($LASTEXITCODE -eq 0) {
            Add-Line "[OK] Docker Engine responding: $(($serverOut | Select-Object -First 1) -join '')"
        } else { Add-Line '[CHECK] Docker CLI installed, but Docker Engine is not responding' }
    } catch { Add-Line '[CHECK] Docker Engine could not be checked' }
}

Add-Line '--- Windows Subsystem for Linux ---'
if (Get-Command wsl -ErrorAction SilentlyContinue) {
    try {
        $wslOutput = @(& wsl --version 2>&1)
        if ($LASTEXITCODE -eq 0) {
            Add-Line '[OK] WSL version command responds'
            foreach ($line in ($wslOutput | Select-Object -First 4)) {
                Add-Line "    $line"
            }
        } else { Add-Line '[CHECK] WSL exists but version command did not succeed' }
    } catch { Add-Line '[CHECK] WSL version could not be checked' }
    try {
        $distros = @(& wsl --list --quiet 2>&1)
        if ($LASTEXITCODE -eq 0) {
            # Only count distributions; do not include names or user-specific configuration.
            $count = @($distros | Where-Object { "$($_)".Trim() }).Count
            Add-Line "WSL distributions found (approx.): $count"
        } else { Add-Line '[CHECK] Could not list WSL distributions' }
    } catch { Add-Line '[CHECK] Could not list WSL distributions' }
} else { Add-Line '[MISSING] wsl' }

Add-Line '--- Optional tools (not required on day one) ---'
Check-Tool 'gh' @('--version')
Check-Tool 'java' @('-version')
Check-Tool 'uv' @('--version')

Add-Line '--- Notes ---'
Add-Line 'This audit changes no installation, configuration, accounts, or repositories.'
Add-Line 'Do not share passwords, tokens, SSH private keys, or a full environment variable dump.'

$outputPath = Join-Path $PSScriptRoot 'environment_report.txt'
$report | Set-Content -Path $outputPath -Encoding UTF8
Write-Host "Saved report: $outputPath"
