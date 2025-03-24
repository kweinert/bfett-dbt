{{ config(materialized='incremental') }}

SELECT
	isin,
	tradeTime::TIMESTAMP AS trade_time,
	size,
	price,
	currency,
	CURRENT_TIMESTAMP as load_timestamp
FROM read_csv_auto(
    '/app/data/trades/lsx_trades_*.csv',
    delim = ';',              -- Semikolon als Trennzeichen
    decimal_separator = ',',  -- Komma als Dezimalpunkt
    header = true,            -- Erwartet Kopfzeile
    dateformat = '%Y-%m-%dT%H:%M:%S.%fZ'
)
{% if is_incremental() %}
    WHERE trade_time > (SELECT MAX(trade_time) FROM {{ this }})
{% endif %}
