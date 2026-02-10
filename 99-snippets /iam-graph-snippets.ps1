# 99-snippets/iam-graph-snippets.ps1
# Graph / Entra -henkiset IAM-snippetit (copy–paste)
# Huom: nämä olettaa, että Microsoft Graph PowerShell -moduuli on käytössä ja olet kirjautunut.

# =========================================================
# 0) Connect (jos tarvitset)
# =========================================================
# Connect-MgGraph -Scopes "User.Read.All","Group.Read.All","GroupMember.Read.All"
# Get-MgContext

# =========================================================
# 1) User: hae ja katso attribuutit
# =========================================================
Get-MgUser `
  -UserId "user@domain.com" `
  -Property displayName,userPrincipalName,mail,accountEnabled,department,jobTitle |
Select-Object `
  DisplayName,
  UserPrincipalName,
  Mail,
  AccountEnabled,
  Department,
  JobTitle

# =========================================================
# 2) Group: hae ryhmä nimen perusteella
# =========================================================
$group = Get-MgGroup `
  -Filter "displayName eq 'esimerkkiryhmä'" `
  -ConsistencyLevel eventual

$group | Select-Object DisplayName, Mail, Id

# =========================================================
# 3) Group members: listaa jäsenet (vain user-objektit)
# =========================================================
Get-MgGroupMember -GroupId $group.Id -All |
Where-Object { $_.AdditionalProperties.'@odata.type' -eq "#microsoft.graph.user" } |
ForEach-Object {
  (Get-MgUser -UserId $_.Id -Property userPrincipalName).UserPrincipalName
}

# =========================================================
# 4) Disabled but still in group: etsi disabled käyttäjät ryhmästä
# =========================================================
Get-MgGroupMember -GroupId $group.Id -All |
Where-Object { $_.AdditionalProperties.'@odata.type' -eq "#microsoft.graph.user" } |
ForEach-Object {
  Get-MgUser -UserId $_.Id -Property displayName,userPrincipalName,accountEnabled
} |
Where-Object { $_.AccountEnabled -eq $false } |
Select-Object DisplayName, UserPrincipalName

# =========================================================
# 5) Distribution-ish groups: mail-enabled + non-security
# =========================================================
Get-MgGroup -All `
  -Filter "mailEnabled eq true and securityEnabled eq false" `
  -ConsistencyLevel eventual |
Select-Object DisplayName, Mail, Id |
Export-Csv ".\distribution-groups.csv" -NoTypeInformation -Encoding UTF8

# =========================================================
# 6) Stale users: ei kirjautumista 90 päivään
# Huom: signInActivity ei aina ole saatavilla kaikilla oikeuksilla/tenanteissa.
# =========================================================
Get-MgUser -All `
  -Property displayName,userPrincipalName,signInActivity `
  -ConsistencyLevel eventual |
Where-Object {
  $_.SignInActivity.LastSignInDateTime -and
  ([datetime]$_.SignInActivity.LastSignInDateTime -lt (Get-Date).AddDays(-90))
} |
Select-Object `
  DisplayName,
  UserPrincipalName,
  @{Name="LastSignIn";Expression={$_.SignInActivity.LastSignInDateTime}} |
Export-Csv ".\stale-users-90d.csv" -NoTypeInformation -Encoding UTF8

# =========================================================
# 7) Guests: guest-käyttäjät + luontipäivä
# =========================================================
Get-MgUser -All `
  -Filter "userType eq 'Guest'" `
  -Property displayName,userPrincipalName,createdDateTime `
  -ConsistencyLevel eventual |
Select-Object DisplayName, UserPrincipalName, CreatedDateTime |
Export-Csv ".\guests.csv" -NoTypeInformation -Encoding UTF8

# =========================================================
# 8) Idempotent add: lisää käyttäjä ryhmään vain jos puuttuu
# =========================================================
$groupName = "esimerkkiryhmä"
$userUpn   = "user@domain.com"

$g2 = Get-MgGroup -Filter "displayName eq '$groupName'" -ConsistencyLevel eventual
$u2 = Get-MgUser -UserId $userUpn
$members2 = Get-MgGroupMember -GroupId $g2.Id -All

if (-not ($members2.Id -contains $u2.Id)) {
  New-MgGroupMember -GroupId $g2.Id -DirectoryObjectId $u2.Id
}

# =========================================================
# 9) Update only if needed: attribuutti kuntoon vain jos väärin
# =========================================================
$u3 = Get-MgUser -UserId "user@domain.com" -Property department

if ($u3.Department -ne "IT") {
  Update-MgUser -UserId $u3.Id -Department "IT"
}

# =========================================================
# 10) Create group only if missing
# =========================================================
$newGroupName = "esimerkkiryhmä"

$existing = Get-MgGroup -Filter "displayName eq '$newGroupName'" -ConsistencyLevel eventual
if (-not $existing) {
  New-MgGroup `
    -DisplayName $newGroupName `
    -MailEnabled:$false `
    -MailNickname ($newGroupName -replace " ","") `
    -SecurityEnabled:$true
}

# =========================================================
# 11) Diff: pitäisi olla vs on
# =========================================================
$should = @("a@example.com","b@example.com") | Sort-Object -Unique
$is     = @("a@example.com","c@example.com") | Sort-Object -Unique
Compare-Object $should $is

# =========================================================
# 12) Groups without owners: omistajattomat ryhmät
# =========================================================
Get-MgGroup -All -ConsistencyLevel eventual |
ForEach-Object {
  [pscustomobject]@{
    GroupName  = $_.DisplayName
    OwnerCount = (Get-MgGroupOwner -GroupId $_.Id -All -ErrorAction SilentlyContinue).Count
  }
} |
Where-Object { $_.OwnerCount -eq 0 } |
Export-Csv ".\groups-without-owners.csv" -NoTypeInformation -Encoding UTF8

# =========================================================
# 13) JSON: nopea payload / config
# =========================================================
$payload = @{
  Department  = "IT"
  EnabledOnly = $true
} | ConvertTo-Json

$payload | ConvertFrom-Json
