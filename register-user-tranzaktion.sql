CREATE OR REPLACE PROCEDURE register_user(
    p_username VARCHAR(50),
    p_password_hash VARCHAR(255),
    p_name VARCHAR(255),
    p_gender VARCHAR(50),
    p_birthdate DATE
)
AS $$
DECLARE
    new_user_id INT;
BEGIN
    -- Начало транзакции
    BEGIN
        -- Вставка в таблицу "Users"
        INSERT INTO users (username, password_hash)
        VALUES (p_username, p_password_hash)
        RETURNING user_id INTO new_user_id;

        -- Вставка в таблицу "Athletes"
        INSERT INTO athletes (user_id, name, gender, birthdate)
        VALUES (new_user_id, p_name, p_gender, p_birthdate);

        -- Если все успешно, фиксация транзакции
        COMMIT;
    EXCEPTION
        -- В случае ошибки, откат транзакции
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END;
END;
$$ LANGUAGE plpgsql;
