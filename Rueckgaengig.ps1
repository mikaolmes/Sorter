# Pfad zur Konfigurationsdatei
$configFilePath = "C:\Dokumente\BBB\M122\conifg.json"

# Prüfen, ob die Konfigurationsdatei existiert
if (-not (Test-Path $configFilePath)) {
    Write-Host "Konfigurationsdatei nicht gefunden: $configFilePath"
    exit
}

# Konfigurationsdatei einlesen und JSON in ein PowerShell-Objekt umwandeln
$config = Get-Content -Path $configFilePath -Raw | ConvertFrom-Json

# Hier wird der Ordner definiert wo alles vorgenommen wird bzw. die Config-Datei als Source Foler definiert
$sourceFolder = $config.sourceFolder

# Schaut ob der Ordner existiert
if (Test-Path $sourceFolder) {
    # Holt alle Unterordner die im aktuellen Ordner drin sind
    $subFolders = Get-ChildItem -Path $sourceFolder -Directory

    # Durchsucht jeden Ordner
    foreach ($subFolder in $subFolders) {
        # Holt alle Dateien
        $files = Get-ChildItem -Path $subFolder.FullName -File

        # Schaut sich die Dateien an
        foreach ($file in $files) {
            # Verschiebt sie zurück in den richtigen Ordner
            $destinationPath = Join-Path -Path $sourceFolder -ChildPath $file.Name
            Move-Item -Path $file.FullName -Destination $destinationPath
        }

        # Der vorherige Ordner wird gelöscht
        Remove-Item -Path $subFolder.FullName -Recurse -Force
    }

    Write-Host "Dateien zurückverschoben und Unterordner entfernt."
} else {
    Write-Host "Ordner nicht gefunden: $sourceFolder"
}
