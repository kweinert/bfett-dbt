#!/bin/bash

# Das Skript versteht die Kommandos "shell", "update-lsx", "update-dbt", "help" und "serve"
# "shell" öffnet eine shell. "help" druckt einen Hilfetext aus.
# "update-lsx" führt zuerst das Skript lsx.sh und danach das Kommando update-dbt aus.
# "update-dbt" führt dbt seed/compile/run aus.
# "serve" startet die Webapps dbt docs (8001), duckdb -ui (8002) und faucet bfettsoll (8003) 

# Funktion für update-dbt Logik
update_dbt() {
  echo "Running dbt seed, compile, and run..."
  dbt seed # Kleine Tabellen kopieren
  dbt compile
  dbt run # TODO: lieber dbt build? spätestens wenn tests hinzugefügt werden.
}

# Prüfe das Kommando
case "$1" in
  shell)
    /bin/bash # Startet eine Bash-Shell
    ;;
  help)
    echo "Verfügbare Kommandos:"
    echo "  shell              - Startet eine interaktive Bash-Shell"
    echo "  update-lsx-trades  - Aktualisiert Handelsdaten von LSX"
    echo "  update-lsx-univ    - Aktualisiert Stammdaten von LSX"
    echo "  update-dbt         - Führt dbt seed, compile und run aus"
    echo "  serve              - Startet dbt docs auf Port 8001 und faucet auf Port 8002"
    echo "  help               - Zeigt diesen Hilfetext an"
    ;;
  update-lsx-trades)
    echo "Updating lsx trade data..."
    /app/scripts/update_lsx_trades.sh
    update_dbt
    ;;
  update-lsx-univ)
    echo "Updating lsx universe data..."
    echo "not yet implemented" # TODO
    exit 1
    ;;
  update-dbt)
    update_dbt
    ;;
  serve)
    echo "Starting services..."
    dbt docs generate
    dbt docs serve --host 0.0.0.0 --port 8001 &
    #faucet start --host 0.0.0.0 --port 8003 &
    wait # Wartet, bis alle Hintergrundprozesse beendet sind
    ;;
  *)
    echo "Unbekanntes Kommando: $1"
    echo "Verwende 'help' für eine Liste der verfügbaren Kommandos."
    exit 1
    ;;
esac
