#!/bin/bash

# Verzeichnisse
OUTPUT_DIR="$HOME/weather_data"
DATA_FILE="$OUTPUT_DIR/weather_data.json"
HTML_FILE="$OUTPUT_DIR/weather.html"
LOG_FILE="$OUTPUT_DIR/weather.log"

# Überprüfen, ob die Daten-Datei existiert
if [[ ! -f "$DATA_FILE" ]]; then
    echo "Fehler: Daten-Datei nicht gefunden." | tee -a "$LOG_FILE"
    exit 1
fi

# JSON-Verarbeitung
weather=$(jq '.weather[0].description' "$DATA_FILE" | tr -d '"')
temperature=$(jq '.main.temp' "$DATA_FILE")
humidity=$(jq '.main.humidity' "$DATA_FILE")
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

# HTML-Datei generieren
echo "<html><body><h1>Wetterdaten für London</h1><p>Stand: ${timestamp}</p><table border='1'><tr><th>Beschreibung</th><th>Temperatur (°C)</th><th>Luftfeuchtigkeit (%)</th></tr><tr><td>${weather}</td><td>${temperature}</td><td>${humidity}</td></tr></table></body></html>" > "$HTML_FILE"

# Log-Eintrag hinzufügen
echo "${timestamp}: HTML-Datei generiert." >> "$LOG_FILE"

