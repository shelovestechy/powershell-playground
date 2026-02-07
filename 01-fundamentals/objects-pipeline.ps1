# playground
# aihe: objektit ja pipeline (putki)
# tämä tiedosto on kirjoitettu niin,
# että jokainen käsite on avattu suomeksi

# --------------------------------------------------
# KÄSITE: komento
# Get-Process on PowerShell-komento.
# Se hakee tietoa tietokoneella käynnissä olevista prosesseista.
# Prosessi = esim. selain, editori, taustalla pyörivä ohjelma.
# --------------------------------------------------

Get-Process

# Tämä tulostaa listan.
# Se NÄYTTÄÄ tekstiltä,
# mutta se EI ole tekstiä.

# --------------------------------------------------
# KÄSITE: muuttuja
# Muuttuja on nimetty laatikko, johon tallennetaan jotain.
# $-merkki tarkoittaa: "tämä on muuttuja".
# --------------------------------------------------

$items = Get-Process

# Nyt Get-Processin tulos on tallennettu laatikkoon nimeltä $items.

# --------------------------------------------------
# KÄSITE: tyyppi (type)
# Tyyppi kertoo, millaista dataa muuttuja sisältää.
# --------------------------------------------------

$items.GetType().FullName

# Tämä kertoo:
# $items EI ole teksti
# vaan kokoelma (lista) objekteja.

# --------------------------------------------------
# KÄSITE: kokoelma (array / collection)
# Kokoelma = monta asiaa yhdessä.
# Esim. ostoskori, jossa on monta tuotetta.
# --------------------------------------------------

# Otetaan yksi asia kokoelmasta.
# [0] tarkoittaa: ensimmäinen.
# (laskeminen alkaa nollasta)
$one = $items[0]

# --------------------------------------------------
# KÄSITE: objekti
# Objekti = yksi "asia", jolla on ominaisuuksia.
# Esim. yksi prosessi.
# --------------------------------------------------

$one.GetType().FullName

# Nyt käsittelemme YHTÄ prosessia.

# --------------------------------------------------
# KÄSITE: property (ominaisuus)
# Property = tieto, joka kuuluu objektille.
# Esim. nimi, id, cpu.
# --------------------------------------------------

$one | Get-Member

# Get-Member näyttää:
# - propertyt (tiedot)
# - metodit (toiminnot)
# Tässä meitä kiinnostaa propertyt.

# --------------------------------------------------
# KÄSITE: pipeline (putki) |
# | tarkoittaa:
# "anna tämä tulos seuraavalle komennolle"
# --------------------------------------------------

# Tässä:
# Get-Process antaa prosessit
# Select-Object valitsee niistä vain tietyt propertyt

$items |
    Select-Object Name, Id, CPU |
    Select-Object -First 5

# Luettuna suomeksi:
# hae prosessit
# näytä nimi, id ja cpu
# ota vain viisi ensimmäistä

# --------------------------------------------------
# KÄSITE: Select-Object
# Select-Object EI muuta alkuperäistä dataa.
# Se tekee vain uuden näkymän.
# --------------------------------------------------

# --------------------------------------------------
# KÄSITE: Where-Object
# Where-Object = suodatus
# "pidä vain ne, jotka täyttävät ehdon"
# --------------------------------------------------

# KÄSITE: $_
# $_ tarkoittaa:
# "tämä yksi objekti, jota käsitellään nyt"

$items |
    Where-Object { $_.CPU -gt 100 } |
    Select-Object Name, CPU

# Luettuna:
# käy jokainen prosessi läpi
# jos sen CPU on suurempi kuin 100
# pidä se

# --------------------------------------------------
# KÄSITE: Sort-Object
# Sort-Object järjestää objektit jonkin propertyn mukaan.
# --------------------------------------------------

$items |
    Sort-Object CPU -Descending |
    Select-Object Name, CPU -First 5

# Descending = suurimmasta pienimpään

# --------------------------------------------------
# KÄSITE: foreach
# foreach = käy lista läpi yksi kerrallaan
# --------------------------------------------------

$small = Get-Process | Select-Object -First 3

foreach ($p in $small) {
    $p.Name
}

# Luettuna:
# jokaiselle prosessille listassa
# näytä sen nimi

# --------------------------------------------------
# KÄSITE: Format-Table
# Format-* komennot ovat VAIN näyttämistä varten.
# Niitä ei pidä käyttää, jos dataa jatkokäsitellään.
# --------------------------------------------------

$items |
    Select-Object Name, CPU -First 5 |
    Format-Table -AutoSize

# --------------------------------------------------
# KÄSITE: Export-Csv
# Export-Csv tallentaa datan tiedostoon.
# Tätä käytetään paljon töissä.
# --------------------------------------------------

$top = $items |
    Sort-Object CPU -Descending |
    Select-Object Name, Id, CPU -First 10

$top |
    Export-Csv ".\top-processes.csv" -NoTypeInformation -Encoding UTF8

# --------------------------------------------------
# MIKSI TÄMÄ KAIKKI?
# --------------------------------------------------

# Koska myöhemmin tämä on TÄSMÄLLEEN SAMA
# mutta eri objekteilla (IAM):

# Get-EntraUser | Where-Object { $_.AccountEnabled -eq $true }
# = hae käyttäjät -> pidä vain aktiiviset

# Get-EntraGroupMember | Select-Object DisplayName, Id
# = hae ryhmän jäsenet -> näytä nimet

# Jos ymmärrät tämän tiedoston,
# ymmärrät PowerShellin peruslogiikan.
