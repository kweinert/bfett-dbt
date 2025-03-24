# buffett: Portfolio als dbt Projekt

## Überblick

Systematische Aufbereitung von Handelsdaten (Lang+Schwarz), Verschneidung mit Portfolio-Daten, Erstellung eines Dashboards.

## Installation

Das Projekt wird auf Linux (konkret Xubuntu LTS 24.04) entwickelt und derzeit nur dort getestet.

Das Projekt nutzt 
- `docker` zum Verwalten der Abhängigkeiten.
- `[earthly]([https::/](https://earthly.dev/earthfile)` als build-Tool für den Docker-Container.
- `[duckdb](https://duckdb.org/)` als Datenbank-Backend
- `[dbt core](https://www.getdbt.com/)` als Datenmanagement-System

### Docker

```
sudo apt update
sudo apt install docker.io
sudo usermod -aG docker $USER  # Erlaubt Docker ohne sudo (nach Neustart wirksam)
newgrp docker  # Sofort wirksam ohne Logout
docker --version  # Überprüfen
```

### Earthly

```
# Add Earthly's repository
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL 'https://releases.earthly.dev/earthly.gpg' | sudo gpg --dearmor -o /usr/share/keyrings/earthly-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/earthly-archive-keyring.gpg] https://releases.earthly.dev/deb ./" | sudo tee /etc/apt/sources.list.d/earthly.list

# Install Earthly
sudo apt-get update
sudo apt-get install earthly
```

In der [EarthFile](https://github.com/kweinert/buffett/blob/main/Earthfile) sind alle Abhängigkeiten (dbt, duckdb, Python, R) deklariert.

### buffett dbt Projekt

Dieses Github-Repository enthält die Modelle für das dbt-Projekt, jedoch nicht die Daten. 

Außerdem enthält das Repository ein Skript `buffett`, mit dem der Docker-Container gestartet wird.
Derzeit erwartet das Skript, dass das Projekt im Ordner `~/Dbtspace/buffett` abgelegt ist.

```
mkdir -p ~/Dbtspace/buffet
cd ~/Dbtspace
git clone https://github.com/kweinert/buffett.git
cd buffett
chmod +x ~/bin/buffett
mv ./buffett ~/bin # oder anderes Verzeichnis
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
