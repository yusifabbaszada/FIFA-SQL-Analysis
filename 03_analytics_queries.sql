-- ANALİZ 1: Gənc İstedadlar (Cevherler)
-- Yaşı 21-dən aşağı olan və inkişaf potensialı 15 xaldan çox olanlar
SELECT name, age, nationality, overall_rating, potential,
       (potential::INTEGER - overall_rating::INTEGER) as cevherlik 
FROM fifa_players
WHERE age::INTEGER < 21 
  AND (potential::INTEGER - overall_rating::INTEGER) > 15
ORDER BY cevherlik DESC
LIMIT 20;

-- ANALİZ 2: Ölkələrin Gələcək Gücü
-- Ən azı 10 gənc oyunçusu olan ölkələrin orta potensial reytinqi
SELECT nationality, COUNT(*) as oyuncu_sayi, 
       ROUND(AVG(potential::INTEGER), 1) as orta_potensial
FROM fifa_players
WHERE age::INTEGER < 23 AND overall_rating::INTEGER > 70
GROUP BY nationality
HAVING COUNT(*) > 10
ORDER BY orta_potensial DESC
LIMIT 5;

-- ANALİZ 3: Yaş və Bazar Dəyəri Əlaqəsi
SELECT age, 
       COUNT(*) as say,
       ROUND(AVG(value_euro::NUMERIC), 2) as orta_deyer
FROM fifa_players
WHERE value_euro is not null
GROUP BY age
ORDER BY age ASC;

-- ANALIZ 4: Ortalamadan yüksək maaş alan oyunçular
SELECT name,nationality, wage_euro
FROM fifa_players
where wage_euro!='wage_euro'
and wage_euro::INTEGER > (SELECT AVG(wage_euro::INTEGER) from fifa_players where wage_euro!='wage_euro')
ORDER BY wage_euro::INTEGER DESC

--ANALİZ 5: Yaşı ortalama yaşdan aşağı olan oyunçuların sayı
SELECT COUNT(*) as gencler
FROM fifa_players
where age!='age'
and age::INTEGER < (SELECT AVG(age::INTEGER) from fifa_players where age!='age')

--ANALİZ 6: Daxilində yalnız Azərbaycanlı oyunçuların adı və yaşı olan view(görüntü)
CREATE VIEW az_lar AS
SELECT name, age FROM fifa_players
WHERE nationality='Azerbaijan'
       -- Yaradılmış View-ya baxmaq üçün ayrıca sorğu
       SELECT * FROM az_lar

-- ANALİZ 7: Taktiki Analiz (Eyni mövqedə oynayan fərqli ayaqlı oyunçular (Qapıçıları çıxmaqla))
SELECT 
    p1.name as oyuncu_1,
    p2.name as oyuncu_2,
    p1.positions,
    p1.overall_rating as overall_1,
    p2.overall_rating as overall_2,
    p1.preferred_foot as foot_1,
    p2.preferred_foot as foot_2
FROM fifa_players p1
INNER JOIN fifa_players p2 ON p1.positions=p2.positions
                        AND p1.preferred_foot<p2.preferred_foot
WHERE p1.positions!='GK' and p1.nationality='Germany' and p2.nationality='Germany' and p1.overall_rating::INTEGER > 75
and p2.overall_rating::INTEGER > 75
LIMIT 100;

-- ANALİZ 8: Agentliyi Olmayan Sahibsiz Ulduzlar (LEFT JOIN ... IS NULL)
-- Reytinqi 85+ olan və agenti olmayan oyunçular
SELECT 
    p.player_id,
    p.name as oyuncu_adi, 
    p.overall_rating,
    p.nationality,
    a.agent_name as futbol_agenti
FROM fifa_players p
LEFT JOIN agents a ON p.player_id = a.player_id
WHERE a.agent_name IS NULL 
  AND p.overall_rating::INTEGER >= 85
ORDER BY p.overall_rating::INTEGER DESC;
