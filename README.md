# buffett: Portfolio als dbt Projekt

## Überblick

Systematische Aufbereitung von Handelsdaten (Lang+Schwarz), Verschneidung mit Portfolio-Daten, Erstellung eines Dashboards.

## Installation

Das Projekt wird auf Linux (konkret Xubuntu LTS 24.04) entwickelt und derzeit nur dort getestet.

Das Projekt nutzt 
- [docker](https://www.docker.com/) zum Verwalten der Abhängigkeiten.
- [duckdb](https://duckdb.org/) als Datenbank-Backend
- [dbt core](https://www.getdbt.com/) als Datenmanagement-System

### Docker

```
sudo apt update
sudo apt install docker.io
sudo usermod -aG docker $USER  # Erlaubt Docker ohne sudo (nach Neustart wirksam)
newgrp docker  # Sofort wirksam ohne Logout
sudo apt install docker-buildx # legacy build decprecated
docker --version  # Überprüfen
```

In der [Dockerfile](https://github.com/kweinert/buffett/blob/main/Dockerfile) sind alle Abhängigkeiten (dbt, duckdb, Python, R) deklariert.

### buffett dbt Projekt

Dieses Github-Repository enthält die Modelle für das dbt-Projekt, jedoch nicht die Daten. 

Außerdem enthält das Repository ein Skript `buffett`, mit dem das Projekt gesteuert wird.
Angenommen, das Projekt ist im Ordner `~/Dbtspace/buffett` abgelegt:

```
mkdir -p ~/Dbtspace/buffett/buffett-build
cd ~/Dbtspace/buffett
git clone https://github.com/kweinert/buffett-build.git
cd buffett-build
ln -s ./buffett ~/bin/buffett # oder anderes Verzeichnis
chmod +x ./buffett
```

## Kommandos

Die Hauptfunktion `buffett` unterstützt verschiedene Kommandos.

### buffett build

Erzeugt ein Docker-Image ohne Daten, aber mit der Modellstruktur und allen Abhängigkeiten. Dieses Kommando wird nur benötigt, wenn `buffett` überarbeitet wurde.

```
buffett build
```

### buffett update

Startet das Docker-Image, prüft ob neue Handelsdaten der LSX vorliegen, und führt `dbt seed` und `dbt run` aus. Dieser Befehl aktualisiert die Datenbasis.

```
buffett update
```

### buffett view

Startet das Dashboard, das auf den Daten beruht.

```
buffett view
```

### buffett dbt-docs und buffett shell

Startet eine grafische Oberfläche, die es ermöglicht, das dbt-Modell zu untersuchen. Gut zum Debuggen.

```
buffett dbt-docs
```

Startet den Container und startet eine Shell. Gut zum Debuggen.

```
buffett shell
```


## Qualität / Einschränkungen

Einige ISIN, die auf Trade Republic handelbar sind, sind offenbar nicht in den Handelsdaten von LSX enthalten. Das sind z.B. ISIN von Knockout Zertifikaten.

Für Freitag, 4.4.2025, hat der späteste Trade einen Zeitstempel von 14 Uhr. 

## Roadmap / What's new

### Version 0.2

- [ ] Wochenchart, wo Cash und Portfolio dargestellt sind
- [ ] aus transactions die Tabellen cash, open_positions und closed_trades generieren.

### Version 0.1

- [x] Qualität prüfen
- [x] [Lang+Schwarz](https://www.ls-x.de/de/download) als Datenquelle erschließen
- [x] Skript um Kommandos erweitern (update / view / etc)

### Später / Vielleicht

- [ ] [edgarWebR](https://cran.r-project.org/web/packages/edgarWebR/vignettes/edgarWebR.html) als Datenquelle erschließen
- [ ] Shiny statt Rmd?
- [ ] abgeschlossene Trades darstellen
- [ ] discount / premium zones bestimmen für einzelne Isin

