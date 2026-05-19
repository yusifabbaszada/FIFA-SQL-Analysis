# FIFA Player Analytics System

Bu layihə PostgreSQL istifadə edərək 17,000-dən çox futbolçunun datasını analiz edir. Layihə çərçivəsində böyük həcmli CSV datası təmizlənmiş və scouting hesabatları hazırlanmışdır.

## İstifadə etmək üçün addımlar
1. `sql_scripts/01_create_table.sql` kodunu pgAdmin-də işlədin.
2. `fifa_players.csv` faylını cədvələ import edin.
3. `sql_scripts/02_data_cleaning.sql` ilə datanı təmizləyin.
4. `sql_scripts/03_analytics_queries.sql` ilə analizləri görün.

## Öyrənilən Nəticələr
- **Gənc İstedadlar:** Analiz göstərir ki, bazarda potensialı 20 xaldan çox artacaq "gizli" oyunçular mövcuddur.
- **Milli Komandalar:** Gənc oyunçuların potensialına görə lider ölkələr müəyyən edilmişdir.

## Texnologiyalar
- Database: **PostgreSQL**
- Tool: **pgAdmin 4**
- Analiz: **Complex SQL Queries (Aggregate functions, Casting, CTEs)**

## Data source
https://www.kaggle.com/datasets/maso0dahmed/football-players-data?resource=download&select=fifa_players.csv
