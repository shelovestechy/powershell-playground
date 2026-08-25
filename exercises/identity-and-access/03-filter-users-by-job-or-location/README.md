# 03 – Find Entra ID users by job or location

## Situation

A manager asks which users work in a certain role or office.

This may be needed before an application rollout, an access review or a device change. I want to build the list from Entra ID instead of copying names manually.

## What I want to do

I want to filter Entra ID users by:

- exact job title
- exact office location
- both values together

The script uses `Get-MgUser` with an OData filter. It doesn't change user attributes.

## Before I start

```powershell
Connect-MgGraph -Scopes 'User.Read.All' -ContextScope Process
Get-MgContext
```

The result is only as useful as the user attributes stored in Entra ID. An empty job title remains impressively empty in PowerShell too.

## Run the script

Find users by job title:

```powershell
.\exercises\identity-and-access\03-filter-users-by-job-or-location\Find-EntraUserByAttribute.ps1 `
    -JobTitle 'Service Desk Analyst'
```

Find users by location:

```powershell
.\exercises\identity-and-access\03-filter-users-by-job-or-location\Find-EntraUserByAttribute.ps1 `
    -OfficeLocation 'Helsinki'
```

Use both filters:

```powershell
.\exercises\identity-and-access\03-filter-users-by-job-or-location\Find-EntraUserByAttribute.ps1 `
    -JobTitle 'Service Desk Analyst' `
    -OfficeLocation 'Helsinki'
```

## Expected result

```text
DisplayName
UserPrincipalName
JobTitle
Department
OfficeLocation
AccountEnabled
Id
```

## What I'm practising

- building an OData filter
- combining two filter conditions
- requesting selected user properties
- sorting PowerShell objects
- returning an empty result without inventing an answer

## Things I want to check

- Are the job titles written consistently?
- Are disabled accounts included?
- Does the request mean office location or department?
- Is an exact match suitable for the task?
- Is the result too large to review safely?

## Current limits

The filters use exact values. A later exercise can add partial searches and clearer handling for inconsistent HR data.

## Microsoft documentation

- [Get-MgUser](https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.users/get-mguser)
