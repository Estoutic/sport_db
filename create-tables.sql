-- Создание таблицы "Roles"
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

-- Создание типа данных "ContactInfo"
CREATE TYPE ContactInfo AS (
    email VARCHAR(100),
    phone VARCHAR(15)
);

-- Создание таблицы "Users" с полем "contact_info"
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role_id INT REFERENCES roles(role_id) ON DELETE SET NULL,
    contact_info ContactInfo
);

-- Создание таблицы "Athletes"
CREATE TABLE athletes (
    athlete_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    gender VARCHAR(50) NOT NULL,
    birthdate DATE NOT NULL,
    user_id INT REFERENCES users(user_id) ON DELETE SET NULL -- Связь с таблицей Users
);

-- Создание таблицы "Nutrition"
CREATE TABLE nutrition (
    nutrition_id SERIAL PRIMARY KEY,
    athlete_id INT REFERENCES athletes(athlete_id) ON DELETE CASCADE, -- Связь с таблицей Athletes
    date DATE NOT NULL,
    meal_type VARCHAR(50),
    calories INT,
    protein INT,
    fats INT,
    carbohydrates INT
);

-- Создание таблицы "Workouts"
CREATE TABLE workouts (
    workout_id SERIAL PRIMARY KEY,
    athlete_id INT REFERENCES athletes(athlete_id) ON DELETE CASCADE, -- Связь с таблицей Athletes
    date DATE NOT NULL,
    type VARCHAR(255) NOT NULL,
    duration INT NOT NULL
);

-- Создание таблицы "Measurements"
CREATE TABLE measurements (
    measurement_id SERIAL PRIMARY KEY,
    athlete_id INT REFERENCES athletes(athlete_id) ON DELETE CASCADE, -- Связь с таблицей Athletes
    date DATE NOT NULL,
    weight DECIMAL(5,2),
    fat_percentage DECIMAL(5,2),
    muscle_percentage DECIMAL(5,2)
);

-- Создание таблицы "Diet Profiles"
CREATE TABLE diet_profiles (
    profile_id SERIAL PRIMARY KEY,
    athlete_id INT REFERENCES athletes(athlete_id) ON DELETE CASCADE, -- Связь с таблицей Athletes
    description TEXT
);

-- Создание таблицы "Training Programs"
CREATE TABLE training_programs (
    program_id SERIAL PRIMARY KEY,
    description TEXT
);

-- Создание таблицы "Training Sessions"
CREATE TABLE training_sessions (
    session_id SERIAL PRIMARY KEY,
    program_id INT REFERENCES training_programs(program_id) ON DELETE CASCADE, -- Связь с таблицей Training Programs
    date DATE NOT NULL,
    workout_id INT REFERENCES workouts(workout_id) ON DELETE SET NULL -- Связь с таблицей Workouts
);

-- Создание таблицы "Endurance Tests"
CREATE TABLE endurance_tests (
    test_id SERIAL PRIMARY KEY,
    athlete_id INT REFERENCES athletes(athlete_id) ON DELETE CASCADE, -- Связь с таблицей Athletes
    date DATE NOT NULL,
    distance DECIMAL(5,2),
    duration INT NOT NULL
);
