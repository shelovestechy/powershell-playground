# playground
# aihe: config + JSON
# erotetaan data ja logiikka toisistaan

# --------------------------------------------------
# IDEA
# Skripti ei saa olla sidottu yhteen kovakoodattuun arvoon.
# Config = ulkoinen data, jota skripti lukee.
# Sama skripti, eri config = eri käytös.
# --------------------------------------------------

# --------------------------------------------------
# 1) hashtable
# PowerShellin perus-datarakenne (avain = arvo)
# --------------------------------------------------

$config = @{
    Environment = "Test"
    Department  = "IT"
    EnabledOnly = $true
}

$config
$config.Environment
$config.Department

# --------------------------------------------------
# 2) PowerShell-data -> JSON
# --------------------------------------------------

$config | ConvertTo-Json

# --------------------------------------------------
# 3) tallennus tiedostoon
# --------------------------------------------------

$config |
    ConvertTo-Json |
    Out-File ".\config.json" -Encoding UTF8

# HUOM:
# JSON oletetaan yleensä UTF8-muotoiseksi.
# UTF8 säilyttää ääkköset oikein ja toimii hyvin eri ympäristöissä.

# HUOMIO VERSIOISTA:
# Kaikki PowerShell-versiot eivät käsittele UTF8-encodingia samalla tavalla.
# Erityisesti vanhemmassa Windows PowerShellissa (esim. 5.1)
# oletus-encoding voi poiketa tästä.
# Jos skriptiä ajetaan eri koneissa tai ympäristöissä,
# encoding-käytös kannattaa tarkistaa.

# --------------------------------------------------
# 4) configin lukeminen tiedostosta
# --------------------------------------------------

$json = Get-Content ".\config.json"
$json

$configFromFile = $json | ConvertFrom-Json
$configFromFile

# --------------------------------------------------
# 5) datan käyttö logiikassa
# --------------------------------------------------

$configFromFile.Environment
$configFromFile.Department

if ($configFromFile.EnabledOnly) {
    "Config: only enabled objects"
}
else {
    "Config: include everything"
}

# --------------------------------------------------
# 6) miltä tämä näyttää IAM-maailmassa
# --------------------------------------------------

# Esimerkki config.json:
# {
#   "Department": "IT",
#   "EnabledOnly": true
# }

# Get-EntraUser |
# Where-Object { $_.Department -eq $configFromFile.Department } |
# Where-Object { $_.AccountEnabled -eq $true }

# --------------------------------------------------
# MUISTILAPPU ITSELLE
# - config ei ole koodia
# - config on dataa
# - data elää tiedostossa, ei skriptissä
# - encoding on asia, ei detalji
