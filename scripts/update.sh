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
  # Schritt 1: lsx Daten nach /data/lsx_trades kopieren
  # Es werden nur diejenigen CSV kopiert, die nicht in 
  # /app/seeds/lsx-processed.csv enthalten sind.
  # Sofern dbt run erfolgreich war, werden sie später gelöscht, s.u.
  echo "updating lsx data."
  ./run_lsx.sh
  
  # Schritt 2: dbt 
  dbt seed # kleine Tabellen kopieren
  dbt compile 
  dbt run
  
  if [ $? -eq 0 ]; then
    echo "dbt run erfolgreich."
       
    # Schritt 3: render dashboard
    echo "render dashboard"
    Rscript -e "rmarkdown::render('/app/dashboard/index.Rmd', output_file='/app/dashboard/index.html')"
  else
    echo "dbt failed."
    exit 1  # Beendet das Skript mit Fehlercode
  fi
fi
