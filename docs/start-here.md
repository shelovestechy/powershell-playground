# Start here

PowerShell Playground is a long-term learning repository. I don't need to complete every exercise in order and I don't need high-level admin permissions to understand how a command works.

## A sensible first route

1. [Find a user in Entra ID](../exercises/entra-id/users/get-user-details/) – learn one exact user lookup
2. [Find users by job or location](../exercises/entra-id/users/find-by-job-or-location/) – add filters and selected properties
3. [List Entra ID group members](../exercises/entra-id/groups/list-group-members/) – work with groups and pipeline output
4. [Compare two Entra ID groups](../exercises/entra-id/groups/compare-group-members/) – compare expected and actual membership
5. [List shared mailbox access](../exercises/exchange-online/shared-mailbox-access/) – learn why mailbox permissions use Exchange Online
6. [Measure sign-in activity](../exercises/security-and-audit/sign-in-activity/) – run a complete local exercise without a tenant

The first five exercises use real Microsoft 365 commands. They require an approved account, a suitable role and the scopes shown on each page.

The sign-in activity exercise uses local sample data. It can be run without Microsoft Graph or a cloud account.

## How I use an exercise

1. Read the situation and expected result.
2. Check the traffic light and required permissions.
3. Open the linked Microsoft documentation.
4. Read the script before running it.
5. Check the current account and tenant.
6. Start with a read-only query.
7. Write down what worked, what didn't and what I learned.

## Exercise levels

| Level | Meaning |
| --- | --- |
| 🌱 **Starting point** | One clear task with a small number of commands |
| 🌿 **Building confidence** | Filters, comparisons or more than one data source |
| 🌳 **Deeper exercise** | More risk, more dependencies or more design decisions |

## Impact levels

| Impact | Meaning |
| --- | --- |
| 🟢 **Read only** | Reads information without changing the environment |
| 🟡 **Local output** | Creates or changes a local report or file |
| 🔴 **Environment change** | Changes a device, account, group, mailbox or tenant |

The colours describe impact. They don't describe whether a command is good or bad.

## Sources

- [Microsoft Graph PowerShell documentation](https://learn.microsoft.com/en-us/powershell/microsoftgraph/)
- [Microsoft Graph PowerShell authentication](https://learn.microsoft.com/en-us/powershell/microsoftgraph/authentication-commands)
- [GitHub Docs: About READMEs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes)
