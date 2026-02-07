# playground
# aihe: virheet + try/catch (sama tyyli kuin objects-pipeline)

# --------------------------------------------------
# KÄSITE: virhe (error)
# Virhe = komento ei onnistu.
# Esim. tiedostoa ei löydy, oikeudet puuttuu, polku väärä.
# --------------------------------------------------

# --------------------------------------------------
# KÄSITE: try / catch
# try = "yritä ajaa tämä"
# catch = "jos tulee virhe, tee tämä"
# --------------------------------------------------

# --------------------------------------------------
# KÄSITE: -ErrorAction (tai -EA)
# Oletus: osa virheistä vain tulostuu punaisena ja skripti jatkaa.
# -ErrorAction Stop pakottaa virheen "oikeaksi" eli se menee catchiin.
# --------------------------------------------------

try {
    Get-Item "C:\this-file-does-not-exist.txt" -ErrorAction Stop
}
catch {
    $_
}

# --------------------------------------------------
# KÄSITE: $_ (catchissa)
# $_ = se virhe-objekti, joka tuli catchiin.
# Sitä voi tutkia.
# --------------------------------------------------

try {
    Get-Item "C:\this-file-does-not-exist.txt" -EA Stop
}
catch {
    $_.GetType().FullName
    $_.Exception
    $_.Exception.GetType().FullName
    $_.Exception.Message
}

# --------------------------------------------------
# KÄSITE: "hiljainen virhe" vs "pysäyttävä virhe"
# Sama komento, eri käytös.
# --------------------------------------------------

Get-Item "C:\this-file-does-not-exist.txt"            # yleensä huutaa mutta jatkaa
Get-Item "C:\this-file-does-not-exist.txt" -EA Stop   # menee catchiin jos ympärillä on try

# --------------------------------------------------
# KÄSITE: throw
# throw = tee oma virhe (ja yleensä pysäytä).
# Tätä käytetään kun haluat oman selkeän viestin.
# --------------------------------------------------

try {
    Get-Item "C:\this-file-does-not-exist.txt" -EA Stop
}
catch {
    throw "Fail: file not found (test). Original: $($_.Exception.Message)"
}

# --------------------------------------------------
# KÄSITE: käsittele monta asiaa (lista), osa onnistuu, osa failaa
# Tämä on se "työelämä-case": käsitellään monta polkua/käyttäjää/juttua.
# --------------------------------------------------

$paths = @(
    "C:\Windows\notepad.exe",
    "C:\nope\missing.txt",
    "C:\Windows\System32\drivers\etc\hosts"
)

# --------------------------------------------------
# KÄSITE: continue
# continue = hyppää seuraavaan kierrokseen loopissa
# eli: "skipataan tämä ja jatketaan"
# --------------------------------------------------

foreach ($path in $paths) {
    try {
        Get-Item $path -EA Stop | Select-Object FullName, Length
    }
    catch {
        "SKIP: $path | $($_.Exception.Message)"
        continue
    }
}

# --------------------------------------------------
# MIKSI TÄMÄ KAIKKI?
# --------------------------------------------------

# Työssä tämä muuttuu muotoon:
# - käyttäjää ei löydy
# - ryhmää ei löydy
# - lisenssi on jo käytössä
# - oikeudet puuttuu

# try/catch + ErrorAction Stop = sinä päätät:
# pysäytetäänkö koko homma vai jatketaanko seuraavaan

# virhe ei ole kaatuminen
# virhe on dataa
