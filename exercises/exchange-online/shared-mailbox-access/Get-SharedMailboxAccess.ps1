[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$MailboxIdentity
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$requiredCommands = @(
    'Get-EXOMailbox'
    'Get-EXOMailboxPermission'
    'Get-EXORecipientPermission'
)

foreach ($command in $requiredCommands) {
    if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
        throw "$command was not found. Install the ExchangeOnlineManagement module and connect with Connect-ExchangeOnline."
    }
}

$results = [System.Collections.Generic.List[object]]::new()

$fullAccessEntries = @(
    Get-EXOMailboxPermission -Identity $MailboxIdentity -ResultSize Unlimited |
        Where-Object {
            -not $_.IsInherited -and
            -not $_.Deny -and
            $_.User -notlike 'NT AUTHORITY\SELF' -and
            $_.AccessRights -contains 'FullAccess'
        }
)

foreach ($entry in $fullAccessEntries) {
    $results.Add([pscustomobject][ordered]@{
        Mailbox     = $MailboxIdentity
        Trustee     = [string]$entry.User
        AccessRight = 'FullAccess'
        IsInherited = [bool]$entry.IsInherited
        Source      = 'Get-EXOMailboxPermission'
    })
}

$sendAsEntries = @(
    Get-EXORecipientPermission -Identity $MailboxIdentity -AccessRights SendAs -ResultSize Unlimited |
        Where-Object {
            $_.Trustee -notlike 'NT AUTHORITY\SELF' -and
            -not $_.IsInherited
        }
)

foreach ($entry in $sendAsEntries) {
    $results.Add([pscustomobject][ordered]@{
        Mailbox     = $MailboxIdentity
        Trustee     = [string]$entry.Trustee
        AccessRight = 'SendAs'
        IsInherited = [bool]$entry.IsInherited
        Source      = 'Get-EXORecipientPermission'
    })
}

$mailbox = Get-EXOMailbox -Identity $MailboxIdentity -Properties GrantSendOnBehalfTo
foreach ($trustee in @($mailbox.GrantSendOnBehalfTo)) {
    $results.Add([pscustomobject][ordered]@{
        Mailbox     = $MailboxIdentity
        Trustee     = [string]$trustee
        AccessRight = 'SendOnBehalf'
        IsInherited = $false
        Source      = 'Get-EXOMailbox'
    })
}

$results |
    Sort-Object AccessRight, Trustee -Unique
