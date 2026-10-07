# Windows and devices

Small Service Desk exercises for understanding what Windows detects and what information is available before troubleshooting starts.

## Available exercises

| Exercise | Level | Impact |
| --- | --- | --- |
| [Generate and read a WLAN report](./wlan-report/) | 🌱 Starting point | 🟡 Local HTML report |

The WLAN exercise includes the CMD command, its PowerShell equivalent and a fictional Ankkalinna troubleshooting case.

## Planned topics

- list recognised devices
- show only devices with a problem
- inspect signed drivers
- find driver versions and dates
- check basic computer information
- check disks and available space
- inspect network adapters
- review recent restart information

Most planned exercises will be read only. The WLAN exercise creates a local report. Hardware is already capable of surprising everyone without help from the script.

## Sources

- [Get-PnpDevice](https://learn.microsoft.com/en-us/powershell/module/pnpdevice/get-pnpdevice)
- [Get-CimInstance](https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance)
- [PnPUtil command syntax](https://learn.microsoft.com/en-us/windows-hardware/drivers/devtest/pnputil-command-syntax)
