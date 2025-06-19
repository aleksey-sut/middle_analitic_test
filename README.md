# Тестовое задание для Middle SQL/Backend-инженера  
**Тема:** Оптимизация выборки истории заказов в PostgreSQL

---

## 1. Контекст

В проекте используется PostgreSQL 15.  
Ниже приведён реальный (упрощённый) запрос, который регулярно выполняется в отчётных
джобах и **становится узким местом** при выборке более 100 k заказов за месяц.
Вам необходимо оптимизировать запрос.

```sql
WITH order_list AS (
    SELECT oo.id,
           oo.marketplace_number,
           oo.sys_status
    FROM   order_order oo
    WHERE  oo.created >= '2025-03-01'
      AND  oo.created <  '2025-04-01'
      AND  oo.marketplace_id = 5
),

history AS (
    SELECT DISTINCT ON (order_id, (data -> 'current' ->> 'sys_status')::int)
           order_id,
           (data -> 'current' ->> 'sys_status')::int AS status,
           created_at
    FROM   order_orderhistory oo
    WHERE  (data -> 'current' ->> 'sys_status')::int IN (9, 91)
    ORDER  BY order_id,
             (data -> 'current' ->> 'sys_status')::int,
             created_at
)

SELECT  ol.marketplace_number,
        h9.created_at  AS created_at_9,
        h91.created_at AS created_at_91
FROM    order_list ol
LEFT JOIN (
    SELECT DISTINCT ON (order_id) *
    FROM   history
    WHERE  status = 9
    ORDER  BY order_id, created_at
) h9   ON ol.id = h9.order_id
LEFT JOIN (
    SELECT DISTINCT ON (order_id) *
    FROM   history
    WHERE  status = 91
    ORDER  BY order_id, created_at
) h91  ON ol.id = h91.order_id;
```


## 2. Запуск

## ⚡ Быстрый старт (развёртывание)

```bash
# 1 . Клонируйте репозиторий

# 2 . Скопируйте переменные окружения и при желании измените пароль/БД
cp .env.example .env

# 3 . Поднимите сервис
docker-compose up -d          # или make up

# 4 . Подключитесь к БД
docker-compose exec postgres psql -U demo_user -d demo_db

# 5 . Убедитесь, что данные на месте
SELECT COUNT(*) FROM order_order;          -- 100 000
SELECT COUNT(*) FROM order_orderhistory;   -- 200 000
