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