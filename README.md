# 🎠 PowerShell Playground

This is where I practise PowerShell through small tasks I recognise from Service Desk work.

I use PowerShell in my daily work through existing scripts and practical admin commands. Here I slow down, write the logic myself and learn why a command works.

My goal isn't to pretend I already know everything. I want to become more confident with PowerShell, GitHub and the tools used around Microsoft Entra ID.

My basic rule is still:

> Read first. Understand second. Change last.

PowerShell is very helpful. It is also extremely willing to do exactly what you asked including the bad idea you didn't think through.

## Identity and access exercises

These exercises use real read-only commands for **Microsoft Entra ID** which was previously called Azure Active Directory or Azure AD.

| Exercise | Main tool | What it does |
| --- | --- | --- |
| [01 – Find a user](./exercises/identity-and-access/01-user-lookup/) | Microsoft Graph | Gets user details by UPN, name, email or employee ID |
| [02 – List shared mailbox access](./exercises/identity-and-access/02-shared-mailbox-members/) | Exchange Online | Lists FullAccess, SendAs and SendOnBehalf permissions |
| [03 – Find users by job or location](./exercises/identity-and-access/03-filter-users-by-job-or-location/) | Microsoft Graph | Filters users by job title or office location |
| [04 – Export group members](./exercises/identity-and-access/04-export-group-members/) | Microsoft Graph | Lists direct user members and can create an Excel-friendly export |
| [05 – Compare group members](./exercises/identity-and-access/05-compare-group-members/) | Microsoft Graph | Compares a reference group with a target access group |

The scripts don't connect automatically and they don't make changes. I need to sign in with an approved account before running them.

## Microsoft Graph setup

If the module isn't already available and installing modules is allowed:

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

Connect with read permissions for the exercises:

```powershell
Connect-MgGraph `
    -Scopes 'User.Read.All', 'Group.Read.All', 'GroupMember.Read.All' `
    -ContextScope Process
```

Check the account, tenant and granted scopes before reading data:

```powershell
Get-MgContext
```

End the session when the work is finished:

```powershell
Disconnect-MgGraph
```

Admin consent and available permissions depend on the organisation. A work device may also have its own rules for installing PowerShell modules.

## Exchange Online setup

The shared mailbox exercise uses Exchange Online PowerShell because mailbox permissions aren't managed only through Entra ID.

```powershell
Install-Module ExchangeOnlineManagement -Scope CurrentUser
Connect-ExchangeOnline
```

End the session with:

```powershell
Disconnect-ExchangeOnline -Confirm:$false
```

## Ankkalinna

The Ankkalinna theme still appears in notes and dry comments because I'm a Duckburg fan. Ankkalinna doesn't pretend to have a live Entra tenant.

I also use the theme in my [Identity Lab](https://github.com/shelovestechy/identity-lab).

## Local security exercise

[`Measure-SignInActivity.ps1`](./scripts/Measure-SignInActivity.ps1) is an older local exercise that reads fictional sign-in events from a CSV file. It doesn't connect to a tenant.

Run it with:

```powershell
.\scripts\Measure-SignInActivity.ps1 `
    -InputPath .\examples\sign-ins.csv `
    -OutputPath .\output\sign-in-summary.csv
```

## Safety notes

- use the scripts only in an environment where you have permission
- check the signed-in account and tenant before running a query
- start with read-only permissions
- don't commit work data, tenant IDs or exported user information to GitHub
- read the script before changing it

These are learning tools and starting points. They aren't production runbooks for every tenant.

## Tests

The local tests don't connect to Microsoft 365. They check PowerShell syntax and the fictional sign-in exercise:

```powershell
.\tests\Test-ScriptSyntax.ps1
.\tests\Measure-SignInActivity.Tests.ps1
```

## Microsoft documentation

- [Get started with Microsoft Graph PowerShell](https://learn.microsoft.com/en-us/powershell/microsoftgraph/get-started)
- [Get-MgUser](https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.users/get-mguser)
- [Get-MgGroupMemberAsUser](https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.groups/get-mggroupmemberasuser)
- [Get-EXOMailboxPermission](https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/get-exomailboxpermission)
- [Get-EXORecipientPermission](https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/get-exorecipientpermission)
