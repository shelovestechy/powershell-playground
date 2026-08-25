Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$scriptFiles = @(
    Get-ChildItem -Path $repositoryRoot -Recurse -Filter '*.ps1' -File |
        Where-Object { $_.FullName -ne $PSCommandPath }
)

$allErrors = [System.Collections.Generic.List[string]]::new()

foreach ($file in $scriptFiles) {
    $tokens = $null
    $parseErrors = $null
    $null = [System.Management.Automation.Language.Parser]::ParseFile(
        $file.FullName,
        [ref]$tokens,
        [ref]$parseErrors
    )

    foreach ($parseError in @($parseErrors)) {
        $relativePath = [System.IO.Path]::GetRelativePath($repositoryRoot, $file.FullName)
        $allErrors.Add("$relativePath`: $($parseError.Message)")
    }
}

if ($allErrors.Count -gt 0) {
    throw "PowerShell syntax errors were found:`n$($allErrors -join "`n")"
}

Write-Host "PowerShell syntax check passed for $($scriptFiles.Count) scripts."
