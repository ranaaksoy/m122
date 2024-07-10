#!/bin/bash

# Log-Datei
LOGFILE="install_log.txt"
> $LOGFILE

# Konfigurationsdatei lesen
source config.txt

# Funktion zum Loggen
log() {
    echo "$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> $LOGFILE
}

# Funktion zum Installieren von Homebrew (wenn nicht installiert)
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        log "Homebrew wird installiert..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >> $LOGFILE 2>&1
        if [ $? -eq 0 ]; then
            log "Homebrew erfolgreich installiert."
        else
            log "Fehler bei der Installation von Homebrew."
            exit 1
        fi
    else
        log "Homebrew ist bereits installiert."
    fi
}

# Homebrew installieren
install_homebrew

# Tools installieren
if [ "$install_git" = true ]; then
    log "Git wird installiert..."
    brew install git >> $LOGFILE 2>&1
    if [ $? -eq 0 ]; then
        log "Git erfolgreich installiert."
    else
        log "Fehler bei der Installation von Git."
    fi
fi

if [ "$install_node" = true ]; then
    log "Node.js wird installiert..."
    brew install node >> $LOGFILE 2>&1
    if [ $? -eq 0 ]; then
        log "Node.js erfolgreich installiert."
    else
        log "Fehler bei der Installation von Node.js."
    fi
fi

if [ "$install_docker" = true ]; then
    log "Docker wird installiert..."
    brew install --cask docker >> $LOGFILE 2>&1
    if [ $? -eq 0 ]; then
        log "Docker erfolgreich installiert."
    else
        log "Fehler bei der Installation von Docker."
    fi
fi

# Tests durchführen
log "Führe Tests durch..."

# Test für Git
if [ "$install_git" = true ]; then
    if command -v git &> /dev/null; then
        log "Git Test bestanden."
    else
        log "Git Test fehlgeschlagen."
    fi
fi

# Test für Node.js
if [ "$install_node" = true ]; then
    if command -v node &> /dev/null; then
        log "Node.js Test bestanden."
    else
        log "Node.js Test fehlgeschlagen."
    fi
fi

# Test für Docker
if [ "$install_docker" = true ]; then
    if command -v docker &> /dev/null; then
        log "Docker Test bestanden."
    else
        log "Docker Test fehlgeschlagen."
    fi
fi

log "Installationsvorgang abgeschlossen."

# Ergebnisse anzeigen
cat $LOGFILE
