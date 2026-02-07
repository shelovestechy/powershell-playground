# playground
# 03-identity-m365/membership-check.ps1
# aihe: jäsenyys (onko mukana vai ei) + "tee vasta jos puuttuu"

# ==================================================
# LÄHTÖKOHTA
# ==================================================
# Meillä on lista jäseniä (array).
# Haluamme tietää: kuuluuko tietty kohde listaan.

$members = @(
    "a@example.com",
    "c@example.com",
    "karita@example.com"
)

$item = "b@example.com"

# ==================================================
# KÄSITE: -contains
# ==================================================
# -contains = "sisältääkö lista tämän arvon?"
# Palauttaa true / false.

$members -contains $item

if ($members -contains $item) {
    "already a member"
}
else {
    "not a member"
}

# ==================================================
# KÄSITE: idempotentti lisäys
# ==================================================
# Lisätään vain jos puuttuu.
# (tämä estää tuplajäsenyydet)

if ($members -notcontains $item) {
    $members = $members + $item
}

$members

# ==================================================
# KÄSITE: case / whitespace
# ==================================================
# Jos data voi olla sekaista, normalisoi ennen tarkistusta.
# (tämä on yleinen syy miksi membership-check "ei toimi")

$itemRaw = " Karita@Example.com "
$itemClean = $itemRaw.Trim().ToLower()

$membersClean = $members | ForEach-Object { $_.Trim().ToLower() }

if ($membersClean -contains $itemClean) {
    "member (after normalize)"
}
else {
    "not member (after normalize)"
}

# ==================================================
# KÄSITE: objektilista + property (yleisempi muoto)
# ==================================================
# Usein jäsenet eivät ole pelkkiä stringejä, vaan objekteja.
# Silloin tarkistus tehdään propertyn kautta.

$memberObjects = @(
    @{ Identifier = "a@example.com"; Role = "Reader" },
    @{ Identifier = "c@example.com"; Role = "Owner"  }
)

$target = "c@example.com"

# Näin:
($memberObjects | Where-Object { $_.Identifier -eq $target }).Count -gt 0

if ( ($memberObjects | Where-Object { $_.Identifier -eq $target }).Count -gt 0 ) {
    "member (object list)"
}
else {
    "not member (object list)"
}

# ==================================================
# COPY–PASTE: PIKAKOMENNOT
# ==================================================

# Tarkista nopeasti (string-lista)
$members -contains "karita@example.com"

# Lisää vain jos puuttuu
$val = "new@example.com"
if ($members -notcontains $val) { $members = $members + $val }
$members

# Normalisoi ja tarkista
$valRaw = "  NEW@EXAMPLE.COM "
$valClean = $valRaw.Trim().ToLower()
($members | ForEach-Object { $_.Trim().ToLower() }) -contains $valClean

# Objektijäsenyys: löytyykö Identifier
$target = "a@example.com"
($memberObjects | Where-Object { $_.Identifier -eq $target }).Count -gt 0

# ==================================================
# MUISTILAPPU ITSELLE
# ==================================================
# -contains toimii vain, jos lista sisältää juuri saman arvon
# jos data voi olla sotkuista -> normalisoi (Trim + ToLower)
# objekteissa tarkistat aina propertyn kautta
# lisää vain jos puuttuu (ei tuplia)
