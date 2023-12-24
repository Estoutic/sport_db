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
