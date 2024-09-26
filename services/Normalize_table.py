import psycopg2
from db import get_db_connection

source_conn = get_db_connection()

target_conn = psycopg2.connect(
    dbname="wwii_missions",
    user="postgres",
    password="1234",
    host="localhost",
    port="5432"
)
def normalize_db():


    try:
        source_cur = source_conn.cursor()
        target_cur = target_conn.cursor()

        print("executing")
        target_cur.execute("select * from mission limit 1")
        print("finished")
        rows = target_cur.fetchall()
        print("fetched")
        print(rows[:5])

        target_cur.execute("""
            CREATE TABLE IF NOT EXISTS targets (
                target_key SERIAL PRIMARY KEY,
                target_id VARCHAR(100),
                target_country VARCHAR(100),
                target_city VARCHAR(100),
                target_type VARCHAR(100),
                target_industry VARCHAR(255),
                target_priority VARCHAR(5),
                target_latitude NUMERIC(10, 6),
                target_longitude NUMERIC(10, 6)
            )
        """)
        print("1")
        # target_conn.commit()
        target_cur.execute("""
            INSERT INTO targets (target_id, target_country, target_city, target_type, target_industry, target_priority, target_latitude, target_longitude)
            SELECT DISTINCT target_id, target_country, target_city, target_type, target_industry, target_priority, target_latitude, target_longitude
            FROM mission
        """)
        print("2")
        # target_conn.commit()
        target_cur.execute("""
            ALTER TABLE IF EXISTS mission
            ADD COLUMN IF NOT EXISTS target_key INTEGER REFERENCES targets(target_key)
        """)
        print("3")
        # target_conn.commit()
        target_cur.execute("""
            UPDATE mission
            SET target_key = (
                SELECT target_key
                FROM targets
                WHERE targets.target_id = mission.target_id
                AND targets.target_country = mission.target_country
                AND targets.target_city = mission.target_city
                AND targets.target_type = mission.target_type
                AND targets.target_industry = mission.target_industry
                AND targets.target_priority = mission.target_priority
                AND targets.target_latitude = mission.target_latitude
                AND targets.target_longitude = mission.target_longitude
                LIMIT 5
            )
        """)
        print("4")
        # target_conn.commit()
        target_cur.execute("""
            ALTER TABLE IF EXISTS mission
            DROP COLUMN IF EXISTS target_country,
            DROP COLUMN IF EXISTS target_city,
            DROP COLUMN IF EXISTS target_type,
            DROP COLUMN IF EXISTS target_industry,
            DROP COLUMN IF EXISTS target_priority,
            DROP COLUMN IF EXISTS target_latitude,
            DROP COLUMN IF EXISTS target_longitude
        """)
        print("5")
        # target_conn.commit()
        target_cur.execute("""
            CREATE TABLE IF NOT EXISTS countries (
                country_id SERIAL PRIMARY KEY,
                country_name VARCHAR(100)
            )
        """)
        print("6")
        # target_conn.commit()
        target_cur.execute("""
            INSERT INTO countries (country_name)
            SELECT DISTINCT target_country FROM targets
        """)
        print("7")
        # target_conn.commit()
        target_cur.execute("""
            CREATE TABLE IF NOT EXISTS locations (
                location_id SERIAL PRIMARY KEY,
                country_id INTEGER REFERENCES countries(country_id),
                target_city VARCHAR(100),
                target_latitude NUMERIC(10, 6),
                target_longitude NUMERIC(10, 6)
            )
        """)

        print("8")
        # target_conn.commit()
        target_cur.execute("""
            INSERT INTO locations (country_id, target_city, target_latitude, target_longitude)
            SELECT DISTINCT countries.country_id, targets.target_city, targets.target_latitude, targets.target_longitude
            FROM targets
            JOIN countries ON targets.target_country = countries.country_name
        """)
        print("9")
        # target_conn.commit()
        target_cur.execute("""
            ALTER TABLE IF EXISTS targets
            ADD COLUMN IF NOT EXISTS location_id INTEGER REFERENCES locations(location_id)
        """)
        print("10")
        # target_conn.commit()
        target_cur.execute("""
            UPDATE targets
            SET location_id = (
                SELECT locations.location_id
                FROM locations
                JOIN countries ON locations.country_id = countries.country_id
                WHERE countries.country_name = targets.target_country
                AND locations.target_city = targets.target_city
                AND locations.target_latitude = targets.target_latitude
                AND locations.target_longitude = targets.target_longitude
            )
        """)

        print("11")
        # target_conn.commit()
        target_cur.execute("""
            ALTER TABLE IF EXISTS targets
            DROP COLUMN IF EXISTS target_country,
            DROP COLUMN IF EXISTS target_city,
            DROP COLUMN IF EXISTS target_latitude,
            DROP COLUMN IF EXISTS target_longitude
        """)
        print("12")
        # target_conn.commit()
        target_cur.execute("""
            CREATE TABLE IF NOT EXISTS industries (
                industry_id SERIAL PRIMARY KEY,
                target_industry VARCHAR(255)
            )
        """)
        print("13")
        # target_conn.commit()
        target_cur.execute("""
            INSERT INTO industries (target_industry)
            SELECT DISTINCT target_industry
            FROM targets
        """)

        print("14")
        # target_conn.commit()
        target_cur.execute("""
            ALTER TABLE IF EXISTS targets
            ADD COLUMN IF NOT EXISTS industry_id INTEGER REFERENCES industries(industry_id)
        """)
        print("15")
        # target_conn.commit()
        target_cur.execute("""
            UPDATE targets
            SET industry_id = (
                SELECT industry_id
                FROM industries
                WHERE industries.target_industry = targets.target_industry
            )
        """)
        print("16")
        # target_conn.commit()
        target_cur.execute("""
            ALTER TABLE IF EXISTS targets
            DROP COLUMN IF EXISTS target_industry
        """)
        print("17")
        # target_conn.commit()
        target_cur.execute("""
            CREATE TABLE IF NOT EXISTS types (
                type_id SERIAL PRIMARY KEY,
                target_type VARCHAR(100)
            )
        """)
        print("18")
        # target_conn.commit()
        target_cur.execute("""
            INSERT INTO types (target_type)
            SELECT DISTINCT target_type
            FROM targets
        """)
        print("19")
        # target_conn.commit()
        target_cur.execute("""
            ALTER TABLE IF EXISTS targets
            ADD COLUMN IF NOT EXISTS type_id INTEGER REFERENCES types(type_id)
        """)
        print("20")
        # target_conn.commit()
        target_cur.execute("""
            UPDATE targets
            SET type_id = (
                SELECT type_id
                FROM types
                WHERE types.target_type = targets.target_type
            )
        """)
        print("21")
        # target_conn.commit()
        target_cur.execute("""
            ALTER TABLE IF EXISTS targets
            DROP COLUMN IF EXISTS target_type
        """)
        print("22")
        # target_conn.commit()
        target_cur.execute("""
            CREATE TABLE IF NOT EXISTS priorities (
                priority_id SERIAL PRIMARY KEY,
                target_priority INTEGER
            )
        """)
        print("23")
        target_cur.execute("""
            INSERT INTO priorities (target_priority)
            SELECT DISTINCT CAST(target_priority AS INTEGER)
            FROM targets
            WHERE target_priority ~ '^[0-9]+$'
        """)
        # target_conn.commit()
        print("24")
        target_cur.execute("""
            ALTER TABLE IF EXISTS targets
            ADD COLUMN IF NOT EXISTS priority_id INTEGER REFERENCES priorities(priority_id)
        """)
        # target_conn.commit()
        print("25")

        target_cur.execute("""
            UPDATE targets
            SET priority_id = (
                SELECT priority_id
                FROM priorities
                WHERE priorities.target_priority = CAST(targets.target_priority AS INTEGER)
            )
            WHERE targets.target_priority ~ '^[0-9]+$'
        """)
        # target_conn.commit()
        print("26")
        target_cur.execute("""
            ALTER TABLE IF EXISTS targets
            DROP COLUMN IF EXISTS target_priority
        """)
        # target_conn.commit()
        print("27")
        print("Normalization was successful")

    except Exception as e:
        print(f"Error: {e}")
        target_conn.rollback()
    finally:
        if source_cur:
            source_cur.close()
        if target_cur:
            target_cur.close()
        if source_conn:
            source_conn.close()
        if target_conn:
            target_conn.close()
