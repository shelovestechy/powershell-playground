# playground
# aihe: objektit + pipeline (services)
# sama tyyli kuin process-versio

# --------------------------------------------------
# KÄSITE: palvelu (service)
# Palvelu = taustalla pyörivä Windows-juttu (esim. päivitykset, verkko, jne.)
# Get-Service hakee palvelut.
# --------------------------------------------------

Get-Service

# --------------------------------------------------
# KÄSITE: muuttuja
# Tallennetaan tulos laatikkoon.
# --------------------------------------------------

$services = Get-Service

# --------------------------------------------------
# KÄSITE: tyyppi (type)
# Mitä dataa tämä on?
# --------------------------------------------------

$services.GetType().FullName

# --------------------------------------------------
# KÄSITE: kokoelma (lista)
# $services sisältää monta palvelua.
# Otetaan yksi palvelu ja tutkitaan sitä.
# --------------------------------------------------

$one = $services[0]
$one.GetType().FullName

# --------------------------------------------------
# KÄSITE: Get-Member
# Näyttää mitä yhdellä palvelu-objektilla on (propertyt + metodit)
# --------------------------------------------------

$one | Get-Member

# --------------------------------------------------
# KÄSITE: property (ominaisuus)
# Näytetään vain muutama perusjuttu:
# - Name = palvelun nimi
# - Status = Running / Stopped
# - StartType = Automatic / Manual / Disabled (jos näkyy)
# --------------------------------------------------

$services |
    Select-Object Name, Status, StartType |
    Select-Object -First 10

# --------------------------------------------------
# KÄSITE: pipeline (|)
# Putki = anna objektit seuraavalle komennolle.
# --------------------------------------------------

# Esimerkki:
# Get-Service | Select-Object Name, Status
# "hae palvelut -> näytä vain nimi ja status"

# --------------------------------------------------
# KÄSITE: Where-Object (suodatus)
# Pidetään vain ne palvelut jotka ovat käynnissä.
# --------------------------------------------------

$services |
    Where-Object { $_.Status -eq "Running" } |
    Select-Object Name, Status |
    Select-Object -First 20

# --------------------------------------------------
# KÄSITE: Sort-Object (järjestys)
# Järjestetään palvelut nimen mukaan.
# --------------------------------------------------

$services |
    Sort-Object Name |
    Select-Object Name, Status -First 20

# --------------------------------------------------
# KÄSITE: foreach (käy lista läpi)
# Sama idea kuin pipeline, mutta käsin yksi kerrallaan.
# --------------------------------------------------

$small = Get-Service | Select-Object -First 5
foreach ($s in $small) { $s.Name }

# --------------------------------------------------
# KÄSITE: Format-Table
# Format-* on vain näyttöä varten. Ei jatkokäsittelyyn.
# --------------------------------------------------

$services |
    Select-Object Name, Status -First 10 |
    Format-Table -AutoSize

# --------------------------------------------------
# MIKSI TÄMÄ KAIKKI?
# --------------------------------------------------

# Sama malli myöhemmin IAM-jutuissa:

# Get-EntraUser | Where-Object { $_.AccountEnabled -eq $true }
# = hae käyttäjät -> pidä vain aktiiviset

# Get-EntraGroupMember | Select-Object DisplayName, Id
# = hae ryhmän jäsenet -> näytä nimet

# Ajatus:
# palvelu/prosessi/käyttäjä/ryhmä = objekti
# pipeline käsittelee objekteja propertyjen kautta
