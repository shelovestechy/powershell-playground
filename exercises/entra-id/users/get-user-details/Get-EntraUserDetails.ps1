[CmdletBinding(DefaultParameterSetName = 'ByUserId')]
param(
    [Parameter(Mandatory, ParameterSetName = 'ByUserId')]
    [ValidateNotNullOrEmpty()]
    [string]$UserId,

    [Parameter(Mandatory, ParameterSetName = 'ByDisplayName')]
    [ValidateNotNullOrEmpty()]
    [string]$DisplayName,

    [Parameter(Mandatory, ParameterSetName = 'ByMail')]
    [ValidateNotNullOrEmpty()]
    [string]$Mail,

    [Parameter(Mandatory, ParameterSetName = 'ByEmployeeId')]
    [ValidateNotNullOrEmpty()]
    [string]$EmployeeId
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

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

$properties = @(
    'id'
    'displayName'
    'userPrincipalName'
    'mail'
    'employeeId'
    'jobTitle'
    'department'
    'officeLocation'
    'accountEnabled'
    'userType'
    'onPremisesSyncEnabled'
    'createdDateTime'
)

$users = switch ($PSCmdlet.ParameterSetName) {
    'ByUserId' {
        @(Get-MgUser -UserId $UserId -Property $properties)
    }
    'ByDisplayName' {
        $value = ConvertTo-ODataStringLiteral -Value $DisplayName
        @(Get-MgUser -All -Filter "displayName eq '$value'" -Property $properties)
    }
    'ByMail' {
        $value = ConvertTo-ODataStringLiteral -Value $Mail
        @(Get-MgUser -All -Filter "mail eq '$value'" -Property $properties)
    }
    'ByEmployeeId' {
        $value = ConvertTo-ODataStringLiteral -Value $EmployeeId
        @(Get-MgUser -All -Filter "employeeId eq '$value'" -Property $properties)
    }
}

if ($users.Count -eq 0) {
    throw 'No matching Entra ID user was found.'
}

$users | Select-Object `
    DisplayName,
    UserPrincipalName,
    Mail,
    EmployeeId,
    JobTitle,
    Department,
    OfficeLocation,
    AccountEnabled,
    UserType,
    OnPremisesSyncEnabled,
    CreatedDateTime,
    Id
