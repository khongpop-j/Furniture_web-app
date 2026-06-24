import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import './Profile.css';
import API_URL from '../config';

const Profile = () => {
  const navigate = useNavigate();
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [isEditing, setIsEditing] = useState(false);
  const [activeTab, setActiveTab] = useState('personal');


  const [formData, setFormData] = useState({
    email: '',
    firstName: '',
    lastName: '',
    phone: '',
    nickname: '',
    gender: '',
  });

  const [addressData, setAddressData] = useState({
    address: '',
    district: '',
    amphoe: '',
    province: '',
    postalCode: ''
  });

  const [provinceSearch, setProvinceSearch] = useState('');
  const [showProvinceDropdown, setShowProvinceDropdown] = useState(false);
  const [phoneError, setPhoneError] = useState('');
  const [orders, setOrders] = useState([]);
  const [favorites, setFavorites] = useState([]);
  const hasToken = !!localStorage.getItem('token');

  // จังหวัด 77 จังหวัด
  const provinces = [
    'กรุงเทพมหานคร', 'กระบี่', 'กาญจนบุรี', 'กาฬสินธุ์', 'กำแพงเพชร', 'ขอนแก่น', 'จันทบุรี', 'ฉะเชิงเทรา',
    'ชลบุรี', 'ชัยนาท', 'ชัยภูมิ', 'ชุมพร', 'เชียงราย', 'เชียงใหม่', 'ตรัง', 'ตราด', 'ตาก', 'นครนายก',
    'นครปฐม', 'นครพนม', 'นครราชสีมา', 'นครศรีธรรมราช', 'นครสวรรค์', 'นนทบุรี', 'นราธิวาส', 'น่าน',
    'บึงกาฬ', 'บุรีรัมย์', 'ปทุมธานี', 'ประจวบคีรีขันธ์', 'ปราจีนบุรี', 'ปัตตานี', 'พระนครศรีอยุธยา',
    'พะเยา', 'พังงา', 'พัทลุง', 'พิจิตร', 'พิษณุโลก', 'เพชรบุรี', 'เพชรบูรณ์', 'แพร่', 'ภูเก็ต', 'มหาสารคาม',
    'มุกดาหาร', 'แม่ฮ่องสอน', 'ยะลา', 'ยโสธร', 'ร้อยเอ็ด', 'ระนอง', 'ระยอง', 'ราชบุรี', 'ลพบุรี', 'ลำปาง',
    'ลำพูน', 'เลย', 'ศรีสะเกษ', 'สกลนคร', 'สงขลา', 'สตูล', 'สมุทรปราการ', 'สมุทรสงคราม', 'สมุทรสาคร',
    'สระแก้ว', 'สระบุรี', 'สิงห์บุรี', 'สุโขทัย', 'สุพรรณบุรี', 'สุราษฎร์ธานี', 'สุรินทร์', 'หนองคาย',
    'หนองบัวลำภู', 'อ่างทอง', 'อำนาจเจริญ', 'อุดรธานี', 'อุตรดิตถ์', 'อุทัยธานี', 'อุบลราชธานี'
  ];

  const handleLogout = () => {
    localStorage.removeItem('token');
    window.location.href = '/';
  };

  useEffect(() => {
    if (!hasToken) {
      const mockUser = {
        id: 1,
        name: 'ก้องภพ สัตบุษ',
        email: 'david.b@gmail.com',
        phone: 'ไม่ระบุ',
        address: 'ไม่ระบุ',
        nickname: 'ไม่ระบุ',
        gender: 'ไม่ระบุ',
        district: 'ไม่ระบุ',
        province: 'ไม่ระบุ',
        postalCode: 'ไม่ระบุ'
      };
      setUser(mockUser);
      setFormData({
        firstName: 'เดวิด',
        lastName: 'เบ็คแฮม',
        email: 'david.b@gmail.com',
        phone: '0802291345',
        nickname: '',
        gender: 'ชาย'
      });
      setAddressData({
        address: 'ไม่ระบุ',
        district: 'ไม่ระบุ',
        amphoe: '',
        province: 'ไม่ระบุ',
        postalCode: 'ไม่ระบุ'
      });
      setProvinceSearch('ไม่ระบุ');
      setLoading(false);
      return;
    }

    const fetchUser = async () => {
      try {
        const token = localStorage.getItem('token');
        const response = await axios.get(`${API_URL}/api/auth/me`, {
          headers: { Authorization: `Bearer ${token}` },
          timeout: 3000
        });

        if (response.data) {
          setUser(response.data);
          const nameParts = (response.data.name || '').split(' ');
          setFormData({
            firstName: nameParts[0] || '',
            lastName: nameParts.slice(1).join(' ') || '',
            email: response.data.email || '',
            phone: response.data.phone || '',
            nickname: response.data.nickname || '',
            gender: response.data.gender || ''
          });
          setAddressData({
            address: response.data.address || '',
            district: response.data.district || '',
            amphoe: response.data.amphoe || '',
            province: response.data.province || '',
            postalCode: response.data.postalCode || ''
          });
          setProvinceSearch(response.data.province || '');
        } else {
          setUser(null);
        }
      } catch (error) {
        console.error('Error fetching user:', error);
        const mockUser = {
          id: 1,
          name: 'nattapat Klu',
          email: 'test1@gmail.com',
          phone: 'ไม่ระบุ',
          address: 'ไม่ระบุ',
          nickname: 'ไม่ระบุ',
          gender: 'ไม่ระบุ',
          district: 'ไม่ระบุ',
          province: 'ไม่ระบุ',
          postalCode: 'ไม่ระบุ'
        };
        setUser(mockUser);
        setFormData({
          firstName: 'เดวิด',
          lastName: 'เบ็คแฮม',
          email: 'david.b@gmail.com',
          phone: '0802291345',
          nickname: '',
          gender: 'ชาย'
        });
        setAddressData({
          address: 'ไม่ระบุ',
          district: 'ไม่ระบุ',
          amphoe: '',
          province: 'ไม่ระบุ',
          postalCode: 'ไม่ระบุ'
        });
        setProvinceSearch('ไม่ระบุ');
      } finally {
        setLoading(false);
      }
    };

    fetchUser();
  }, [hasToken]);

  // ฟอร์มข้อมูลส่วนตัว
  const handleInputChange = (e) => {
    const { name, value } = e.target;

    if (name === 'phone') {
      const numericValue = value.replace(/[^0-9]/g, '').slice(0, 10);
      setFormData(prev => ({ ...prev, phone: numericValue }));
      if (numericValue.length > 0 && numericValue.length !== 10) setPhoneError('เบอร์โทรศัพท์ต้องมี 10 หลัก');
      else setPhoneError('');
      return;
    }

    setFormData(prev => ({ ...prev, [name]: value }));
  };

  // ฟอร์มที่อยู่
  const handleAddressChange = (e) => {
    const { name, value } = e.target;

    if (name === 'postalCode') {
      // เก็บเฉพาะตัวเลข และจำกัดความยาว 5 หลัก
      const digitsOnly = value.replace(/\D/g, '').slice(0, 5);
      setAddressData(prev => ({ ...prev, postalCode: digitsOnly }));
      return; // ไม่แสดง error ใด ๆ
    }

    // ช่องอื่น ๆ เก็บตามที่พิมพ์ (ตัวอักษร/ตัวเลขได้ปกติ)
    setAddressData(prev => ({ ...prev, [name]: value }));
  };

  const handleProvinceSearch = (e) => {
    setProvinceSearch(e.target.value);
    setShowProvinceDropdown(true);
  };

  const handleProvinceSelect = (province) => {
    setAddressData(prev => ({ ...prev, province }));
    setProvinceSearch(province);
    setShowProvinceDropdown(false);
  };

  const filteredProvinces = provinces.filter(province =>
    province.toLowerCase().includes(provinceSearch.toLowerCase())
  );

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (!event.target.closest('.province-dropdown')) setShowProvinceDropdown(false);
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (formData.phone && formData.phone.length !== 10) {
      setPhoneError('เบอร์โทรศัพท์ต้องมี 10 หลัก');
      return;
    }

    try {
      const token = localStorage.getItem('token');
      if (token) {
        const response = await axios.put(`${API_URL}/api/user`, {
          name: `${formData.firstName} ${formData.lastName}`.trim(),
          email: formData.email,
          phone: formData.phone,
          nickname: formData.nickname,
          gender: formData.gender,
          address: addressData.address,
          district: addressData.district,
          province: addressData.province,
          postalCode: addressData.postalCode
        }, { headers: { Authorization: `Bearer ${token}` } });

        if (response.data) {
          setUser(prev => ({
            ...prev,
            name: response.data.name,
            email: response.data.email,
            phone: response.data.phone,
            nickname: response.data.nickname,
            gender: response.data.gender,
            address: response.data.address
          }));
          setFormData(prev => ({ ...prev }));
        }
        alert('บันทึกข้อมูลส่วนตัวสำเร็จ');
      } else {
        const mockAddress = [addressData.address, addressData.district, addressData.province, addressData.postalCode]
          .filter(Boolean).join(', ');
        setUser(prev => ({
          ...prev,
          name: `${formData.firstName} ${formData.lastName}`.trim(),
          email: formData.email,
          phone: formData.phone,
          nickname: formData.nickname,
          gender: formData.gender,
          address: mockAddress
        }));
        setFormData(prev => ({ ...prev }));
        alert('บันทึกข้อมูลส่วนตัวสำเร็จ (Demo Mode)');
      }
    } catch (error) {
      console.error('Error saving profile:', error);
      alert('เกิดข้อผิดพลาดในการบันทึกข้อมูล');
    }
    setIsEditing(false);
  };

  const handleSaveAddress = async () => {
    // บังคับให้ต้องเป็น 5 หลัก แต่ไม่แสดง error ใต้ช่อง
    if (addressData.postalCode && addressData.postalCode.length !== 5) {
      alert('รหัสไปรษณีย์ต้องมี 5 หลัก');
      return;
    }

    try {
      const token = localStorage.getItem('token');
      if (token) {
        const response = await axios.put(`${API_URL}/api/user`, {
          address: addressData.address,
          district: addressData.district,
          amphoe: addressData.amphoe,
          province: addressData.province,
          postalCode: addressData.postalCode
        }, { headers: { Authorization: `Bearer ${token}` } });

        if (response.data) {
          setUser(prev => ({
            ...prev,
            address: response.data.address,
            district: response.data.district,
            amphoe: response.data.amphoe,
            province: response.data.province,
            postalCode: response.data.postalCode
          }));
          setAddressData(prev => ({ ...prev }));
          setProvinceSearch(addressData.province);
        }
        alert('บันทึกที่อยู่สำเร็จ');
      } else {
        setUser(prev => ({
          ...prev,
          address: addressData.address,
          district: addressData.district,
          amphoe: addressData.amphoe,
          province: addressData.province,
          postalCode: addressData.postalCode
        }));
        setAddressData(prev => ({ ...prev }));
        setProvinceSearch(addressData.province);
        alert('บันทึกที่อยู่สำเร็จ (Demo Mode)');
      }
    } catch (error) {
      console.error('Error saving address:', error);
      alert('เกิดข้อผิดพลาดในการบันทึกที่อยู่');
    }
  };

  const fetchFavorites = async () => {
    try {
      const token = localStorage.getItem('token');
      const response = await axios.get(`${API_URL}/api/favorites`, {
        headers: { Authorization: `Bearer ${token}` },
        timeout: 3000
      });
      setFavorites(response.data);
    } catch (error) {
      console.error('Error fetching favorites:', error);
      setFavorites([]);
    }
  };

  const fetchOrders = async () => {
    try {
      const token = localStorage.getItem('token');
      const response = await axios.get(`${API_URL}/api/orders`, {
        headers: { Authorization: `Bearer ${token}` },
        timeout: 3000
      });
      setOrders(response.data);
    } catch (error) {
      console.error('Error fetching orders:', error);
      setOrders([]);
    }
  };

  useEffect(() => {
    if (activeTab === 'favorites') {
      fetchFavorites();
    } else if (activeTab === 'orders') {
      fetchOrders();
    } else if (activeTab === 'personal' || activeTab === 'address') {
      fetchUserData();
    }
  }, [activeTab]);

  const fetchUserData = async () => {
    try {
      const token = localStorage.getItem('token');
      if (token) {
        const response = await axios.get(`${API_URL}/api/auth/me`, {
          headers: { Authorization: `Bearer ${token}` },
          timeout: 3000
        });

        if (response.data) {
          setUser(response.data);
          const nameParts = (response.data.name || '').split(' ');
          setFormData({
            firstName: nameParts[0] || '',
            lastName: nameParts.slice(1).join(' ') || '',
            email: response.data.email || '',
            phone: response.data.phone || '',
            nickname: response.data.nickname || '',
            gender: response.data.gender || ''
          });
          setAddressData({
            address: response.data.address || '',
            district: response.data.district || '',
            amphoe: response.data.amphoe || '',
            province: response.data.province || '',
            postalCode: response.data.postalCode || ''
          });
          setProvinceSearch(response.data.province || '');
        }
      }
    } catch (error) {
      console.error('Error fetching user data:', error);
    }
  };

  const renderContent = () => {
    switch (activeTab) {
      case 'personal':
        return (
          <div className="content-section">
            <h2>ข้อมูลส่วนตัว</h2>
            {isEditing ? (
              <form onSubmit={handleSubmit} className="profile-form">
                <div className="form-row">
                  <div className="form-group">
                    <label>อีเมล์</label>
                    <input
                      type="email"
                      name="email"
                      value={formData.email}
                      readOnly
                      className="readonly-input"
                    />
                  </div>
                </div>
                <div className="form-row">
                  <div className="form-group">
                    <label>ชื่อ</label>
                    <input
                      type="text"
                      name="firstName"
                      value={formData.firstName}
                      onChange={handleInputChange}
                      required
                    />
                  </div>
                  <div className="form-group">
                    <label>นามสกุล</label>
                    <input
                      type="text"
                      name="lastName"
                      value={formData.lastName}
                      onChange={handleInputChange}
                      required
                    />
                  </div>
                </div>
                <div className="form-row">
                  <div className="form-group">
                    <label>เบอร์มือถือ</label>
                    <input
                      type="tel"
                      name="phone"
                      value={formData.phone}
                      onChange={handleInputChange}
                      placeholder="เบอร์โทรศัพท์ 10 หลัก"
                      maxLength="10"
                      className={phoneError ? 'error' : ''}
                    />
                    {phoneError && <div className="error-message">{phoneError}</div>}
                  </div>
                </div>
                <div className="form-row">
                  <div className="form-group">
                    <label>ชื่อเล่น</label>
                    <input
                      type="text"
                      name="nickname"
                      value={formData.nickname}
                      onChange={handleInputChange}
                      placeholder="ไม่บังคับ"
                    />
                  </div>
                </div>
                <div className="form-row">
                  <div className="form-group">
                    <label>เพศ</label>
                    <select
                      name="gender"
                      value={formData.gender}
                      onChange={handleInputChange}
                    >
                      <option value="">เลือกเพศ</option>
                      <option value="ชาย">ชาย</option>
                      <option value="หญิง">หญิง</option>
                      <option value="อื่นๆ">อื่นๆ</option>
                    </select>
                  </div>
                </div>
                <div className="form-actions">
                  <button type="submit" className="btn-save">บันทึก</button>
                </div>
              </form>
            ) : (
              <div className="profile-info-display">
                <div className="info-item">
                  <span className="label">อีเมล์:</span>
                  <span className="value">{formData.email}</span>
                </div>
                <div className="info-item">
                  <span className="label">ชื่อ - นามสกุล:</span>
                  <span className="value">{`${formData.firstName} ${formData.lastName}`.trim() || 'ไม่ระบุ'}</span>
                </div>
                <div className="info-item">
                  <span className="label">เบอร์โทรศัพท์:</span>
                  <span className="value">{formData.phone || 'ไม่ระบุ'}</span>
                </div>
                <div className="info-item">
                  <span className="label">ชื่อเล่น:</span>
                  <span className="value">{formData.nickname || 'ไม่ระบุ'}</span>
                </div>
                <div className="info-item">
                  <span className="label">เพศ:</span>
                  <span className="value">{formData.gender || 'ไม่ระบุ'}</span>
                </div>
              </div>
            )}
          </div>
        );

      case 'address':
        return (
          <div className="content-section">
            <h2>ที่อยู่ของฉัน</h2>
            <form className="profile-form">
              <div className="form-row">
                <div className="form-group full-width">
                  <label>ที่อยู่</label>
                  <textarea
                    name="address"
                    value={addressData.address}
                    onChange={handleAddressChange}
                    rows="3"
                    placeholder="กรอกที่อยู่"
                  />
                </div>
              </div>
              <div className="form-row">
                <div className="form-group">
                  <label>ตำบล/แขวง</label>
                  <input
                    type="text"
                    name="district"
                    value={addressData.district}
                    onChange={handleAddressChange}
                    placeholder="ตำบล/แขวง"
                  />
                </div>
                <div className="form-group">
                  <label>อำเภอ/เขต</label>
                  <input
                    type="text"
                    name="amphoe"
                    value={addressData.amphoe}
                    onChange={handleAddressChange}
                    placeholder="อำเภอ/เขต"
                  />
                </div>
                <div className="form-group">
                  <label>จังหวัด</label>
                  <div className="province-dropdown">
                    <input
                      type="text"
                      name="province"
                      value={provinceSearch}
                      onChange={handleProvinceSearch}
                      onFocus={() => setShowProvinceDropdown(true)}
                      placeholder="ค้นหาจังหวัด..."
                      className="province-input"
                    />
                    {showProvinceDropdown && (
                      <div className="province-dropdown-list">
                        {filteredProvinces.map((province, index) => (
                          <div
                            key={index}
                            className="province-option"
                            onClick={() => handleProvinceSelect(province)}
                          >
                            {province}
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                </div>
              </div>
              <div className="form-row">
                <div className="form-group">
                  <label>รหัสไปรษณีย์</label>
                  <input
                    type="text"
                    name="postalCode"
                    value={addressData.postalCode}
                    onChange={handleAddressChange}
                    placeholder="รหัสไปรษณีย์ 5 หลัก"
                    inputMode="numeric"
                    pattern="\d{5}"
                    maxLength={5}
                  />
                </div>
              </div>
              <div className="form-actions">
                <button type="button" className="btn-save" onClick={handleSaveAddress}>
                  บันทึกที่อยู่
                </button>
              </div>
            </form>
          </div>
        );

      case 'orders':
        // ===== Helpers =====
        const fmtTHB = (n) =>
          Number(n || 0).toLocaleString('th-TH', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

        const fmtDate = (d) => {
          try {
            return new Date(d).toLocaleDateString('en-US', {
              month: 'short', day: '2-digit', year: 'numeric'
            });
          } catch {
            return '-';
          }
        };

        const statusClass = (s) => {
          const k = String(s || 'PENDING').toUpperCase();
          if (k === 'COMPLETED' || k === 'PAID') return 'is-completed';
          if (k === 'SHIPPED' || k === 'DELIVERED') return 'is-shipped';
          if (k === 'CANCELLED') return 'is-cancelled';
          return 'is-pending';
        };

        return (
          <div className="content-section">
            <h2>คำสั่งซื้อ</h2>

            <div className="orders-table">
              {/* head */}
              <div className="orders-head">
                <div className="col col-order">คำสั่งซื้อ</div>
                <div className="col col-date">วันที่</div>
                <div className="col col-status">สถานะ</div>
                <div className="col col-amount">ยอดรวม</div>
                <div className="col col-action">จัดการ</div>
              </div>

              {orders.length > 0 ? (
                orders.map((order, i) => (
                  <div key={i} className="orders-row">
                    <div className="col col-order">
                      <div className="order-title">Order #{order.id}</div>
                      {/* ถ้ามีอีเมลผู้สั่ง ซื้อหรือชื่อ เพิ่มบรรทัดนี้ได้ */}
                      {/* <div className="order-sub">{user?.email}</div> */}
                    </div>

                    <div className="col col-date">{fmtDate(order.createdAt)}</div>

                    <div className="col col-status">
                      <span className={`status-badge ${statusClass(order.status)}`}>
                        {String(order.status || 'PENDING')}
                      </span>
                    </div>

                    <div className="col col-amount">{order.total > 0 ? `฿${fmtTHB(order.total)}` : 'Free'}</div>

                    <div className="col col-action">
                      <button
                        className="link-action"
                        onClick={() => navigate(`/order/${order.id}`)}
                      >
                        ดูรายละเอียด
                      </button>
                    </div>
                  </div>
                ))
              ) : (
                <div className="orders-empty">
                  ยังไม่มีคำสั่งซื้อ
                </div>
              )}
            </div>
          </div>
        );


      case 'favorites':
        const getProductImage = (product) => {
          if (product.model) return `/images/products/${product.model}.jpg`;
          return '/images/NoImage.png';
        };

        return (
          <div className="content-section">
            <h2>รายการโปรด</h2>
            <div className="favorites-grid">
              {favorites.length > 0 ? (
                favorites.map((favorite, index) => {
                  const p = favorite.product || {};
                  const productId = p.id ?? p.product_id ?? favorite.product_id;
                  const imgUrl = getProductImage(p);
                  const price = Number(p.price ?? 0).toLocaleString('th-TH', {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                  });

                  return (
                    <div
                      key={index}
                      className="favorite-card"
                      role="button"
                      tabIndex={0}
                      onClick={() => navigate(`/product/${productId}`)}
                      onKeyDown={(e) => {
                        if (e.key === 'Enter' || e.key === ' ') navigate(`/product/${productId}`);
                      }}
                    >
                      <div className="favorite-thumb">
                        <img src={imgUrl} alt={p.name || 'product'} />
                      </div>
                      <div className="favorite-info">
                        <div className="favorite-title">{p.name || 'ไม่ระบุชื่อสินค้า'}</div>
                        {p.model && <div className="favorite-code">{p.model}</div>}
                        <div className="favorite-price">{price} ฿ THB</div>
                      </div>
                    </div>
                  );
                })
              ) : (
                <div className="empty-state">
                  <p>ยังไม่มีรายการโปรด</p>
                </div>
              )}
            </div>
          </div>
        );

      default:
        return null;
    }
  };

  if (loading) {
    return (
      <div className="profile-page">
        <div className="profile-container">
          {/* sidebar + skeleton simplified */}
          <div className="profile-sidebar">
            <div className="user-info">
              <div className="user-avatar"><i className="fas fa-user"></i></div>
              <h3>ก้องภพ สัตบุษ</h3>
            </div>
            <nav className="profile-nav">
              <button className={`nav-item ${activeTab === 'personal' ? 'active' : ''}`} onClick={() => setActiveTab('personal')}>ข้อมูลส่วนตัว</button>
              <button className={`nav-item ${activeTab === 'address' ? 'active' : ''}`} onClick={() => setActiveTab('address')}>ที่อยู่ของฉัน</button>
              <button className={`nav-item ${activeTab === 'orders' ? 'active' : ''}`} onClick={() => setActiveTab('orders')}>คำสั่งซื้อ</button>
              <button className={`nav-item ${activeTab === 'favorites' ? 'active' : ''}`} onClick={() => setActiveTab('favorites')}>รายการโปรด</button>
            </nav>
            <div className="sidebar-actions">
              {activeTab === 'personal' && (
                <button className="btn-edit" onClick={() => setIsEditing(!isEditing)}>
                  {isEditing ? 'ยกเลิก' : 'แก้ไข'}
                </button>
              )}
              <button className="btn-logout" onClick={handleLogout}>ออกจากระบบ</button>
            </div>
          </div>
          <div className="profile-main">{renderContent()}</div>
        </div>
      </div>
    );
  }

  if (!hasToken || !user) {
    return (
      <div className="profile-page">
        <div className="profile-container">
          <div className="profile-sidebar">
            <div className="user-info">
              <div className="user-avatar"><i className="fas fa-user"></i></div>
              <h3>ก้องภพ สัตบุษ</h3>
            </div>
            <nav className="profile-nav">
              <button className={`nav-item ${activeTab === 'personal' ? 'active' : ''}`} onClick={() => setActiveTab('personal')}>ข้อมูลส่วนตัว</button>
              <button className={`nav-item ${activeTab === 'address' ? 'active' : ''}`} onClick={() => setActiveTab('address')}>ที่อยู่ของฉัน</button>
              <button className={`nav-item ${activeTab === 'orders' ? 'active' : ''}`} onClick={() => setActiveTab('orders')}>คำสั่งซื้อ</button>
              <button className={`nav-item ${activeTab === 'favorites' ? 'active' : ''}`} onClick={() => setActiveTab('favorites')}>รายการโปรด</button>
            </nav>
            <div className="sidebar-actions">
              {activeTab === 'personal' && (
                <button className="btn-edit" onClick={() => setIsEditing(!isEditing)}>
                  {isEditing ? 'ยกเลิก' : 'แก้ไข'}
                </button>
              )}
              <button className="btn-logout" onClick={handleLogout}>ออกจากระบบ</button>
            </div>
          </div>
          <div className="profile-main">{renderContent()}</div>
        </div>
      </div>
    );
  }

  return (
    <div className="profile-page">
      <div className="profile-container">
        <div className="profile-sidebar">
          <div className="user-info">
            <div className="user-avatar"><i className="fas fa-user"></i></div>
            <h3>{user?.name || 'ไม่ระบุชื่อ'}</h3>
          </div>
          <nav className="profile-nav">
            <button className={`nav-item ${activeTab === 'personal' ? 'active' : ''}`} onClick={() => setActiveTab('personal')}>ข้อมูลส่วนตัว</button>
            <button className={`nav-item ${activeTab === 'address' ? 'active' : ''}`} onClick={() => setActiveTab('address')}>ที่อยู่ของฉัน</button>
            <button className={`nav-item ${activeTab === 'orders' ? 'active' : ''}`} onClick={() => setActiveTab('orders')}>คำสั่งซื้อ</button>
            <button className={`nav-item ${activeTab === 'favorites' ? 'active' : ''}`} onClick={() => setActiveTab('favorites')}>รายการโปรด</button>
          </nav>
          <div className="sidebar-actions">
            {activeTab === 'personal' && (
              <button className="btn-edit" onClick={() => setIsEditing(!isEditing)}>
                {isEditing ? 'ยกเลิก' : 'แก้ไข'}
              </button>
            )}
            <button className="btn-logout" onClick={handleLogout}>ออกจากระบบ</button>
          </div>
        </div>
        <div className="profile-main">{renderContent()}</div>
      </div>
    </div>
  );
};

export default Profile;
