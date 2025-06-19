-- === order_order ============================================================
CREATE TABLE order_order (
    id                BIGSERIAL PRIMARY KEY,
    marketplace_number BIGINT       NOT NULL,
    sys_status         INT          NOT NULL,
    created            TIMESTAMPTZ  NOT NULL,
    marketplace_id     INT          NOT NULL
);

--CREATE INDEX idx_order_created_market
--          ON order_order (created, marketplace_id);

-- === order_orderhistory =====================================================
CREATE TABLE order_orderhistory (
    id         BIGSERIAL PRIMARY KEY,
    order_id   BIGINT      NOT NULL REFERENCES order_order(id) ON DELETE CASCADE,
    data       JSONB       NOT NULL,
    created_at TIMESTAMPTZ NOT NULL
);

--CREATE INDEX idx_history_order          ON order_orderhistory (order_id);
--CREATE INDEX idx_history_status_expr
--          ON order_orderhistory ( ((data -> 'current' ->> 'sys_status')::INT) );

-- частичный индекс только по интересующим нас статусам 9/91 (ускорит запрос)
--CREATE INDEX idx_history_status_9_91
--          ON order_orderhistory (order_id, created_at)
--       WHERE (data -> 'current' ->> 'sys_status')::INT IN (9,91);
