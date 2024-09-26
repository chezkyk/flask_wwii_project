from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def get_missions():
    try:
        result = db.session.execute('SELECT * FROM mission2')
        missions = result.fetchall()
        mission_data = [dict(row) for row in missions]
        return mission_data
    except Exception as e:
        db.session.rollback()
        raise e
def get_mission_by_id(mission_id):
    try:
        result = db.session.execute('SELECT * FROM MISSION2 WHERE mission_id = :mission_id', {'mission_id': mission_id})
        mission = result.fetchone()
        if mission:
            return dict(mission)
        else:
            return None
    except Exception as e:
        db.session.rollback()
        raise e