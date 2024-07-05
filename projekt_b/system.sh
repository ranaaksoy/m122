#!/bin/bash

# Funktion zur Ausgabe der Systeminformationen
print_system_info() {
    # Ausgabe der aktuellen Systemlaufzeit
    printf "%-30s: %s\n" "Aktuelle Systemlaufzeit" "$(uptime)"
    # Ausgabe der aktuellen Systemzeit
    printf "%-30s: %s\n" "Aktuelle Systemzeit" "$(date '+%Y-%m-%d %H:%M:%S')"
    # Ausgabe des freien Speicherplatzes für das Dateisystem 'ext4' (Anpassung für macOS)
    printf "%-30s: %s\n" "Freier Speicherplatz" "$(df [-T type])"
    # Ausgabe des belegten Speicherplatzes für das Dateisystem 'ext4' (Anpassung für macOS)
    printf "%-30s: %s\n" "Belegter Speicherplatz (macOS)" "$(df -T)"
    # Ausgabe des Hostnamens
    printf "%-30s: %s\n" "Hostname" "$(hostname)"
    # Ausgabe der IP-Adresse (Anpassung für macOS)
    printf "%-30s: %s\n" "IP-Adresse" "$(ipconfig getifaddr en0)"
    # Ausgabe des Betriebssystemnamens und -version (Anpassung für macOS)
    printf "%-30s: %s\n" "Betriebssystemname und -version" "$(sw_vers -productName) $(sw_vers -productVersion)"
    # Ausgabe des CPU-Modells
    printf "%-30s: %s\n" "CPU-Modell" "$(sysctl -n machdep.cpu.brand_string)"
    # Ausgabe der Anzahl der CPU-Kerne
    printf "%-30s: %s\n" "Anzahl der CPU-Kerne" "$(sysctl -n hw.physicalcpu)"
    # Ausgabe des gesamten Arbeitsspeichers
    printf "%-30s: %s\n" "Gesamter RAM" "$(sysctl -n hw.memsize | awk '{print $0/1073741824 " GB"}')"
    # Ausgabe des genutzten Arbeitsspeichers (Anpassung für macOS)
    printf "%-30s: %s\n" "Genutzter RAM" "$(top -l 1 | grep PhysMem | awk '{print $8}')"
    # Ausgabe eines Trenner-Strichs
    echo "------------------------------------------"
}

# Ausgabeformat wählen
if [ "$1" == "-f" ]; then
    # Wenn die Option -f angegeben wurde, wird in eine Datei geschrieben
    FILENAME="$(date '+%Y-%m')-sys-$(system).log"
    print_system_info >> "$FILENAME"
else
    # Andernfalls wird die Ausgabe auf der Konsole angezeigt
    print_system_info
fi
