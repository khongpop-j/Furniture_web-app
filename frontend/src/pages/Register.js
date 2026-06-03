import React, { useState } from 'react';
import axios from 'axios';
import { Link } from 'react-router-dom';
import './Register.css';

export default function Register() {
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [confirm, setConfirm] = useState('');
  const [accept, setAccept] = useState(false);
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);


  // field-level errors
  const [emailError, setEmailError] = useState('');
  const [phoneError, setPhoneError] = useState('');
  const [passwordError, setPasswordError] = useState('');
  const [confirmError, setConfirmError] = useState('');
  const [acceptError, setAcceptError] = useState('');
  const [apiError, setApiError] = useState(''); // สำรอง (เช่น อีเมลซ้ำ)

  const validateEmail = (v) =>
    /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(v).toLowerCase());

  // ไทย: เบอร์ขึ้นต้น 0 แล้วตามด้วย 8–9 ตัว (อนุโลมช่องว่าง/ขีด)
  const validatePhone = (v) =>
    v.trim() === '' || /^0\d{8,9}$/.test(v.replace(/[^0-9]/g, ''));

  const onSubmit = async (e) => {
    e.preventDefault();
    setEmailError('');
    setPhoneError('');
    setPasswordError('');
    setConfirmError('');
    setAcceptError('');
    setApiError('');

    // client validation
    let hasErr = false;

    if (!email) { setEmailError('กรุณากรอกอีเมล'); hasErr = true; }
    else if (!validateEmail(email)) { setEmailError('รูปแบบอีเมลไม่ถูกต้อง'); hasErr = true; }

    if (!validatePhone(phone)) { setPhoneError('รูปแบบเบอร์โทรไม่ถูกต้อง'); hasErr = true; }

    if (!password) { setPasswordError('กรุณากรอกรหัสผ่าน'); hasErr = true; }
    else if (password.length < 8) { setPasswordError('รหัสผ่านอย่างน้อย 8 ตัวอักษร'); hasErr = true; }

    if (!confirm) { setConfirmError('กรุณายืนยันรหัสผ่าน'); hasErr = true; }
    else if (password !== confirm) { setConfirmError('รหัสผ่านไม่ตรงกัน'); hasErr = true; }

    if (!accept) { setAcceptError('กรุณายอมรับเงื่อนไขการใช้งาน'); hasErr = true; }

    if (hasErr) return;

    setLoading(true);
    try {
      const name = `${firstName} ${lastName}`.trim();
      const res = await axios.post('http://localhost:5050/api/auth/register', {
        name, email, password, phone
      });
      localStorage.setItem('token', res.data.token);
      window.location.href = '/profile';
    } catch (err) {
      const msg = err?.response?.data?.message || 'สมัครสมาชิกไม่สำเร็จ';
      // ถ้าจาก backend แจ้งว่าอีเมลซ้ำ ฯลฯ ให้แสดงใต้ช่องอีเมล
      setEmailError(msg);
      setApiError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="register-page">
      <div className="register-container">
        {/* LEFT: big logo image */}
        <div className="register-left">
          <img className="logo-login" src="/images/logo-login-kaokai.png" alt="Kaokai Furniture" />
        </div>

        {/* RIGHT: form */}
        <div className="register-right">
          <h1>สมัครสมาชิก</h1>
          <form onSubmit={onSubmit} className="register-form">
            <label>ชื่อ - นามสกุล</label>
            <div className="name-row">
              <input
                type="text"
                placeholder="ชื่อ"
                value={firstName}
                onChange={(e) => {
                  // เอาตัวเลขออก (อนุญาตเฉพาะตัวอักษรไทย/อังกฤษและช่องว่าง)
                  const clean = e.target.value.replace(/[0-9]/g, '');
                  setFirstName(clean);
                }}
                required
                className={/[\d]/.test(firstName) ? 'is-invalid' : ''}
                aria-invalid={/[\d]/.test(firstName)}
              />

              <input
                type="text"
                placeholder="นามสกุล"
                value={lastName}
                onChange={(e) => {
                  const clean = e.target.value.replace(/[0-9]/g, '');
                  setLastName(clean);
                }}
                required
                className={/[\d]/.test(lastName) ? 'is-invalid' : ''}
                aria-invalid={/[\d]/.test(lastName)}
              />
            </div>


            <label>อีเมล์ผู้ใช้งาน</label>
            <input
              type="email" placeholder="อีเมล์ผู้ใช้งาน"
              value={email}
              onChange={(e) => {
                const v = e.target.value;
                setEmail(v);
                if (emailError && validateEmail(v)) setEmailError('');
              }}
              required
              className={emailError ? 'is-invalid' : ''}
              aria-invalid={!!emailError}
              aria-describedby={emailError ? 'email-err' : undefined}
            />
            {emailError && <p className="field-error" id="email-err" role="alert" aria-live="polite">{emailError}</p>}

            <label>เบอร์มือถือ</label>
            <input
              type="tel" placeholder="หมายเลขโทรศัพท์"
              value={phone}
              onChange={(e) => {
                const v = e.target.value;
                setPhone(v);
                if (phoneError && validatePhone(v)) setPhoneError('');
              }}
              className={phoneError ? 'is-invalid' : ''}
              aria-invalid={!!phoneError}
              aria-describedby={phoneError ? 'phone-err' : undefined}
            />
            {phoneError && <p className="field-error" id="phone-err" role="alert" aria-live="polite">{phoneError}</p>}

            <label>รหัสผ่าน</label>
            <input
              type={showPassword ? 'text' : 'password'}
              placeholder="อย่างน้อย 8 ตัวอักษร"
              value={password}
              onChange={(e) => {
                const v = e.target.value;
                setPassword(v);
                if (passwordError && v.length >= 8) setPasswordError('');
                if (confirm && confirmError && v === confirm) setConfirmError('');
              }}
              required
              className={passwordError ? 'is-invalid' : ''}
              aria-invalid={!!passwordError}
              aria-describedby={passwordError ? 'pwd-err' : undefined}
            />
            {passwordError && <p className="field-error" id="pwd-err" role="alert" aria-live="polite">{passwordError}</p>}

            <label>ยืนยันรหัสผ่าน</label>
            <input
              type={showPassword ? 'text' : 'password'}
              placeholder="พิมพ์รหัสผ่านอีกครั้ง"
              value={confirm}
              onChange={(e) => {
                const v = e.target.value;
                setConfirm(v);
                if (confirmError && v === password) setConfirmError('');
              }}
              required
              className={confirmError ? 'is-invalid' : ''}
              aria-invalid={!!confirmError}
              aria-describedby={confirmError ? 'confirm-err' : undefined}
            />
            {confirmError && <p className="field-error" id="confirm-err" role="alert" aria-live="polite">{confirmError}</p>}

            {/* Show password toggle */}
            <div className="show-password">
              <label>
                <input
                  type="checkbox"
                  checked={showPassword}
                  onChange={(e) => setShowPassword(e.target.checked)}
                />
                <span> แสดงรหัสผ่าน</span>
              </label>
            </div>

            <div className="terms">
              <label>
                <input
                  type="checkbox"
                  checked={accept}
                  onChange={(e) => { setAccept(e.target.checked); if (acceptError) setAcceptError(''); }}
                  aria-invalid={!!acceptError}
                  aria-describedby={acceptError ? 'terms-err' : undefined}
                />
                <span> ฉันได้อ่านและยอมรับ เงื่อนไขการใช้บริการ และ นโยบายความเป็นส่วนตัว</span>
              </label>
            </div>

            {acceptError && <p className="field-error" id="terms-err" role="alert" aria-live="polite">{acceptError}</p>}

            {/* เผื่อข้อความจาก backend ที่ไม่ผูกฟิลด์ใดฟิลด์หนึ่ง */}
            {apiError && <p className="field-error" role="alert" aria-live="polite">{apiError}</p>}

            <button type="submit" className="btn-register" disabled={loading}>
              {loading ? 'กำลังสมัคร...' : 'สมัครสมาชิก'}
            </button>

            <div className="login-note">
              หากคุณมีบัญชีอยู่แล้ว สามารถ <Link to="/login">เข้าสู่ระบบ</Link> ได้ที่นี่
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
