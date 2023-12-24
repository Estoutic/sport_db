-- Определение ролей
CREATE ROLE admin_role;
CREATE ROLE user_role;
CREATE ROLE trainer_role;

-- Присвоение ролей пользователям
CREATE USER admin PASSWORD 'admin_password';
CREATE USER user PASSWORD 'user_password';
CREATE USER trainer PASSWORD 'trainer_password';

GRANT admin_role TO admin;
GRANT user_role TO user;
GRANT trainer_role TO rainer;

-- Грант привилегий
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES athletes, nutrition, workouts, measurements, diet_profiles, training_programs, training_sessions, endurance_tests TO user_role, trainer_role;

-- Определение политик доступа

-- Для таблицы "diet_profiles"
CREATE POLICY diet_profiles_admin_policy ON diet_profiles
  FOR ALL
  TO admin_role
  USING (true);

CREATE POLICY diet_profiles_trainer_policy ON diet_profiles
  FOR ALL
  TO trainer_role
  USING (true);

CREATE POLICY diet_profiles_user_policy ON diet_profiles
  FOR SELECT
  TO user_role
  USING (true);

-- Для таблицы "training_programs"
CREATE POLICY training_programs_admin_policy ON training_programs
  FOR ALL
  TO admin_role
  USING (true);

CREATE POLICY training_programs_trainer_policy ON training_programs
  FOR ALL
  TO trainer_role
  USING (true);

CREATE POLICY training_programs_user_policy ON training_programs
  FOR SELECT
  TO user_role
  USING (true);


--  trigger bju 
CREATE OR REPLACE FUNCTION update_mass_after_nutrition()
RETURNS TRIGGER AS $$
DECLARE
    current_weight DECIMAL(5,2);
    current_fat_percentage DECIMAL(5,2);
    current_muscle_percentage DECIMAL(5,2);
BEGIN
    SELECT weight, fat_percentage, muscle_percentage
    INTO current_weight, current_fat_percentage, current_muscle_percentage
    FROM measurements
    WHERE athlete_id = NEW.athlete_id AND date = NEW.date;

    current_weight := current_weight + NEW.calories / 7700; 
    current_fat_percentage := current_fat_percentage + (NEW.fats / current_weight) * 100; 
    current_muscle_percentage := current_muscle_percentage + (NEW.protein / current_weight) * 100; 

    UPDATE measurements
    SET
        weight = current_weight,
        fat_percentage = current_fat_percentage,
        muscle_percentage = current_muscle_percentage
    WHERE athlete_id = NEW.athlete_id AND date = NEW.date;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_insert_nutrition
AFTER INSERT ON nutrition
FOR EACH ROW
EXECUTE FUNCTION update_mass_after_nutrition();


-- food limit trigger 
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

-- middle trainig time procedure + call
CREATE OR REPLACE PROCEDURE calculate_average_workout_duration()
AS $$
DECLARE
    athlete_id_var INT;
    athlete_name VARCHAR(255);
    avg_duration DECIMAL(10,2);
BEGIN

    FOR athlete_id_var, athlete_name IN SELECT DISTINCT a.athlete_id, a.name FROM athletes a
    LOOP

        SELECT AVG(w.duration)
        INTO avg_duration
        FROM workouts w
        WHERE w.athlete_id = athlete_id_var;


        RAISE NOTICE 'Средняя длительность тренировок для %: % минут', athlete_name, COALESCE(avg_duration, 0);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CALL calculate_average_workout_duration();

-- callories day rodcedure + call 
CREATE OR REPLACE PROCEDURE calculate_total_calories()
AS $$
DECLARE
    athlete_rec RECORD;
    athlete_id_var INT;
    athlete_name VARCHAR(255);
    total_calories INT;
BEGIN
    FOR athlete_rec IN SELECT DISTINCT a.athlete_id, a.name FROM athletes a
    LOOP
        athlete_id_var := athlete_rec.athlete_id;
        athlete_name := athlete_rec.name;

        SELECT COALESCE(SUM(n.calories), 0)
        INTO total_calories
        FROM nutrition n
        WHERE n.athlete_id = athlete_id_var;

        RAISE NOTICE 'Общее количество потраченных калорий для %: %', athlete_name, total_calories;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CALL calculate_total_calories();

