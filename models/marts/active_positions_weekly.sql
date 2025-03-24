{{ config(materialized='table') }}

WITH positions_with_week AS (
    SELECT
        isin,
        name,
        buy_date,
        amount,
        buy_price,
        category,
        CONCAT(EXTRACT(YEAR FROM buy_date), '-', LPAD(EXTRACT(WEEK FROM buy_date)::TEXT, 2, '0')) AS buy_week
    FROM {{ ref('stg_active_positions') }}
)

SELECT
    pw.isin,
    pw.name,
    pw.category,
    tw.calendar_week,
    SUM(pw.amount) AS amount,
    SUM(pw.amount * pw.buy_price) AS buy_in,
    tw.close * SUM(pw.amount) AS close_value,          -- close * amount
    tw.previous_close * SUM(pw.amount) AS previous_close_value  -- previous_close * amount
FROM {{ ref('int_trades_weekly') }} tw
LEFT JOIN positions_with_week pw
    ON pw.isin = tw.isin
    AND pw.buy_week <= tw.calendar_week  -- Nur Käufe vor oder in der Woche
GROUP BY
    pw.isin,
    pw.name,
    pw.category,
    tw.calendar_week,
    tw.close,
    tw.previous_close
HAVING SUM(pw.amount * pw.buy_price) IS NOT NULL  -- Entfernt Wochen ohne aktive Positionen
