[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
    [string]$InputPath,

    [string]$OutputPath,

    [ValidateRange(1, 1000)]
    [int]$FailureThreshold = 3
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$requiredColumns = @(
    'Timestamp',
    'UserPrincipalName',
    'Result',
    'IPAddress',
    'Country',
    'Application'
)

$events = @(Import-Csv -LiteralPath $InputPath)
if ($events.Count -eq 0) {
    Write-Output @()
    return
}

$availableColumns = @($events[0].PSObject.Properties.Name)
$missingColumns = @($requiredColumns | Where-Object { $_ -notin $availableColumns })
if ($missingColumns.Count -gt 0) {
    throw "Input CSV is missing required columns: $($missingColumns -join ', ')"
}

foreach ($event in $events) {
    if ([string]::IsNullOrWhiteSpace($event.UserPrincipalName)) {
        throw 'UserPrincipalName cannot be empty.'
    }

    $parsedTimestamp = [datetimeoffset]::MinValue
    if (-not [datetimeoffset]::TryParse($event.Timestamp, [ref]$parsedTimestamp)) {
        throw "Invalid timestamp '$($event.Timestamp)' for $($event.UserPrincipalName)."
    }
}

$failedEvents = @($events | Where-Object { $_.Result -ne 'Success' })
$summaries = foreach ($userGroup in ($failedEvents | Group-Object UserPrincipalName)) {
    $groupEvents = @($userGroup.Group)
    $timestamps = @($groupEvents | ForEach-Object { [datetimeoffset]::Parse($_.Timestamp) })
    $uniqueIps = @($groupEvents.IPAddress | Where-Object { $_ } | Sort-Object -Unique)
    $countries = @($groupEvents.Country | Where-Object { $_ } | Sort-Object -Unique)
    $applications = @($groupEvents.Application | Where-Object { $_ } | Sort-Object -Unique)

    $reasons = [System.Collections.Generic.List[string]]::new()
    if ($groupEvents.Count -ge $FailureThreshold) {
        $reasons.Add("$($groupEvents.Count) failed attempts")
    }
    if ($uniqueIps.Count -ge 3) {
        $reasons.Add("$($uniqueIps.Count) IP addresses")
    }
    if ($countries.Count -ge 2) {
        $reasons.Add("$($countries.Count) countries")
    }

    $decision = if ($reasons.Count -gt 0) { 'Review' } else { 'Observe' }
    $reasonText = if ($reasons.Count -gt 0) { $reasons -join '; ' } else { 'Below example thresholds' }

    [pscustomobject][ordered]@{
        UserPrincipalName = $userGroup.Name
        FailedAttempts    = $groupEvents.Count
        UniqueIPCount     = $uniqueIps.Count
        IPAddresses       = $uniqueIps -join '; '
        Countries         = $countries -join '; '
        Applications      = $applications -join '; '
        FirstFailureUtc   = ($timestamps | Measure-Object -Minimum).Minimum.ToUniversalTime().ToString('o')
        LastFailureUtc    = ($timestamps | Measure-Object -Maximum).Maximum.ToUniversalTime().ToString('o')
        Decision          = $decision
        Reason            = $reasonText
    }
}

$sortedSummaries = @(
    $summaries | Sort-Object `
        @{ Expression = { $_.Decision -eq 'Review' }; Descending = $true }, `
        @{ Expression = 'FailedAttempts'; Descending = $true }, `
        UserPrincipalName
)

if ($OutputPath) {
    $outputDirectory = Split-Path -Parent $OutputPath
    if ($outputDirectory -and -not (Test-Path -LiteralPath $outputDirectory)) {
        New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
    }
    $sortedSummaries | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding utf8
}

$sortedSummaries
