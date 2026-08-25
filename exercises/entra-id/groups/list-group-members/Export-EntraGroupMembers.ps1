[CmdletBinding(DefaultParameterSetName = 'ByDisplayName')]
param(
    [Parameter(Mandatory, ParameterSetName = 'ById')]
    [ValidateNotNullOrEmpty()]
    [string]$GroupId,

    [Parameter(Mandatory, ParameterSetName = 'ByDisplayName')]
    [ValidateNotNullOrEmpty()]
    [string]$GroupDisplayName,

    [string]$OutputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$requiredCommands = @('Get-MgContext', 'Get-MgGroup', 'Get-MgGroupMemberAsUser')
foreach ($command in $requiredCommands) {
    if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
        throw "$command was not found. Install the Microsoft.Graph.Groups module first."
    }
}

if (-not (Get-MgContext -ErrorAction SilentlyContinue)) {
    throw "No Microsoft Graph connection was found. Run Connect-MgGraph -Scopes 'Group.Read.All','GroupMember.Read.All','User.Read.All' first."
}

function ConvertTo-ODataStringLiteral {
    param([Parameter(Mandatory)][string]$Value)

    $Value.Replace("'", "''")
}

if ($PSCmdlet.ParameterSetName -eq 'ByDisplayName') {
    $value = ConvertTo-ODataStringLiteral -Value $GroupDisplayName
    $groups = @(Get-MgGroup -All -Filter "displayName eq '$value'" -Property 'id,displayName')

    if ($groups.Count -eq 0) {
        throw "No Entra ID group named '$GroupDisplayName' was found."
    }
    if ($groups.Count -gt 1) {
        throw "More than one group named '$GroupDisplayName' was found. Run the script again with GroupId."
    }

    $GroupId = $groups[0].Id
    $resolvedGroupName = $groups[0].DisplayName
}
else {
    $group = Get-MgGroup -GroupId $GroupId -Property 'id,displayName'
    $resolvedGroupName = $group.DisplayName
}

$properties = @(
    'id'
    'displayName'
    'userPrincipalName'
    'mail'
    'jobTitle'
    'department'
    'officeLocation'
    'accountEnabled'
)

$members = @(
    Get-MgGroupMemberAsUser -GroupId $GroupId -All -Property $properties |
        Select-Object `
            @{ Name = 'GroupDisplayName'; Expression = { $resolvedGroupName } },
            DisplayName,
            UserPrincipalName,
            Mail,
            JobTitle,
            Department,
            OfficeLocation,
            AccountEnabled,
            Id |
        Sort-Object DisplayName
)

if ($OutputPath) {
    $outputDirectory = Split-Path -Parent $OutputPath
    if ($outputDirectory -and -not (Test-Path -LiteralPath $outputDirectory)) {
        New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
    }

    $members | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding utf8
}

$members
