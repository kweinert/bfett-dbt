{{ config(materialized='table') }}

SELECT
	date,
	cash
FROM read_csv_auto(
	'/app/data/cash.csv',
	delim = ',',
	decimal_separator = '.',
    dateformat = '%Y-%m-%d',
    header = true
)

