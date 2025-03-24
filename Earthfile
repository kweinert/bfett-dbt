VERSION 0.8
FROM ghcr.io/dbt-labs/dbt-core:1.9.3

WORKDIR /app

dbt-deps:
	# Installiere Systemabhängigkeiten für R und pak
	RUN apt-get update && apt-get install -y \
		build-essential \
		libssl-dev \
		libcurl4-openssl-dev \
		r-base \
		&& rm -rf /var/lib/apt/lists/*

	# Installiere pak von CRAN
	RUN R -e "install.packages('pak', repos='https://cloud.r-project.org/')"

	# Konfiguriere P3M als Repository für Binärpakete (Ubuntu 22.04 "jammy" als Beispiel)
	RUN mkdir -p /usr/local/lib/R/etc && echo "options(repos = c(CRAN = 'https://p3m.dev/cran/__linux__/jammy/latest'))" >> /usr/local/lib/R/etc/Rprofile.site
	
	# Installiere weitere Pakete als Binaries über pak
    RUN R -e "pak::pkg_install(c('data.table', 'tinytest'))"

	# Installiere duckdb adapter for dbt
	RUN pip install dbt-duckdb duckdb

buffett-img:
	FROM +dbt-deps
	USER $(id -u):$(id -g)  # Muss auf dem Host ausgewertet werden, nicht ideal für Earthly
	
	# only needed if not bind mount
    COPY profiles.yml .  
    COPY dbt_project.yml .
	COPY models/ ./models/  

    ENTRYPOINT ["dbt"]
    CMD ["run", "--project-dir", "/app", "--profiles-dir", "/app"]
    SAVE IMAGE buffett-duckdb:latest
	
