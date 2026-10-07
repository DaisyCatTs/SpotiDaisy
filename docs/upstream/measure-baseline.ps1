param(
    [string]$Executable = "$PSScriptRoot/../../target/release/spotifast.exe",
    [int]$SoakSeconds = 600
)
$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path "$PSScriptRoot/../..").Path
$executablePath = (Resolve-Path $Executable).Path
$scratch = Join-Path $repo '.cache/phase0/measurement'
$evidence = Join-Path $PSScriptRoot 'evidence'
New-Item -ItemType Directory -Force $scratch, $evidence | Out-Null
$logicalProcessors = [Environment]::ProcessorCount
Add-Type @'
using System;
using System.Runtime.InteropServices;
public static class BaselineWindow {
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr hWnd);
}
'@
$launches = @()
$samples = @()
for ($run = 0; $run -lt 4; $run++) {
    # One isolated profile, reused for warm launches. No credential restoration.
    $data = Join-Path $scratch 'profile'
    $out = Join-Path $scratch "run-$run.stdout.txt"
    $err = Join-Path $scratch "run-$run.stderr.txt"
    $arguments = "--demo --demo-data `"$data`" --demo-page playlist:pl1 --demo-show dark,playing-next --demo-size 1280x800"
    $timer = [Diagnostics.Stopwatch]::StartNew()
    $process = Start-Process -FilePath $executablePath -ArgumentList $arguments -WindowStyle Hidden -PassThru -RedirectStandardOutput $out -RedirectStandardError $err
    try {
        do {
            $process.Refresh()
            if ($process.HasExited) { throw "Demo exited before window readiness, run $run" }
            if ($timer.Elapsed.TotalSeconds -gt 30) { throw 'Window readiness timed out' }
            Start-Sleep -Milliseconds 10
        } while ($process.MainWindowHandle -eq 0)
        $readyMs = $timer.Elapsed.TotalMilliseconds
        $visible = [BaselineWindow]::IsWindowVisible($process.MainWindowHandle)
        $launches += [pscustomobject]@{Run=$run; Kind=$(if ($run -eq 0) {'Fresh profile, OS cache uncontrolled'} else {'Warm profile'}); WindowReadyMs=[math]::Round($readyMs,2); WindowVisible=$visible}
        if ($run -lt 3) { Start-Sleep -Seconds 3; continue }
        Start-Sleep -Seconds 10
        $process.Refresh()
        $lastCpu = $process.TotalProcessorTime.TotalSeconds
        $lastTime = $timer.Elapsed.TotalSeconds
        $end = $lastTime + $SoakSeconds
        while ($timer.Elapsed.TotalSeconds -lt $end) {
            Start-Sleep -Seconds 5
            $process.Refresh()
            if ($process.HasExited) { throw 'Demo exited during soak' }
            $time = $timer.Elapsed.TotalSeconds
            $cpu = $process.TotalProcessorTime.TotalSeconds
            $samples += [pscustomobject]@{
                ElapsedSeconds=[math]::Round($time,2)
                CpuPercentMachine=[math]::Round(100*($cpu-$lastCpu)/($time-$lastTime)/$logicalProcessors,4)
                WorkingSetMiB=[math]::Round($process.WorkingSet64/1MB,3)
                PrivateMiB=[math]::Round($process.PrivateMemorySize64/1MB,3)
                Handles=$process.HandleCount
                Threads=$process.Threads.Count
            }
            $lastCpu=$cpu
            $lastTime=$time
        }
    } finally {
        if (-not $process.HasExited) {
            $null = $process.CloseMainWindow()
            if (-not $process.WaitForExit(5000)) { Stop-Process -Id $process.Id }
        }
        $process.Dispose()
    }
}
$launches | Export-Csv (Join-Path $evidence 'startup.csv') -NoTypeInformation
$samples | Export-Csv (Join-Path $evidence 'idle-soak.csv') -NoTypeInformation
[pscustomobject]@{
    DateUtc=[DateTime]::UtcNow.ToString('o')
    Executable=$executablePath
    Sha256=(Get-FileHash $executablePath -Algorithm SHA256).Hash
    LogicalProcessors=$logicalProcessors
    SoakSeconds=$SoakSeconds
    Startup=$launches
    CpuMean=($samples | Measure-Object CpuPercentMachine -Average).Average
    WorkingSetMin=($samples | Measure-Object WorkingSetMiB -Minimum).Minimum
    WorkingSetMax=($samples | Measure-Object WorkingSetMiB -Maximum).Maximum
    PrivateFirst=$samples[0].PrivateMiB
    PrivateLast=$samples[-1].PrivateMiB
    Caveat='Release demo, simulated paused local state, no Spotify engine/audio decode. Window handle is not first paint. Fresh profile is not reboot-cold. No memory-leak conclusion from static short soak.'
} | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $evidence 'performance.json')
