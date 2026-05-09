# Microsoft Graph + PowerShell: komentoja oikeaan käyttöön

Tämä tiedosto on käytännön listaus Microsoft Graph PowerShell -komennoista, joita IAM-, Entra ID- ja Microsoft 365 -hommissa oikeasti tarvitaan. 

((Huom. lisenssien lisäys ym on ehket helpompaa tai selkeämpää tehdä Entran kautta mutta nämä on hyvä osata anyways))

Ei pelkkää “tässä komento, onnea matkaan” -meininkiä, vaan mitä komento tekee, milloin sitä käytetään ja pieni esimerkki Ankkalinna-ympäristöllä.

Esimerkkiympäristö:

- Yritys: Ankkalinna Oy
- Domain: ankkalinna.fi
- Käyttäjäesimerkki: aku.ankka@ankkalinna.fi
- Admin-esimerkki: admin@ankkalinna.fi

> Huom: Älä aja poisto-, lisenssi- tai ryhmämuutoskomentoja tuotannossa sokkona. Ensin haetaan tieto, katsotaan mitä komento tekee ja vasta sitten muutetaan mitään. PowerShell ei aina kysy nätisti “ootko nyt ihan varma?” — joskus se vain tekee.

---

## 1. Microsoft Graphiin yhdistäminen

Ensin pitää kirjautua Microsoft Graphiin. Ilman tätä komennot eivät tiedä, mihin tenanttiin ollaan menossa.

    Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All"

Tämä avaa kirjautumisen ja pyytää oikeudet lukea käyttäjiä ja ryhmiä.

Tätä käytetään, kun halutaan vain katsoa tietoja eikä muuttaa mitään.

Jos pitää muokata käyttäjiä tai ryhmiä, tarvitaan laajemmat oikeudet:

    Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All"

Elikkäs:

> Ensin pyydetään vain lukuoikeudet. Muokkausoikeudet vasta sitten, kun ihan oikeasti pitää muuttaa jotain.

---

## 2. Tarkista mihin olet kirjautunut

    Get-MgContext

Tällä näet nykyisen Graph-yhteyden tiedot.

Hyödyllinen komento, koska väärään tenanttiin kirjautuminen on todella klassinen sekasotku. Kaikki näyttää aluksi hyvältä, kunnes huomaat, että olet ihan väärässä paikassa.

Elikkäs:

> Ennen kuin alat säätää mitään, tarkista missä olet. Ei lähdetä lapioimaan väärää hiekkalaatikkoa.

---

## 3. Katkaise Graph-yhteys

    Disconnect-MgGraph

Tämä katkaisee yhteyden Microsoft Graphiin.

Hyvä tapa käyttää, kun olet valmis tai vaihdat toiseen tenanttiin.

Elikkäs:

> Kun homma on valmis, sulje yhteys. Siisti työskentelytapa tekee elämästä vähemmän kaoottista.

---

## 4. Hae yksittäinen käyttäjä

    Get-MgUser -UserId "aku.ankka@ankkalinna.fi"

Tämä hakee käyttäjän userPrincipalName-arvolla.

Tätä käytetään, kun halutaan tarkistaa nopeasti:

- löytyykö käyttäjä
- onko tunnus olemassa
- näkyykö käyttäjä Graphin kautta
- onko kirjoitusasu oikein

Elikkäs:

> Tämä on IAM-maailman “onko tämä käyttäjä edes olemassa?” -komento.

---

## 5. Hae käyttäjä ja näytä vain tärkeät tiedot

    Get-MgUser -UserId "aku.ankka@ankkalinna.fi" -Property DisplayName,UserPrincipalName,Mail,AccountEnabled,Department,JobTitle |
        Select-Object DisplayName, UserPrincipalName, Mail, AccountEnabled, Department, JobTitle

Tämä on paljon siistimpi kuin täysi raakadata.

Tällä näet heti tärkeimmät tiedot:

- nimi
- käyttäjätunnus
- sähköpostiosoite
- onko tunnus aktiivinen
- osasto
- työnimike

Elikkäs:

> Älä kaiva koko romuläjää, jos tarvitset vain muutaman kentän.

---

## 6. Hae kaikki käyttäjät

    Get-MgUser -All

Tämä hakee kaikki tenantin käyttäjät.

Tätä ei välttämättä kannata ajaa ihan huvikseen isossa ympäristössä, koska tulosta voi tulla paljon.

Useammin kannattaa hakea vain tarvittavat kentät:

    Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled |
        Select-Object DisplayName, UserPrincipalName, AccountEnabled

Elikkäs:

> Kaikki käyttäjät saa haettua, mutta fiksu ihminen hakee vain sen mitä tarvitsee.

---

## 7. Hae kaikki käyttäjät tietyltä domainilta

    Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled |
        Where-Object { $_.UserPrincipalName -like "*@ankkalinna.fi" } |
        Select-Object DisplayName, UserPrincipalName, AccountEnabled

Tämä listaa kaikki käyttäjät, joiden UPN päättyy `@ankkalinna.fi`.

Tätä voi käyttää esimerkiksi, kun halutaan tarkistaa:

- ketkä ovat yrityksen omalla domainilla
- löytyykö vanhoja tai outoja tunnuksia
- onko mukana käyttäjiä, joiden ei pitäisi olla aktiivisia

Elikkäs:

> Domain kertoo usein paljon siitä, kuuluuko käyttäjä oikeaan ympäristöön vai onko mukana jotain vanhaa roskaa.

---

## 8. Hae aktiiviset käyttäjät

    Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled |
        Where-Object { $_.AccountEnabled -eq $true } |
        Select-Object DisplayName, UserPrincipalName, AccountEnabled

Tämä näyttää aktiiviset käyttäjätilit.

IAM-näkökulmasta aktiivinen tunnus tarkoittaa aina mahdollista pääsyä johonkin.

Elikkäs:

> Aktiivinen tunnus = potentiaalinen pääsy. Ei pidetä turhia tunnuksia hengissä kuin zombiankkoja.

---

## 9. Hae pois käytöstä olevat käyttäjät

    Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled |
        Where-Object { $_.AccountEnabled -eq $false } |
        Select-Object DisplayName, UserPrincipalName, AccountEnabled

Tämä näyttää käyttäjät, joiden tunnus on pois käytöstä.

Tätä käytetään esimerkiksi offboarding-tarkistuksissa.

Hyviä kysymyksiä:

- miksi tunnus on disabloitu?
- onko lisenssit poistettu?
- onko käyttäjä vielä ryhmissä?
- pitäisikö tunnus poistaa myöhemmin kokonaan?
- onko data käsitelty oikein?

Elikkäs:

> Disabloitu tunnus ei vielä tarkoita, että offboarding on tehty loppuun.

---

## 10. Luo uusi käyttäjä

Ensin tehdään salasanaprofiili.

    $passwordProfile = @{
        Password = "VaihdaTamaHeti!2026"
        ForceChangePasswordNextSignIn = $true
    }

Sitten luodaan käyttäjä.

    New-MgUser `
        -DisplayName "Aku Ankka" `
        -UserPrincipalName "aku.ankka@ankkalinna.fi" `
        -MailNickname "aku.ankka" `
        -AccountEnabled `
        -PasswordProfile $passwordProfile

Tämä luo uuden käyttäjän Ankkalinna-tenanttiin.

Tärkeää:

- salasana on vain esimerkki
- käyttäjän pitää vaihtaa salasana ensimmäisellä kirjautumisella
- tuotannossa käyttäjän luonti tulee yleensä HR-prosessista, tiketin kautta tai automaation kautta

Elikkäs:

> Käyttäjän luonti ei ole vain tekninen nappi. Se on joiner-prosessin alku.

---

## 11. Päivitä käyttäjän osasto ja työnimike

    Update-MgUser -UserId "aku.ankka@ankkalinna.fi" `
        -Department "Finance" `
        -JobTitle "Accounting Specialist"

Tätä käytetään, kun käyttäjän tiedot muuttuvat.

IAM-näkökulmasta tämä liittyy mover-prosessiin:

- henkilö vaihtaa tiimiä
- työnimike muuttuu
- osasto muuttuu
- oikeuksien pitäisi muuttua mukana

Elikkäs:

> Jos rooli muuttuu mutta oikeudet eivät muutu, syntyy helposti käyttöoikeusroskaa.

---

## 12. Poista käyttäjän tunnus käytöstä

    Update-MgUser -UserId "aku.ankka@ankkalinna.fi" -AccountEnabled:$false

Tämä disabloi käyttäjän tunnuksen.

Tätä käytetään esimerkiksi, kun:

- työntekijä lähtee
- tunnus pitää lukita nopeasti
- epäillään väärinkäyttöä (!!!)
- halutaan estää kirjautuminen ennen lopullista poistoprosessia

Elikkäs:

> Offboardingissa ensimmäinen iso kysymys on: pääseekö käyttäjä enää sisään?

---

## 13. Aktivoi käyttäjän tunnus

    Update-MgUser -UserId "aku.ankka@ankkalinna.fi" -AccountEnabled:$true

Tämä aktivoi käyttäjän tunnuksen takaisin käyttöön.

Tätä voidaan tarvita esimerkiksi, jos käyttäjä on disabloitu vahingossa tai tunnus pitää palauttaa käyttöön.

Elikkäs:

> Aktivointi on helppoa teknisesti, mutta varmista aina miksi tunnus oli pois päältä ennen kuin laitat sen takaisin päälle.

---

## 14. Poista käyttäjä

    Remove-MgUser -UserId "aku.ankka@ankkalinna.fi"

Tämä poistaa käyttäjän.

Tätä ei ajeta kevyesti.

Ennen poistoa pitää miettiä ainakin:

- onko mailbox käsitelty?
- tarvitaanko OneDrive-dataa?
- onko lisenssit poistettu?
- onko käyttäjä poistettu ryhmistä?
- onko auditointi tai säilytysvaatimuksia?
- onko poisto yrityksen prosessin mukainen?

Elikkäs:

> Poistaminen on viimeinen askel, ei paniikkinappi.

---

## 15. Hae käyttäjän ryhmäjäsenyydet

    Get-MgUserMemberOf -UserId "aku.ankka@ankkalinna.fi"

Tämä hakee käyttäjän ryhmäjäsenyydet.

Jos haluat nähdä raakamuodossa mitä Graph palauttaa:

    Get-MgUserMemberOf -UserId "aku.ankka@ankkalinna.fi" |
        Select-Object Id, AdditionalProperties

Tätä käytetään, kun halutaan selvittää:

- mihin ryhmiin käyttäjä kuuluu
- mistä oikeudet voivat tulla
- onko mukana vanhoja ryhmiä
- onko käyttäjälle kertynyt turhia oikeuksia

Elikkäs:

> Ryhmät ovat usein se paikka, mistä käyttöoikeudet oikeasti tulevat. Käyttäjän oikeuksia ei ymmärrä katsomatta ryhmiä.

---

## 16. Hae ryhmä nimen perusteella

    Get-MgGroup -Filter "displayName eq 'Ankkalinna Finance Users'"

Tämä hakee ryhmän nimen perusteella.

Monessa Graph-komennossa tarvitaan ryhmän Id-arvoa, ei pelkkää nimeä.

Elikkäs:

> Ihminen muistaa ryhmän nimen. Graph haluaa usein sen ID:n. Koska tietenkin haluaa.

---

## 17. Tallenna käyttäjä ja ryhmä muuttujiin

    $user = Get-MgUser -UserId "aku.ankka@ankkalinna.fi"
    $group = Get-MgGroup -Filter "displayName eq 'Ankkalinna Finance Users'"

Tämän jälkeen voit käyttää arvoja näin:

    $user.Id
    $group.Id

Muuttujat tekevät komennoista helpompia lukea ja vähentävät toistoa.

Elikkäs:

> Jos komento alkaa näyttää käärmeeltä, ota muuttujat käyttöön.

---

## 18. Lisää käyttäjä ryhmään

    New-MgGroupMember -GroupId $group.Id -DirectoryObjectId $user.Id

Tämä lisää käyttäjän ryhmään.

Tätä käytetään esimerkiksi, kun:

- uusi työntekijä tarvitsee tiimiryhmän
- käyttäjä siirtyy uuteen rooliin
- käyttäjä saa pääsyn sovellukseen ryhmän kautta

Muista: ryhmään lisääminen ei ole vain “lisätään nyt kun pyydettiin” !

Hyvät kysymykset:

- miksi käyttäjä tarvitsee tämän?
- kuka hyväksyi tämän?
- onko tämä määräaikainen?
- tuleeko oikeus roolin kautta vai yksittäisenä poikkeuksena?

Elikkäs:

> Ryhmään lisääminen on käyttöoikeuden antamista. Sitä ei pidä tehdä sokkona.

---

## 19. Poista käyttäjä ryhmästä

    Remove-MgGroupMemberByRef -GroupId $group.Id -DirectoryObjectId $user.Id

Tämä poistaa käyttäjän ryhmästä.

Tätä käytetään esimerkiksi, kun:

- käyttäjä vaihtaa tehtävää
- käyttäjä ei enää tarvitse pääsyä
- käyttäjä lähtee yrityksestä
- access review’n jälkeen poistetaan turhat oikeudet

Elikkäs:

> Ryhmästä poistaminen on yhtä tärkeä taito kuin lisääminen. Oikeuksien siivoaminen on IAM:n oikeaa arkea.

---

## 20. Listaa ryhmän jäsenet

    Get-MgGroupMember -GroupId $group.Id -All

Tämä näyttää ryhmän jäsenet.

Tätä käytetään, kun halutaan tarkistaa:

- ketkä kuuluvat ryhmään
- onko ryhmä paisunut oudosti
- löytyykö käyttäjiä, joiden ei pitäisi olla mukana
- onko ryhmää käytetty “kaatopaikkana” vuosien ajan

Elikkäs:

> Jos ryhmän nimi on “Finance Users”, siellä ei ehkä pitäisi olla puolta organisaatiota. Hurja ajatus, tiedän.

---

## 21. Hae käyttäjän lisenssit

    Get-MgUserLicenseDetail -UserId "aku.ankka@ankkalinna.fi"

Tämä näyttää käyttäjän lisenssitiedot.

Tätä käytetään esimerkiksi, kun selvitetään:

- onko käyttäjällä Microsoft 365 -lisenssi
- miksi Teams, Exchange tai Office ei toimi
- onko lähteneellä käyttäjällä vielä maksullinen lisenssi päällä
- tuleeko lisenssi suoraan vai ryhmän kautta

Elikkäs:

> Lisenssi ei ole vain laskutusasia. Se vaikuttaa suoraan siihen, mitä käyttäjä voi käyttää.

---

## 22. Hae tenantin saatavilla olevat lisenssit

    Get-MgSubscribedSku |
        Select-Object SkuPartNumber, ConsumedUnits, PrepaidUnits

Tämä näyttää tenantin lisenssipaketit.

Hyödyllinen, kun halutaan nähdä:

- mitä lisenssejä yrityksellä on
- paljonko lisenssejä on käytössä
- onko vapaita lisenssejä jäljellä

Elikkäs:

> Ennen kuin lupaat käyttäjälle lisenssin, tarkista onko niitä edes jäljellä. Taikuus ei kuulu lisenssihallintaan.

---

## 23. Aseta käyttäjälle Usage Location

    Update-MgUser -UserId "aku.ankka@ankkalinna.fi" -UsageLocation "FI"

Tämä asettaa käyttäjän käyttömaaksi Suomen.

Suomi = `FI`

Tämä on tärkeä, koska käyttäjälle pitää yleensä olla asetettu käyttömaa ennen lisenssin antamista.

Elikkäs:

> Ennen lisenssiä tarkista käyttömaa. Muuten lisensointi voi alkaa kiukutella.

---

## 24. Anna käyttäjälle lisenssi

Ensin haetaan oikea lisenssi.

    $sku = Get-MgSubscribedSku | Where-Object { $_.SkuPartNumber -eq "SPE_E3" }

Sitten annetaan lisenssi käyttäjälle.

    Set-MgUserLicense -UserId "aku.ankka@ankkalinna.fi" `
        -AddLicenses @{ SkuId = $sku.SkuId } `
        -RemoveLicenses @()

Huomaa `-RemoveLicenses @()`.

Vaikka et poistaisi lisenssejä, parametri annetaan mukana tyhjänä listana.

Elikkäs:

> Graph haluaa tietää sekä mitä lisätään että mitä poistetaan. Jos et poista mitään, annat tyhjän listan.

---

## 25. Poista käyttäjältä lisenssi

Ensin haetaan lisenssi.

    $sku = Get-MgSubscribedSku | Where-Object { $_.SkuPartNumber -eq "SPE_E3" }

Sitten poistetaan lisenssi käyttäjältä.

    Set-MgUserLicense -UserId "aku.ankka@ankkalinna.fi" `
        -AddLicenses @() `
        -RemoveLicenses @($sku.SkuId)

Tätä käytetään esimerkiksi offboardingissa.

Tärkeää:

- älä poista lisenssiä ennen kuin tiedät mitä tapahtuu mailboxille ja datalle
- varmista yrityksen prosessi
- tarkista onko kyseessä direct licensing vai group-based licensing

Elikkäs:

> Lisenssin poisto voi vaikuttaa palveluihin ja dataan. Ei tehdä sokkona, vaikka komento on lyhyt.

---

## 26. Tarkista käyttäjän manageri

    Get-MgUserManager -UserId "aku.ankka@ankkalinna.fi"

IAM:ssa manageritieto voi olla tärkeä, koska hyväksynnät ja access review’t voivat perustua esihenkilöön.

Jos manageri puuttuu tai on väärin, prosessit voivat mennä vinoon.

Elikkäs:

> Huono käyttäjädata tekee huonoa automaatiota. Roskaa sisään, roskaa ulos.

---

## 27. Aseta käyttäjälle manageri

Ensin haetaan manageri.

    $manager = Get-MgUser -UserId "minni.hiiri@ankkalinna.fi"

Sitten asetetaan manageri käyttäjälle.

    Set-MgUserManagerByRef -UserId "aku.ankka@ankkalinna.fi" -BodyParameter @{
        "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($manager.Id)"
    }

Tämä asettaa käyttäjän managerin.

Tätä voidaan käyttää esimerkiksi labrassa tai tilanteessa, jossa käyttäjätietoja korjataan käsin.

Elikkäs:

> Manageritieto ei ole koriste. Se voi vaikuttaa hyväksyntöihin, työnkulkuun ja käyttöoikeuksien hallintaan.

---

## 28. Etsi käyttäjiä osaston mukaan

    Get-MgUser -All -Property DisplayName,UserPrincipalName,Department |
        Where-Object { $_.Department -eq "Finance" } |
        Select-Object DisplayName, UserPrincipalName, Department

Tätä käytetään, kun halutaan tarkistaa tietyn osaston käyttäjät.

IAM-esimerkki:

> Kaikilla Finance-osaston käyttäjillä pitäisi ehkä olla pääsy talousjärjestelmään, mutta ei välttämättä HR-järjestelmään.

Elikkäs:

> Osasto voi auttaa ymmärtämään, millaiset perusoikeudet käyttäjällä pitäisi olla.

---

## 29. Etsi käyttäjiä työnimikkeen mukaan

    Get-MgUser -All -Property DisplayName,UserPrincipalName,JobTitle |
        Where-Object { $_.JobTitle -like "*Specialist*" } |
        Select-Object DisplayName, UserPrincipalName, JobTitle

Tämä auttaa tutkimaan käyttäjien rooleja.

IAM:ssa tämä liittyy RBAC-ajatteluun.

RBAC = Role-Based Access Control eli roolipohjainen käyttöoikeuksien hallinta.

Ajatus on, että saman roolin käyttäjillä pitäisi olla suunnilleen samat perusoikeudet.

Elikkäs:

> Jos kahdella saman työnimikkeen ihmisellä on täysin eri oikeudet, kannattaa kysyä miksi.

---

## 30. Vie käyttäjälista CSV-tiedostoon

    Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled,Department,JobTitle |
        Select-Object DisplayName, UserPrincipalName, AccountEnabled, Department, JobTitle |
        Export-Csv -Path ".\ankkalinna-users.csv" -NoTypeInformation -Encoding UTF8

Tämä luo CSV-tiedoston käyttäjistä.

Tätä voidaan käyttää esimerkiksi:

- raportointiin
- auditointiin
- access review’n pohjaksi
- Excelissä tutkimiseen

Elikkäs:

> Kaikkea ei tarvitse tuijottaa terminaalissa. Välillä Excel on ihan validi työkalu, vaikka nörtit vähän pyörittelee silmiä.

---

## 31. Vie pois käytöstä olevat käyttäjät CSV-tiedostoon

    Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled,Department |
        Where-Object { $_.AccountEnabled -eq $false } |
        Select-Object DisplayName, UserPrincipalName, AccountEnabled, Department |
        Export-Csv -Path ".\disabled-users.csv" -NoTypeInformation -Encoding UTF8

Tämä luo raportin disabloiduista käyttäjistä.

Tätä voi käyttää offboardingin ja tunnusten siivouksen apuna.

Hyviä jatkokysymyksiä:

- miksi tunnus on pois käytöstä?
- onko lisenssi poistettu?
- onko ryhmät poistettu?
- onko mailbox käsitelty?
- pitääkö tunnus poistaa myöhemmin?

Elikkäs:

> Disabloidut tunnukset eivät saa jäädä ikuiseksi hautausmaaksi tenanttiin.

---

## 32. Tee yksinkertainen käyttäjän tarkistusfunktio

    function Get-AnkkalinnaUserSummary {
        param (
            [Parameter(Mandatory)]
            [string]$UserPrincipalName
        )

        Get-MgUser -UserId $UserPrincipalName -Property DisplayName,UserPrincipalName,Mail,AccountEnabled,Department,JobTitle |
            Select-Object DisplayName, UserPrincipalName, Mail, AccountEnabled, Department, JobTitle
    }

    Get-AnkkalinnaUserSummary -UserPrincipalName "aku.ankka@ankkalinna.fi"

Tämä tekee käyttäjän tarkistuksesta siistimmän.

Sen sijaan että kirjoitat saman pitkän komennon uudestaan ja uudestaan, voit käyttää omaa funktiota.

Elikkäs:

> Jos huomaat toistavasi samaa komentoa jatkuvasti, tee siitä funktio. Se on PowerShellin “hei en jaksa tehdä tätä käsin enää” -hetki.

---

## 33. Mini-checklist käyttäjän tarkistukseen

Kun tarkistan käyttäjää IAM-näkökulmasta, en katso vain yhtä asiaa.

Katson yleensä:

- löytyykö käyttäjä
- onko tunnus aktiivinen
- mikä UPN käyttäjällä on
- mikä mail-osoite käyttäjällä on
- mikä osasto käyttäjällä on
- mikä työnimike käyttäjällä on
- kuuluuko käyttäjä oikeisiin ryhmiin
- kuuluuko käyttäjä outoihin ryhmiin
- onko lisenssi kunnossa
- onko manageritieto oikein
- onko kyse joiner-, mover- vai leaver-tilanteesta

Elikkäs:

> IAM ei ole pelkkää käyttäjän klikkailua. Se on pääsyn, roolien, riskien ja prosessin ymmärtämistä.

---

## 34. Hyvä perusjärjestys Graph-komentoihin

Ensin lue:

    Get-MgUser -UserId "aku.ankka@ankkalinna.fi"

Sitten tarkenna:

    Get-MgUser -UserId "aku.ankka@ankkalinna.fi" -Property DisplayName,UserPrincipalName,AccountEnabled

Sitten vasta muuta:

    Update-MgUser -UserId "aku.ankka@ankkalinna.fi" -AccountEnabled:$false

Elikkäs:

> Read first. Understand second. Change last.

Tämä on oikeasti hyvä sääntö.

Ei tehdä sokkona. Ei sählätä. Ei “katotaan mitä tapahtuu” tuotannossa. Labrassa saa räjäytellä hiekkalaatikkoa, mutta työympäristössä pitää olla aikuinen huoneessa.

---

## 35. Muista tämä:

PowerShell-komento on vain työkalu.

Oikea osaaminen näkyy siinä, että ymmärrät:

- mitä oikeutta olet antamassa
- miksi sitä tarvitaan
- kuka sen hyväksyi
- mistä oikeus tulee
- milloin oikeus pitää poistaa
- mitä riskiä oikeuteen liittyy
- miten muutos dokumentoidaan

Elikkäs:

> Komennon osaaminen on hyvä alku. Mutta IAM-osaaminen alkaa siitä, että ymmärrät miksi komento ajetaan.
