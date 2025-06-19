-- ▸ 100 000 заказов за март 2025 (≈ 1 / секунда)
INSERT INTO order_order (marketplace_number, sys_status, created, marketplace_id)
SELECT 10000000 + gs,
       (ARRAY[0,1,2,3,4,5,6,7,8,9,91])[floor(random()*11 + 1)::INT],
       TIMESTAMP '2025-03-01 00:00:00' + (gs * INTERVAL '30 second'),
       floor(random() * 10 + 1)::int
FROM generate_series(1, 1000000) AS gs;

-- ▸ по два состояния (9 и 91) для каждого заказа → 200 000 строк history
INSERT INTO order_orderhistory (order_id, data, created_at)
SELECT o.id,
       jsonb_build_object('current', jsonb_build_object('sys_status', s.status)),
       o.created + (s.offset_hours * INTERVAL '1 hour')
FROM order_order o
CROSS JOIN (VALUES (9, 1), (91, 2), (1, 10), (3, 15), (71, 20)) AS s(status, offset_hours);
