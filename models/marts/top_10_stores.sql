with

transactions as (

    select * from {{ ref('stg_transactions') }}

),

store as (

    select * from {{ ref('stg_store') }}

),

devices as (

    select * from {{ ref('stg_devices') }}

),

store_transaction_data AS (
       SELECT a.id AS transaction_id,
              a.device_id,
              a.product_name,
              a.product_sku,
              a.category_name,
              a.amount,
              a.status,
              a.created_at AS transaction_created_at,
              b.type aS device_type,
              c.id AS store_id,
              c.name AS store_name
       FROM transactions a
                LEFT JOIN devices b on a.device_id = b.id
                LEFT JOIN store c on b.store_id = c.id
)

SELECT store_name,
       SUM(amount) AS total_amount
FROM store_transaction_data
WHERE status = 'accepted'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;