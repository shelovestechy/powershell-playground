# tool
# 04-tools/Invoke-UserLookup.ps1
# Hae käyttäjiä listan perusteella ja tee raportti (ei tee muutoksia)
#
# INPUT:
# - txt: yksi arvo per rivi (UPN/email/displayName)
# - csv: sarake nimeltä Identifier / UPN / Email / DisplayName (yksi riittää)
#
# LIVE:
# - käyttää Get-EntraUser jos löytyy
# - muuten käyttää Get-MgUser jos löytyy
# - muuten DEMO (ei failaa)
#
# OUTPUT:
# - CSV raportti, mukana Found + miten osui + peruskentät

param(
    [string]$InputFile = ".\users.txt",
    [string]$OutFile   = ".\user-lookup.csv",
    [switch]$IncludeNotFound,
    [switch]$VerboseOutput
)

# --------------------------------------------------
# apufunktiot
# --------------------------------------------------

function Normalize-Value {
    param([string]$Value)
    if ($null -eq $Value) { return "" }
    return $Value.Trim()
}

function Escape-ODataString {
    param([string]$Value)
    # OData string literal: single quotes escaped as doubled
    return ($Value -replace "'", "''")
}

function Get-InputIdentifiers {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        throw "Missing input file: $Path"
    }

    $ext = [System.IO.Path]::GetExtension($Path).ToLowerInvariant()

    if ($ext -eq ".csv") {
        $rows = Import-Csv $Path
        if (-not $rows) { return @() }

        # etsitään järkevä sarake
        $possibleColumns = @("Identifier","UPN","UserPrincipalName","Email","Mail","DisplayName","Name")
        $col = $null
        foreach ($c in $possibleColumns) {
            if ($rows[0].PSObject.Properties.Name -contains $c) { $col = $c; break }
        }
        if (-not $col) {
            throw "CSV missing column. Add one of: Identifier, UPN, UserPrincipalName, Email, DisplayName"
        }

        return $rows |
            ForEach-Object { Normalize-Value $_.$col } |
            Where-Object { $_ -ne "" } |
            Sort-Object -Unique
    }
    else {
        return Get-Content $Path |
            ForEach-Object { Normalize-Value $_ } |
            Where-Object { $_ -ne "" } |
            Sort-Object -Unique
    }
}

function Detect-QueryKind {
    param([string]$Value)
    # hyvin kevyt heuristiikka: email/upn vs "nimi"
    if ($Value -match "^\S+@\S+\.\S+$") { return "UPNOrMail" }
    return "DisplayName"
}

function New-ResultRow {
    param(
        [string]$Identifier,
        [bool]$Found,
        [string]$MatchType,
        [string]$DisplayName,
        [string]$UserPrincipalName,
        [string]$Mail,
        [string]$AccountEnabled,
        [string]$Id,
        [string]$Source,
        [string]$Error
    )

    [pscustomobject]@{
        Identifier       = $Identifier
        Found            = $Found
        MatchType        = $MatchType
        DisplayName      = $DisplayName
        UserPrincipalName= $UserPrincipalName
        Mail             = $Mail
        AccountEnabled   = $AccountEnabled
        Id               = $Id
        Source           = $Source
        Error            = $Error
    }
}

# --------------------------------------------------
# live provider valinta
# --------------------------------------------------

$hasEntra = (Get-Command Get-EntraUser -ErrorAction SilentlyContinue) -ne $null
$hasMg    = (Get-Command Get-MgUser   -ErrorAction SilentlyContinue) -ne $null

$mode =
    if ($hasEntra) { "Entra" }
    elseif ($hasMg) { "Graph" }
    else { "Demo" }

# --------------------------------------------------
# input
# --------------------------------------------------

try {
    $ids = Get-InputIdentifiers -Path $InputFile
}
catch {
    $_.Exception.Message
    "Create $InputFile (txt) or $InputFile (csv) and run again."
    return
}

if ($ids.Count -eq 0) {
    "No input values found in $InputFile"
    return
}

"mode: $mode"
"input count: $($ids.Count)"

# --------------------------------------------------
# lookup
# --------------------------------------------------

$results = @()

foreach ($id in $ids) {

    $kind = Detect-QueryKind -Value $id

    if ($mode -eq "Demo") {
        # DEMO: ei keksi liikaa, vain muoto
        $found = ($kind -eq "UPNOrMail")
        $row = New-ResultRow `
            -Identifier $id `
            -Found $found `
            -MatchType ($kind) `
            -DisplayName "" `
            -UserPrincipalName "" `
            -Mail "" `
            -AccountEnabled "" `
            -Id "" `
            -Source "Demo" `
            -Error ""
        if ($found -or $IncludeNotFound) { $results += $row }
        continue
    }

    if ($mode -eq "Entra") {
        try {
            $safe = Escape-ODataString $id

            # ensisijainen: täsmämatch UPN:ään tai mailiin
            if ($kind -eq "UPNOrMail") {
                $u = Get-EntraUser -Filter "userPrincipalName eq '$safe' or mail eq '$safe'" -ErrorAction Stop

                if ($null -eq $u) {
                    $row = New-ResultRow -Identifier $id -Found $false -MatchType "UPNOrMail" `
                        -DisplayName "" -UserPrincipalName "" -Mail "" -AccountEnabled "" -Id "" -Source "Entra" -Error ""
                    if ($IncludeNotFound) { $results += $row }
                    continue
                }

                # jos palautuu useita (harvinaista mutta mahdollista), ota kaikki
                foreach ($x in @($u)) {
                    $results += New-ResultRow -Identifier $id -Found $true -MatchType "UPNOrMail" `
                        -DisplayName $x.DisplayName -UserPrincipalName $x.UserPrincipalName -Mail $x.Mail `
                        -AccountEnabled $x.AccountEnabled -Id $x.Id -Source "Entra" -Error ""
                }
                continue
            }

            # displayName-haku: voi palauttaa monta -> kaikki mukaan
            $u2 = Get-EntraUser -Filter "displayName eq '$safe'" -ErrorAction Stop

            if ($null -eq $u2) {
                $row = New-ResultRow -Identifier $id -Found $false -MatchType "DisplayName" `
                    -DisplayName "" -UserPrincipalName "" -Mail "" -AccountEnabled "" -Id "" -Source "Entra" -Error ""
                if ($IncludeNotFound) { $results += $row }
                continue
            }

            foreach ($x in @($u2)) {
                $results += New-ResultRow -Identifier $id -Found $true -MatchType "DisplayName" `
                    -DisplayName $x.DisplayName -UserPrincipalName $x.UserPrincipalName -Mail $x.Mail `
                    -AccountEnabled $x.AccountEnabled -Id $x.Id -Source "Entra" -Error ""
            }
        }
        catch {
            $msg = $_.Exception.Message
            $row = New-ResultRow -Identifier $id -Found $false -MatchType $kind `
                -DisplayName "" -UserPrincipalName "" -Mail "" -AccountEnabled "" -Id "" -Source "Entra" -Error $msg
            if ($IncludeNotFound) { $results += $row }
            if ($VerboseOutput) { "error: $id | $msg" }
        }

        continue
    }

    if ($mode -eq "Graph") {
        try {
            # NOTE: Get-MgUser tarvitsee yleensä Connect-MgGraph ensin.
            # Tämä tool ei yritä kirjautua automaattisesti.
            $safe = Escape-ODataString $id

            if ($kind -eq "UPNOrMail") {
                # Graph filter: userPrincipalName/mail
                $u = Get-MgUser -Filter "userPrincipalName eq '$safe' or mail eq '$safe'" -ConsistencyLevel eventual -ErrorAction Stop

                if ($null -eq $u) {
                    $row = New-ResultRow -Identifier $id -Found $false -MatchType "UPNOrMail" `
                        -DisplayName "" -UserPrincipalName "" -Mail "" -AccountEnabled "" -Id "" -Source "Graph" -Error ""
                    if ($IncludeNotFound) { $results += $row }
                    continue
                }

                foreach ($x in @($u)) {
                    $results += New-ResultRow -Identifier $id -Found $true -MatchType "UPNOrMail" `
                        -DisplayName $x.DisplayName -UserPrincipalName $x.UserPrincipalName -Mail $x.Mail `
                        -AccountEnabled "" -Id $x.Id -Source "Graph" -Error ""
                }
                continue
            }

            $u2 = Get-MgUser -Filter "displayName eq '$safe'" -ConsistencyLevel eventual -ErrorAction Stop
            if ($null -eq $u2) {
                $row = New-ResultRow -Identifier $id -Found $false -MatchType "DisplayName" `
                    -DisplayName "" -UserPrincipalName "" -Mail "" -AccountEnabled "" -Id "" -Source "Graph" -Error ""
                if ($IncludeNotFound) { $results += $row }
                continue
            }

            foreach ($x in @($u2)) {
                $results += New-ResultRow -Identifier $id -Found $true -MatchType "DisplayName" `
                    -DisplayName $x.DisplayName -UserPrincipalName $x.UserPrincipalName -Mail $x.Mail `
                    -AccountEnabled "" -Id $x.Id -Source "Graph" -Error ""
            }
        }
        catch {
            $msg = $_.Exception.Message
            $row = New-ResultRow -Identifier $id -Found $false -MatchType $kind `
                -DisplayName "" -UserPrincipalName "" -Mail "" -AccountEnabled "" -Id "" -Source "Graph" -Error $msg
            if ($IncludeNotFound) { $results += $row }
            if ($VerboseOutput) { "error: $id | $msg" }
        }

        continue
    }
}

# --------------------------------------------------
# output
# --------------------------------------------------

if (-not $IncludeNotFound) {
    $results = $results | Where-Object { $_.Found -eq $true }
}

$results | Export-Csv $OutFile -NoTypeInformation -Encoding UTF8

"saved: $OutFile"
"rows: $($results.Count)"

# pikayhteenveto
$foundCount = ($results | Where-Object { $_.Found -eq $true }).Count
"found: $foundCount"

# --------------------------------------------------
# COPY–PASTE: input-mallit
# --------------------------------------------------
# users.txt:
# user1@domain.com
# user2@domain.com
# Display Name Here
#
# users.csv:
# Identifier
# user1@domain.com
# user2@domain.com
