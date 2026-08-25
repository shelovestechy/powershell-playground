Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$markdownFiles = @(Get-ChildItem -Path $repositoryRoot -Recurse -Filter '*.md' -File)
$brokenLinks = [System.Collections.Generic.List[string]]::new()
$linkPattern = '\[[^\]]*\]\(([^)]+)\)'

foreach ($file in $markdownFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    foreach ($match in [regex]::Matches($content, $linkPattern)) {
        $target = $match.Groups[1].Value.Trim()
        if (
            $target.StartsWith('http://') -or
            $target.StartsWith('https://') -or
            $target.StartsWith('#') -or
            $target.StartsWith('mailto:')
        ) {
            continue
        }

        $pathPart = ($target -split '#', 2)[0]
        if ([string]::IsNullOrWhiteSpace($pathPart)) {
            continue
        }

        $decodedPath = [uri]::UnescapeDataString($pathPart)
        $resolvedPath = [System.IO.Path]::GetFullPath(
            (Join-Path $file.DirectoryName $decodedPath)
        )

        if (-not (Test-Path -LiteralPath $resolvedPath)) {
            $relativeFile = [System.IO.Path]::GetRelativePath($repositoryRoot, $file.FullName)
            $brokenLinks.Add("$relativeFile -> $target")
        }
    }
}

if ($brokenLinks.Count -gt 0) {
    throw "Broken relative Markdown links were found:`n$($brokenLinks -join "`n")"
}

Write-Host "Relative Markdown link check passed for $($markdownFiles.Count) files."
