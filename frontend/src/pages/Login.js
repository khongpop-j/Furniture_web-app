import React, { useState } from 'react';
import axios from 'axios';
import './Login.css';

export default function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  // ใหม่: toggle แสดงรหัสผ่าน
  const [showPassword, setShowPassword] = useState(false);

  // แยก error ของแต่ละฟิลด์
  const [emailError, setEmailError] = useState('');
  const [passwordError, setPasswordError] = useState('');

  const validateEmail = (v) => {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(String(v).toLowerCase());
  };

  const onSubmit = async (e) => {
    e.preventDefault();
    setEmailError('');
    setPasswordError('');

    if (!email) { setEmailError('กรุณากรอกอีเมล'); return; }
    if (!validateEmail(email)) { setEmailError('รูปแบบอีเมลไม่ถูกต้อง'); return; }
    if (!password) { setPasswordError('กรุณากรอกรหัสผ่าน'); return; }

    setLoading(true);
    try {
      const res = await axios.post('http://localhost:5050/api/auth/login', { email, password });
      localStorage.setItem('token', res.data.token);
      window.location.href = '/profile';
    } catch (err) {
      const msg = err?.response?.data?.message || 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
      setEmailError(msg);
      setPasswordError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-page">
      <div className="login-container">
        <div className="login-left">
          <div className="brand-logo">
            <img
              className="photo-left"
              src="/images/logo-login-kaokai.png"
              alt="KaoKai Furniture"
              loading="eager"
              decoding="async"
            />
          </div>
        </div>

        <div className="login-right">
          <h1>เข้าสู่ระบบ</h1>

          <form onSubmit={onSubmit} className="login-form">
            {/* Email */}
            <label>อีเมล์ผู้ใช้งาน</label>
            <input
              type="email"
              placeholder="อีเมล์ผู้ใช้งาน"
              value={email}
              onChange={(e) => {
                const v = e.target.value;
                setEmail(v);
                if (emailError && validateEmail(v)) setEmailError('');
              }}
              required
              className={emailError ? 'is-invalid' : ''}
              aria-invalid={!!emailError}
              aria-describedby={emailError ? 'email-error' : undefined}
            />
            {emailError && (
              <p className="field-error" id="email-error" role="alert" aria-live="polite">
                {emailError}
              </p>
            )}

            {/* Password */}
            <label>รหัสผ่าน</label>
            <input
              type={showPassword ? 'text' : 'password'}
              placeholder="ระบุรหัสผ่าน ( อย่างน้อย8ตัวอักษร )"
              value={password}
              onChange={(e) => {
                setPassword(e.target.value);
                if (passwordError) setPasswordError('');
              }}
              required
              className={passwordError ? 'is-invalid' : ''}
              aria-invalid={!!passwordError}
              aria-describedby={passwordError ? 'password-error' : undefined}
            />
            {passwordError && (
              <p className="field-error" id="password-error" role="alert" aria-live="polite">
                {passwordError}
              </p>
            )}

            {/* แถวเดียว: ซ้าย = แสดงรหัสผ่าน / ขวา = ลืมรหัสผ่าน */}
            <div className="login-utils">
              <label className="showpass">
                <input
                  type="checkbox"
                  checked={showPassword}
                  onChange={(e) => setShowPassword(e.target.checked)}
                />
                <span>แสดงรหัสผ่าน</span>
              </label>

              <a className="forgot-link" href="/forgot-password">ลืมรหัสผ่าน?</a>
            </div>

            <button className="btn-login" type="submit" disabled={loading}>
              {loading ? 'กำลังเข้าสู่ระบบ...' : 'เข้าสู่ระบบ'}
            </button>

            <div className="signup-note">
              หากคุณยังไม่มีบัญชีสามารถ <a href="/register">สมัครสมาชิก</a> ได้ที่นี่
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
