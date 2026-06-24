import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import './Cart.css';
import API_URL from '../config';

const Cart = () => {
  const navigate = useNavigate();
  const [cartItems, setCartItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [paymentModalOpen, setPaymentModalOpen] = useState(false);
  const [paymentInfo, setPaymentInfo] = useState(null); // { paymentIntentId, qrPng, status }
  const [paymentStatus, setPaymentStatus] = useState('requires_payment_method');
  const [pollTimer, setPollTimer] = useState(null);

  useEffect(() => {
    const fetchCart = async () => {
      try {
        const token = localStorage.getItem('token');
        if (!token) {
          setLoading(false);
          return;
        }

        const response = await axios.get(`${API_URL}/api/cart`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        setCartItems(response.data);
      } catch (error) {
        console.error('Error fetching cart:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchCart();
  }, []);

  const updateQuantity = async (cartItemId, newQuantity) => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return;

      // Find the cart item to get productId
      const cartItem = cartItems.find(item => item.id === cartItemId);
      if (!cartItem) return;

      if (newQuantity < 1) {
        await axios.delete(`${API_URL}/api/cart/${cartItem.productId}`, {
          headers: { Authorization: `Bearer ${token}` }
        });
      } else {
        // ตรวจสอบ stock ก่อนอัปเดต
        if (cartItem.product.stock && newQuantity > cartItem.product.stock) {
          alert(`สินค้าเหลือเพียง ${cartItem.product.stock} ชิ้น`);
          return;
        }

        await axios.put(`${API_URL}/api/cart/${cartItem.productId}`, 
          { quantity: newQuantity },
          { headers: { Authorization: `Bearer ${token}` } }
        );
      }
      const response = await axios.get(`${API_URL}/api/cart`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      setCartItems(response.data);
      
      // ส่ง event เพื่ออัพเดทจำนวนสินค้าใน Header
      window.dispatchEvent(new CustomEvent('cartUpdated'));
    } catch (e) {
      console.error('Error updating cart quantity:', e);
      // แสดงข้อความ error จาก server
      if (e.response && e.response.data && e.response.data.message) {
        alert(e.response.data.message);
      }
    }
  };

  const removeItem = async (cartItemId) => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return;

      // Find the cart item to get productId
      const cartItem = cartItems.find(item => item.id === cartItemId);
      if (!cartItem) return;

      await axios.delete(`${API_URL}/api/cart/${cartItem.productId}`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      const response = await axios.get(`${API_URL}/api/cart`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      setCartItems(response.data);
      
      // ส่ง event เพื่ออัพเดทจำนวนสินค้าใน Header
      window.dispatchEvent(new CustomEvent('cartUpdated'));
    } catch (e) {
      console.error('Error removing item from cart:', e);
    }
  };

  const calculateTotal = () => {
    return cartItems.reduce((total, item) => total + (item.product.price * item.quantity), 0);
  };

  const getTotalItems = () => {
    return cartItems.reduce((total, item) => total + item.quantity, 0);
  };

  const printQuotation = async () => {
    const printWindow = window.open('', '_blank');
    const currentDate = new Date().toLocaleDateString('th-TH');
    const quotationNumber = 'QT-' + Date.now().toString().slice(-6);
    
    // ดึงข้อมูลผู้ใช้ที่ล็อกอินอยู่
    let userData = null;
    try {
      const token = localStorage.getItem('token');
      if (token) {
        const response = await axios.get(`${API_URL}/api/auth/me`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        userData = response.data;
      }
    } catch (error) {
      console.error('Error fetching user data:', error);
    }
    
    const quotationHTML = `
      <!DOCTYPE html>
      <html lang="th">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>ใบเสนอราคา - ${quotationNumber}</title>
        <style>
          body {
            font-family: 'Sarabun', Arial, sans-serif;
            margin: 0;
            padding: 20px;
            color: #333;
          }
          .quotation-header {
            text-align: center;
            border-bottom: 2px solid #2c3e50;
            padding-bottom: 20px;
            margin-bottom: 30px;
          }
          .company-name {
            font-size: 24px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
          }
          .quotation-title {
            font-size: 20px;
            color: #34495e;
            margin-bottom: 10px;
          }
          .quotation-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
          }
          .info-section {
            flex: 1;
          }
          .info-section h3 {
            margin: 0 0 10px 0;
            color: #2c3e50;
            font-size: 16px;
          }
          .info-section p {
            margin: 5px 0;
            font-size: 14px;
          }
          table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
          }
          th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
          }
          th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #2c3e50;
          }
          .total-section {
            text-align: right;
            margin-top: 20px;
          }
          .total-row {
            font-size: 16px;
            font-weight: bold;
            color: #2c3e50;
            padding: 10px 0;
          }
          .grand-total {
            font-size: 18px;
            font-weight: bold;
            color: #e74c3c;
            border-top: 2px solid #2c3e50;
            padding-top: 10px;
          }
          .terms {
            margin-top: 40px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 5px;
          }
          .terms h3 {
            color: #2c3e50;
            margin-bottom: 10px;
          }
          .terms ul {
            margin: 0;
            padding-left: 20px;
          }
          .terms li {
            margin-bottom: 5px;
            font-size: 14px;
          }
          @media print {
            body { margin: 0; }
            .no-print { display: none; }
          }
        </style>
      </head>
      <body>
        <div class="quotation-header">
          <div class="company-name">บริษัท เฟอร์นิเจอร์ออฟฟิศ จำกัด</div>
          <div class="quotation-title">ใบเสนอราคา (Quotation)</div>
        </div>
        
        <div class="quotation-info">
          <div class="info-section">
            <h3>ข้อมูลบริษัท</h3>
            <p>ที่อยู่: 123 ถนนสุขุมวิท แขวงคลองเตย เขตคลองเตย กรุงเทพฯ 10110</p>
            <p>โทร: 02-123-4567</p>
            <p>อีเมล: info@furniture-office.com</p>
          </div>
          <div class="info-section">
            <h3>ข้อมูลลูกค้า</h3>
            <p><strong>ชื่อ:</strong> ${userData ? userData.name : 'ไม่ระบุ'}</p>
            <p><strong>อีเมล:</strong> ${userData ? userData.email : 'ไม่ระบุ'}</p>
            <p><strong>โทรศัพท์:</strong> ${userData ? userData.phone || 'ไม่ระบุ' : 'ไม่ระบุ'}</p>
            <p><strong>ที่อยู่:</strong> ${userData ? userData.address || 'ไม่ระบุ' : 'ไม่ระบุ'}</p>
          </div>
          <div class="info-section">
            <h3>ข้อมูลใบเสนอราคา</h3>
            <p><strong>เลขที่:</strong> ${quotationNumber}</p>
            <p><strong>วันที่:</strong> ${currentDate}</p>
            <p><strong>วันหมดอายุ:</strong> ${new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toLocaleDateString('th-TH')}</p>
          </div>
        </div>
        
        <table>
          <thead>
            <tr>
              <th>ลำดับ</th>
              <th>รายการสินค้า</th>
              <th>รุ่น</th>
              <th>จำนวน</th>
              <th>ราคาต่อหน่วย</th>
              <th>ราคารวม</th>
            </tr>
          </thead>
          <tbody>
            ${cartItems.map((item, index) => `
              <tr>
                <td>${index + 1}</td>
                <td>${item.product.name}</td>
                <td>${item.product.model || '-'}</td>
                <td>${item.quantity}</td>
                <td>${item.product.price.toLocaleString()} บาท</td>
                <td>${(item.product.price * item.quantity).toLocaleString()} บาท</td>
              </tr>
            `).join('')}
          </tbody>
        </table>
        
        <div class="total-section">
          <div class="total-row">
            <span>ราคารวมสินค้า:</span>
            <span style="margin-left: 20px;">${calculateTotal().toLocaleString()} บาท</span>
          </div>
          <div class="total-row">
            <span>ค่าจัดส่ง:</span>
            <span style="margin-left: 20px;">ฟรี</span>
          </div>
          <div class="grand-total">
            <span>ยอดรวมทั้งหมด:</span>
            <span style="margin-left: 20px;">${calculateTotal().toLocaleString()} บาท</span>
          </div>
        </div>
        
        <div class="terms">
          <h3>เงื่อนไขและข้อกำหนด</h3>
          <ul>
            <li>ใบเสนอราคานี้มีอายุ 30 วัน นับจากวันที่ออกใบเสนอราคา</li>
            <li>ราคาดังกล่าวรวมภาษีมูลค่าเพิ่ม 7% แล้ว</li>
            <li>ระยะเวลาจัดส่ง 7-14 วันทำการ หลังจากยืนยันคำสั่งซื้อ</li>
            <li>การชำระเงิน: ชำระเงิน 50% เมื่อสั่งซื้อ และชำระส่วนที่เหลือก่อนจัดส่ง</li>
            <li>การรับประกัน: รับประกันสินค้า 1 ปี สำหรับชิ้นส่วนที่ผลิตจากโรงงาน</li>
          </ul>
        </div>
        
        <div style="margin-top: 50px; text-align: center;">
          <p>ขอบคุณที่ให้ความไว้วางใจ</p>
          <p style="margin-top: 30px;">ลงชื่อผู้เสนอราคา: _________________</p>
          <p>วันที่: ${currentDate}</p>
          ${userData ? `
          <div style="margin-top: 20px; text-align: left; border-top: 1px solid #ddd; padding-top: 20px;">
            <h4>ข้อมูลลูกค้า:</h4>
            <p><strong>ชื่อ:</strong> ${userData.name}</p>
            <p><strong>อีเมล:</strong> ${userData.email}</p>
            <p><strong>โทรศัพท์:</strong> ${userData.phone || 'ไม่ระบุ'}</p>
            <p><strong>ที่อยู่:</strong> ${userData.address || 'ไม่ระบุ'}</p>
          </div>
          ` : ''}
        </div>
      </body>
      </html>
    `;
    
    printWindow.document.write(quotationHTML);
    printWindow.document.close();
    printWindow.focus();
    
    // รอให้เนื้อหาถูกโหลดก่อนพิมพ์
    setTimeout(() => {
      printWindow.print();
      printWindow.close();
    }, 500);
  };

  // ---------- PromptPay Payment ----------
  // eslint-disable-next-line no-unused-vars
  const extractQrFromNextAction = (nextAction) => {
    if (!nextAction) return null;
    // รองรับหลายรูปแบบของ Stripe next_action สำหรับ PromptPay
    // 1) next_action.promptpay_display_qr_code.image_url_png/svg
    const pqr = nextAction.promptpay_display_qr_code;
    if (pqr?.image_url_png) return { type: 'url', value: pqr.image_url_png };
    if (pqr?.image_url_svg) return { type: 'url', value: pqr.image_url_svg };
    // 2) next_action.display_qr_code?.image_url_png/svg (fallback ชื่อ generic)
    const gqr = nextAction.display_qr_code;
    if (gqr?.image_url_png) return { type: 'url', value: gqr.image_url_png };
    if (gqr?.image_url_svg) return { type: 'url', value: gqr.image_url_svg };
    // 3) ถ้ามี data ในรูปแบบ base64
    if (pqr?.image_data_url) return { type: 'data', value: pqr.image_data_url };
    if (gqr?.image_data_url) return { type: 'data', value: gqr.image_data_url };
    return null;
  };

  // eslint-disable-next-line no-unused-vars
  const openPaymentModal = (info) => {
    setPaymentInfo(info);
    setPaymentStatus(info?.status || 'processing');
    setPaymentModalOpen(true);
  };

  const closePaymentModal = () => {
    setPaymentModalOpen(false);
    setPaymentInfo(null);
    if (pollTimer) {
      clearInterval(pollTimer);
      setPollTimer(null);
    }
  };

  // eslint-disable-next-line no-unused-vars
  const startPollingStatus = (paymentIntentId) => {
    if (pollTimer) clearInterval(pollTimer);
    const timer = setInterval(async () => {
      try {
        const { data } = await axios.get(`${API_URL}/api/payments/${paymentIntentId}/status`);
        setPaymentStatus(data.status);
        if (data.status === 'succeeded') {
          // เมื่อชำระเงินสำเร็จ ให้บันทึกคำสั่งซื้อ
          await handleSaveOrderAfterPayment();
          clearInterval(timer);
          setPollTimer(null);
        } else if (data.status === 'canceled' || data.status === 'requires_payment_method') {
          clearInterval(timer);
          setPollTimer(null);
        }
      } catch (e) {
        // หยุดถ้าผิดพลาดหลายครั้ง
        clearInterval(timer);
        setPollTimer(null);
      }
    }, 3000);
    setPollTimer(timer);
  };

  const handleSaveOrderAfterPayment = async () => {
    try {
      const token = localStorage.getItem('token');
      if (!token) {
        alert('กรุณาเข้าสู่ระบบก่อนบันทึกคำสั่งซื้อ');
        return;
      }

      if (cartItems.length === 0) {
        alert('ไม่มีสินค้าในตะกร้า');
        return;
      }

      // สร้างคำสั่งซื้อหลังจากชำระเงินสำเร็จ
      const orderData = {
        items: cartItems,
        shippingAddress: 'ที่อยู่จัดส่ง (กรุณาไปแก้ไขในโปรไฟล์)'
      };

      console.log('🛒 Creating order after payment:', orderData);

      const response = await axios.post(`${API_URL}/api/orders`, orderData, {
        headers: { Authorization: `Bearer ${token}` }
      });

      if (response.data) {
        console.log('✅ Order created successfully:', response.data.id);
        alert('บันทึกคำสั่งซื้อสำเร็จ! หมายเลขคำสั่งซื้อ: ' + response.data.id);
        // ล้างตะกร้าหลังบันทึกคำสั่งซื้อ
        await axios.delete(`${API_URL}/api/cart/clear`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        // รีเฟรชข้อมูลตะกร้า
        const cartResponse = await axios.get(`${API_URL}/api/cart`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        setCartItems(cartResponse.data);
      }
    } catch (error) {
      console.error('Error saving order:', error);
      alert('เกิดข้อผิดพลาดในการบันทึกคำสั่งซื้อ');
    }
  };


  if (loading) {
    return (
    <div className="cart-page">
      <div className="container">
        <h1>ตะกร้าสินค้า({getTotalItems() || 0})</h1>
        <div className="loading">กำลังโหลด...</div>
      </div>
    </div>
  );
  }

  if (cartItems.length === 0) {
  return (
    <div className="cart-page">
      <div className="container">
        {/* หัวข้อซ้ายบนตามภาพ */}
        <h1>ตะกร้าของคุณ (0)</h1>

        {/* บล็อก empty state กลางหน้า */}
       <div className="empty-cart empty-cart--center">
  <p className="empty-title">ไม่มีสินค้าในตะกร้าของคุณ</p>
  <a href="/products" className="btn btn-brand btn-xl">ช้อปต่อ</a>
</div>

      </div>
    </div>
  );
}


  return (
    <div className="cart-page">
  <div className="container">
    <h1>ตะกร้าสินค้า({getTotalItems() || 0})</h1>

    {/* ✅ ทำ 2 คอลัมน์ในกล่องเดียวกัน */}
    <div className="cart-content">
      {/* LEFT */}
      <div className="cart-left">
        <h3 className="items-title">รายการสินค้า</h3>
        <div className="cart-items">
          {cartItems.map((item) => (
            <div key={item.id} className="cart-item cart-item--boxed">
              <button
                className="remove-item remove-item--icon"
                onClick={() => removeItem(item.id)}
                aria-label="ลบสินค้าออก"
                title="ลบสินค้าออก"
              >
                <i className="fas fa-trash"></i>
              </button>

              <div className="item-image">
                <img
                  src={item.product.model 
                    ? `/images/products/${item.product.model}.jpg`
                    : (item.product.image 
                        ? (item.product.image.startsWith('http')
                            ? item.product.image
                            : `/images/products/${item.product.image}`)
                        : '/images/NoImage.png')}
                  alt={item.product.name}
                  onError={(e) => {
                    e.target.src = '/images/NoImage.png';
                  }}
                />
              </div>

              <div className="item-middle">
                <h4 className="item-title">{item.product.name}</h4>
                <div className="item-subprice">
                  ราคา: {item.product.price.toLocaleString()}/ตัว
                </div>
                {item.product.stock !== undefined && (
                  <div className="item-stock">
                    สต็อก: {item.product.stock} ชิ้น
                  </div>
                )}
                <div className="item-qty-row">
                  <span className="qty-label">จำนวน</span>
                  <div className="item-quantity item-quantity--square">
                    <button 
                      onClick={() => updateQuantity(item.id, item.quantity - 1)}
                      disabled={item.quantity <= 1}
                    >−</button>
                    <span className="qty-num">{item.quantity}</span>
                    <button 
                      onClick={() => updateQuantity(item.id, item.quantity + 1)}
                      disabled={item.product.stock !== undefined && item.quantity >= item.product.stock}
                    >＋</button>
                  </div>
                </div>
              </div>

              <div className="item-right">
                <div className="item-total-right">
                  <span className="sum-label">รวม</span>&nbsp;
                  <b>{(item.product.price * item.quantity).toLocaleString()}</b>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* RIGHT */}
      <aside className="cart-summary">
        <h2>รายละเอียดการชำระเงิน</h2>
        <div className="summary-item">
          <span>ราคา</span>
          <span>{calculateTotal().toLocaleString()}</span>
        </div>
        <div className="summary-item">
          <span>ค่าจัดส่ง</span>
          <span>0</span>
        </div>
        <div className="summary-total">
          <span>ราคารวมสุทธิ</span>
          <span>{calculateTotal().toLocaleString()}</span>
        </div>

        <div className="cart-actions">
  {!localStorage.getItem('token') && (
    <div className="login-required-notice">
      <i className="fas fa-exclamation-triangle"></i>
      <span>กรุณาเข้าสู่ระบบก่อนดำเนินการจ่ายเงิน</span>
    </div>
  )}

  {/* ปุ่มแดง */}
  <button
    className={`btn btn-primary checkout-btn ${!localStorage.getItem('token') ? 'disabled' : ''}`}
    onClick={() => navigate('/checkout')}
    disabled={!localStorage.getItem('token')}
    title={!localStorage.getItem('token') ? 'กรุณาเข้าสู่ระบบก่อน' : 'ไปหน้าสั่งซื้อ'}
  >
    ดำเนินการต่อ
  </button>

  {/* ตัวคั่น "หรือ" */}
  <div className="or-sep"><span>หรือ</span></div>

  {/* ปุ่มดำ */}
  <button
    className="btn btn-secondary print-quotation-btn"
    onClick={printQuotation}
  >
    ดาวน์โหลดใบเสนอราคา
  </button>
</div>

      </aside>
    </div>
  </div>

      {paymentModalOpen && (
        <div className="payment-modal">
          <div className="payment-modal__content">
            <button className="payment-modal__close" onClick={closePaymentModal}>×</button>
            <h3>ชำระเงินด้วย PromptPay</h3>
            {paymentInfo?.qrSrc ? (
              <div className="payment-modal__qr">
                <img src={paymentInfo.qrSrc} alt="PromptPay QR" />
              </div>
            ) : (
              <div className="payment-modal__loading">กำลังเตรียม QR...</div>
            )}
            <div className={`payment-status status-${paymentStatus}`}>
              สถานะ: {paymentStatus}
            </div>
            <div className="payment-hint">สแกน QR ด้วยแอปธนาคารของคุณ</div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Cart; 