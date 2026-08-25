# 05 – Compare two Entra ID groups

| | |
| --- | --- |
| Level | 🌿 Building confidence |
| Impact | 🟢 Read only |
| Tool | Microsoft Graph PowerShell |
| Required scopes | `Group.Read.All`, `GroupMember.Read.All`, `User.Read.All` |
| Validation | Syntax checked. Live use requires approved tenant access. |

## Situation

One Entra ID group represents users who should receive access. Another group gives access to the application.

I want to check whether every user in the reference group is also in the target access group. I also want to see users who only exist in the target group.

## What I want to do

I want to compare two live Entra ID groups without a CSV input file.

The script reports users as:

- `Present`
- `Missing`
- `Unexpected`

It doesn't add or remove group members.

## Before I start

I need to know which group is the approved reference and which group provides the actual access.

```powershell
Connect-MgGraph `
    -Scopes 'Group.Read.All', 'GroupMember.Read.All', 'User.Read.All' `
    -ContextScope Process

Get-MgContext
```

## Run the script

Use exact group display names:

```powershell
.\exercises\entra-id\groups\compare-group-members\Compare-EntraGroupMembers.ps1 `
    -ReferenceGroup 'SG-Example-Approved-Users' `
    -TargetGroup 'SG-Example-App-Users'
```

Group object IDs can be used when names aren't unique:

```powershell
.\exercises\entra-id\groups\compare-group-members\Compare-EntraGroupMembers.ps1 `
    -ReferenceGroup '00000000-0000-0000-0000-000000000000' `
    -TargetGroup '11111111-1111-1111-1111-111111111111'
```

Show only differences:

```powershell
.\exercises\entra-id\groups\compare-group-members\Compare-EntraGroupMembers.ps1 `
    -ReferenceGroup 'SG-Example-Approved-Users' `
    -TargetGroup 'SG-Example-App-Users' |
    Where-Object Status -ne 'Present'
```

## What the statuses mean

- `Present` means the user is in both groups
- `Missing` means the user is in the reference group but not in the target group
- `Unexpected` means the user is in the target group but not in the reference group

`Unexpected` doesn't mean remove the user immediately. It means check the access owner, request or approved exception.

## What I'm practising

- resolving groups by name or object ID
- reading direct group members
- comparing users by immutable object ID
- separating expected access from actual access
- producing a reviewable result without making changes

## Things I want to check

- Who owns the reference group?
- Is the reference group really the approved source?
- Are nested groups used?
- Are disabled users included?
- Is there a documented exception for an unexpected member?

## Current limits

The exercise compares direct user members. It doesn't expand nested groups and it doesn't make an access decision.

If the approved source only exists in Excel that should be a separate exercise. This version keeps both sides of the comparison in Entra ID.

The script can find a difference. It can't explain why someone added Pekka to the group on a Friday afternoon.

## Microsoft documentation

- [Get-MgGroup](https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.groups/get-mggroup)
- [Get-MgGroupMemberAsUser](https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.groups/get-mggroupmemberasuser)
