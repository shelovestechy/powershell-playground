# tool
# 04-tools/Invoke-DistributionGroupInventory.ps1
# listaa jakeluryhmät + jäsenet (nimi + count + UPN:t)
#
# HUOM:
# - Tämä hakee Entra/Graphin kautta "mail-enabled + non-security" -ryhmät
# - Se on käytännössä jakeluryhmätyyppinen.
# - Jäsenten haku voi olla raskas isossa ympäristössä -> rajat mukana.

param(
    [string]$OutGroupsFile   = ".\distribution-groups.csv",
    [string]$OutMembersFile  = ".\distribution-group-members.csv",
    [switch]$IncludeMembers,              # jos päällä -> haetaan jäsenet ja exportataan OutMembersFile
    [int]$MaxGroups = 0,                  # 0 = kaikki, muuten rajoita testiin esim 20
    [int]$MaxMembersPerGroup = 0,         # 0 = kaikki, muuten esim 200
    [string]$NameContains = "",           # esim "Finance" jos haluat rajata
    [switch]$DemoMode                     # pakota demo (jos haluat testata ilman yhteyttä)
)

function Normalize-Text {
    param([string]$Value)
    if ($null -eq $Value) { return "" }
    return $Value.Trim()
}

function Escape-ODataString {
    param([string]$Value)
    return ($Value -replace "'", "''")
}

function Need-Command {
    param([string]$Name)
    return (Get-Command $Name -ErrorAction SilentlyContinue) -ne $null
}

# --------------------------------------------------
# tarkistus: Graph cmdletit
# --------------------------------------------------

$hasMgGroup = Need-Command "Get-MgGroup"
$hasMgMember = Need-Command "Get-MgGroupMember"
$hasMgUser = Need-Command "Get-MgUser"

if ($DemoMode -or -not $hasMgGroup -or -not $hasMgMember -or -not $hasMgUser) {
    "mode: DEMO"
    "note: missing Graph cmdlets or DemoMode enabled"
    "missing: Get-MgGroup=$hasMgGroup Get-MgGroupMember=$hasMgMember Get-MgUser=$hasMgUser"

    $demoGroups = @(
        [pscustomobject]@{ GroupName="Esimerkkiryhmä A"; GroupId="demo-1"; MemberCount=2; MembersUPN="karita@example.com;sari@example.com" },
        [pscustomobject]@{ GroupName="Esimerkkiryhmä B"; GroupId="demo-2"; MemberCount=1; MembersUPN="mikko@example.com" }
    )

    $demoGroups | Export-Csv $OutGroupsFile -NoTypeInformation -Encoding UTF8
    "saved: $OutGroupsFile"
    return
}

"mode: LIVE (Graph)"

# --------------------------------------------------
# ryhmähaku: mailEnabled=true AND securityEnabled=false
# (jakeluryhmä-tyyppinen)
# --------------------------------------------------

$baseFilter = "mailEnabled eq true and securityEnabled eq false"

if ((Normalize-Text $NameContains) -ne "") {
    $safe = Escape-ODataString (Normalize-Text $NameContains)
    $filter = "$baseFilter and contains(displayName,'$safe')"
}
else {
    $filter = $baseFilter
}

"filter: $filter"

$groups = @()

try {
    # -All hakee kaiken
    # -ConsistencyLevel eventual on usein tarpeen filttereihin
    $groups = Get-MgGroup -All -Filter $filter -ConsistencyLevel eventual -ErrorAction Stop |
        Select-Object Id, DisplayName, Mail, SecurityEnabled, MailEnabled
}
catch {
    "failed: $($_.Exception.Message)"
    "note: you likely need to Connect-MgGraph first (with the right permissions)"
    return
}

if ($MaxGroups -gt 0) {
    $groups = $groups | Select-Object -First $MaxGroups
}

"groups found: $($groups.Count)"

# --------------------------------------------------
# jäsenet + export
# --------------------------------------------------

$groupRows = @()
$memberRows = @()

foreach ($g in $groups) {

    $memberUpns = @()
    $memberCount = 0

    if ($IncludeMembers) {
        try {
            $members = Get-MgGroupMember -GroupId $g.Id -All -ErrorAction Stop

            # jäsenet voi olla muutakin kuin user -> rajataan käyttäjiin
            $userMembers = $members | Where-Object { $_.AdditionalProperties.'@odata.type' -eq "#microsoft.graph.user" }

            if ($MaxMembersPerGroup -gt 0) {
                $userMembers = $userMembers | Select-Object -First $MaxMembersPerGroup
            }

            foreach ($m in $userMembers) {
                # Get-MgGroupMember palauttaa directoryObjectin -> haetaan user erikseen, jotta saadaan UPN
                try {
                    $u = Get-MgUser -UserId $m.Id -Property "displayName,userPrincipalName,mail" -ErrorAction Stop

                    $upn = if ($u.UserPrincipalName) { $u.UserPrincipalName } elseif ($u.Mail) { $u.Mail } else { $u.Id }
                    $memberUpns += $upn
                    $memberCount++

                    $memberRows += [pscustomobject]@{
                        GroupName   = $g.DisplayName
                        GroupId     = $g.Id
                        MemberName  = $u.DisplayName
                        MemberUPN   = $upn
                    }
                }
                catch {
                    # jos yksittäinen user-haku failaa, jatketaan
                    $memberRows += [pscustomobject]@{
                        GroupName   = $g.DisplayName
                        GroupId     = $g.Id
                        MemberName  = ""
                        MemberUPN   = $m.Id
                    }
                    $memberUpns += $m.Id
                    $memberCount++
                }
            }
        }
        catch {
            # jos koko ryhmän jäsenhaku failaa, kirjataan tyhjänä
            $memberCount = 0
            $memberUpns = @()
        }
    }

    $groupRows += [pscustomobject]@{
        GroupName   = $g.DisplayName
        GroupId     = $g.Id
        Mail        = $g.Mail
        MemberCount = $memberCount
        MembersUPN  = ($memberUpns -join ";")
    }
}

$groupRows | Export-Csv $OutGroupsFile -NoTypeInformation -Encoding UTF8
"saved: $OutGroupsFile"
"rows: $($groupRows.Count)"

if ($IncludeMembers) {
    $memberRows | Export-Csv $OutMembersFile -NoTypeInformation -Encoding UTF8
    "saved: $OutMembersFile"
    "member rows: $($memberRows.Count)"
}

# --------------------------------------------------
# COPY–PASTE: ajotavat
# --------------------------------------------------
# perus:
# .\Invoke-DistributionGroupInventory.ps1
#
# jäsenet mukaan (ja erillinen members.csv):
# .\Invoke-DistributionGroupInventory.ps1 -IncludeMembers
#
# testiajo (vain 10 ryhmää):
# .\Invoke-DistributionGroupInventory.ps1 -IncludeMembers -MaxGroups 10 -MaxMembersPerGroup 200
#
# rajaa nimellä:
# .\Invoke-DistributionGroupInventory.ps1 -IncludeMembers -NameContains "Finance"
