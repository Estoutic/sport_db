ALTER TABLE athletes ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION is_athlete_allowed(user_role_id INT, target_role_id INT)
RETURNS BOOLEAN AS $$
BEGIN
    IF user_role_id = 1 THEN
        RETURN TRUE;
    ELSIF user_role_id IN (2, 3) THEN
        RETURN target_role_id IS NOT NULL;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE POLICY select_insert_policy
    ON athletes
    USING (is_athlete_allowed(current_setting('myvars.current_user_role_id')::INT, role_id));

CREATE POLICY delete_policy
    ON athletes
    FOR DELETE
    USING (current_setting('myvars.current_user_role_id')::INT = 1);
