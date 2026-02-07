# playground
# aihe: arrayt (listat) ja hashtablet (avain=arvo)
# tämä on perus-dataa, jota käytetään koko ajan (myös IAM-jutuissa)

# --------------------------------------------------
# ARRAY (lista)
# Array = monta asiaa yhdessä.
# --------------------------------------------------

# 1) tehdään lista
$names = @("Karita", "William", "Roosa")

$names
$names.GetType().FullName

# 2) hae yksi asia listasta
# [0] = ensimmäinen (laskeminen alkaa nollasta)
$names[0]
$names[1]

# 3) montako asiaa listassa on
$names.Count

# 4) lisää listaan (yksinkertainen tapa)
$names = $names + "Essi"
$names

# 5) käy lista läpi
foreach ($n in $names) {
    $n
}

# --------------------------------------------------
# HASHTABLE (avain = arvo)
# Hashtable = "sanakirja": jokaisella avaimella on arvo.
# --------------------------------------------------

# 6) tehdään hashtable
$user = @{
    Name    = "Karita"
    Role    = "Service Desk"
    Enabled = $true
}

$user
$user.GetType().FullName

# 7) hae arvo avaimen avulla
$user.Name
$user.Role
$user.Enabled

# 8) lisää uusi avain
$user.Department = "IT"
$user

# 9) muuta arvo
$user.Role = "IAM-focused"
$user

# 10) listaa avaimet
$user.Keys

# 11) käy avain-arvo parit läpi
foreach ($key in $user.Keys) {
    "$key = $($user[$key])"
}

# --------------------------------------------------
# ARRAY + HASHTABLE yhdessä (tämä on tosi yleinen)
# lista käyttäjiä, jokainen käyttäjä = hashtable
# --------------------------------------------------

$users = @(
    @{ Name = "Karita";  Department = "IT";  Enabled = $true  },
    @{ Name = "Mikko";   Department = "HR";  Enabled = $false },
    @{ Name = "Sari";    Department = "IT";  Enabled = $true  }
)

$users
$users.Count

# 12) suodata (Where-Object)
$users | Where-Object { $_.Department -eq "IT" }

# 13) suodata vain aktiiviset
$users | Where-Object { $_.Enabled -eq $true }

# 14) valitse vain tietyt kentät
$users | Select-Object Name, Department

# --------------------------------------------------
# MUISTILAPPU ITSELLE (IAM yhteys)
# --------------------------------------------------

# IAM-jutuissa tulee koko ajan sama rakenne:
# - lista käyttäjiä / ryhmiä / laitteita (array)
# - jokaisella on kenttiä (hashtable / objekti)
# - suodatetaan ja valitaan propertyjen avulla
