# 🛠️ PowerShell Playground

**A personal learning playground and a growing PowerShell handbook.**

Tämä repositorio on hiekkalaatikkoni, jossa rakennan ymmärrykseni PowerShellistä pohjamudista alkaen. Tänne kerään muistiinpanoja, kokeiluja, raakavedoksia ja IT-arjessa vastaantulevia patterneja.

Pisteenä i:n päälle tässä ei ole kyse vain kopioinnista, vaan siitä, **mitä konepellin alla tapahtuu**: miksi asiat toimivat kuten ne toimivat ja miten työkaluja käytetään ilman arvailua.

---

## 🧭 Roadmap: Zero to IAM Hero

Tämä polku on jaettu vaiheisiin, jotka vievät perusasioista syvään päätyyn (Identity, Security & Automation).

### Phase 1: The Foundation (Core Concepts)
*Tavoitteena ymmärtää, ettei kyseessä ole teksti, vaan objektit.*
- [ ] **The Pipeline:** Miten data virtaa (`Select-Object`, `Where-Object`, `ForEach-Object`).
- [ ] **Object Anatomy:** Jäsenet, metodit ja ominaisuudet (`Get-Member`).
- [ ] **Variables & Data Types:** String, Int, Array, Hashtable ja Custom Objects.
- [ ] **Filtering & Sorting:** Tehokas datan käsittely ennen tulostusta.
- [ ] **The Help System:** Miten löytää vastaukset itse (`Get-Help`, `Get-Command`).

### Phase 2: Logic & Scripting Basics
*Tavoitteena kirjoittaa skriptejä, jotka tekevät päätöksiä.*
- [ ] **Control Flow:** `if/else`, `switch`, `while` ja `do-until` loopit.
- [ ] **Error Handling:** `Try/Catch/Finally` ja `$ErrorActionPreference`.
- [ ] **Functions:** Parametrien käyttö, `Process`-blokit ja koodin uusiokäyttö.
- [ ] **File I/O:** CSV, JSON ja XML -tiedostojen lukeminen ja kirjoittaminen.
- [ ] **Scope:** Global, Script, Local ja Private muuttujien erot.

### Phase 3: Advanced Automation & Toolmaking
*Tavoitteena rakentaa työkaluja, jotka kestävät käyttöä.*
- [ ] **Advanced Functions:** `[CmdletBinding()]`, validointi-attribuutit ja dynaamiset parametrit.
- [ ] **Modules:** Omien moduulien (.psm1) rakentaminen ja manifestit.
- [ ] **Logging & Verbosity:** `Write-Verbose` ja transkriptien käyttö.
- [ ] **Performance Tuning:** `Measure-Command` ja .NET-luokkien hyödyntäminen.
- [ ] **API Interaction:** `Invoke-RestMethod` (Graph API:n perusta).

### Phase 4: IAM & Cloud Identity (The Senior Path)
*Tavoitteena hallita identiteettiä ja pääsyhallintaa ohjelmallisesti.*
- [ ] **Microsoft Graph SDK:** Kirjautuminen, luvat (Scopes) ja resurssien hallinta.
- [ ] **Active Directory (Hybrid):** On-prem AD -objektien hallinta ja synkronointi.
- [ ] **Entra ID (Azure AD):** Käyttäjien elinkaarihallinta (JML - Joiner, Mover, Leaver).
- [ ] **Role-Based Access Control (RBAC):** Oikeuksien auditointi ja hallinta skripteillä.
- [ ] **Security Auditing:** Epäilyttävien muutosten monitorointi ja raportointi.

---

## 🏛️ Structure

* [**01-fundamentals**](./01-fundamentals) – Peruskäsitteet, hitaasti ja huolella.
* [**02-logic-and-flow**](./02-logic-and-flow) – Silmukat, virheenkäsittely ja logiikka.
* [**03-automation-patterns**](./03-automation-patterns) – Moduulit, logit ja uudelleenkäytettävät mallit.
* [**04-iam-and-m365**](./04-iam-and-m365) – Identity, Entra ID, MS Graph ja tietoturva.
* [**99-snippets**](./99-snippets) – One-linerit ja pika-apuvälineet.
* [**docs**](./docs) – Syvemmät muistiinpanot ja kirja-analyysit.

---

## 📜 Principles

1.  **Objects over text.** PowerShell ei ole Bash. Käsittele objekteja, älä parsia tekstiä.
2.  **Understand before optimizing.** Ensin toimiva koodi, sitten vasta hienostelu.
3.  **Idempotency.** Skriptin on voitava ajaa kahdesti ilman, että se rikkoo mitään.
4.  **No silent failures.** Virheet saavat näkyä, jotta ne voidaan korjata.
5.  **Future-me insurance.** Kirjoita niin, että ymmärrät koodisi vielä 6kk päästä.

---

## 📚 Resources
* *PowerShell in a Month of Lunches* (Jeffery Hicks & Travis Plunk)
* *PowerShell 101* (Microsoft)
* [Microsoft Learn: PowerShell Documentation](https://learn.microsoft.com/en-us/powershell/)

---

**Status:** 🏗️ Active learning phase.
**Language:** Suomi / English.
