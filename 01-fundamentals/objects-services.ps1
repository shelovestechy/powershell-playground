# PowerShell playground
# Topic: objects and pipeline (services)

# Sama malli kuin prosesseissa
# Eri objekti, sama ajattelutapa

$services = Get-Service

$services.GetType().FullName

$services | Get-Member

$services |
    Select-Object Name, Status, StartType |
    Select-Object -First 5

$services |
    Where-Object { $_.Status -eq "Running" } |
    Select-Object Name, Status

# Tämä ajatus siirtyy suoraan käytössä esimerkiksi:
# Get-EntraUser | Where-Object { $_.AccountEnabled -eq $true }
