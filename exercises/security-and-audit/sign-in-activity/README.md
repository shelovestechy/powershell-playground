# Measure sign-in activity

| | |
| --- | --- |
| Level | 🌿 Building confidence |
| Impact | 🟡 Optional local output |
| Tool | PowerShell with local CSV data |
| Required access | None |
| Validation | Local tests and GitHub Actions |

## Situation

A small set of sign-in events needs a user-level summary. I want to see repeated failures, different IP addresses and activity from more than one country.

## What I want to do

`Measure-SignInActivity.ps1` reads fictional sign-in events and creates a summary of failed attempts.

It reports:

- failed attempt count
- unique IP addresses
- countries and applications
- first and last failure time
- a simple `Review` or `Observe` decision
- reasons behind the decision

The rules are intentionally simple. Four failed logins are worth looking at but they aren't automatically an international cyber operation.

## Run the exercise

From the repository root:

```powershell
.\exercises\security-and-audit\sign-in-activity\Measure-SignInActivity.ps1 `
    -InputPath .\exercises\security-and-audit\sign-in-activity\sign-ins.csv `
    -OutputPath .\output\sign-in-summary.csv
```

The output file is optional. Without `OutputPath` the script returns PowerShell objects to the pipeline.

## Run the test

```powershell
.\tests\Measure-SignInActivity.Tests.ps1
```

## What I'm practising

- importing CSV data
- grouping PowerShell objects
- validating required columns
- parsing dates
- creating a clear result object
- exporting optional output

## Current limits

- the data is fictional and local
- the rules aren't production detection logic
- there is no enrichment from Entra ID or a SIEM
- the exercise doesn't decide whether a login was malicious

## Sources

- [Import-Csv](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/import-csv)
- [Group-Object](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/group-object)
- [Export-Csv](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-csv)
