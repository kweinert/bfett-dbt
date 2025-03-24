{{ config(materialized='table') }}

SELECT
	isin,
	name,
	amount,
	buy_date::DATE as buy_date,
	buy_price,
	category
FROM read_csv_auto(
	'/app/data/active_positions.csv',
	delim = ',',
	decimal_separator = '.',
    dateformat = '%Y-%m-%d',
    header = true
)

