# playground
# error handling

# 1) perus: jotain mitä ei ole olemassa
try {
    Get-Item "C:\this-file-does-not-exist.txt" -ErrorAction Stop
}
catch {
    $_
    $_.Exception
    $_.Exception.Message
}

# 2) "hiljainen" virhe vs "oikea" virhe (ErrorAction)
Get-Item "C:\this-file-does-not-exist.txt"            # yleensä huutaa mutta jatkaa
Get-Item "C:\this-file-does-not-exist.txt" -EA Stop   # pakottaa catchiin

# 3) omat virheilmoitukset (että tietää missä meni pieleen)
try {
    Get-Item "C:\this-file-does-not-exist.txt" -EA Stop
}
catch {
    throw "Fail: file not found (test). Original: $($_.Exception.Message)"
}

# 4) loopissa: jatketaanko vai pysäytetäänkö
$paths = @(
    "C:\Windows\notepad.exe",
    "C:\nope\missing.txt",
    "C:\Windows\System32\drivers\etc\hosts"
)

foreach ($path in $paths) {
    try {
        Get-Item $path -EA Stop | Select-Object FullName, Length
    }
    catch {
        "SKIP: $path | $($_.Exception.Message)"
        continue
    }
}

# virhe ei ole kaatuminen
# virhe on dataa
# tärkeintä: valitset itse, pysäytetäänkö vai jatketaanko
