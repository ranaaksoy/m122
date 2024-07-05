#!/bin/bash

# API-Details

API_KEY="weather2"
CITY="London"
API_URL="http://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=c0687e2adb6ea0c019c07cb4967b77d8"


# Verzeichnisse
OUTPUT_DIR="$HOME/weather_data"
DATA_FILE="$OUTPUT_DIR/weather_data.json"
LOG_FILE="$OUTPUT_DIR/weather.log"

# Erstellen des Ausgabe-Verzeichnisses, wenn es nicht existiert
mkdir -p "$OUTPUT_DIR"

# Abrufen der Wetterdaten
response=$(curl -s "$API_URL")

# Überprüfen, ob die Anfrage erfolgreich war
if [[ $? -ne 0 ]]; then
    echo "Fehler: Konnte die Wetterdaten nicht abrufen." | tee -a "$LOG_FILE"
    exit 1
fi

# Speichern der Rohdaten in einer JSON-Datei
echo $response > "$DATA_FILE"

# Log-Eintrag hinzufügen
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
echo "${timestamp}: Wetterdaten abgerufen und gespeichert." >> "$LOG_FILE"
