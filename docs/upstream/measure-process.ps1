param(
    [Parameter(Mandatory)][int]$ProcessId,
    [Parameter(Mandatory)][string]$Label,
    [int]$Seconds = 120
)
$ErrorActionPreference='Stop'
$evidence=Join-Path $PSScriptRoot 'evidence'
$process=Get-Process -Id $ProcessId
$binary=$process.Path
$rows=@()
$clock=[Diagnostics.Stopwatch]::StartNew()
$lastTime=0.0
$lastCpu=$process.TotalProcessorTime.TotalSeconds
try {
    while ($clock.Elapsed.TotalSeconds -lt $Seconds) {
        Start-Sleep -Seconds 2
        $process.Refresh()
        if ($process.HasExited) { throw 'Measured process exited' }
        $time=$clock.Elapsed.TotalSeconds
        $cpu=$process.TotalProcessorTime.TotalSeconds
        $rows += [pscustomobject]@{
            Label=$Label
            DateUtc=[DateTime]::UtcNow.ToString('o')
            ElapsedSeconds=[math]::Round($time,3)
            CpuPercentMachine=[math]::Round(100*($cpu-$lastCpu)/($time-$lastTime)/[Environment]::ProcessorCount,4)
            WorkingSetMiB=[math]::Round($process.WorkingSet64/1MB,3)
            PrivateMiB=[math]::Round($process.PrivateMemorySize64/1MB,3)
            Threads=$process.Threads.Count
            Handles=$process.HandleCount
        }
        $lastTime=$time
        $lastCpu=$cpu
    }
} finally {
    $process.Dispose()
    $rows | Export-Csv (Join-Path $evidence "$Label.csv") -NoTypeInformation
}
[pscustomobject]@{
    Label=$Label
    Binary=$binary
    Sha256=(Get-FileHash -LiteralPath $binary -Algorithm SHA256).Hash
    Version=(& $binary --version | Out-String).Trim()
    LogicalProcessors=[Environment]::ProcessorCount
    Samples=$rows.Count
    CpuMean=($rows | Measure-Object CpuPercentMachine -Average).Average
    CpuMax=($rows | Measure-Object CpuPercentMachine -Maximum).Maximum
    WorkingSetMin=($rows | Measure-Object WorkingSetMiB -Minimum).Minimum
    WorkingSetMax=($rows | Measure-Object WorkingSetMiB -Maximum).Maximum
    PrivateFirst=$rows[0].PrivateMiB
    PrivateLast=$rows[-1].PrivateMiB
    Caveat='Existing user-owned installed process; state and local-vs-remote playback require user confirmation. No credential access or process control.'
} | ConvertTo-Json | Set-Content (Join-Path $evidence "$Label.json")
