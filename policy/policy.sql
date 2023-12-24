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

