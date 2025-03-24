{{ config(materialized='table') }}

WITH trades_with_week AS (
    SELECT
        isin,
        trade_time,
        price,
        CONCAT(EXTRACT(YEAR FROM trade_time), '-', LPAD(EXTRACT(WEEK FROM trade_time)::TEXT, 2, '0')) AS calendar_week
    FROM {{ ref('stg_trades') }}
),

weekly_closes AS (
    SELECT
        isin,
        calendar_week,
        LAST_VALUE(price) OVER (PARTITION BY isin, calendar_week ORDER BY trade_time 
                                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS close
    FROM trades_with_week
    QUALIFY ROW_NUMBER() OVER (PARTITION BY isin, calendar_week ORDER BY trade_time DESC) = 1
)

SELECT
    wc.isin,
    wc.calendar_week,
    wc.close,
    LAG(wc.close) OVER (PARTITION BY wc.isin ORDER BY wc.calendar_week) AS previous_close
FROM weekly_closes wc
