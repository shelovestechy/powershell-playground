# 01 – Find a user in Entra ID

## Situation

A user contacts Service Desk because they can't access an application.

Before I check groups or permissions I need to make sure I have the correct account. A display name isn't always unique and a remembered username isn't always correct.

## What I want to do

I want to get a user from Microsoft Entra ID by:

- user principal name or object ID
- exact display name
- email address
- employee ID

The script uses `Get-MgUser`. It only reads user information.

## Before I start

I connect to Microsoft Graph with a read-only scope:

```powershell
Connect-MgGraph -Scopes 'User.Read.All' -ContextScope Process
Get-MgContext
```

The account needs permission to read the requested user properties. Consent rules depend on the organisation.

## Run the script

From the repository root:

```powershell
.\exercises\identity-and-access\01-user-lookup\Get-EntraUserDetails.ps1 `
    -UserId 'user@contoso.com'
```

Search by exact display name:

```powershell
.\exercises\identity-and-access\01-user-lookup\Get-EntraUserDetails.ps1 `
    -DisplayName 'Adele Vance'
```

Search by email or employee ID:

```powershell
.\exercises\identity-and-access\01-user-lookup\Get-EntraUserDetails.ps1 `
    -Mail 'user@contoso.com'

.\exercises\identity-and-access\01-user-lookup\Get-EntraUserDetails.ps1 `
    -EmployeeId '12345'
```

Replace the example values with values from an environment where you are allowed to run the query.

## Expected result

The result includes fields such as:

```text
DisplayName
UserPrincipalName
Mail
EmployeeId
JobTitle
Department
OfficeLocation
AccountEnabled
UserType
OnPremisesSyncEnabled
Id
```

More than one result can be returned when an exact display name isn't unique.

## What I'm practising

- connecting to Microsoft Graph
- using `Get-MgUser`
- requesting properties that aren't returned by default
- using UPN and object ID
- using OData filters
- checking the correct tenant before reading information

## Things I want to check

- Is the account enabled?
- Is the user cloud-only or synchronised from on-premises AD?
- Is the UPN the same as the email address?
- Are job title and department values up to date?
- Did the search return more than one account?

## Current limits

The script uses exact matches for display name, email and employee ID. It doesn't search with partial text and it doesn't change the user.

Finding the correct account is a small task. Finding the wrong account and confidently fixing it is a much bigger task.

## Microsoft documentation

- [Get-MgUser](https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.users/get-mguser)
- [Microsoft Graph PowerShell authentication](https://learn.microsoft.com/en-us/powershell/microsoftgraph/authentication-commands)
