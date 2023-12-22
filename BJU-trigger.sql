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
