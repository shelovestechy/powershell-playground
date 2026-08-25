Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$scriptPath = Join-Path $repositoryRoot 'scripts/Measure-SignInActivity.ps1'
$inputPath = Join-Path $repositoryRoot 'examples/sign-ins.csv'

function Assert-Equal {
    param(
        [Parameter(Mandatory)]$Actual,
        [Parameter(Mandatory)]$Expected,
        [Parameter(Mandatory)][string]$Message
    )

    if ($Actual -ne $Expected) {
        throw "$Message Expected '$Expected', got '$Actual'."
    }
}

$results = @(& $scriptPath -InputPath $inputPath -FailureThreshold 3)

Assert-Equal -Actual $results.Count -Expected 4 -Message 'Unexpected summary count.'
Assert-Equal -Actual @($results | Where-Object Decision -eq 'Review').Count -Expected 2 -Message 'Unexpected Review count.'
Assert-Equal -Actual @($results | Where-Object Decision -eq 'Observe').Count -Expected 2 -Message 'Unexpected Observe count.'

$aku = $results | Where-Object UserPrincipalName -eq 'aku.ankka@ankkalinna.example'
Assert-Equal -Actual $aku.FailedAttempts -Expected 4 -Message 'Aku failure count is wrong.'
Assert-Equal -Actual $aku.UniqueIPCount -Expected 3 -Message 'Aku IP count is wrong.'
Assert-Equal -Actual $aku.Decision -Expected 'Review' -Message 'Aku decision is wrong.'

$roope = $results | Where-Object UserPrincipalName -eq 'roope.ankka@ankkalinna.example'
Assert-Equal -Actual $roope.Decision -Expected 'Observe' -Message 'Roope decision is wrong.'

$hannu = $results | Where-Object UserPrincipalName -eq 'hannu.hanhi@ankkalinna.example'
Assert-Equal -Actual @($hannu).Count -Expected 0 -Message 'Successful-only users should not appear.'

$temporaryOutput = Join-Path ([System.IO.Path]::GetTempPath()) "ankkalinna-sign-in-$([guid]::NewGuid()).csv"
try {
    $null = & $scriptPath -InputPath $inputPath -OutputPath $temporaryOutput
    Assert-Equal -Actual (Test-Path -LiteralPath $temporaryOutput) -Expected $true -Message 'Output CSV was not created.'
    $exported = @(Import-Csv -LiteralPath $temporaryOutput)
    Assert-Equal -Actual $exported.Count -Expected 4 -Message 'Exported row count is wrong.'
}
finally {
    if (Test-Path -LiteralPath $temporaryOutput) {
        Remove-Item -LiteralPath $temporaryOutput -Force
    }
}

Write-Host 'All PowerShell playground tests passed.'
