[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$ReferenceGroup,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$TargetGroup
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

function Resolve-EntraGroup {
    param([Parameter(Mandatory)][string]$Identity)

    $groupGuid = [guid]::Empty
    if ([guid]::TryParse($Identity, [ref]$groupGuid)) {
        return Get-MgGroup -GroupId $Identity -Property 'id,displayName'
    }

    $value = ConvertTo-ODataStringLiteral -Value $Identity
    $groups = @(Get-MgGroup -All -Filter "displayName eq '$value'" -Property 'id,displayName')
    if ($groups.Count -eq 0) {
        throw "No Entra ID group named '$Identity' was found."
    }
    if ($groups.Count -gt 1) {
        throw "More than one group named '$Identity' was found. Use the group object ID instead."
    }

    $groups[0]
}

$reference = Resolve-EntraGroup -Identity $ReferenceGroup
$target = Resolve-EntraGroup -Identity $TargetGroup
$properties = @('id', 'displayName', 'userPrincipalName', 'accountEnabled')

$referenceMembers = @(Get-MgGroupMemberAsUser -GroupId $reference.Id -All -Property $properties)
$targetMembers = @(Get-MgGroupMemberAsUser -GroupId $target.Id -All -Property $properties)

$referenceById = @{}
foreach ($member in $referenceMembers) {
    $referenceById[$member.Id] = $member
}

$targetById = @{}
foreach ($member in $targetMembers) {
    $targetById[$member.Id] = $member
}

$comparison = [System.Collections.Generic.List[object]]::new()

foreach ($member in $referenceMembers) {
    $status = if ($targetById.ContainsKey($member.Id)) { 'Present' } else { 'Missing' }
    $comparison.Add([pscustomobject][ordered]@{
        DisplayName       = $member.DisplayName
        UserPrincipalName = $member.UserPrincipalName
        AccountEnabled    = $member.AccountEnabled
        Status            = $status
        ReferenceGroup    = $reference.DisplayName
        TargetGroup       = $target.DisplayName
        UserId            = $member.Id
    })
}

foreach ($member in $targetMembers) {
    if (-not $referenceById.ContainsKey($member.Id)) {
        $comparison.Add([pscustomobject][ordered]@{
            DisplayName       = $member.DisplayName
            UserPrincipalName = $member.UserPrincipalName
            AccountEnabled    = $member.AccountEnabled
            Status            = 'Unexpected'
            ReferenceGroup    = $reference.DisplayName
            TargetGroup       = $target.DisplayName
            UserId            = $member.Id
        })
    }
}

$statusOrder = @{ Missing = 0; Unexpected = 1; Present = 2 }
$comparison |
    Sort-Object @{ Expression = { $statusOrder[$_.Status] } }, DisplayName
