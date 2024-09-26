from flask import Flask
# from services.Normalize_table import normalize_db
from blueprints.mission import mission_bp
from db import db
app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:1234@localhost:5432/wwii_missions'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.register_blueprint(mission_bp)
print("Starting database normalization...")
# with app.app_context():
#     # normalize_db()
print("Database normalization completed.")

with app.app_context():
    db.init_app(app)

if __name__ == '__main__':
    app.run()
