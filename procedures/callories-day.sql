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
