# run by starting Powershell as administrator then
# powershell -ExecutionPolicy Bypass -File "C:\Scripts\CheckSubMods.ps1"
#
# Check if the script is running as Administrator
if (-not ([System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Restart powershell as Administrator and run script again..."
    exit
}
# === Setup ===
$apiKeyPath = "C:\Games\Nexusmods\SoftwareKeys\apikey.txt"
$apiKey = Get-Content $apiKeyPath -Raw
$gameFolders = @(
    @{ Path = "C:\Games\SubnauticaMods";        Domain = "subnautica" },
    @{ Path = "C:\Games\BelowZeroMods";         Domain = "subnauticabelowzero" }
)
$headers = @{ "apikey" = $apiKey }
$infoColor = "DarkGray"

# === Scan each game folder ===
foreach ($entry in $gameFolders) {
    $localFolder = $entry.Path
    $gameDomain = $entry.Domain

    Write-Host ""
    Write-Host ("Checking folder: " + $localFolder) -ForegroundColor White
    Write-Host "Game: " -ForegroundColor White -NoNewline
    Write-Host $gameDomain -ForegroundColor DarkBlue

    $localFiles = Get-ChildItem -Path $localFolder -Filter *.zip

    foreach ($file in $localFiles) {
        $fileName = $file.Name
        $baseName = $file.BaseName

        # Extract mod ID using -####- format
        if ($baseName -match '-(\d{2,4})-') {
            $modId = $matches[1]
            $filesUrl = "https://api.nexusmods.com/v1/games/$gameDomain/mods/$modId/files.json"

            try {
                $response = Invoke-RestMethod -Uri $filesUrl -Headers $headers

                # === Case-sensitive filtering using Regex ===
                if ($gameDomain -eq "subnautica") {
                    $filteredFiles = $response.files | Where-Object {
                        -not ([System.Text.RegularExpressions.Regex]::IsMatch($_.file_name, "BZ", [System.Text.RegularExpressions.RegexOptions]::None))
                    }
                } elseif ($gameDomain -eq "subnauticabelowzero") {
                    $filteredFiles = $response.files | Where-Object {
                        -not ([System.Text.RegularExpressions.Regex]::IsMatch($_.file_name, "SN", [System.Text.RegularExpressions.RegexOptions]::None))
                    }
                } else {
                    $filteredFiles = $response.files
                }

                if ($filteredFiles.Count -eq 0) {
                    Write-Host ("No compatible files for mod ID " + $modId + ".") -ForegroundColor DarkGray
                    continue
                }

                $latestFile = $filteredFiles | Sort-Object -Property uploaded_time -Descending | Select-Object -First 1
                $remoteFilename = $latestFile.file_name

                if ($fileName -eq $remoteFilename) {
                    Write-Host ($fileName + " ") -ForegroundColor $infoColor -NoNewline
                    Write-Host "is up to date" -ForegroundColor DarkGreen
                } else {
                    Write-Host ""
                    Write-Host ("Update available for mod ID " + $modId + ":") -ForegroundColor Yellow
                    Write-Host ("Local file:  " + $fileName) -ForegroundColor Gray
                    Write-Host ("Latest file: " + $remoteFilename) -ForegroundColor Gray

                    $modUrl = "https://www.nexusmods.com/$gameDomain/mods/$modId"
                    Write-Host ("Mod page:    " + $modUrl) -ForegroundColor Cyan

                    $openBrowser = Read-Host "Open this page in your browser now? (Y to confirm)"
                    if ($openBrowser -eq "Y") {
                        Start-Process $modUrl
                    }
                    Write-Host ""
                }
            } catch {
                Write-Host ("Error accessing mod ID " + $modId + ": " + $_.Exception.Message) -ForegroundColor Red
                Write-Host ""
            }
        } else {
            Write-Host ("Filename missing valid mod ID (-####-): " + $fileName) -ForegroundColor DarkGray
            Write-Host ""
        }
    }
}
