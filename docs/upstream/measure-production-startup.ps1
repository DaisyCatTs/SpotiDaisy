param(
    [string]$Executable = "$PSScriptRoot/../../target/release/spotifast.exe",
    [ValidateSet('Warm', 'FirstLaunchAfterRestart')]
    [string]$Condition = 'Warm'
)
$ErrorActionPreference = 'Stop'
$binary = (Resolve-Path -LiteralPath $Executable).Path
# The production client shares the installed client's profile and instance lock.
# Never close an existing process or let a second launch masquerade as startup.
if (Get-Process -Name spotifast -ErrorAction SilentlyContinue) {
    throw 'Exit Spotifast using its tray menu before recording production startup.'
}
$boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$hash = (Get-FileHash -LiteralPath $binary -Algorithm SHA256).Hash
$startedUtc = [DateTime]::UtcNow
$timer = [Diagnostics.Stopwatch]::StartNew()
# This is an explicitly requested interactive application, not a background helper.
$process = Start-Process -FilePath $binary -PassThru
try {
    do {
        $process.Refresh()
        if ($process.HasExited) { throw 'The application exited before creating its main window.' }
        if ($timer.Elapsed.TotalSeconds -gt 60) { throw 'Main-window readiness timed out.' }
        Start-Sleep -Milliseconds 10
    } while ($process.MainWindowHandle -eq 0)
    $readyMs = $timer.Elapsed.TotalMilliseconds
    $record = [pscustomobject]@{
        DateUtc = $startedUtc.ToString('o')
        Executable = '<repo>/target/release/spotifast.exe'
        Sha256 = $hash
        ProcessId = $process.Id
        Condition = $Condition
        BootUtc = $boot.ToUniversalTime().ToString('o')
        BootAgeSeconds = [math]::Round(($startedUtc - $boot.ToUniversalTime()).TotalSeconds, 3)
        WindowReadyMs = [math]::Round($readyMs, 2)
        Caveat = 'Production application using its existing local profile. Window handle is not first paint or Spotify readiness. Restart condition is operator-declared; boot age alone cannot prove cold caches or that no earlier launch occurred. Application remains open. No credentials or account data recorded.'
    }
    $evidence = Join-Path $PSScriptRoot 'evidence'
    $name = 'production-startup-' + $startedUtc.ToString('yyyyMMddTHHmmssfffZ') + '.json'
    $record | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $evidence $name)
    $record
} finally {
    $process.Dispose()
}
