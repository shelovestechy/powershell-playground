# 🛠️ PowerShell Playground

This is where I practise writing small PowerShell tools instead of only collecting commands.

I use PowerShell in Service Desk work, often through existing scripts and practical admin commands. In this repository I slow down, build the logic myself and test it with fictional data.

My basic rule is still:

> Read first. Understand second. Change last.

PowerShell is very helpful. It is also extremely willing to do exactly what you asked, including the bad idea you did not think through.

## Current exercise: sign-in activity summary

[`Measure-SignInActivity.ps1`](./scripts/Measure-SignInActivity.ps1) reads fictional sign-in events from a CSV file and creates a user-level summary of failed attempts.

It reports:

- number of failed attempts
- unique IP addresses
- countries and applications in the events
- first and last failure time
- a simple `Review` or `Observe` decision
- reasons behind the decision

The example uses **Ankkalinna Identity Lab Oy** users. No tenant, Microsoft Graph connection or cloud account is required.

This is not a threat-detection product. The rules are intentionally simple so I can practise PowerShell objects, grouping, validation, dates and CSV output. Four failed logins are worth looking at, but they are not automatically an international cyber operation. Aku may simply have forgotten his password again.

## Run the exercise

```powershell
.\scripts\Measure-SignInActivity.ps1 `
    -InputPath .\examples\sign-ins.csv `
    -OutputPath .\output\sign-in-summary.csv
```

The script writes the CSV file and also returns the results to the PowerShell pipeline.

A committed example is available in [`examples/sample-output.csv`](./examples/sample-output.csv).

## Run the tests

The test script uses only PowerShell and does not require Pester:

```powershell
.\tests\Measure-SignInActivity.Tests.ps1
```

GitHub Actions runs the same test after each push.

## Safety choices

- the exercise reads local fictional data
- it does not connect to Microsoft Graph
- it does not change users, groups or devices
- required CSV columns are checked before processing
- invalid timestamps stop the script instead of creating a misleading report
- output is written only when an output path is provided

## Current limits

- the rules are examples, not production detection logic
- there is no enrichment from Entra ID, a SIEM or threat intelligence
- successful and failed result names are simplified for the sample data
- the exercise does not decide whether a login was malicious

Microsoft Graph may become a data source later when I have a suitable lab environment. For now I am keeping the data local and concentrating on PowerShell logic I can actually run and verify.

My IAM-focused PowerShell exercise is also available in the [Identity Lab](https://github.com/shelovestechy/identity-lab/tree/main/projects/access-governance-and-audit/powershell).
