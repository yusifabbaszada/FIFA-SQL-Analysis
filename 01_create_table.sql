DROP TABLE IF EXISTS fifa_players;

CREATE TABLE fifa_players (
    name TEXT,
    full_name TEXT,
    birth_date TEXT,
    age TEXT,
    height_cm TEXT,
    weight_kgs TEXT,
    positions TEXT,
    nationality TEXT,
    overall_rating TEXT,
    potential TEXT,
    value_euro TEXT,
    wage_euro TEXT,
    preferred_foot TEXT,
    international_reputation TEXT,
    weak_foot TEXT,
    skill_moves TEXT,
    body_type TEXT,
    release_clause_euro TEXT,
    national_team TEXT,
    national_rating TEXT,
    national_team_position TEXT,
    national_jersey_number TEXT,
    crossing TEXT,
    finishing TEXT,
    heading_accuracy TEXT,
    short_passing TEXT,
    volleys TEXT,
    dribbling TEXT,
    curve TEXT,
    freekick_accuracy TEXT,
    long_passing TEXT,
    ball_control TEXT,
    acceleration TEXT,
    sprint_speed TEXT,
    agility TEXT,
    reactions TEXT,
    balance TEXT,
    shot_power TEXT,
    jumping TEXT,
    stamina TEXT,
    strength TEXT,
    long_shots TEXT,
    aggression TEXT,
    interceptions TEXT,
    positioning TEXT,
    vision TEXT,
    penalties TEXT,
    composure TEXT,
    marking TEXT,
    standing_tackle TEXT,
    sliding_tackle TEXT
);

DROP TABLE IF EXISTS agents;

CREATE TABLE agents (
    agent_id SERIAL PRIMARY KEY,
    agent_name TEXT,
    player_id INTEGER
);

-- Test məlumatları
INSERT INTO agents (agent_name, player_id) VALUES
('Jorge Mendes', 1),
('Jorge Mendes', 5),
('Mino Raiola Legacy', 10),
('Mino Raiola Legacy', 12),
('Jonathan Barnett', 3),
('Pini Zahavi', 7),
('Pini Zahavi', 25),
('Volker Struth', 50),
('Volker Struth', 100);
