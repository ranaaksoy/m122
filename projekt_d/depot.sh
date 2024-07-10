#!/bin/bash

# API-Schlüssel
alpha_vantage_api_key="SLPYAXGSLOU6YZG2"
cryptocompare_api_key="40dbd51386169427746acabff89e5b371559504bb1c46234b3e0e11cb1e6e939"
exchangerate_api_key="bc7bc41eb7bda22f61818dae"

calculate_asset_value() {
    quantity=$1
    price=$2
    if [[ -z "$price" || "$price" == "null" ]]; then
        price=0
    fi
    value=$(echo "$quantity * $price" | bc)
    echo $value
}

# Funktion zur Umwandlung von Fremdwährungen zu CHF
convert_to_chf() {
    amount=$1
    from_currency=$2
    if [[ "$from_currency" != "CHF" ]]; then
        conversion=$(curl -s "https://v6.exchangerate-api.com/v6/$bc7bc41eb7bda22f61818dae/latest/$from_currency" | jq -r ".conversion_rates.CHF")
        if [[ -z "$conversion" || "$conversion" == "null" ]]; then
            conversion=0
        fi
        value=$(echo "$amount * $conversion" | bc)
    else
        value=$amount
    fi
    echo $value
}

# Aktuelle Kursdaten von Aktien abrufen und berechnen
fetch_stock_price() {
    symbol=$1
    price=$(curl -s "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=5min&apikey=$SLPYAXGSLOU6YZG2" | jq -r '.["Time Series (5min)"] | to_entries[0].value["4. close"]')
    if [[ -z "$price" || "$price" == "null" ]]; then
        price=0
    fi
    echo $price
}

novartis_price=$(fetch_stock_price "NVS")
abb_price=$(fetch_stock_price "ABB")
nestle_price=$(fetch_stock_price "NSRGY")

novartis_value=$(calculate_asset_value 10 "$novartis_price")
abb_value=$(calculate_asset_value 10 "$abb_price")
nestle_value=$(calculate_asset_value 10 "$nestle_price")

# Fremdwährungen und Kryptowährungen in CHF umrechnen
usd_value=$(convert_to_chf 3000 "USD")
btc_price=$(curl -s "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=CHF&api_key=$40dbd51386169427746acabff89e5b371559504bb1c46234b3e0e11cb1e6e939" | jq -r ".CHF")
if [[ -z "$btc_price" || "$btc_price" == "null" ]]; then
    btc_price=0
fi
btc_value=$(calculate_asset_value 0.1 "$btc_price")

# Gesamtwert des Depots berechnen
total_value=$(echo "$novartis_value + $abb_value + $nestle_value + $usd_value + $btc_value" | bc)

# Aktuelle Zeit für die Zeitschreibung
current_time=$(date)

# Ergebnisse ausgeben
echo "Aktueller Wert des Depots in CHF: $total_value"
echo "Zeitpunkt der Berechnung: $current_time"

# Optional: Loggen der Ergebnisse in eine Datei
echo "$current_time,$total_value" >> depot_values.csv
