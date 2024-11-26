from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
import random

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
bcrypt = Bcrypt(app)

# نموذج المستخدم
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)
    reset_code = db.Column(db.String(6), nullable=True)  # كود الاستعادة

# إنشاء قاعدة البيانات
with app.app_context():
    db.create_all()

# تسجيل المستخدم
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if User.query.filter_by(email=email).first():
        return jsonify({'message': 'Email already exists'}), 400

    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
    new_user = User(email=email, password=hashed_password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({'message': 'User registered successfully'}), 201

# تسجيل الدخول
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    user = User.query.filter_by(email=email).first()

    if not user or not bcrypt.check_password_hash(user.password, password):
        return jsonify({'message': 'Invalid credentials'}), 401

    return jsonify({'message': 'Login successful'}), 200

# استعادة كلمة المرور (إرسال كود)
@app.route('/forgot-password', methods=['POST'])
def forgot_password():
    data = request.get_json()
    email = data.get('email')

    user = User.query.filter_by(email=email).first()

    if not user:
        return jsonify({'message': 'Email not found'}), 404

    reset_code = str(random.randint(100000, 999999))
    user.reset_code = reset_code
    db.session.commit()

    # من المفترض إرسال الكود عبر البريد الإلكتروني (هنا مجرد محاكاة)
    print(f"Reset code for {email}: {reset_code}")

    return jsonify({'message': 'Reset code sent to your email'}), 200

# تغيير كلمة المرور
@app.route('/reset-password', methods=['POST'])
def reset_password():
    data = request.get_json()
    email = data.get('email')
    code = data.get('code')
    new_password = data.get('new_password')

    user = User.query.filter_by(email=email, reset_code=code).first()

    if not user:
        return jsonify({'message': 'Invalid code or email'}), 400

    hashed_password = bcrypt.generate_password_hash(new_password).decode('utf-8')
    user.password = hashed_password
    user.reset_code = None  # مسح كود الاستعادة بعد الاستخدام
    db.session.commit()

    return jsonify({'message': 'Password reset successfully'}), 200

# تشغيل التطبيق
if __name__ == '__main__':
    app.run(debug=True)
