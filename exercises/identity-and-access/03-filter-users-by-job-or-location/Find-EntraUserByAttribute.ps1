[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]$JobTitle,

    [ValidateNotNullOrEmpty()]
    [string]$OfficeLocation
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $JobTitle -and -not $OfficeLocation) {
    throw 'Provide JobTitle, OfficeLocation or both.'
}

if (-not (Get-Command Get-MgUser -ErrorAction SilentlyContinue)) {
    throw 'Get-MgUser was not found. Install the Microsoft.Graph.Users module first.'
}

if (-not (Get-MgContext -ErrorAction SilentlyContinue)) {
    throw "No Microsoft Graph connection was found. Run Connect-MgGraph -Scopes 'User.Read.All' first."
}

function ConvertTo-ODataStringLiteral {
    param([Parameter(Mandatory)][string]$Value)

    $Value.Replace("'", "''")
}

$filterParts = [System.Collections.Generic.List[string]]::new()
if ($JobTitle) {
    $value = ConvertTo-ODataStringLiteral -Value $JobTitle
    $filterParts.Add("jobTitle eq '$value'")
}
if ($OfficeLocation) {
    $value = ConvertTo-ODataStringLiteral -Value $OfficeLocation
    $filterParts.Add("officeLocation eq '$value'")
}

$properties = @(
    'id'
    'displayName'
    'userPrincipalName'
    'jobTitle'
    'department'
    'officeLocation'
    'accountEnabled'
)

$filter = $filterParts -join ' and '
$users = @(Get-MgUser -All -Filter $filter -Property $properties)

if ($users.Count -eq 0) {
    Write-Verbose "No users matched the filter: $filter"
}

$users |
    Select-Object DisplayName, UserPrincipalName, JobTitle, Department, OfficeLocation, AccountEnabled, Id |
    Sort-Object OfficeLocation, JobTitle, DisplayName
