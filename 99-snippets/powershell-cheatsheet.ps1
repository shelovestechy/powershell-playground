# 99-snippets/powershell-cheatsheet.ps1
# iso pikamuistilista / copy–paste -pankki
# huom: osa riveistä vaatii oikeudet / moduulit / yhteyden

# =========================================================
# 0) PERUS: apu, syntaksi, tiedonhaku
# =========================================================

# mikä komento tekee mitä
# Get-Help Get-Process -Full
# Get-Help Get-Process -Examples

# mikä komento löytyy
# Get-Command *user*
# Get-Command -Module Microsoft.Graph.Users

# komennon parametrit
# (Get-Command Get-Process).Parameters.Keys

# =========================================================
# 1) OBJEKTIT: Get-Member, Select, Where, Sort, Group
# =========================================================

# katso mitä kenttiä (propertyjä) objektissa on
# Get-Process | Get-Member

# valitse kenttiä
# Get-Process | Select-Object Name, Id, CPU | Select-Object -First 10

# suodata (Where-Object)
# Get-Process | Where-Object { $_.CPU -gt 100 }

# järjestä
# Get-Process | Sort-Object CPU -Descending | Select-Object Name, CPU -First 10

# ryhmitä
# Get-Service | Group-Object Status

# laske nopeasti
# (Get-Process).Count

# =========================================================
# 2) MUUTTUJAT, TYYPIT, NULL, TRUE/FALSE
# =========================================================

# null-check
# if ($null -eq $x) { "empty" }

# true/false ehtoja
# if ($flag) { "on" } else { "off" }

# tyyppi
# $x.GetType().FullName

# =========================================================
# 3) STRING: Trim, ToLower, Replace, Split, Join, Format
# =========================================================

# normalisoi (jäsenyystarkistuksiin jne)
# $v = "  Karita@Example.com  "
# $vClean = $v.Trim().ToLower()

# replace
# "hello world" -replace "world","you"

# split
# "a;b;c" -split ";"

# join
# @("a","b","c") -join ";"

# string format
# $name="Karita"; "hi {0}" -f $name

# =========================================================
# 4) ARRAY/LISTA: contains, notcontains, unique, foreach
# =========================================================

# tarkista jäsenyys (string-lista)
# $list = @("a","b","c")
# $list -contains "b"

# lisää vain jos puuttuu
# $val = "x"
# if ($list -notcontains $val) { $list = $list + $val }

# uniikit
# $list | Sort-Object -Unique

# loop
# foreach ($x in $list) { $x }

# =========================================================
# 5) HASHTABLE/OBJEKTI: PSCustomObject, keys, propertyt
# =========================================================

# hashtable
# $h = @{ Name="Karita"; Enabled=$true }
# $h.Name

# lisää kenttä
# $h.Department = "IT"

# PSCustomObject (siistimpi exporteihin)
# $o = [pscustomobject]@{ Name="Karita"; Enabled=$true }
# $o

# listaa avaimet
# $h.Keys

# =========================================================
# 6) FILES/PATH: Test-Path, New-Item, Get-ChildItem, Select-String
# =========================================================

# onko olemassa
# Test-Path ".\file.txt"

# luo kansio
# if (-not (Test-Path ".\logs")) { New-Item ".\logs" -ItemType Directory | Out-Null }

# listaa tiedostot
# Get-ChildItem . -Recurse -File

# etsi tekstistä
# Select-String -Path .\*.log -Pattern "error" -SimpleMatch

# =========================================================
# 7) JSON/CSV: ConvertTo/From-Json, Export/Import-Csv
# =========================================================

# json -> tiedosto
# $cfg = @{ Department="IT"; EnabledOnly=$true }
# $cfg | ConvertTo-Json | Out-File .\config.json -Encoding UTF8

# tiedosto -> json
# $cfg2 = (Get-Content .\config.json) | ConvertFrom-Json

# csv export
# $data | Export-Csv .\out.csv -NoTypeInformation -Encoding UTF8

# csv import
# $rows = Import-Csv .\out.csv

# =========================================================
# 8) ERROR HANDLING: try/catch, -ErrorAction, throw
# =========================================================

# perus try/catch
# try { Get-Item "C:\nope.txt" -EA Stop } catch { $_.Exception.Message }

# oma virhe
# if (-not $ok) { throw "fail: something was not ok" }

# =========================================================
# 9) LOGGING: nopea peruslogi tiedostoon
# =========================================================

# $log = ".\logs\run.log"
# $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [INFO] started"
# $line | Out-File $log -Append -Encoding UTF8

# =========================================================
# 10) PROSESSIT/SERVICES: käytännön
# =========================================================

# top cpu
# Get-Process | Sort-Object CPU -Descending | Select-Object Name, CPU -First 10

# running services
# Get-Service | Where-Object { $_.Status -eq "Running" } | Select-Object Name, Status

# =========================================================
# 11) NETWORK: ping, dns, ports
# =========================================================

# ping
# Test-Connection "8.8.8.8" -Count 2

# dns
# Resolve-DnsName "microsoft.com"

# port check
# Test-NetConnection "login.microsoftonline.com" -Port 443

# ipconfig (legacy)
# ipconfig /all

# =========================================================
# 12) WINDOWS EVENT LOG: nopea haku
# =========================================================

# viimeisimmät system-eventit
# Get-WinEvent -LogName System -MaxEvents 20

# etsi virheet
# Get-WinEvent -LogName System -MaxEvents 200 | Where-Object { $_.LevelDisplayName -eq "Error" }

# =========================================================
# 13) SERVICES DESK -tyyppiset pikajutut (paikallinen kone)
# =========================================================

# koneen nimi
# $env:COMPUTERNAME

# käyttäjän nimi
# $env:USERNAME

# uptime (helppo tapa)
# (Get-CimInstance Win32_OperatingSystem).LastBootUpTime

# levytila
# Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, Size, FreeSpace

# =========================================================
# 14) GRAPH / ENTRA - SNIPPETS (vaatii moduulin + kirjautumisen)
# =========================================================
# NOTE: Nämä ovat "kun mahdollista" -snippettejä.
# Et välttämättä voi ajaa työasemalla ilman moduuleja/oikeuksia.

# --- Graph: kirjautuminen (esimerkki)
# Connect-MgGraph -Scopes "User.Read.All","Group.Read.All"
# Get-MgContext

# --- Entra (jos käytössä)
# Connect-Entra

# =========================================================
# 15) Käyttäjän haku (Graph)
# =========================================================

# hae user UPN:llä
# Get-MgUser -Filter "userPrincipalName eq 'user@domain.com'" -ConsistencyLevel eventual

# hae displayName:lla (täsmä)
# Get-MgUser -Filter "displayName eq 'Firstname Lastname'" -ConsistencyLevel eventual

# hae "contains" (voi vaatia eventual ja joskus ei ole täydellinen)
# Get-MgUser -Filter "startsWith(displayName,'Kar')" -ConsistencyLevel eventual

# hae tietyt propertyt
# Get-MgUser -UserId "user@domain.com" -Property "displayName,userPrincipalName,mail,accountEnabled"

# =========================================================
# 16) Ryhmät (Graph)
# =========================================================

# hae ryhmä nimellä
# Get-MgGroup -Filter "displayName eq 'esimerkkiryhmä'" -ConsistencyLevel eventual

# hae kaikki mail-enabled non-security (jakeluryhmätyyppinen)
# Get-MgGroup -All -Filter "mailEnabled eq true and securityEnabled eq false" -ConsistencyLevel eventual | Select-Object DisplayName, Id, Mail

# hae vain security groups
# Get-MgGroup -All -Filter "securityEnabled eq true" -ConsistencyLevel eventual

# =========================================================
# 17) Ryhmän jäsenet (Graph)
# =========================================================

# $g = Get-MgGroup -Filter "displayName eq 'esimerkkiryhmä'" -ConsistencyLevel eventual
# Get-MgGroupMember -GroupId $g.Id -All

# vain käyttäjät jäsenistä
# $members = Get-MgGroupMember -GroupId $g.Id -All
# $userMembers = $members | Where-Object { $_.AdditionalProperties.'@odata.type' -eq "#microsoft.graph.user" }

# käyttäjien UPN:t (vaatii Get-MgUser jokaiselle)
# foreach ($m in $userMembers) { (Get-MgUser -UserId $m.Id -Property "userPrincipalName").UserPrincipalName }

# =========================================================
# 18) Jäsenyystarkistus (Graph)
# =========================================================

# "onko user ryhmässä" -tyyppinen (yksi tapa: hae jäsenet ja vertaile)
# $targetUpn = "user@domain.com"
# $upns = foreach ($m in $userMembers) { (Get-MgUser -UserId $m.Id -Property "userPrincipalName").UserPrincipalName }
# $upns -contains $targetUpn

# =========================================================
# 19) Exportit (Graph)
# =========================================================

# ryhmät csv:ksi
# Get-MgGroup -All -Filter "mailEnabled eq true and securityEnabled eq false" -ConsistencyLevel eventual |
#   Select-Object DisplayName, Mail, Id |
#   Export-Csv .\groups.csv -NoTypeInformation -Encoding UTF8

# =========================================================
# 20) PERF / VAROITUS: isot tenantit
# =========================================================
# Jos haet "kaikki ryhmät + kaikki jäsenet + jokaiselle userhaku", se on hidas.
# Tee aina raja:
# -MaxGroups
# -MaxMembersPerGroup
# tai rajaa nimellä (contains(displayName,'X'))

# =========================================================
# 21) PARAMETRIT: skriptin ajaminen parametreilla
# =========================================================

# .\Invoke-UserLookup.ps1 -InputFile .\users.txt -OutFile .\out.csv -IncludeNotFound
# .\Invoke-DistributionGroupInventory.ps1 -IncludeMembers -MaxGroups 10 -MaxMembersPerGroup 200

# =========================================================
# 22) PIKAKOMENTOJA "TÄMÄN HETKEN" DEBUGIIN
# =========================================================

# missä olen
# Get-Location

# mitä tiedostoja tässä on
# Get-ChildItem

# mitä muuttujia on olemassa (varovasti, voi olla paljon)
# Get-Variable | Select-Object -First 50

# =========================================================
# 23) TEE OMA SNIPPET
# =========================================================
# pidä kaava:
# - 1-3 riviä
# - suoraan ajettavissa
# - ei riippuvuuksia jos mahdollista
# - jos riippuu: kommenttiin "vaatii X"
