# Safety and traffic lights

The scripts in this repository are learning tools. A command being available doesn't mean I have permission to run it in every environment.

## Permission boundaries

Some exercises require permissions outside my current Service Desk role. I can still study the command, understand the required scope and practise the logic with read-only or local examples.

I only run a command against a real environment when:

- I have approval for the task
- my account has the required access
- I have checked the account and tenant
- I understand what the command changes
- the organisation allows the tool and module

Microsoft recommends granting only the lowest privileged permission needed for a task. [Microsoft Entra PowerShell best practices](https://learn.microsoft.com/en-us/powershell/entra-powershell/entra-powershell-best-practices)

## Traffic lights

### 🟢 Read only

The script reads information and doesn't intentionally change the environment.

Read-only commands can still expose personal, security or tenant information. Their output must be handled as work data.

### 🟡 Local output

The script creates or changes a local file such as a CSV report.

The report may contain work data even if the tenant itself wasn't changed. Output folders are ignored by Git and real exports shouldn't be committed.

### 🔴 Environment change

The script changes a device, application, account, group, mailbox or tenant.

A red exercise should include:

- the exact change
- required permissions
- a test plan
- rollback or recovery notes
- `-WhatIf` or confirmation when supported
- a clear warning before the command

## Before a Microsoft Graph query

```powershell
Get-MgContext
```

I check the signed-in account, tenant and scopes. I use `-ContextScope Process` when I don't want the sign-in to persist after the PowerShell session.

## Sources

- [Microsoft Graph PowerShell authentication](https://learn.microsoft.com/en-us/powershell/microsoftgraph/authentication-commands)
- [Microsoft Graph permissions reference](https://learn.microsoft.com/en-us/graph/permissions-reference)
- [PowerShell common parameters including WhatIf and Confirm](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_commonparameters)
