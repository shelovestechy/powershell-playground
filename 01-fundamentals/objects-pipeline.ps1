# PowerShell playground
# Topic: objects and pipeline

# Putki | tarkoittaa vain tätä:
# "Ota tämä asia ja anna se seuraavalle komennolle käsiteltäväksi"

# Esimerkki:
# Get-Process | Select-Object Name, CPU
# Luettuna:
# "Hae prosessit → näytä niistä vain nimi ja CPU"

$items = Get-Process

$items.GetType().FullName

$items | Get-Member

$items |
    Select-Object Name, Id, CPU |
    Select-Object -First 5

$items |
    Where-Object { $_.CPU -gt 100 } |
    Select-Object Name, CPU

# Miksi tätä edes opetellaan?
# Koska myöhemmin tämä muuttuu muotoon:

# Get-EntraUser | Where-Object { $_.AccountEnabled -eq $true }

# Ja se tarkoittaa:
# "Hae käyttäjät → pidä vain ne, jotka ovat aktiivisia"
