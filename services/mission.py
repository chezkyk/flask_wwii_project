from models.mission2 import Mission
from flask_sqlalchemy import SQLAlchemy


db = SQLAlchemy()

def get_missions():
    try:
        missions = Mission.query.all()
        mission_data = [mission_to_dict(mission) for mission in missions]
        return mission_data
    except Exception as e:
        db.session.rollback()
        raise e

def get_mission_by_id(mission_id):

    try:
        mission = Mission.query.filter_by(mission_id=mission_id).first()
        if mission:
            return mission_to_dict(mission)
        else:
            return None
    except Exception as e:
        db.session.rollback()
        raise e

def mission_to_dict(mission):

    return {
        'mission_id': mission.mission_id,
        'mission_date': str(mission.mission_date),
        'theater_of_operations': mission.theater_of_operations,
        'country': mission.country,
        'air_force': mission.air_force,
        'unit_id': mission.unit_id,
        'aircraft_series': mission.aircraft_series,
        'callsign': mission.callsign,
        'mission_type': mission.mission_type,
        'takeoff_base': mission.takeoff_base,
        'takeoff_location': mission.takeoff_location,
        'takeoff_latitude': mission.takeoff_latitude,
        'takeoff_longitude': mission.takeoff_longitude,
        'target_id': mission.target_id,
        'target_country': mission.target_country,
        'target_city': mission.target_city,
        'target_type': mission.target_type,
        'target_industry': mission.target_industry,
        'target_priority': mission.target_priority,
        'target_latitude': mission.target_latitude,
        'target_longitude': mission.target_longitude,
        'altitude_hundreds_of_feet': mission.altitude_hundreds_of_feet,
        'airborne_aircraft': mission.airborne_aircraft,
        'attacking_aircraft': mission.attacking_aircraft,
        'bombing_aircraft': mission.bombing_aircraft,
        'aircraft_returned': mission.aircraft_returned,
        'aircraft_failed': mission.aircraft_failed,
        'aircraft_damaged': mission.aircraft_damaged,
        'aircraft_lost': mission.aircraft_lost,
        'high_explosives': mission.high_explosives,
        'high_explosives_type': mission.high_explosives_type,
        'high_explosives_weight_pounds': mission.high_explosives_weight_pounds,
        'high_explosives_weight_tons': mission.high_explosives_weight_tons,
        'incendiary_devices': mission.incendiary_devices,
        'incendiary_devices_type': mission.incendiary_devices_type,
        'incendiary_devices_weight_pounds': mission.incendiary_devices_weight_pounds,
        'incendiary_devices_weight_tons': mission.incendiary_devices_weight_tons,
        'fragmentation_devices': mission.fragmentation_devices,
        'fragmentation_devices_type': mission.fragmentation_devices_type,
        'fragmentation_devices_weight_pounds': mission.fragmentation_devices_weight_pounds,
        'fragmentation_devices_weight_tons': mission.fragmentation_devices_weight_tons,
        'total_weight_pounds': mission.total_weight_pounds,
        'total_weight_tons': mission.total_weight_tons,
        'time_over_target': mission.time_over_target,
        'bomb_damage_assessment': mission.bomb_damage_assessment,
        'source_id': mission.source_id
    }
