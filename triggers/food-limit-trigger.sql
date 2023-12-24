CREATE OR REPLACE FUNCTION check_meal_limit()
RETURNS TRIGGER AS $$
DECLARE
    meal_count INT;
BEGIN
    SELECT COUNT(*)
    INTO meal_count
    FROM nutrition
    WHERE athlete_id = NEW.athlete_id AND date = NEW.date;

    IF meal_count >= 3 THEN
        RAISE EXCEPTION 'Превышено максимальное количество приемов пищи в день.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_nutrition
BEFORE INSERT ON nutrition
FOR EACH ROW
EXECUTE FUNCTION check_meal_limit();

CREATE TRIGGER before_update_nutrition
BEFORE UPDATE ON nutrition
FOR EACH ROW
EXECUTE FUNCTION check_meal_limit();
