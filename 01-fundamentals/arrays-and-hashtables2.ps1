# playground
# aihe: arrayt (listat) ja hashtablet (avain = arvo)
# tämä on se data-muoto, jota PowerShell oikeasti käsittelee

# ==================================================
# ARRAY (lista)
# ==================================================
# Array = monta asiaa yhdessä.
# Esim. monta käyttäjää, monta ryhmää, monta tiedostoa.

# 1) lista tiedostopolkuja
$paths = @(
    "C:\Windows\notepad.exe",
    "C:\nope\missing.txt",
    "C:\Windows\System32\drivers\etc\hosts"
)

$paths
$paths.Count

# 2) ota yksi arvo listasta
$paths[0]

# 3) käy lista läpi yksi kerrallaan
foreach ($path in $paths) {
    $path
}

# ==================================================
# ARRAY + LOGIIKKA
# ==================================================
# Yhdistetään lista ja tarkistus (tämä alkaa tuntua työltä)

foreach ($path in $paths) {
    if (Test-Path $path) {
        "exists: $path"
    }
    else {
        "missing: $path"
    }
}

# ==================================================
# HASHTABLE (avain = arvo)
# ==================================================
# Hashtable = yksi asia, jolla on kenttiä.
# Esim. yksi käyttäjä.

$user = @{
    UserPrincipalName = "karita@example.com"
    Department        = "IT"
    Enabled           = $true
    License           = "E3"
}

$user
$user.UserPrincipalName
$user.Department
$user.Enabled

# ==================================================
# HASHTABLE + MUUTOS
# ==================================================

# muokataan arvoa
$user.License = "F3"
$user

# lisätään uusi kenttä
$user.LastUpdated = Get-Date
$user

# ==================================================
# ARRAY HASHTABLEJA = useampi käyttäjä
# ==================================================
# Tämä on todella yleinen malli.

$users = @(
    @{
        UserPrincipalName = "karita@example.com"
        Department        = "IT"
        Enabled           = $true
    },
    @{
        UserPrincipalName = "mikko@example.com"
        Department        = "HR"
        Enabled           = $false
    },
    @{
        UserPrincipalName = "sari@example.com"
        Department        = "IT"
        Enabled           = $true
    }
)

$users
$users.Count

# ==================================================
# SUODATUS (IAM-ajatus alkaa näkyä)
# ==================================================

# 1) vain IT-osasto
$users | Where-Object { $_.Department -eq "IT" }

# 2) vain aktiiviset
$users | Where-Object { $_.Enabled -eq $true }

# 3) aktiiviset IT-käyttäjät
$users |
    Where-Object { $_.Department -eq "IT" } |
    Where-Object { $_.Enabled -eq $true }

# ==================================================
# VALITAAN VAIN TARVITTAVAT KENTÄT
# ==================================================

$users |
    Select-Object UserPrincipalName, Department

# ==================================================
# MUISTILAPPU ITSELLE
# ==================================================

# array = lista asioita
# hashtable = yksi asia + sen kentät
# array hashtableja = useampi "objekti"
#
# tämä on täsmälleen se muoto,
# jossa käyttäjät, ryhmät ja laitteet liikkuu IAM-maailmassa
