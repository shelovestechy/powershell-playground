# 🟡 Generate and read a WLAN report

**Level:** 🌱 Starting point  
**Impact:** 🟡 Local output — creates an HTML diagnostics report  
**Tool:** Windows `netsh.exe` (a native command, not a PowerShell cmdlet)  
**Environment:** Windows 10 / 11 with Wi-Fi  
**Permissions:** Run Command Prompt or PowerShell as administrator, with workplace approval where required.

## Why this belongs here

A user says: "Wi-Fi keeps dropping." Before changing settings, collect evidence of when the connection failed and what Windows recorded.

This command is commonly run in CMD. PowerShell can run the same native executable, so it fits this repository's Windows troubleshooting track too.

## Generate the report in CMD

Open **Command Prompt → Run as administrator**:

```cmd
netsh wlan show wlanreport
```

Wait for the command to finish. It prints the report location. A typical location is:

```text
C:\ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html
```

Use the location returned on your device if it differs. To open the typical path from CMD:

```cmd
start "" "%ProgramData%\Microsoft\Windows\WlanReport\wlan-report-latest.html"
```

## The same command in PowerShell

Open **PowerShell → Run as administrator**:

```powershell
netsh.exe wlan show wlanreport
if ($LASTEXITCODE -ne 0) {
    throw 'WLAN report generation failed. Read the netsh output before continuing.'
}
```

To open the typical report path:

```powershell
$reportPath = Join-Path $env:ProgramData 'Microsoft\Windows\WlanReport\wlan-report-latest.html'
if (Test-Path -LiteralPath $reportPath) {
    Invoke-Item -LiteralPath $reportPath
} else {
    Write-Warning 'Report not found at the typical location. Check the path printed by netsh.'
}
```

Generating a report writes local files; it does not reset the adapter or change Wi-Fi settings.

## Read it with a question in mind

| Question | Where to look |
| --- | --- |
| Does the failure line up with the time the user reported? | Session chart and individual session events |
| What reason did Windows record for a disconnect? | Disconnect reasons and session details |
| Which adapter and driver are involved? | Adapter details and driver information |
| Is the issue repeated or isolated? | Session history and success/failure summary |

The history normally covers the last three days. A recorded reason is a troubleshooting clue, not proof of the underlying cause.

## Fictional Ankkalinna exercise

Aku Ankka reports that his laptop lost Wi-Fi during two meetings. Record the exact times, compare them with the report and note the adapter, driver and recorded disconnect reasons.

Write a short ticket update:

> Aku reported Wi-Fi drops at [times]. The WLAN report records [events/reasons] at [times]. Adapter: [model]; driver: [version/date]. Next check: [one justified step]. Root cause has not been confirmed.

These are placeholders, not fabricated test results. Do not invent a disconnect code or blame the driver just because it is old.

## If generation fails

- Check that the terminal is elevated.
- Read the actual error before rerunning the command.
- Check that Windows detects a Wi-Fi adapter and that WLAN AutoConfig is running.
- A missing adapter or stopped service may need escalation; do not change services or reinstall drivers as part of this collection exercise.

## Handle the output carefully

Reports can contain device/user details, network names, addresses and certificate information. Keep real reports in approved support locations. Do not commit them to GitHub; use fictional examples for the portfolio.

## Validation status

Documentation checked against the Microsoft sources below on **2026-10-07**. These commands have **not been executed on a Windows Wi-Fi device as part of this repository update**. Generation and opening still need a local Windows check.

## Sources

- [Microsoft Support: Analyze the wireless network report](https://support.microsoft.com/en-us/windows/experience/connectivity-networking/analyze-the-wireless-network-report)
- [Microsoft Learn: netsh wlan](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/netsh-wlan)
- [Microsoft Learn: Wireless network connectivity issues troubleshooting](https://learn.microsoft.com/en-us/troubleshoot/windows-client/networking/wireless-network-connectivity-issues-troubleshooting)
