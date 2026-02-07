# playground
# aihe: idempotency
# suomeksi: "voi ajaa uudestaan ilman sotkua"

# --------------------------------------------------
# LÄHTÖTILANNE
# Haluamme:
# - kansion
# - tiedoston kansion sisään
#
# Mutta:
# - jos ne on jo olemassa, ei tehdä niitä uudestaan
# --------------------------------------------------

# 1) määritellään nimet
$FolderPath = ".\example"
$FilePath   = ".\example\test.txt"

# --------------------------------------------------
# 2) Test-Path
# Test-Path kysyy:
# "onko tämä jo olemassa?"
# --------------------------------------------------

Test-Path $FolderPath
Test-Path $FilePath

# (true = on olemassa, false = ei ole)

# --------------------------------------------------
# 3) kansio: luo vain jos puuttuu
# --------------------------------------------------

if (-not (Test-Path $FolderPath)) {
    New-Item -Path $FolderPath -ItemType Directory
}
else {
    "folder already exists"
}

# Aja tämä useamman kerran.
# Huomaa: kansio ei monistu.

# --------------------------------------------------
# 4) tiedosto: luo vain jos puuttuu
# --------------------------------------------------

if (-not (Test-Path $FilePath)) {
    "created at $(Get-Date)" | Out-File $FilePath -Encoding UTF8
}
else {
    "file already exists"
}

# Aja uudestaan.
# Tiedostoa ei luoda uudelleen.

# --------------------------------------------------
# 5) lisätään rivi tiedostoon (vain kerran)
# --------------------------------------------------

$Line = "hello world"

# luetaan tiedoston sisältö
$Content = Get-Content $FilePath

if ($Content -notcontains $Line) {
    $Line | Out-File $FilePath -Append -Encoding UTF8
}
else {
    "line already exists"
}

# Aja tämä useita kertoja.
# "hello world" ei tule tiedostoon kuin kerran.

# --------------------------------------------------
# MUISTILAPPU ITSELLE
# --------------------------------------------------

# idempotency = 
# 1) tarkista ensin
# 2) tee vain jos puuttuu
# 3) älä tee uudestaan jos jo on

# --------------------------------------------------
# TÄMÄ ON SAMA AJATUS MYÖHEMMIN
# --------------------------------------------------

# jos käyttäjä ei ole olemassa -> luo
# jos käyttäjä on jo olemassa -> älä tee mitään

# if (-not (UserExists)) { CreateUser }
