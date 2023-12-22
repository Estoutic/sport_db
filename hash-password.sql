-- Создание функции и триггера
CREATE OR REPLACE FUNCTION before_insert_user_trigger()
RETURNS TRIGGER AS $$
BEGIN
    -- Хеширование пароля и вставка пользователя
    INSERT INTO users (username, password_hash,role_id)
    VALUES (NEW.username, HASHBYTES('SHA2_512', NEW.password_hash), NEW.role_id);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_user
BEFORE INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION before_insert_user_trigger();
