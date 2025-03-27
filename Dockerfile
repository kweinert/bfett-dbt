FROM rocker/r-ver:4.3.2

WORKDIR /app

# --------
# Schritt 1: R
# Installiere Systemabhängigkeiten für R und pak
RUN apt-get update && apt-get install -y \
	build-essential \
	libssl-dev \
	libcurl4-openssl-dev \
	curl \
	jq \
	&& rm -rf /var/lib/apt/lists/*

# Installiere pak von CRAN
RUN R -e "install.packages('pak', repos='https://cloud.r-project.org/')"

# Konfiguriere P3M als Repository für Binärpakete (Ubuntu 22.04 "jammy" als Beispiel)
RUN mkdir -p /usr/local/lib/R/etc && echo "options(repos = c(CRAN = 'https://p3m.dev/cran/__linux__/jammy/latest', duckdb = 'https://duckdb.r-universe.dev'))" >> /usr/local/lib/R/etc/Rprofile.site

# Installiere weitere Pakete als Binaries über pak
RUN R -e "pak::pkg_install(c('data.table', 'rmarkdown', 'tinytest', 'plotly', 'htmltools', 'htmlwidgets', 'flexdashboard', 'DBI', 'duckdb', 'reactable'))"

# es dauert 1h, duckdb aus den Quellen zu installieren. Wir wählen eine Abkürzung. Nachteil ist, dass es nicht automatisch die neueste Version installiert.
# r-universe führt zu einem glibc Problem.
#RUN R -e "install.packages('https://duckdb.r-universe.dev/bin/linux/noble/4.5/src/contrib/duckdb_1.2.1.9000.tar.gz', repos=NULL)"

# --------
# Schritt 2: dbt
RUN apt-get update && apt-get install -y \
	python3 \
	python3-pip \
	python3-venv \
	git \
	&& rm -rf /var/lib/apt/lists/*

# Erstelle eine virtuelle Umgebung für Python
RUN python3 -m venv /opt/dbt-venv

# Aktiviere die virtuelle Umgebung und aktualisiere pip
RUN /opt/dbt-venv/bin/pip install --upgrade pip

# Installiere dbt-core und dbt-postgres (Adapter für PostgreSQL)
RUN /opt/dbt-venv/bin/pip install dbt-core dbt-duckdb duckdb

# Setze PATH, damit dbt direkt ausführbar ist
ENV PATH="/opt/dbt-venv/bin:${PATH}"

# ---------
# Schritt 4: buffet Projekt
# Installiere dbt packages
# damit dbt deps funktioniert, werden dbt.project.yml und packages.yml benötigt
# die anderen Dateien werden nur "sicherheitshalber" mitkopiert; sie werden
# bei späteren Läufen von dbt durch aktuelle Version ersetzt (bind mount)
COPY dbt_project.yml .
COPY packages.yml .
COPY profiles.yml .  
COPY models/ ./models/
COPY macros/ ./macros/
#COPY docs/ ./docs/
RUN mkdir -p ./target
RUN dbt deps

# -----------
# Schritt 5: EntryPoint
# user, ports etc.
RUN groupadd -g 1000 buffettgroup && \
    useradd -u 1000 -g buffettgroup buffettuser

RUN mkdir -p /app && \
    chown -R buffettuser:buffettgroup . && \
    chmod -R 755 .  
    
RUN mkdir -p /home/buffettuser
    
COPY run_dbt.sh . 
RUN chmod +x run_dbt.sh

COPY run_lsx.sh . 
RUN chmod +x run_lsx.sh

USER buffettuser

EXPOSE 8080

# Standardverhalten: 1) dbt run 2) Dashboard rendern
ENTRYPOINT ["/app/run_dbt.sh"]
#CMD ["run", "--project-dir", "/app", "--profiles-dir", "/app"]
#ENTRYPOINT ["/bin/sh"]


