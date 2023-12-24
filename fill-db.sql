-- Заполнение таблицы "Roles" 
INSERT INTO roles (role_name) VALUES
  ('Admin'), -- администратор
  ('User'),  -- пользователь
  ('Trainer'); --  тренер

-- Вставка данных в таблицу "Users"
INSERT INTO users (username, password_hash, role_id, contact_info) VALUES
  ('ВАСЯ', crypt('hashed_password_admin', gen_salt('bf')), 1, ROW('admin@example.com', '123-456-7890')),
  ('ПЕТЯ', crypt('hashed_password_user', gen_salt('bf')) , 2, ROW('user@example.com', '987-654-3210')),
  ('КСЮША', crypt('hashed_password_trainer', gen_salt('bf')) , 3, ROW('trainer@example.com', '555-555-5555'));

-- Вставка данных в таблицу "Athletes"
INSERT INTO athletes (name, gender, birthdate, user_id) VALUES
  ('Администратор', 'М', '1990-01-01'::date, 1),
  ('Обычный пользователь', 'Ж', '1995-05-10'::date, 2),
  ('Тренер', 'М', '1988-08-15'::date, 3);

-- Заполнение таблицы "Nutrition" 
INSERT INTO nutrition (athlete_id, date, meal_type, calories, protein, fats, carbohydrates) VALUES
  (1, '2023-01-01'::date, 'Завтрак', 500, 20, 10, 60),
  (1, '2023-01-01'::date, 'Обед', 1000, 40, 20, 120),
  (1, '2023-01-01'::date, 'Ужин', 250, 10, 5, 30),

  (2, '2023-01-02'::date, 'Завтрак', 700, 25, 15, 80),
  (2, '2023-01-02'::date, 'Обед', 1400, 50, 30, 160),
  (2, '2023-01-02'::date, 'Ужин', 350, 15, 8, 40),

  (3, '2023-01-03'::date, 'Завтрак', 400, 15, 8, 50),
  (3, '2023-01-03'::date, 'Обед', 800, 30, 16, 100),
  (3, '2023-01-03'::date, 'Ужин', 200, 8, 4, 25);

-- Заполнение таблицы "Workouts" 
INSERT INTO workouts (athlete_id, date, type, duration) VALUES
  (1, '2023-01-04'::date, 'Бег', 30),
  (2, '2023-01-05'::date, 'Плавание', 45),
  (3, '2023-01-06'::date, 'Силовая тренировка', 60);

-- Заполнение таблицы "Measurements"
INSERT INTO measurements (athlete_id, date, weight, fat_percentage, muscle_percentage) VALUES
  (1, '2023-01-07'::date, 75.5, 15.0, 40.0),
  (2, '2023-01-08'::date, 60.0, 20.0, 35.0),
  (3, '2023-01-09'::date, 80.0, 18.0, 42.0);

-- Заполнение таблицы "Diet Profiles" 
INSERT INTO diet_profiles (athlete_id, description) VALUES
  (1, 'Высокобелковая диета'),
  (2, 'Низкокалорийная диета'),
  (3, 'Сбалансированное питание');

-- Заполнение таблицы "Training Programs" 
INSERT INTO training_programs (description) VALUES
  ('Программа для бегунов'),
  ('Программа для пловцов'),
  ('Программа для силовых тренировок');

-- Заполнение таблицы "Training Sessions" 
INSERT INTO training_sessions (program_id, date, workout_id) VALUES
  (1, '2023-01-10'::date, 1),
  (2, '2023-01-11'::date, 2),
  (3, '2023-01-12'::date, 3);

-- Заполнение таблицы "Endurance Tests" 
INSERT INTO endurance_tests (athlete_id, date, distance, duration) VALUES
  (1, '2023-01-13'::date, 10.0, 60),
  (2, '2023-01-14'::date, 5.0, 30),
  (3, '2023-01-15'::date, 15.0, 90);
