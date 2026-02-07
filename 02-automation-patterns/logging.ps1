# playground
# aihe: logging (kirjaa mitä tapahtuu)
# tavoite: nähdä jälkeenpäin mitä tehtiin ja milloin

# --------------------------------------------------
# IDEA
# Ilman logia:
# - et tiedä missä kohtaa skripti meni pieleen
# - et tiedä mitä se ehti tehdä
# - et pysty todistamaan mitään
#
# Logi = aikaleima + taso + viesti
# --------------------------------------------------

# --------------------------------------------------
# 1) logipolku
# --------------------------------------------------

$LogPath = ".\logs"
$LogFile = Join-Path $LogPath "run.log"

# --------------------------------------------------
# 2) varmista että kansio on olemassa
# --------------------------------------------------

if (-not (Test-Path $LogPath)) {
    New-Item -Path $LogPath -ItemType Directory | Out-Null
}

# --------------------------------------------------
# 3) funktio: Write-Log
# Funktio = oma komento
# --------------------------------------------------

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO","WARN","ERROR")]
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "$timestamp [$Level] $Message"

    $line | Out-File $LogFile -Append -Encoding UTF8
    $line
}

# HUOM encoding:
# JSON/logit on usein UTF8.
# Vanhemmissa PowerShell-versioissa encoding voi käyttäytyä eri tavalla.

# --------------------------------------------------
# 4) testataan
# --------------------------------------------------

Write-Log "Script started"
Write-Log "Doing a test step" "INFO"
Write-Log "This is a warning example" "WARN"

# --------------------------------------------------
# 5) virhe-esimerkki try/catch + logi
# --------------------------------------------------

try {
    Write-Log "Trying to read a file that doesn't exist"
    Get-Item "C:\nope\missing.txt" -EA Stop | Out-Null
    Write-Log "File found"
}
catch {
    Write-Log "Failed: $($_.Exception.Message)" "ERROR"
}

Write-Log "Script finished"
