# Exchange Online

Exercises for shared mailboxes, recipients and Exchange Online permissions.

Exchange Online has its own PowerShell module and role model. A user existing in Entra ID doesn't mean every mailbox permission can be read through an Entra user query.

## Exercises

| Exercise | Level | Impact |
| --- | --- | --- |
| [List shared mailbox access](./shared-mailbox-access/) | 🌿 Building confidence | 🟢 Read only |

## Planned topics

- list shared mailboxes
- check mailbox forwarding
- review mailbox delegates
- inspect inbox rules safely
- list distribution group members

## Sources

- [Exchange Online PowerShell](https://learn.microsoft.com/en-us/powershell/exchange/exchange-online-powershell)
- [Get-EXOMailboxPermission](https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/get-exomailboxpermission)
- [Get-EXORecipientPermission](https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/get-exorecipientpermission)
