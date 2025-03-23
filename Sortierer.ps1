# Pfad zur Konfigurationsdatei
$configFilePath = "C:\Dokumente\BBB\M122\conifg.json"

# Prüfen, ob die Konfigurationsdatei existiert
if (-not (Test-Path $configFilePath)) {
    Write-Host "Konfigurationsdatei nicht gefunden: $configFilePath"
    exit
}

# Konfigurationsdatei einlesen und JSON in ein PowerShell-Objekt umwandeln
$config = Get-Content -Path $configFilePath -Raw | ConvertFrom-Json

# Ordner definieren wo der Vorgang vorgenommen wird bzw. Config-Datei als Source Folder definieren
$sourceFolder = $config.sourceFolder

# Hier wird geschaut ob der Ordner existiert, wenn nicht wird der Vorgang abgebrochen
if (Test-Path $sourceFolder) {
    # Nimmt die Dateien aus dem Ordner
    $files = Get-ChildItem -Path $sourceFolder -File

    # Schaut sich jede Datei an
    foreach ($file in $files) {
        # Schaut sich den Dateityp an (die Endung)
        $extension = $file.Extension.TrimStart('.')

        # Erstellt einen Zielordner mit der Endung (Dateityp)
        $destinationFolder = Join-Path -Path $sourceFolder -ChildPath $extension.ToUpper()

        # Erstellt einen Zielordner falls dieser nicht existiert
        if (-not (Test-Path $destinationFolder)) {
            New-Item -Path $destinationFolder -ItemType Directory
        }

        # Hier wird die Datei in den richtigen Ordner verschoben
        $destinationPath = Join-Path -Path $destinationFolder -ChildPath $file.Name
        Move-Item -Path $file.FullName -Destination $destinationPath
    }

    Write-Host "Dateien sortiert und verschoben."
} else {
    Write-Host "Ordner nicht gefunden: $sourceFolder"
}
