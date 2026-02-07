# playground
# aihe: datan suodatus ja jatkokäyttö
# tämä tiedosto näyttää, miten raakadatasta päädytään päätöksiin

# ==================================================
# LÄHTÖKOHTA: lista asioita
# ==================================================
# Meillä on lista kohteita.
# Jokainen kohde on yksi "tietue", jolla on useita kenttiä.
# Lista = array
# Yksi tietue = hashtable (tai objekti)

$items = @(
    @{
        Identifier       = "karita@example.com"
        Enabled          = $true
        Department       = "IT"
        LastSignInDays   = 2
        Risk             = "Low"
    },
    @{
        Identifier       = "mikko@example.com"
        Enabled          = $false
        Department       = "HR"
        LastSignInDays   = 120
        Risk             = "Low"
    },
    @{
        Identifier       = "sari@example.com"
        Enabled          = $true
        Department       = "IT"
        LastSignInDays   = 45
        Risk             = "Med"
    },
    @{
        Identifier       = "toni@example.com"
        Enabled          = $true
        Department       = "Sales"
        LastSignInDays   = 10
        Risk             = "High"
    }
)

# ==================================================
# KÄSITE: Select-Object
# ==================================================
# Select-Object ei muuta dataa.
# Se vain valitsee, mitkä kentät näytetään.
# Tätä käytetään, jotta kokonaisuus on helpompi hahmottaa.

$items |
    Select-Object Identifier, Enabled, Department, LastSignInDays, Risk

# ==================================================
# KÄSITE: Where-Object
# ==================================================
# Where-Object = suodatus.
# Käydään lista läpi yksi kohde kerrallaan.
# $_ tarkoittaa: "tämä yksi kohde nyt".

# Suodatetaan vain ne, jotka ovat käytössä.

$enabled = $items | Where-Object { $_.Enabled -eq $true }

$enabled |
    Select-Object Identifier, Department, LastSignInDays, Risk

# ==================================================
# KÄSITE: ketjutettu suodatus
# ==================================================
# Suodatusta voi tehdä useassa vaiheessa.
# Jokainen vaihe pienentää joukkoa.

# Tässä:
# 1) vain käytössä olevat
# 2) vain tietystä osastosta

$enabledIT = $enabled | Where-Object { $_.Department -eq "IT" }

$enabledIT |
    Select-Object Identifier, LastSignInDays, Risk

# ==================================================
# KÄSITE: numeerinen ehto
# ==================================================
# LastSignInDays on numero.
# Voimme verrata sitä suurempi / pienempi -ehdoilla.

# Tässä etsitään kohteet, joilla
# kirjautumisesta on kulunut yli 30 päivää.

$stale = $enabled | Where-Object { $_.LastSignInDays -gt 30 }

$stale |
    Select-Object Identifier, Department, LastSignInDays, Risk

# ==================================================
# KÄSITE: Sort-Object
# ==================================================
# Sort-Object järjestää tulokset jonkin kentän mukaan.
# Descending = suurimmasta pienimpään.

$stale |
    Sort-Object LastSignInDays -Descending |
    Select-Object Identifier, Department, LastSignInDays, Risk

# ==================================================
# KÄSITE: priorisointi
# ==================================================
# Usein ei haluta kaikkea, vaan tärkeimmät ensin.
# Select-Object -First ottaa listan alusta.

$priority = $stale |
    Sort-Object LastSignInDays -Descending |
    Select-Object -First 10

$priority |
    Select-Object Identifier, Department, LastSignInDays, Risk

# ==================================================
# KÄSITE: ExpandProperty
# ==================================================
# Joskus halutaan vain yksi kenttä listaksi.
# ExpandProperty poistaa "objektikuoren"
# ja palauttaa pelkät arvot.

$actionList = $priority | Select-Object -ExpandProperty Identifier
$actionList

# ==================================================
# KÄSITE: Export-Csv
# ==================================================
# Export-Csv tallentaa datan tiedostoon.
# Tämä mahdollistaa:
# - raportoinnin
# - jatkokäsittelyn
# - dokumentoinnin

$priority |
    Select-Object Identifier, Department, LastSignInDays, Risk |
    Export-Csv ".\stale-enabled-items.csv" -NoTypeInformation -Encoding UTF8

# ==================================================
# KÄSITE: sanity check
# ==================================================
# Ennen jatkotoimia on hyvä tarkistaa:
# löytyikö mitään vai ei.

if ($priority.Count -eq 0) {
    "no candidates found"
}
else {
    "candidates found: $($priority.Count)"
}

# ==================================================
# MUISTILAPPU ITSELLE
# ==================================================
# 1) aloita raakadatasta
# 2) suodata askel kerrallaan
# 3) järjestä ja priorisoi
# 4) tiivistä toimintalistaksi
# 5) tallenna tulos


# ==================================================
# COPY–PASTE: PIKAKOMENNOT
# ==================================================
# Näitä voi ajaa sellaisenaan, kun haluaa nopeasti tarkistaa tai muistella.

# --------------------------------------------------
# Näytä koko data nopeasti
$items

# --------------------------------------------------
# Näytä vain käytössä olevat
$items | Where-Object { $_.Enabled -eq $true }

# --------------------------------------------------
# Näytä käytössä olevat + tietyssä osastossa
$items |
    Where-Object { $_.Enabled -eq $true } |
    Where-Object { $_.Department -eq "IT" }

# --------------------------------------------------
# Näytä käytössä olevat, joilla kirjautumisesta yli 30 päivää
$items |
    Where-Object { $_.Enabled -eq $true } |
    Where-Object { $_.LastSignInDays -gt 30 }

# --------------------------------------------------
# Järjestä "vanhimmat ensin"
$items |
    Where-Object { $_.Enabled -eq $true } |
    Sort-Object LastSignInDays -Descending

# --------------------------------------------------
# Ota vain tunnisteet toimintalistaksi
$items |
    Where-Object { $_.Enabled -eq $true } |
    Where-Object { $_.LastSignInDays -gt 30 } |
    Select-Object -ExpandProperty Identifier

# --------------------------------------------------
# Tallenna tulos CSV:ksi
$items |
    Where-Object { $_.Enabled -eq $true } |
    Where-Object { $_.LastSignInDays -gt 30 } |
    Select-Object Identifier, Department, LastSignInDays, Risk |
    Export-Csv ".\filtered-items.csv" -NoTypeInformation -Encoding UTF8

# --------------------------------------------------
# Montako kohdetta täyttää ehdot
(
    $items |
    Where-Object { $_.Enabled -eq $true } |
    Where-Object { $_.LastSignInDays -gt 30 }
).Count
