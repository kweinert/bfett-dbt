#!/bin/bash

if [ "$1" == "shell" ]; then
  /bin/bash  # Startet eine Bash-Shell; kann durch eine andere Shell ersetzt werden (z. B. /bin/sh)
elif [ "$1" == "dbt-docs" ]; then
  echo "dbt docs generate"
  rm -rf target/*
  dbt compile
  dbt docs generate
  echo "dbt docs serve"
  dbt docs serve --host 0.0.0.0
else
  # Standardverhalten: dbt run ausführen und bei Erfolg das Dashboard rendern
  dbt run
  if [ $? -eq 0 ]; then
    echo "dbt run erfolgreich, rendere Dashboard..."
    Rscript -e "rmarkdown::render('/app/dashboard/index.Rmd', output_file='/app/dashboard/index.html')"
  else
    echo "dbt run fehlgeschlagen, Dashboard-Rendering wird übersprungen"
    exit 1  # Beendet das Skript mit Fehlercode
  fi
fi
