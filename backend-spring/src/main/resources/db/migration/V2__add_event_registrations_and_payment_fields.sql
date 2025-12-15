-- Создание таблицы event_registrations для хранения регистраций пользователей на события
CREATE TABLE IF NOT EXISTS event_registrations (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    event_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'CONFIRMED',
    registered_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_event_registration_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_event_registration_event FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    CONSTRAINT uk_user_event UNIQUE (user_id, event_id)
);

-- Создание индексов для быстрого поиска
CREATE INDEX idx_event_registrations_user_id ON event_registrations(user_id);
CREATE INDEX idx_event_registrations_event_id ON event_registrations(event_id);
CREATE INDEX idx_event_registrations_status ON event_registrations(status);

-- Добавление полей для интеграции с платежной системой в таблицу donations
ALTER TABLE donations 
    ADD COLUMN IF NOT EXISTS payment_intent_id VARCHAR(255),
    ADD COLUMN IF NOT EXISTS transaction_id VARCHAR(255),
    ADD COLUMN IF NOT EXISTS payment_method VARCHAR(50),
    ADD COLUMN IF NOT EXISTS payment_url VARCHAR(500),
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP;

-- Обновление существующих записей donations: установка статуса PENDING вместо COMPLETED
UPDATE donations SET status = 'PENDING' WHERE status = 'COMPLETED' AND transaction_id IS NULL;

-- Комментарии к таблицам
COMMENT ON TABLE event_registrations IS 'Регистрации пользователей на события';
COMMENT ON COLUMN event_registrations.status IS 'Статус регистрации: CONFIRMED, CANCELLED, WAITLIST';
COMMENT ON COLUMN donations.payment_intent_id IS 'ID намерения платежа от Stripe/PayPal';
COMMENT ON COLUMN donations.transaction_id IS 'ID завершенной транзакции';
COMMENT ON COLUMN donations.payment_method IS 'Метод оплаты: CARD, PAYPAL, STRIPE, BANK_TRANSFER';
COMMENT ON COLUMN donations.payment_url IS 'URL для редиректа на страницу оплаты';
