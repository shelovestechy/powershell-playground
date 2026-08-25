# 02 – List shared mailbox access

## Situation

A user can open a shared mailbox but they can't send messages from it.

Opening the mailbox and sending as the mailbox are different permissions. Before changing anything I want to see which permissions already exist.

## What I want to do

I want to list directly assigned:

- `FullAccess`
- `SendAs`
- `SendOnBehalf`

This exercise uses Exchange Online PowerShell. Shared mailbox permissions aren't read only from Entra ID.

## Before I start

If the Exchange Online module is available I connect with:

```powershell
Connect-ExchangeOnline
```

The signed-in account also needs a suitable Exchange Online role. The exact role and access model depend on the organisation.

## Run the script

```powershell
.\exercises\identity-and-access\02-shared-mailbox-members\Get-SharedMailboxAccess.ps1 `
    -MailboxIdentity 'shared-mailbox@contoso.com'
```

The mailbox identity must not be empty. Some Exchange `Get-` commands can return far more objects than expected when identity input is missing.

## Expected result

```text
Mailbox                    Trustee              AccessRight  IsInherited Source
-------                    -------              -----------  ----------- ------
shared-mailbox@contoso.com user1@contoso.com    FullAccess   False       Get-EXOMailboxPermission
shared-mailbox@contoso.com user1@contoso.com    SendAs       False       Get-EXORecipientPermission
shared-mailbox@contoso.com user2@contoso.com    SendOnBehalf False       Get-EXOMailbox
```

The script doesn't add or remove permissions.

## What I'm practising

- connecting to Exchange Online PowerShell
- checking mailbox permissions before making changes
- understanding `FullAccess`, `SendAs` and `SendOnBehalf`
- filtering inherited permission entries
- returning one clear permission list

## Things I want to check

- Can the user open the mailbox?
- Can the user send as the mailbox?
- Is the permission direct or inherited?
- Is access assigned to a user or a group?
- Is the ticket asking for the same permission the user is missing?

## Current limits

The trustee value for `SendOnBehalf` may be shown as an Exchange identity instead of a friendly email address. The exercise lists current access but it doesn't decide whether the access is correct.

The mailbox has three permission types because one simple checkbox would apparently have been too relaxing.

## Microsoft documentation

- [Get-EXOMailboxPermission](https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/get-exomailboxpermission)
- [Get-EXORecipientPermission](https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/get-exorecipientpermission)
