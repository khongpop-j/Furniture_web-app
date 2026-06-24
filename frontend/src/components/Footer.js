import React from 'react';
import { Link } from 'react-router-dom';
import './Footer.css';

const Footer = () => {
  return (
    <footer className="footer">
      <div className="container">
        <div className="footer-content">
          {/* BRAND + CONTACT */}
          <div className="footer-section">
            <Link to="/" className="footer-logo" aria-label="Kaokai Office Furniture - home">
              <img
                src="/images/kaokai-logo-footer.png"        // ไฟล์อยู่ใน public
                alt="Kaokai Office Furniture"
                className="footer-logo-img"
              />
            </Link>



          </div>

          {/* HELP */}
          <div className="footer-section">
            <h3>ช่วยเหลือ</h3>
            <ul>
              <li><Link to="/contact">ติดต่อเรา</Link></li>
            </ul>
          </div>

          {/* ABOUT */}
          <div className="footer-section">
            <h3>เกี่ยวกับเรา</h3>
            <ul>
              <li><Link to="/about">เกี่ยวกับเรา</Link></li>
              <li><Link to="/contact">ติดต่อเรา</Link></li>
            </ul>
          </div>
        </div>

        {/* หมายเหตุ: ซ่อนส่วนล่างเพื่อให้เหมือนภาพตัวอย่าง */}
        <div className="footer-bottom" aria-hidden="true">
          <p>&copy; 2024 KaokaiOfficeFurniture. สงวนลิขสิทธิ์.</p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
