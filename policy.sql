-- Определение ролей
CREATE ROLE admin_role;
CREATE ROLE user_role;
CREATE ROLE trainer_role;

-- Присвоение ролей пользователям
CREATE USER your_admin_user PASSWORD 'admin_password';
CREATE USER your_user PASSWORD 'user_password';
CREATE USER your_trainer PASSWORD 'trainer_password';

GRANT admin_role TO your_admin_user;
GRANT user_role TO your_user;
GRANT trainer_role TO your_trainer;

-- Грант привилегий
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES athletes, nutrition, workouts, measurements, diet_profiles, training_programs, training_sessions, endurance_tests TO user_role, trainer_role;

-- Определение политик доступа

-- Для таблицы "athletes"
CREATE POLICY athletes_admin_policy ON athletes
  FOR ALL
  TO admin_role
  USING (true);

CREATE POLICY athletes_user_policy ON athletes
  FOR ALL
  TO user_role
  USING (true);

CREATE POLICY athletes_trainer_policy ON athletes
  FOR ALL
  TO trainer_role
  USING (true);

-- Для таблицы "nutrition"
CREATE POLICY nutrition_admin_policy ON nutrition
  FOR ALL
  TO admin_role
  USING (true);

CREATE POLICY nutrition_user_policy ON nutrition
  FOR ALL
  TO user_role
  USING (true);

CREATE POLICY nutrition_trainer_policy ON nutrition
  FOR ALL
  TO trainer_role
  USING (true);