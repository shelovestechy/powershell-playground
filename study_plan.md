# 📅 PowerShell & IAM Mastery: 22 Viikon Opintosuunnitelma

Tämä suunnitelma on jaettu neljään päävaiheeseen. Tavoitteena on edetä johdonmukaisesti perusteista monimutkaisiin IAM (Identity and Access Management) -automaatioihin.

---

## 🟢 Vaihe 1: Perusteet & Objektit (Viikot 1–4)
*Tavoite: Lopeta tekstin parsiminen ja ala hallita objekteja.*

### Viikko 1: Discovery & Help
- [ ] `Get-Help`, `Get-Command`, `Get-Member`.
- [ ] Ohjeiden lukeminen ja esimerkkien hyödyntäminen.
- [ ] Komentojen löytäminen verbien ja nounien perusteella.

### Viikko 2: The Pipeline (Putki)
- [ ] Datan suodatus: `Where-Object`.
- [ ] Datan valitseminen: `Select-Object`.
- [ ] Datan järjestäminen: `Sort-Object`.

### Viikko 3: Muuttujat & Tietotyypit
- [ ] Perustyypit: String, Int, Boolean.
- [ ] Kokoelmat: Array (taulukko) ja Hashtable (sanakirja).
- [ ] `PSCustomObject`-olion luominen.

### Viikko 4: Tiedostojen käsittely
- [ ] CSV-tiedostojen tuonti ja vienti (`Import-Csv`, `Export-Csv`).
- [ ] JSON-datan käsittely (`ConvertFrom-Json`, `ConvertTo-Json`).
- [ ] TXT-tiedostot ja `Out-File` / `Set-Content`.

---

## 🟡 Vaihe 2: Skriptauslogiikka (Viikot 5–9)
*Tavoite: Kirjoita koodia, joka tekee päätöksiä ja toistaa tehtäviä.*

### Viikko 5: Päätöksenteko (Logic)
- [ ] `if`, `else`, `elseif` rakenteet.
- [ ] Vertailuoperaattorit: `-eq`, `-ne`, `-like`, `-match`, `-contains`.
- [ ] `Switch`-rakenne monimutkaisempiin valintoihin.

### Viikko 6: Toisto (Loops)
- [ ] `foreach` (IAM-työn tärkein työkalu).
- [ ] `for`-lause ja `while`-silmukat.
- [ ] `ForEach-Object` käyttö suoraan pipelinessa.

### Viikko 7: Virheiden hallinta
- [ ] `Try { } Catch { }` lohkot.
- [ ] `$ErrorActionPreference` ja `-ErrorAction` parametri.
- [ ] `Finally`-lohkon käyttö puhdistustoimenpiteisiin.

### Viikko 8: Funktiot
- [ ] Perusfunktion kirjoittaminen.
- [ ] Parametrien määrittely ja tyypitys.
- [ ] Paluuarvot ja koodin uusiokäyttö.

### Viikko 9: Scopes & Best Practices
- [ ] Scopen (Global, Local, Script) erojen ymmärtäminen.
- [ ] Muuttujien elinkaari skripteissä.
- [ ] PowerShell-tyylioppaat ja nimeämiskäytännöt.

---

## 🔵 Vaihe 3: Työkalujen rakentaminen (Viikot 10–14)
*Tavoite: Tee koodista ammattimaista, kestävää ja jaettavaa.*

### Viikko 10: Advanced Functions
- [ ] `[CmdletBinding()]` hyödyntäminen.
- [ ] Parametrien validointi (`ValidateNotNullOrEmpty`, `ValidateSet`).
- [ ] `-WhatIf` ja `-Confirm` toiminnallisuuksien lisäys.

### Viikko 11: Moduulit
- [ ] `.psm1` tiedoston luominen.
- [ ] Moduulimanifestit (`.psd1`).
- [ ] Oman moduulikirjaston lataaminen ja hallinta.

### Viikko 12: Dokumentointi & Lokitus
- [ ] Comment-based help (ohjetekstien kirjoitus funktion sisään).
- [ ] Lokitiedostojen automaattinen luonti.
- [ ] `Write-Verbose` ja `Write-Debug` tehokäyttö.

### Viikko 13: Suorituskyky & .NET
- [ ] `Measure-Command` käyttö pullonkaulojen etsinnässä.
- [ ] `.NET`-luokkien kutsuminen (esim. `[System.Text.StringBuilder]`).
- [ ] Suurten datamäärien tehokas käsittely muistissa.

### Viikko 14: API-perusteet (REST)
- [ ] `Invoke-RestMethod` ja `Invoke-WebRequest`.
- [ ] HTTP-metodit (GET, POST, PATCH, DELETE).
- [ ] Headerit ja Auth-tokenien perusteet.

---

## 🔴 Vaihe 4: IAM & Cloud Identity (Viikot 15–22)
*Tavoite: Senior IAM-tason saavuttaminen koodin avulla.*

### Viikko 15: Microsoft Graph SDK Alku
- [ ] Graph Explorerin käyttö testaukseen.
- [ ] Autentikointi: `Connect-MgGraph`.
- [ ] Oikeudet (Scopes) ja App Registrations (Entra ID).

### Viikko 16: Käyttäjähallinta (Cloud)
- [ ] Käyttäjien haku (`Get-MgUser`) ja suodattaminen (`-Filter`).
- [ ] Käyttäjien luonti, päivitys ja poisto pilvessä.
- [ ] Salasanojen ja Authentication Methodien hallinta.

### Viikko 17: Ryhmät & Lisenssit
- [ ] Ryhmäjäsenyyksien automaatio ja auditointi.
- [ ] Dynaamiset ryhmät vs. staattiset ryhmät.
- [ ] M365-lisenssien määrittäminen ja poistaminen koodilla.

### Viikko 18: Hybridi-identiteetti
- [ ] `ActiveDirectory`-moduulin käyttö (On-prem).
- [ ] AD:n ja Entra ID:n välinen synkronointi (atribuuttien tarkistus).
- [ ] On-premise ja Cloud -objektien vertailu skriptillä.

### Viikko 19: RBAC & Oikeudet
- [ ] Directory Rolejen hallinta.
- [ ] PIM (Privileged Identity Management) perusteet PowerShellillä.
- [ ] Oikeusmatriisien ja raporttien generointi.

### Viikko 20: JML-Prosessit (Joiner, Mover, Leaver)
- [ ] Käyttäjän automaattinen luonti (HR-data -> AD/Entra).
- [ ] Provisionointi: Postilaatikot, ryhmät ja oikeudet.
- [ ] Offboarding-työnkulun automatisointi.

### Viikko 21: Tietoturva & Auditointi
- [ ] Kirjautumislokien (Sign-in logs) haku ja analysointi.
- [ ] Kriittisten asetusten (esim. CA-policyt) monitorointi.
- [ ] Automaattiset tietoturvaraportit Teamsiin tai sähköpostiin.

### Viikko 22: Loppuprojekti
- [ ] Rakenna työkalu, joka lukee käyttäjälistan, tarkistaa puuttuvat lisenssit, vertaa niitä määritettyihin ryhmiin ja korjaa erot automaattisesti raportoiden muutokset lokiin.

---

## 🛠️ Työkalut & Resurssit
- **VS Code** + PowerShell Extension.
- **Git** versienhallintaan (tämä repo).
- **M365 Developer Tenant** 
- **PowerShell in a Month of Lunches** -kirja.

---

**Muista:** Laatu korvaa määrän. Jos jokin viikko tuntuu haastavalta, käytä siihen tarvittava aika ennen seuraavaan siirtymistä.
