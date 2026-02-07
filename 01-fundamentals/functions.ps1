# playground
# aihe: funktiot
# funktio = oma pieni komento
# sama ajatus toistuu monessa arjen tilanteessa

# --------------------------------------------------
# 1) yksinkertaisin mahdollinen funktio
# --------------------------------------------------

function Say-Hello {
    "hello"
}

Say-Hello

# --------------------------------------------------
# 2) funktio, joka ottaa tiedon ulkoa
# --------------------------------------------------

function Say-HelloTo {
    param (
        $Name
    )

    "hello $Name"
}

Say-HelloTo -Name "Karita"

# --------------------------------------------------
# 3) funktio + yksinkertainen ehto
# --------------------------------------------------

function Check-Enabled {
    param (
        $Enabled
    )

    if ($Enabled -eq $true) {
        "enabled"
    }
    else {
        "disabled"
    }
}

Check-Enabled -Enabled $true
Check-Enabled -Enabled $false

# --------------------------------------------------
# 4) yksi arjessa vastaan tuleva "tietue"
# --------------------------------------------------

$item = @{
    Identifier = "karita@example.com"
    Department = "IT"
    Enabled    = $true
}

# --------------------------------------------------
# 5) funktio, joka lukee tietuetta
# --------------------------------------------------

function Get-ItemStatus {
    param (
        $Item
    )

    if ($Item.Enabled -eq $true) {
        "item is enabled"
    }
    else {
        "item is disabled"
    }
}

Get-ItemStatus -Item $item

# --------------------------------------------------
# 6) lista vastaavia tietueita
# --------------------------------------------------

$items = @(
    @{ Identifier = "karita@example.com"; Department = "IT"; Enabled = $true  },
    @{ Identifier = "mikko@example.com";  Department = "HR"; Enabled = $false },
    @{ Identifier = "sari@example.com";   Department = "IT"; Enabled = $true  }
)

# --------------------------------------------------
# 7) funktio: hae vain käytössä olevat
# --------------------------------------------------

function Get-EnabledItems {
    param (
        $Items
    )

    $Items | Where-Object { $_.Enabled -eq $true }
}

Get-EnabledItems -Items $items

# --------------------------------------------------
# 8) funktio: hae osaston mukaan
# --------------------------------------------------

function Get-ItemsByDepartment {
    param (
        $Items,
        $Department
    )

    $Items | Where-Object { $_.Department -eq $Department }
}

Get-ItemsByDepartment -Items $items -Department "IT"

# --------------------------------------------------
# 9) yhdistetty suodatus (tätä tapahtuu arjessa paljon)
# --------------------------------------------------

function Get-ActiveItemsByDepartment {
    param (
        $Items,
        $Department
    )

    $Items |
        Where-Object { $_.Enabled -eq $true } |
        Where-Object { $_.Department -eq $Department }
}

Get-ActiveItemsByDepartment -Items $items -Department "IT"

# --------------------------------------------------
# 10) funktio palauttaa dataa
# --------------------------------------------------

$activeITItems = Get-ActiveItemsByDepartment -Items $items -Department "IT"
$activeITItems
$activeITItems.Count

# --------------------------------------------------
# 11) ajatus myöhemmin muualla
# --------------------------------------------------

# sama malli toistuu:
# - hae lista asioita
# - suodata tilan mukaan
# - rajaa kontekstin mukaan
# - palauta data jatkokäsittelyyn

# --------------------------------------------------
# MUISTILAPPU ITSELLE
# --------------------------------------------------

# funktio = nimetty pala toistuvaa logiikkaa
# tekee skriptistä luettavamman
# ja ajattelusta selkeämpää
