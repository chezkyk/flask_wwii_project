from flask import Blueprint, jsonify
from services.mission import get_missions, get_mission_by_id

mission_bp = Blueprint('mission', __name__, url_prefix='/api/mission')

@mission_bp.route('/', methods=['GET'])
def get_missions_route():
    try:
        missions = get_missions()
        return jsonify(missions), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@mission_bp.route('/<int:id>', methods=['GET'])
def get_mission_by_id_route(id):
    try:
        mission = get_mission_by_id(id)
        if mission:
            return jsonify(mission), 200
        else:
            return jsonify({'error': 'Mission not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500