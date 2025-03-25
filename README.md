# buffett: Portfolio als dbt Projekt

## Überblick

Systematische Aufbereitung von Handelsdaten (Lang+Schwarz), Verschneidung mit Portfolio-Daten, Erstellung eines Dashboards.

## Installation

Das Projekt wird auf Linux (konkret Xubuntu LTS 24.04) entwickelt und derzeit nur dort getestet.

Das Projekt nutzt 
- `docker` zum Verwalten der Abhängigkeiten.
- [duckdb](https://duckdb.org/) als Datenbank-Backend
- [dbt core](https://www.getdbt.com/) als Datenmanagement-System

### Docker

```
sudo apt update
sudo apt install docker.io
sudo usermod -aG docker $USER  # Erlaubt Docker ohne sudo (nach Neustart wirksam)
newgrp docker  # Sofort wirksam ohne Logout
docker --version  # Überprüfen
```

In der [Dockerfile](https://github.com/kweinert/buffett/blob/main/Dockerfile) sind alle Abhängigkeiten (dbt, duckdb, Python, R) deklariert.

### buffett dbt Projekt

Dieses Github-Repository enthält die Modelle für das dbt-Projekt, jedoch nicht die Daten. 

Außerdem enthält das Repository ein Skript `buffett`, mit dem der Docker-Container gestartet wird.
Derzeit erwartet das Skript, dass das Projekt im Ordner `~/Dbtspace/buffett` abgelegt ist.

```
mkdir -p ~/Dbtspace/buffet/buffett-build
cd ~/Dbtspace/buffett
git clone https://github.com/kweinert/buffett-build.git
cd buffett-build
ln -s ./buffet ~/bin/buffett # oder anderes Verzeichnis
chmod +x ./buffett
chmod +x ~/bin/buffett
```


## Daten-Modelle

TODO

## Roadmap

### Version 0.1

[ ] [Lang+Schwarz](https://www.ls-x.de/de/download) als Datenquelle erschließen
[ ] Skript um Kommandos erweitern (update / view / etc)

### Später / Vielleicht

[ ] [edgarWebR](https://cran.r-project.org/web/packages/edgarWebR/vignettes/edgarWebR.html) als Datenquelle erschließen
[ ] Shiny statt Rmd?
