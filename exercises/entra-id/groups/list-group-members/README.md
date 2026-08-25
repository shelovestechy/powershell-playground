# 04 – List or export Entra ID group members

| | |
| --- | --- |
| Level | 🌿 Building confidence |
| Impact | 🟡 Optional local output |
| Tool | Microsoft Graph PowerShell |
| Required scopes | `Group.Read.All`, `GroupMember.Read.All`, `User.Read.All` |
| Validation | Syntax checked. Live use requires approved tenant access. |

## Situation

A group owner asks for a list of users who currently have access to an application.

I want to get the current membership directly from Entra ID. I can inspect the result in PowerShell or create an Excel-friendly CSV when a file is actually needed.

## What I want to do

I want to:

- find a group by exact display name or object ID
- list its direct user members
- show useful user properties
- optionally export the result

The script doesn't require an input file.

## Before I start

```powershell
Connect-MgGraph `
    -Scopes 'Group.Read.All', 'GroupMember.Read.All', 'User.Read.All' `
    -ContextScope Process

Get-MgContext
```

## Run the script

Show the result in PowerShell:

```powershell
.\exercises\entra-id\groups\list-group-members\Export-EntraGroupMembers.ps1 `
    -GroupDisplayName 'SG-Example-App-Users'
```

Open the result in a searchable window:

```powershell
.\exercises\entra-id\groups\list-group-members\Export-EntraGroupMembers.ps1 `
    -GroupDisplayName 'SG-Example-App-Users' |
    Out-GridView
```

Create a CSV only when an Excel-friendly file is needed:

```powershell
.\exercises\entra-id\groups\list-group-members\Export-EntraGroupMembers.ps1 `
    -GroupDisplayName 'SG-Example-App-Users' `
    -OutputPath '.\output\example-app-users.csv'
```

If two groups have the same display name the script stops and asks for the object ID:

```powershell
.\exercises\entra-id\groups\list-group-members\Export-EntraGroupMembers.ps1 `
    -GroupId '00000000-0000-0000-0000-000000000000'
```

## What I'm practising

- resolving an Entra ID group
- using `Get-MgGroupMemberAsUser`
- requesting user properties
- sending objects through the PowerShell pipeline
- exporting only when a file is needed

## Things I want to check

- Is this the correct group?
- Does the group contain only users?
- Are any accounts disabled?
- Does the group use nested membership?
- Does the exported file contain work data that must be protected?

## Current limits

`Get-MgGroupMemberAsUser` returns direct user members. It doesn't expand users from nested groups. Dynamic group membership also needs to be understood before the result is used as audit evidence.

The CSV shows who is in the group. It doesn't decide who should be there.

## Microsoft documentation

- [Get-MgGroup](https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.groups/get-mggroup)
- [Get-MgGroupMemberAsUser](https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.groups/get-mggroupmemberasuser)
