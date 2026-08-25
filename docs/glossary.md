# Glossary

## Cmdlet

A PowerShell command that normally uses a verb-noun name such as `Get-MgUser`.

## Microsoft Entra ID

Microsoft's cloud identity and access management service. It was previously called Azure Active Directory or Azure AD.

Source: [Microsoft Entra ID new name](https://learn.microsoft.com/en-us/entra/fundamentals/new-name)

## Microsoft Graph

The API used to access Microsoft cloud resources including users and groups. Microsoft Graph PowerShell provides PowerShell cmdlets for Graph operations.

Source: [Microsoft Graph overview](https://learn.microsoft.com/en-us/graph/overview)

## Object ID

The unique identifier of an Entra ID object such as a user or group. Display names can be duplicated but object IDs are unique inside the tenant.

## Scope

A delegated permission requested when connecting to Microsoft Graph. An example is `User.Read.All`.

Source: [Microsoft Graph permissions overview](https://learn.microsoft.com/en-us/graph/permissions-overview)

## Tenant

An organisation's Microsoft Entra ID instance.

## UPN

User principal name. It is commonly used as a user's sign-in name and often looks like an email address.

## Direct member

A user or object added directly to a group.

## Transitive member

A member found through nested group membership. A direct-member query doesn't automatically return every transitive member.

Source: [Microsoft Graph group membership](https://learn.microsoft.com/en-us/graph/api/group-list-members)
