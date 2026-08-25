# 🎠 PowerShell Playground

Small PowerShell exercises from Service Desk work, identity administration and Windows troubleshooting.

I use PowerShell in my daily work through existing scripts and practical admin commands. Here I slow down, write the logic myself and learn why a command works.

My goal isn't to pretend I already know everything. I want to become more confident with PowerShell, GitHub and the tools used around Microsoft Entra ID.

> Read first. Understand second. Change last.

PowerShell is very helpful. It is also extremely willing to do exactly what you asked including the bad idea you didn't think through.

## A note about permissions

> [!NOTE]
> Some commands in this repository require permissions I don't have in my current Service Desk role. That doesn't stop me from learning what the commands do, which permissions they require and how they should be used safely.
>
> I only run commands against a real environment when I have approval and the required access. Otherwise I study the official documentation, test read-only parts where possible and keep the limitation visible.
>
> Curiosity doesn't require Global Administrator. Real tenant changes quite reasonably do.

Microsoft recommends using only the least privileged permissions required for a task. [Microsoft Entra PowerShell best practices](https://learn.microsoft.com/en-us/powershell/entra-powershell/entra-powershell-best-practices)

## Start here

New to the repository? Open the [start here guide](./docs/start-here.md).

The guide explains the traffic lights, a sensible exercise order and what can be tested without high-level tenant permissions.

## Choose a learning track

| Learning track | What it covers | Current state |
| --- | --- | --- |
| [PowerShell basics](./exercises/powershell-basics/) | Objects, filters, pipelines and errors | Growing next |
| [Microsoft Entra ID](./exercises/entra-id/) | Users, groups and access checks | 4 exercises |
| [Exchange Online](./exercises/exchange-online/) | Shared mailboxes and permissions | 1 exercise |
| [Windows and devices](./exercises/windows-and-devices/) | Hardware, drivers and diagnostics | Planned |
| [Software management](./exercises/software-management/) | Applications and uninstall problems | Planned |
| [Security and audit](./exercises/security-and-audit/) | Sign-ins, evidence and review logic | 1 exercise |
| [Reporting and files](./exercises/reporting-and-files/) | CSV, Excel-friendly output and comparisons | Planned |

The main README stays short even when the repository grows. Each learning track has its own index and every completed exercise has its own page.

## Traffic lights

| Impact | Meaning |
| --- | --- |
| 🟢 **Read only** | Reads information without changing the environment |
| 🟡 **Local output** | Creates or changes a local file such as a report |
| 🔴 **Environment change** | Changes a device, account, group, mailbox or tenant |

A red exercise needs a clear warning, required permissions and a safe test plan. It should also use `-WhatIf` or confirmation when the command supports it.

Read the full [safety notes](./docs/safety.md) before using examples in a real environment.

## Setup

<details>
<summary>Microsoft Graph PowerShell</summary>

If installing modules is allowed:

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

Connect only with the scopes needed for the current exercise:

```powershell
Connect-MgGraph -Scopes 'User.Read.All' -ContextScope Process
Get-MgContext
```

End the session with:

```powershell
Disconnect-MgGraph
```

</details>

<details>
<summary>Exchange Online PowerShell</summary>

If installing modules is allowed:

```powershell
Install-Module ExchangeOnlineManagement -Scope CurrentUser
Connect-ExchangeOnline
```

End the session with:

```powershell
Disconnect-ExchangeOnline -Confirm:$false
```

</details>

Admin consent and available permissions depend on the organisation. A work device may also have its own rules for installing PowerShell modules.

## Ankkalinna

The Ankkalinna theme still appears in notes and dry comments because I'm a Duckburg fan. Ankkalinna doesn't pretend to have a live Entra tenant.

I also use the theme in my [Identity Lab](https://github.com/shelovestechy/identity-lab).

## Documentation

- [Start here](./docs/start-here.md)
- [Safety and traffic lights](./docs/safety.md)
- [Source policy](./docs/source-policy.md)
- [Glossary](./docs/glossary.md)
- [Learning log](./docs/learning-log.md)

## Tests

The tests don't connect to Microsoft 365. They check PowerShell syntax and exercises that can run with local sample data.

```powershell
.\tests\Test-ScriptSyntax.ps1
.\tests\Measure-SignInActivity.Tests.ps1
```

GitHub Actions runs the same checks after each push and pull request.

## Repository sources

- [GitHub Docs: About READMEs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes)
- [Microsoft Graph PowerShell documentation](https://learn.microsoft.com/en-us/powershell/microsoftgraph/)
- [Microsoft Graph permissions reference](https://learn.microsoft.com/en-us/graph/permissions-reference)
- [Exchange Online PowerShell documentation](https://learn.microsoft.com/en-us/powershell/exchange/exchange-online-powershell)
