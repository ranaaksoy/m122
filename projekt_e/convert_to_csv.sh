#!/bin/bash

# Config-Datei lesen
source config.txt

# CSV-Header für die Ausgabe definieren
output_header="Name,Address,ZIP,City,Country,Amount,Date,Description"

# Output-Datei erstellen und Header hinzufügen
echo "$output_header" > "$output_file"

# Funktion, um eine einzelne Datei zu verarbeiten
process_file() {
    local input_file="$1"

    # Jede Zeile in der Eingabedatei lesen und in CSV-Format umwandeln
    while IFS= read -r line; do
        # Angenommen, das Format ist: Name|Address|ZIP|City|Country|Amount|Date|Description
        IFS='|' read -ra fields <<< "$line"
        name="${fields[0]}"
        address="${fields[1]}"
        zip="${fields[2]}"
        city="${fields[3]}"
        country="${fields[4]}"
        amount="${fields[5]}"
        date="${fields[6]}"
        description="${fields[7]}"

        # CSV-Zeile erstellen
        csv_line="$name,$address,$zip,$city,$country,$amount,$date,$description"
        
        # CSV-Zeile zur Output-Datei hinzufügen
        echo "$csv_line" >> "$output_file"
    done < "$input_file"
}

# Alle in der Konfigurationsdatei angegebenen Dateien verarbeiten
IFS=',' read -ra files <<< "$input_files"
for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        process_file "$file"
    else
        echo "Datei $file nicht gefunden"
    fi
done

echo "CSV-Datei wurde erstellt: $output_file"
