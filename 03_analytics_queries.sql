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

--ANALIZ 9: Oyuncunun adinin ilk 3 herfinden ve olkesinin ilk 3 herfinden ibaret skaut kodlari
--Meselen L. Messi ucun MES-ARG
SELECT CONCAT(
	CASE
		WHEN POSITION(' ' IN name) > 0 THEN SUBSTRING(UPPER(name) FROM POSITION(' ' IN name) + 1 FOR 3)
		WHEN POSITION('.' IN name) > 0 and POSITION('. ' IN name) = 0 THEN SUBSTRING(UPPER(name) FROM POSITION('.' IN name) + 1 FOR 3)
		ELSE SUBSTRING(UPPER(TRIM(name)) FROM 1 FOR 3)
		END,
		'-' ,SUBSTRING(UPPER(nationality) FOR 3)
	) as skaut_kodu
FROM fifa_players
WHERE name !='' and name!='name'
LIMIT 200;

--ANALIZ 10: Maaş Balansı və Kateqoriya Analizi
--Oyunçuları reytinq qruplarına bölür və fərdi maaşları öz qruplarının ortalaması ilə müqayisə edir.
SELECT 
    name, 
    overall_rating,
    CASE 
        WHEN overall_rating::INTEGER >= 90 THEN '90+'
        WHEN overall_rating::INTEGER >= 80 THEN '80-89'
        ELSE '79-'
    END as category,
    wage_euro::INTEGER as ferdi_maas,
    ROUND((
        SELECT AVG(s2.wage_euro::INTEGER) 
        FROM fifa_players s2
        WHERE s2.wage_euro != 'wage_euro' AND s2.wage_euro != ''
          AND CASE 
                  WHEN s1.overall_rating::INTEGER >= 90 THEN s2.overall_rating::INTEGER >= 90
                  WHEN s1.overall_rating::INTEGER >= 80 THEN s2.overall_rating::INTEGER >= 80 AND s2.overall_rating::INTEGER < 90
                  ELSE s2.overall_rating::INTEGER < 80
              END
    )) as kateqoriya_orta_maasi
FROM fifa_players s1
WHERE overall_rating != 'overall_rating' AND overall_rating != ''
ORDER BY overall_rating::INTEGER DESC
LIMIT 20;

--ANALIZ 11: Gənc Oyunçuların İnkişaf və Zaman Analizi
--Yaşı cüt olan oyunçuların reytinq kökünü tapır və gələcək yoxlanış tarixlərini hesablayır.
SELECT 
    name, 
    age, 
    overall_rating,
    ROUND(SQRT(overall_rating::INTEGER)::NUMERIC, 1) as reyting_kok,
    CURRENT_DATE + INTERVAL '1 year 6 months' as inkisaf_yoxlanis_tarixi
FROM fifa_players
WHERE name != 'name' 
  AND name != ''
  AND MOD(age::INTEGER, 2) = 0
LIMIT 20;

--ANALIZ 12: Overall_rating-i 70 den cox olan Ispaniya veya Argentina milliyyetine sahib oyunculari 1-den baslayaraq siralamaq

SELECT 
    name, nationality, overall_rating,
    ROW_NUMBER() OVER(PARTITION BY nationality ORDER BY overall_rating::INTEGER DESC) as milli_daxili_sira
FROM fifa_players
WHERE nationality IN ( 'Argentina', 'Spain' )  AND overall_rating != 'overall_rating' and overall_rating::INTEGER > 70;

--ANALIZ 13: Lead ve Lag sorgulari
--Fransa millisi uzre her oyuncunun ozunden sonra (derece siralamasinda) gelen oyuncudan olan derece ferqi

SELECT  name,
		overall_rating,
		overall_rating::INTEGER - lead(overall_rating::INTEGER) OVER(ORDER BY overall_rating::INTEGER DESC) as ferq
FROM fifa_players
WHERE nationality = 'France' and overall_rating  != 'overall_rating'
LIMIT 30;


--ANALIZ 14: Budcesi (millilerin umumi ortalama budcesinden) cox olan millilerin budceleri
--(derece siralamasinda ilk 25 oyuncuya esasen)

WITH top25_oyuncu AS (
    SELECT
		nationality,
		wage_euro::INTEGER as maas,
		ROW_NUMBER() OVER(PARTITION BY nationality ORDER BY overall_rating::INTEGER DESC) as sira_no
	FROM fifa_players
	WHERE nationality != '' AND nationality != 'nationality'
      AND wage_euro != '' AND wage_euro != 'wage_euro' AND wage_euro IS NOT NULL
),


milli_budceleri AS (
	SELECT nationality,
		   SUM(maas) as umumi_budce
	FROM top25_oyuncu
	WHERE sira_no <= 25
	GROUP BY nationality
)

SELECT
	nationality,
	umumi_budce
FROM milli_budceleri
WHERE umumi_budce > (SELECT AVG(umumi_budce) FROM milli_budceleri)
ORDER BY umumi_budce DESC;


--ANALIZ 15: Yaş və bazar dəyəri əlaqəsi (M - milyon , K - min  görünüşü ilə)

SELECT age, 
       COUNT(*) as say,
	   CASE
       	WHEN
		   AVG(value_euro::NUMERIC)>=1000000
		   THEN CONCAT(ROUND(AVG(value_euro::NUMERIC)/1000000,2), 'M')
		WHEN AVG(value_euro::NUMERIC)>=1000
			THEN CONCAT(ROUND(AVG(value_euro::NUMERIC)/1000,2), 'K')
		ELSE
			ROUND(AVG(value_euro::NUMERIC),2)::TEXT
		END as orta_deyer
FROM fifa_players
WHERE value_euro is not null
GROUP BY age
ORDER BY age ASC;

--ANALIZ 16: ANALIZ 10-un maaslarin K (min) ile gosterildiyi yeni versiyasi

SELECT 
    s1.name,
    s1.overall_rating,
    CASE 
        WHEN s1.overall_rating::INTEGER >= 90 THEN '90+'
        WHEN s1.overall_rating::INTEGER >= 80 THEN '80-89'
        ELSE '79-'
    END as category,
    CASE
        WHEN s1.wage_euro::NUMERIC >= 1000
            THEN CONCAT(ROUND(s1.wage_euro::NUMERIC / 1000, 1), 'K')
        ELSE
            ROUND(s1.wage_euro::NUMERIC, 2)::TEXT
    END as ferdi_maas,
    ROUND((
        SELECT AVG(s2.wage_euro::INTEGER) 
        FROM fifa_players s2
        WHERE s2.wage_euro != 'wage_euro' AND s2.wage_euro != ''
          AND CASE 
                  WHEN s1.overall_rating::INTEGER >= 90 THEN s2.overall_rating::INTEGER >= 90
                  WHEN s1.overall_rating::INTEGER >= 80 THEN s2.overall_rating::INTEGER >= 80 AND s2.overall_rating::INTEGER < 90
                  ELSE s2.overall_rating::INTEGER < 80
              END
    )) as kateqoriya_orta_maasi
FROM fifa_players s1
WHERE s1.overall_rating != 'overall_rating' AND s1.overall_rating != ''
  AND s1.wage_euro != 'wage_euro' AND s1.wage_euro != '' AND s1.wage_euro IS NOT NULL
ORDER BY s1.overall_rating::INTEGER DESC
LIMIT 20;

--ANALIZ 17: ANALIZ 16-daki uzun kodu lazim oldluqda her defe yazmaga ehtiyac qalmasin deye VIEW yaradiriq

CREATE VIEW v_advanced_player_analytics AS
SELECT 
    s1.name,
    s1.overall_rating,
    CASE 
        WHEN s1.overall_rating::INTEGER >= 90 THEN '90+'
        WHEN s1.overall_rating::INTEGER >= 80 THEN '80-89'
        ELSE '79-'
    END as category,
    CASE
        WHEN s1.wage_euro::NUMERIC >= 1000
            THEN CONCAT(ROUND(s1.wage_euro::NUMERIC / 1000, 1), 'K')
        ELSE
            ROUND(s1.wage_euro::NUMERIC, 2)::TEXT
    END as ferdi_maas,
    ROUND((
        SELECT AVG(s2.wage_euro::INTEGER) 
        FROM fifa_players s2
        WHERE s2.wage_euro != 'wage_euro' AND s2.wage_euro != ''
          AND CASE 
                  WHEN s1.overall_rating::INTEGER >= 90 THEN s2.overall_rating::INTEGER >= 90
                  WHEN s1.overall_rating::INTEGER >= 80 THEN s2.overall_rating::INTEGER >= 80 AND s2.overall_rating::INTEGER < 90
                  ELSE s2.overall_rating::INTEGER < 80
              END
    )) as kateqoriya_orta_maasi
FROM fifa_players s1
WHERE s1.overall_rating != 'overall_rating' AND s1.overall_rating != ''
  AND s1.wage_euro != 'wage_euro' AND s1.wage_euro != '' AND s1.wage_euro IS NOT NULL
ORDER BY s1.overall_rating::INTEGER DESC

-- ... ve sadece 1 setirlik kodla hemin cedvele baxa bilirik
SELECT * FROM v_advanced_player_analytics WHERE category = '90+' -- 90+ dereceli oyunculari secerek


-- ANALIZ 18: Tehlukesizliyi qorumaq ucun BEGIN ve COMMIT emrlerinden istifade edirik
-- ROLLBACK; emri ile ise deyisikliyi geri qaytara bilirik

BEGIN;

Update fifa_players
set overall_rating='80'
Where name='Y.Abbaszada';

Update fifa_players
set value_euro='15000000'
where name='Y.Abbaszada';

COMMIT;

--ANALIZ 19: Oyuncularin yaslarini cari tarix etibarile gun deqiqliyi ile hesablayiriq

SELECT name, age(CURRENT_DATE,TO_DATE(birth_date,'MM/DD/YYYY')) as YAS
from fifa_players
WHERE birth_date != 'birth_date' 
  AND birth_date != '' 
  AND birth_date IS NOT NULL
ORDER BY overall_rating DESC
limit 20
