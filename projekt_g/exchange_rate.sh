#!/bin/bash

# API-Schlüssel für exchangerate-api.com (registrieren und erhalten Sie Ihren eigenen kostenlosen API-Schlüssel)
API_KEY="c995dfae5e74219f65cbf67b"

# Datei zum Speichern der historischen Daten
DATA_FILE="exchange_data.json"

# Setze Lokalisierung, um sicherzustellen, dass Dezimalpunkte verwendet werden
export LC_NUMERIC=C

# Funktion zum Abrufen der aktuellen Wechselkurse
get_exchange_rates() {
    curl -s "https://v6.exchangerate-api.com/v6/c995dfae5e74219f65cbf67b/latest/CHF"
}

# Funktion zum Abrufen eines bestimmten Währungskurses
get_rate() {
    local rates=$1
    local currency=$2
    jq -r ".conversion_rates.$currency" <<< "$rates"
}

# Funktion zum Vergleichen der alten und neuen Daten
compare_rates() {
    local new_rates=$1
    if [[ -f $DATA_FILE ]]; then
        local old_rates=$(cat $DATA_FILE)
        echo -e "Vergleich der Wechselkurse (alt vs. neu):\n"
        for currency in EUR USD TRY; do
            old_rate=$(get_rate "$old_rates" "$currency")
            new_rate=$(get_rate "$new_rates" "$currency")
            if [[ -z "$old_rate" || "$old_rate" == "null" || -z "$new_rate" || "$new_rate" == "null" ]]; then
                continue
            fi
            diff=$(echo "$new_rate - $old_rate" | bc -l)
            diff_percent=$(echo "scale=2; ($diff / $old_rate) * 100" | bc -l)
            if (( $(echo "$diff > 0" | bc -l) )); then
                color="\033[0;32m"  # Grün
                symbol="↑"
            else
                color="\033[0;31m"  # Rot
                symbol="↓"
            fi
            printf "${color}%s: %.4f CHF %s %.4f (%.2f%%)\033[0m\n" "$currency" "$old_rate" "$symbol" "$new_rate" "$diff_percent"
        done
    fi
}

# Hauptlogik
if [[ -z "$1" ]]; then
    echo "Bitte geben Sie einen Betrag in CHF ein."
    exit 1
fi

amount_in_chf=$1
echo -e "\nAbfrage der aktuellen Wechselkurse...\n"
new_rates=$(get_exchange_rates)
echo "Abgerufene Daten: $new_rates"

# Überprüfen Sie, ob die abgerufenen Daten gültiges JSON sind
if ! jq empty <<< "$new_rates" > /dev/null 2>&1; then
    echo "Fehler: Ungültige JSON-Daten erhalten. Überprüfen Sie Ihren API-Schlüssel und die API-Antwort."
    exit 1
fi

parsed_rates=$(jq '.' <<< "$new_rates")
echo "Geparste Daten: $parsed_rates"

echo -e "Betrag in CHF: $amount_in_chf\n"

# Anzeige der Umrechnung in verschiedene Währungen
echo -e "Umrechnung in verschiedene Währungen:\n"
for currency in EUR USD TRY; do
    rate=$(get_rate "$parsed_rates" "$currency")
    if [[ -z "$rate" || "$rate" == "null" ]]; then
        amount=0
    else
        amount=$(echo "$amount_in_chf * $rate" | bc -l)
    fi
    printf "%s: %.4f\n" "$currency" "$amount"
done

# Vergleich mit alten Daten
compare_rates "$parsed_rates"

# Speichern der neuen Daten
echo "$parsed_rates" > $DATA_FILE
echo -e "\nNeue Wechselkurse wurden gespeichert.\n"
