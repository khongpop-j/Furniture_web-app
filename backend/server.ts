import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import { PrismaClient } from '@prisma/client';
import Stripe from 'stripe';
import bodyParser from 'body-parser';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { createTransport } from 'nodemailer';

const PORT = Number(process.env.PORT) || 5050;
const app = express();
const stripeSecretKey = process.env.STRIPE_SECRET_KEY || '';
const stripe = new Stripe(stripeSecretKey, { apiVersion: '2024-06-20' as any });
const prisma = new PrismaClient();

// Email configuration using environment variables
const EMAIL_USER = process.env.EMAIL_USER;
const EMAIL_PASS = process.env.EMAIL_PASS;

// Create email transporter
const createEmailTransporter = () => {
  if (!EMAIL_USER || !EMAIL_PASS) {
    console.error('EMAIL_USER or EMAIL_PASS is not set in environment variables.');
    return null;
  }

  return createTransport({
    service: 'gmail',
    auth: {
      user: EMAIL_USER,
      pass: EMAIL_PASS,
    },
  });
};

// Function to send password reset email
const sendPasswordResetEmail = async (toEmail: string, userName: string, resetUrl: string) => {
  const transporter = createEmailTransporter();
  
  if (!transporter) {
    console.error('Email transporter is not initialized. Cannot send email.');
    return false;
  }

  const mailOptions = {
    from: `"Furniture KaoKai" <${EMAIL_USER}>`,
    to: toEmail,
    subject: 'รีเซ็ตรหัสผ่านของคุณ - Furniture KaoKai',
    html: `
      <div style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 8px; overflow: hidden;">
        <div style="background-color: #dc3545; color: white; padding: 20px; text-align: center;">
          <h1 style="margin: 0;">รีเซ็ตรหัสผ่าน</h1>
        </div>
        <div style="padding: 20px;">
          <p>สวัสดีคุณ ${userName},</p>
          <p>คุณได้รับการร้องขอให้รีเซ็ตรหัสผ่านสำหรับบัญชีของคุณ</p>
          <p>กรุณาคลิกที่ปุ่มด้านล่างเพื่อดำเนินการรีเซ็ตรหัสผ่าน:</p>
          <p style="text-align: center; margin: 30px 0;">
            <a href="${resetUrl}" style="background-color: #dc3545; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-size: 16px;">
              รีเซ็ตรหัสผ่านของคุณ
            </a>
          </p>
          <p>ลิงก์นี้จะหมดอายุใน 1 ชั่วโมง</p>
          <p>หากคุณไม่ได้ร้องขอการรีเซ็ตรหัสผ่านนี้ โปรดละเว้นอีเมลนี้</p>
          <p>ขอบคุณ,<br>ทีมงาน Furniture KaoKai</p>
        </div>
        <div style="background-color: #f8f9fa; color: #6c757d; padding: 15px; text-align: center; font-size: 0.8em;">
          <p>&copy; ${new Date().getFullYear()} Furniture KaoKai. All rights reserved.</p>
        </div>
      </div>
    `,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log('✅ Password reset email sent successfully to:', toEmail);
    return true;
  } catch (error) {
    console.error('❌ Error sending email:', error);
    return false;
  }
};

// MySQL pool is no longer needed - using Prisma instead

// Middleware
app.use(cors());
// Stripe webhook ต้องใช้ raw body — ต้องลงทะเบียนก่อน express.json()
app.use('/api/stripe/webhook', bodyParser.raw({ type: 'application/json' }));
app.use(express.json());

// Health check
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// ฟังก์ชันสร้างคำสั่งซื้อจาก Stripe Session
const createOrderFromSession = async (session: Stripe.Checkout.Session) => {
  try {
    console.log('🛒 Creating order from session:', session.id);
    console.log('📧 Session metadata:', session.metadata);
    
    // ดึง user ID จาก session metadata
    const userId = session.metadata?.userId ? parseInt(session.metadata.userId) : 1;
    console.log('👤 Using user ID:', userId);
    
    // ดึงข้อมูลสินค้าจาก cart ของ user ที่ระบุ
    const cartItems = await prisma.cartItem.findMany({
      where: { userId: userId },
      include: {
        product: true
      }
    });

    console.log('🛒 Found cart items:', cartItems.length);
    cartItems.forEach(item => {
      console.log(`  - ${item.product.name} x${item.quantity} (Stock: ${item.product.stock})`);
    });

    if (cartItems.length === 0) {
      console.log('⚠️ No items in cart, skipping order creation');
      return;
    }

    // คำนวณยอดรวม
    const total = cartItems.reduce((sum, item) => 
      sum + (parseFloat(item.product.price.toString()) * item.quantity), 0
    );
    console.log('💰 Total amount:', total);

    // ดึงข้อมูลการจัดส่งจาก metadata (ถ้ามี)
    const deliveryMethod = session.metadata?.deliveryMethod || 'pickup';
    const deliveryDetails = session.metadata?.deliveryDetails || null;
    
    // สร้าง shippingAddress จาก deliveryDetails
    let shippingAddressStr = 'ที่อยู่จัดส่ง';
    if (deliveryMethod === 'delivery' && deliveryDetails) {
      try {
        const addr = JSON.parse(deliveryDetails);
        const addressParts = [];
        if (addr.address) addressParts.push(addr.address);
        if (addr.district) addressParts.push(`ตำบล${addr.district}`);
        if (addr.amphoe) addressParts.push(`อำเภอ${addr.amphoe}`);
        if (addr.province) addressParts.push(`จังหวัด${addr.province}`);
        if (addr.postalCode) addressParts.push(`${addr.postalCode}`);
        shippingAddressStr = addressParts.join(' ');
      } catch (e) {
        console.error('Error parsing deliveryDetails:', e);
      }
    } else if (deliveryMethod === 'pickup') {
      shippingAddressStr = 'รับที่ร้าน - 99/5 หมู่ที่ 5 ตำบลไทรน้อย อำเภอไทรน้อย จังหวัดนนทบุรี 11150';
    }
    
    // สร้างคำสั่งซื้อ
    const order = await prisma.order.create({
      data: {
        userId: userId,
        total: total,
        status: 'PENDING',
        shippingAddress: shippingAddressStr,
        deliveryMethod: deliveryMethod,
        deliveryDetails: deliveryDetails,
        orderItems: {
          create: cartItems.map((item) => ({
            productId: item.productId,
            name: item.product.name,
            price: parseFloat(item.product.price.toString()),
            quantity: item.quantity
          }))
        }
      } as any,
      include: {
        orderItems: true
      }
    });

    // ลดสต็อกสินค้า
    console.log('📦 Updating stock...');
    for (const item of cartItems) {
      const beforeStock = item.product.stock;
      const afterStock = beforeStock - item.quantity;
      
      await prisma.product.update({
        where: { id: item.productId },
        data: {
          stock: {
            decrement: item.quantity
          }
        }
      });
      
      console.log(`  - ${item.product.name}: ${beforeStock} → ${afterStock} (sold ${item.quantity})`);
    }

    // ลบสินค้าออกจาก cart
    console.log('🗑️ Clearing cart...');
    const deletedCartItems = await prisma.cartItem.deleteMany({
      where: { userId: userId }
    });
    console.log(`  - Deleted ${deletedCartItems.count} cart items`);

    console.log('✅ Order created successfully:', order.id);
    console.log('✅ Stock updated and cart cleared');
    
    return order;
  } catch (error) {
    console.error('❌ Error creating order from session:', error);
    throw error;
  }
};

// Stripe Webhook
app.post('/api/stripe/webhook', async (req: any, res) => {
  const sig = req.headers['stripe-signature'] as string | undefined;
  const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET;
  if (!sig || !webhookSecret) {
    return res.status(400).send('Missing signature or webhook secret');
  }

  let event: Stripe.Event;
  try {
    event = stripe.webhooks.constructEvent(req.body, sig, webhookSecret);
  } catch (err: any) {
    console.error('Webhook signature verification failed.', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  try {
    switch (event.type) {
      case 'checkout.session.completed': {
        const session = event.data.object as Stripe.Checkout.Session;
        console.log('🎉 Checkout session completed:', session.id);
        console.log('📧 Session metadata:', session.metadata);
        console.log('💰 Payment status:', session.payment_status);
        
        // สร้างคำสั่งซื้อจาก session
        await createOrderFromSession(session);
        break;
      }
      case 'payment_intent.succeeded': {
        const paymentIntent = event.data.object as Stripe.PaymentIntent;
        console.log('Payment succeeded:', paymentIntent.id);
        // การล้างตะกร้าและสร้าง order จัดการใน checkout.session.completed แล้ว
        break;
      }
      case 'payment_intent.payment_failed': {
        const paymentIntent = event.data.object as Stripe.PaymentIntent;
        console.log('Payment failed:', paymentIntent.id);
        break;
      }
      default:
        console.log(`Unhandled event type ${event.type}`);
    }
    res.json({ received: true });
  } catch (error) {
    console.error('Error handling webhook:', error);
    res.status(500).send('Webhook handler error');
  }
});

// Payments - Create PromptPay PaymentIntent
app.post('/api/payments/create', async (req, res) => {
  try {
    const { amount, currency = 'thb', description = 'Order payment', email, name, phone } = req.body;
    console.log('[payments/create] body =', req.body);
    if (!amount || amount <= 0) {
      return res.status(400).json({ message: 'จำนวนเงินไม่ถูกต้อง' });
    }
    if (!email) {
      return res.status(400).json({ message: 'Missing required param: billing_details[email].' });
    }

    // 1) สร้าง PaymentMethod แบบ PromptPay พร้อม billing_details ก่อน
    const pm = await stripe.paymentMethods.create({
      type: 'promptpay',
      billing_details: { email, name, phone },
    });

    // 2) สร้างและยืนยัน PaymentIntent โดยแนบ payment_method ที่สร้างไว้
    const confirmed = await stripe.paymentIntents.create({
      amount: Math.round(Number(amount)),
      currency,
      description,
      payment_method_types: ['promptpay'],
      payment_method: pm.id,
      confirm: true,
    });

    // ข้อมูล QR จะอยู่ใน next_action.display_qr_code (ถ้ามี)
    const nextAction: any = confirmed.next_action;
    const qr = nextAction?.promptpay_display_qr_code || nextAction?.display_qr_code;
    const hostedUrl = qr?.hosted_voucher_url || qr?.hosted_instructions_url || nextAction?.hosted_voucher_url || nextAction?.hosted_instructions_url || null;

    res.json({
      clientSecret: confirmed.client_secret,
      paymentIntentId: confirmed.id,
      status: confirmed.status,
      nextAction: confirmed.next_action,
      promptpayQr: qr || null,
      hostedUrl,
    });
  } catch (error: any) {
    console.error('Error creating PromptPay intent:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการสร้างการชำระเงิน', error: error?.message });
  }
});

// Payments - Check PaymentIntent status
app.get('/api/payments/:id/status', async (req, res) => {
  try {
    const { id } = req.params;
    const pi = await stripe.paymentIntents.retrieve(id, { expand: ['charges'] });
    res.json({ id: pi.id, status: pi.status, charges: (pi as any).charges || null });
  } catch (error: any) {
    res.status(404).json({ message: 'ไม่พบการชำระเงินนี้', error: error?.message });
  }
});

// Stripe Checkout (Hosted)
app.post('/api/checkout/create', async (req, res) => {
  try {
    const { amount, email, successUrl, cancelUrl, userId, deliveryMethod, deliveryDetails } = req.body || {};
    if (!amount || amount <= 0) {
      return res.status(400).json({ message: 'จำนวนเงินไม่ถูกต้อง' });
    }

    const origin = req.headers.origin || 'http://localhost:3000';
    
    // เตรียม metadata สำหรับ Stripe
    const metadata: any = {
      userId: userId || '1'
    };
    
    // เพิ่มข้อมูลการจัดส่งใน metadata ถ้ามี
    if (deliveryMethod) {
      metadata.deliveryMethod = deliveryMethod;
    }
    
    if (deliveryDetails) {
      metadata.deliveryDetails = deliveryDetails;
    }
    
    const session = await stripe.checkout.sessions.create({
      mode: 'payment',
      payment_method_types: ['promptpay'],
      currency: 'thb',
      line_items: [
        {
          price_data: {
            currency: 'thb',
            product_data: { name: 'คำสั่งซื้อจากตะกร้า' },
            unit_amount: Math.round(Number(amount)),
          },
          quantity: 1,
        },
      ],
      customer_email: email,
      success_url: successUrl || `${origin}/checkout/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: cancelUrl || `${origin}/cart?payment=cancel`,
      metadata: metadata
    });

    res.json({ id: session.id, url: session.url });
  } catch (error: any) {
    console.error('Error creating checkout session:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการสร้าง Checkout', error: error?.message });
  }
});

// Get checkout session details (for receipt)
app.get('/api/checkout/session/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const session = await stripe.checkout.sessions.retrieve(id, {
      expand: ['payment_intent', 'payment_intent.latest_charge']
    });
    res.json({
      id: session.id,
      amount_total: session.amount_total,
      currency: session.currency,
      payment_status: session.payment_status,
      customer_email: session.customer_email,
      payment_intent_id: typeof session.payment_intent === 'string' ? session.payment_intent : session.payment_intent?.id,
    });
  } catch (error: any) {
    res.status(404).json({ message: 'ไม่พบ session', error: error?.message });
  }
});

// Create order from checkout session
app.post('/api/checkout/session/:id/create-order', async (req, res) => {
  try {
    const { id } = req.params;
    console.log('🔍 Creating order for session:', id);
    
    const session = await stripe.checkout.sessions.retrieve(id);
    console.log('📧 Session details:', {
      id: session.id,
      payment_status: session.payment_status,
      metadata: session.metadata
    });
    
    if (session.payment_status !== 'paid') {
      return res.status(400).json({ message: 'การชำระเงินยังไม่สำเร็จ' });
    }

    // ตรวจสอบว่ามีคำสั่งซื้อแล้วหรือไม่
    const existingOrder = await prisma.order.findFirst({
      where: {
        // ใช้ session ID เป็น unique identifier
        shippingAddress: session.id
      }
    });

    if (existingOrder) {
      console.log('⚠️ Order already exists:', existingOrder.id);
      return res.json({ 
        message: 'คำสั่งซื้อถูกสร้างแล้ว', 
        order: existingOrder 
      });
    }

    // สร้างคำสั่งซื้อ
    console.log('🛒 Creating new order...');
    const order = await createOrderFromSession(session);
    
    res.json({ 
      message: 'สร้างคำสั่งซื้อสำเร็จ', 
      order: order 
    });
  } catch (error: any) {
    console.error('❌ Error creating order from session:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการสร้างคำสั่งซื้อ', error: error?.message });
  }
});

// Test endpoint - สร้างคำสั่งซื้อโดยตรง (สำหรับการทดสอบ)
app.post('/api/test/create-order', async (req, res) => {
  try {
    const { userId = 1 } = req.body;
    console.log('🧪 Test: Creating order for user:', userId);
    
    // ดึงข้อมูลสินค้าจาก cart
    const cartItems = await prisma.cartItem.findMany({
      where: { userId: userId },
      include: { product: true }
    });

    console.log('🛒 Found cart items:', cartItems.length);
    
    if (cartItems.length === 0) {
      return res.status(400).json({ message: 'ไม่มีสินค้าในตะกร้า' });
    }

    // คำนวณยอดรวม
    const total = cartItems.reduce((sum, item) => 
      sum + (parseFloat(item.product.price.toString()) * item.quantity), 0
    );

    // สร้างคำสั่งซื้อ
    const order = await prisma.order.create({
      data: {
        userId: userId,
        total: total,
        status: 'PENDING',
        shippingAddress: 'Test Order',
        orderItems: {
          create: cartItems.map((item) => ({
            productId: item.productId,
            name: item.product.name,
            price: parseFloat(item.product.price.toString()),
            quantity: item.quantity
          }))
        }
      },
      include: {
        orderItems: true
      }
    });

    // ลดสต็อกสินค้า
    for (const item of cartItems) {
      await prisma.product.update({
        where: { id: item.productId },
        data: {
          stock: {
            decrement: item.quantity
          }
        }
      });
    }

    // ลบสินค้าออกจาก cart
    await prisma.cartItem.deleteMany({
      where: { userId: userId }
    });

    res.json({ 
      message: 'สร้างคำสั่งซื้อทดสอบสำเร็จ', 
      order: order 
    });
  } catch (error: any) {
    console.error('❌ Error creating test order:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการสร้างคำสั่งซื้อทดสอบ', error: error?.message });
  }
});

// Product Routes
app.get('/api/products', async (req, res) => {
  try {
    const { search, category, minPrice, maxPrice, sort } = req.query;
    
    // Build where conditions for Prisma
    const where: any = {};
    
    // Search by name, model, or category
    if (search) {
      where.OR = [
        { name: { contains: search as string } },
        { model: { contains: search as string } },
        { category: { contains: search as string } }
      ];
    }

    // Filter by category
    if (category) {
      where.category = category;
    }

    // Filter by price range
    if (minPrice || maxPrice) {
      where.price = {};
      if (minPrice) {
        where.price.gte = parseFloat(minPrice as string);
      }
      if (maxPrice) {
        where.price.lte = parseFloat(maxPrice as string);
      }
    }

    // Build orderBy for Prisma
    let orderBy: any = {};
    if (sort) {
      switch (sort) {
        case 'price-asc':
          orderBy = { price: 'asc' };
          break;
        case 'price-desc':
          orderBy = { price: 'desc' };
          break;
        case 'name-asc':
          orderBy = { name: 'asc' };
          break;
        case 'rating-desc':
          orderBy = { rating: 'desc' };
          break;
      }
    }
    
    const products = await prisma.product.findMany({
      where,
      orderBy: Object.keys(orderBy).length > 0 ? orderBy : undefined
    });
    
    res.json(products);
  } catch (error) {
    console.error('Error fetching products:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลสินค้า' });
  }
});

app.get('/api/products/bestsellers', async (req, res) => {
  try {
    const bestSellers = await prisma.product.findMany({
      where: { isBestSeller: true },
      take: 4
    });
    res.json(bestSellers);
  } catch (error) {
    console.error('Error fetching best sellers:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลสินค้าขายดี' });
  }
});

app.get('/api/products/:id', async (req, res) => {
  try {
    const product = await prisma.product.findUnique({
      where: { id: parseInt(req.params.id) }
    });

    if (!product) {
      return res.status(404).json({ message: 'ไม่พบสินค้า' });
    }

    res.json(product);
  } catch (error) {
    console.error('Error fetching product:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลสินค้า' });
  }
});

app.get('/api/categories', async (req, res) => {
  try {
    const categories = await prisma.product.findMany({
      select: { category: true },
      distinct: ['category']
    });
    
    res.json(categories.map(c => c.category));
  } catch (error) {
    console.error('Error fetching categories:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลหมวดหมู่' });
  }
});


// User Routes - จะย้ายไปไว้หลังการประกาศ authMiddleware

// Order Routes - จะย้ายไปไว้หลังการประกาศ authMiddleware

app.put('/api/orders/:orderId', async (req, res) => {
  try {
    const { status } = req.body;
    const orderId = req.params.orderId;
    
    const updatedOrder = await prisma.order.update({
      where: { id: orderId },
      data: { status }
    });
    
    res.json(updatedOrder);
  } catch (error) {
    console.error('Error updating order:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการอัปเดตคำสั่งซื้อ' });
  }
});

// Promotion Routes
app.get('/api/promotions', async (req, res) => {
  try {
    const promotions = await prisma.promotion.findMany({
      where: {
        validUntil: {
          gte: new Date()
        }
      },
      orderBy: { createdAt: 'desc' }
    });
    res.json(promotions);
  } catch (error) {
    console.error('Error fetching promotions:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลโปรโมชั่น' });
  }
});

// Contact Routes
app.post('/api/contact', async (req, res) => {
  try {
    const { name, email, phone, subject, message } = req.body;
    
    // บันทึกข้อมูลลงฐานข้อมูล
    await prisma.contact.create({
      data: {
        name,
        email,
        phone: phone || null,
        message
      }
    });
    
    // สร้าง transporter สำหรับส่งอีเมล
    const transporter = createEmailTransporter();

    // เนื้อหาอีเมล
    const mailOptions = {
      from: EMAIL_USER,
      to: 'info@kaokaioffice.com', // เมลบริษัท
      subject: `ข้อความติดต่อจากลูกค้า: ${subject || 'ไม่ระบุหัวข้อ'}`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h2 style="color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px;">
            📧 ข้อความติดต่อจากลูกค้า
          </h2>
          
          <div style="background-color: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;">
            <h3 style="color: #2c3e50; margin-top: 0;">📋 ข้อมูลลูกค้า</h3>
            <p><strong>ชื่อ:</strong> ${name}</p>
            <p><strong>อีเมล:</strong> ${email}</p>
            <p><strong>โทรศัพท์:</strong> ${phone || 'ไม่ระบุ'}</p>
            <p><strong>หัวข้อ:</strong> ${subject || 'ไม่ระบุหัวข้อ'}</p>
          </div>
          
          <div style="background-color: #e8f4fd; padding: 20px; border-radius: 8px; margin: 20px 0;">
            <h3 style="color: #2c3e50; margin-top: 0;">💬 ข้อความ</h3>
            <p style="white-space: pre-wrap; line-height: 1.6;">${message}</p>
          </div>
          
          <div style="background-color: #d4edda; padding: 15px; border-radius: 8px; margin: 20px 0;">
            <p style="margin: 0; color: #155724;">
              <strong>⏰ เวลาที่ส่ง:</strong> ${new Date().toLocaleString('th-TH')}
            </p>
          </div>
          
          <div style="text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #dee2e6;">
            <p style="color: #6c757d; font-size: 14px;">
              ข้อความนี้ส่งมาจากระบบติดต่อของ KaokaiOfficeFurniture
            </p>
          </div>
        </div>
      `
    };
    
    // ส่งอีเมล (ถ้าตั้งค่า email ไว้)
    if (transporter) {
      try {
        await transporter.sendMail(mailOptions);
        console.log('✅ อีเมลส่งสำเร็จไปยัง:', 'info@kaokaioffice.com');
      } catch (emailError) {
        console.error('❌ เกิดข้อผิดพลาดในการส่งอีเมล:', emailError);
      }
    }
    
    res.json({ 
      message: 'ส่งข้อความเรียบร้อยแล้ว เราจะติดต่อกลับโดยเร็วที่สุด',
      success: true 
    });
  } catch (error) {
    console.error('Error sending contact message:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการส่งข้อความ' });
  }
});

// Search Routes
app.get('/api/search', async (req, res) => {
  try {
    const { q } = req.query;
    
    if (!q) {
      return res.json([]);
    }

    const searchResults = await prisma.product.findMany({
      where: {
        OR: [
          { name: { contains: q as string } },
          { model: { contains: q as string } },
          { category: { contains: q as string } }
        ]
      },
      take: 10
    });

    res.json(searchResults);
  } catch (error) {
    console.error('Error searching products:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการค้นหาสินค้า' });
  }
});

// ===== Auth (JWT) =====
const JWT_SECRET = process.env.JWT_SECRET || 'dev-secret';

// Password column is managed by Prisma schema - no need to check manually

const signToken = (payload: object) => jwt.sign(payload as any, JWT_SECRET, { expiresIn: '7d' });

const authMiddleware = (req: any, res: any, next: any) => {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) return res.status(401).json({ message: 'Unauthorized' });
  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch {
    return res.status(401).json({ message: 'Invalid token' });
  }
};

// Order Routes - แสดงเฉพาะคำสั่งซื้อของ user
app.get('/api/orders', authMiddleware, async (req: any, res) => {
  try {
    const userId = req.user.id;
    
    const orders = await prisma.order.findMany({
      where: { userId }, // แสดงเฉพาะคำสั่งซื้อของ user นี้
      include: {
        user: {
          select: {
            name: true,
            email: true
          }
        },
        orderItems: true
      },
      orderBy: { createdAt: 'desc' }
    });

    // Format response to match frontend expectations
    const formattedOrders = orders.map(order => ({
      ...order,
      userName: order.user.name,
      userEmail: order.user.email,
      orderItems: order.orderItems
    }));

    console.log(`แสดงคำสั่งซื้อของ user ID: ${userId}, จำนวน: ${formattedOrders.length} รายการ`);
    res.json(formattedOrders);
  } catch (error) {
    console.error('Error fetching orders:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลคำสั่งซื้อ' });
  }
});

// Get single order details for user
app.get('/api/orders/:id', authMiddleware, async (req: any, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;
    
    const order = await prisma.order.findUnique({
      where: { id },
      select: {
        id: true,
        userId: true,
        total: true,
        status: true,
        shippingAddress: true,
        deliveryMethod: true,
        deliveryDetails: true,
        createdAt: true,
        updatedAt: true,
        user: {
          select: {
            name: true,
            email: true,
            phone: true
          }
        },
        orderItems: {
          include: {
            product: {
              select: {
                id: true,
                name: true,
                model: true,
                image: true,
                price: true
              }
            }
          }
        }
      }
    });
    
    if (!order) {
      return res.status(404).json({ message: 'ไม่พบคำสั่งซื้อ' });
    }
    
    // ตรวจสอบว่าคำสั่งซื้อเป็นของ user นี้หรือไม่
    if (order.userId !== userId) {
      return res.status(403).json({ message: 'คุณไม่มีสิทธิ์เข้าถึงคำสั่งซื้อนี้' });
    }
    
    // Format response
    const formattedOrder = {
      ...order,
      orderItems: order.orderItems.map(item => ({
        ...item,
        name: item.product.name,
        product: item.product
      }))
    };
    
    res.json(formattedOrder);
  } catch (error) {
    console.error('Error fetching order details:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลคำสั่งซื้อ' });
  }
});

// Create Order - สร้างคำสั่งซื้อใหม่
app.post('/api/orders', authMiddleware, async (req: any, res) => {
  try {
    const userId = req.user.id;
    const { items, totalAmount, deliveryMethod, deliveryAddress, needInvoice, invoiceData } = req.body;

    // สร้างคำสั่งซื้อ
    const order = await prisma.order.create({
      data: {
        userId,
        total: totalAmount,
        status: 'PENDING',
        shippingAddress: deliveryAddress?.address || 'ที่อยู่จัดส่ง',
        orderItems: {
          create: items.map((item: any) => ({
            productId: item.productId,
            quantity: item.quantity,
            price: item.price
          }))
        }
      },
      include: {
        orderItems: {
          include: {
            product: true
          }
        }
      }
    });

    // ลดสต็อกสินค้า
    for (const item of items) {
      await prisma.product.update({
        where: { id: item.productId },
        data: {
          stock: {
            decrement: item.quantity
          }
        }
      });
    }

    // ลบสินค้าออกจาก cart
    await prisma.cartItem.deleteMany({
      where: { userId }
    });

    console.log(`สร้างคำสั่งซื้อใหม่ ID: ${order.id} สำหรับ user ID: ${userId}`);
    res.json(order);
  } catch (error) {
    console.error('Error creating order:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการสร้างคำสั่งซื้อ' });
  }
});

// Cart Routes
app.get('/api/cart', authMiddleware, async (req: any, res) => {
  try {
    const userId = req.user.id;
    const cartItems = await prisma.cartItem.findMany({
      where: { userId },
      include: {
        product: {
          select: {
            id: true,
            name: true,
            model: true,
            price: true,
            image: true,
            stock: true
          }
        }
      }
    });

    // Format response to match frontend expectations
    const formattedCartItems = cartItems.map(item => ({
      id: item.id,
      productId: item.product.id,
      product: {
        id: item.product.id,
        name: item.product.name,
        model: item.product.model,
        price: parseFloat(item.product.price.toString()),
        image: item.product.image,
        stock: item.product.stock
      },
      quantity: item.quantity
    }));

    res.json(formattedCartItems);
  } catch (error) {
    console.error('Error fetching cart:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลตะกร้าสินค้า' });
  }
});

app.post('/api/cart', authMiddleware, async (req: any, res) => {
  try {
    const { productId, quantity = 1 } = req.body;
    const userId = req.user.id;

    // Check if product exists using Prisma
    const product = await prisma.product.findUnique({
      where: { id: productId }
    });

    if (!product) {
      return res.status(404).json({ message: 'ไม่พบสินค้า' });
    }

    // ตรวจสอบ stock ก่อนเพิ่มลงตะกร้า
    if (product.stock <= 0) {
      return res.status(400).json({ message: 'สินค้าหมดสต็อกแล้ว' });
    }

    // ตรวจสอบว่าสินค้าที่ต้องการเพิ่มมีเพียงพอหรือไม่
    if (product.stock < quantity) {
      return res.status(400).json({ 
        message: `สินค้าเหลือเพียง ${product.stock} ชิ้น` 
      });
    }

    // Check if item already exists in cart
    const existingItem = await prisma.cartItem.findFirst({
      where: { productId: productId, userId }
    });

    if (existingItem) {
      // ตรวจสอบ stock รวมกับที่อยู่ในตะกร้าแล้ว
      const totalQuantity = existingItem.quantity + quantity;
      if (product.stock < totalQuantity) {
        return res.status(400).json({ 
          message: `สินค้าเหลือเพียง ${product.stock} ชิ้น (ในตะกร้า: ${existingItem.quantity} ชิ้น)` 
        });
      }

      // Update quantity
      await prisma.cartItem.update({
        where: { id: existingItem.id },
        data: { quantity: totalQuantity }
      });
    } else {
      // Add new item
      await prisma.cartItem.create({
        data: {
          productId: productId,
          quantity: quantity,
          userId
        }
      });
    }

    // Return updated cart
    const cartItems = await prisma.cartItem.findMany({
      where: { userId },
      include: {
        product: {
          select: {
            id: true,
            name: true,
            model: true,
            price: true,
            image: true
          }
        }
      }
    });

    // Format response to match frontend expectations
    const formattedCartItems = cartItems.map(item => ({
      id: item.id,
      productId: item.product.id,
      product: {
        id: item.product.id,
        name: item.product.name,
        model: item.product.model,
        price: parseFloat(item.product.price.toString()),
        image: item.product.image
      },
      quantity: item.quantity
    }));

    res.json(formattedCartItems);
  } catch (error: any) {
    console.error('Error adding to cart:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการเพิ่มสินค้าลงตะกร้า', error: error.message });
  }
});

app.put('/api/cart/:productId', authMiddleware, async (req: any, res) => {
  try {
    const productId = parseInt(req.params.productId);
    const { quantity } = req.body;
    const userId = req.user.id;

    // เช็คสินค้าและสต็อก
    const product = await prisma.product.findUnique({
      where: { id: productId }
    });
    if (!product) {
      return res.status(404).json({ message: 'ไม่พบสินค้า' });
    }
    if (typeof product.stock === 'number' && quantity > product.stock) {
      return res.status(400).json({ message: `สินค้าเหลือเพียง ${product.stock} ชิ้น` });
    }

    // ตรงนี้ต้องประกาศ cartItem ก่อนใช้ทุกครั้ง
    const cartItem = await prisma.cartItem.findFirst({
      where: { productId: productId, userId }
    });

    if (!cartItem) {
      return res.status(404).json({ message: 'ไม่พบสินค้าในตะกร้า' });
    }

    if (quantity <= 0) {
      // Remove item
      await prisma.cartItem.delete({
        where: { id: cartItem.id }
      });
    } else {
      // Update quantity
      await prisma.cartItem.update({
        where: { id: cartItem.id },
        data: { quantity: quantity }
      });
    }

    // ดึง cart กลับคืน
    const cartItems = await prisma.cartItem.findMany({
      where: { userId },
      include: {
        product: {
          select: {
            id: true,
            name: true,
            model: true,
            price: true,
            image: true,
            stock: true
          }
        }
      }
    });

    const formattedCartItems = cartItems.map(item => ({
      id: item.id,
      productId: item.product.id,
      product: {
        id: item.product.id
      },
      quantity: item.quantity
    }));
    res.json(formattedCartItems);
  } catch (error) {
    console.error('Error updating cart:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการอัปเดตตะกร้าสินค้า' });
  }
});

app.delete('/api/cart/:productId', authMiddleware, async (req: any, res) => {
  try {
    const productId = parseInt(req.params.productId);
    const userId = req.user.id;

    // ลบสินค้าจากตะกร้าตาม productId
    await prisma.cartItem.deleteMany({
      where: { 
        productId: productId,
        userId
      }
    });

    // Return updated cart
    const cartItems = await prisma.cartItem.findMany({
      where: { userId },
      include: {
        product: {
          select: {
            id: true,
            name: true,
            model: true,
            price: true,
            image: true
          }
        }
      }
    });

    // Format response to match frontend expectations
    const formattedCartItems = cartItems.map(item => ({
      id: item.id,
      productId: item.product.id,
      product: {
        id: item.product.id,
        name: item.product.name,
        model: item.product.model,
        price: parseFloat(item.product.price.toString()),
        image: item.product.image
      },
      quantity: item.quantity
    }));

    res.json(formattedCartItems);
  } catch (error) {
    console.error('Error removing from cart:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการลบสินค้าออกจากตะกร้า' });
  }
});

app.delete('/api/cart', authMiddleware, async (req: any, res) => {
  try {
    const userId = req.user.id;
    await prisma.cartItem.deleteMany({
      where: { userId }
    });
    res.json([]);
  } catch (error) {
    console.error('Error clearing cart:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการล้างตะกร้าสินค้า' });
  }
});

// Clear all cart items (alias for /api/cart)
app.delete('/api/cart/clear', authMiddleware, async (req: any, res) => {
  try {
    const userId = req.user.id;
    await prisma.cartItem.deleteMany({
      where: { userId }
    });
    res.json({ message: 'ลบสินค้าออกจากตะกร้าเรียบร้อยแล้ว' });
  } catch (error) {
    console.error('Error clearing cart:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการลบสินค้าออกจากตะกร้า' });
  }
});

// User Routes
app.get('/api/user', authMiddleware, async (req: any, res) => {
  try {
    const userId = req.user.id;
    const user = await prisma.user.findUnique({
      where: { id: userId }
    });
    res.json(user || null);
  } catch (error) {
    console.error('Error fetching user:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้' });
  }
});

app.put('/api/user', authMiddleware, async (req: any, res) => {
  try {
    const { name, email, phone, address, district, amphoe, province, postalCode } = req.body;
    const userId = req.user.id;
    
    // เตรียมข้อมูลสำหรับอัปเดต (จัดการ undefined values)
    const updateData: any = {};
    
    if (name !== undefined) updateData.name = name;
    if (email !== undefined) updateData.email = email;
    if (phone !== undefined) updateData.phone = phone;
    if (address !== undefined) updateData.address = address;
    if (req.body.gender !== undefined) updateData.gender = req.body.gender;
    if (req.body.nickname !== undefined) updateData.nickname = req.body.nickname;
    if (district !== undefined) updateData.district = district;
    if (amphoe !== undefined) updateData.amphoe = amphoe;
    if (province !== undefined) updateData.province = province;
    if (postalCode !== undefined) updateData.postalCode = postalCode;
    
    // อัปเดตผู้ใช้ที่ล็อกอินอยู่
    const updatedUser = await prisma.user.update({
      where: { id: userId },
      data: updateData
    });
    
    res.json(updatedUser);
  } catch (error) {
    console.error('Error updating user:', error);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการอัปเดตข้อมูลผู้ใช้' });
  }
});


// Admin middleware - ตรวจสอบสิทธิ์ admin
const adminMiddleware = async (req: any, res: any, next: any) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      select: { role: true }
    });
    
    if (!user || user.role !== 'ADMIN') {
      return res.status(403).json({ message: 'ไม่มีสิทธิ์เข้าถึง - ต้องเป็น Admin เท่านั้น' });
    }
    
    next();
  } catch (error) {
    console.error('Admin middleware error:', error);
    return res.status(500).json({ message: 'เกิดข้อผิดพลาดในการตรวจสอบสิทธิ์' });
  }
};

app.post('/api/auth/register', async (req, res) => {
  try {
    const { name, email, password, phone } = req.body || {};
    if (!name || !email || !password) {
      return res.status(400).json({ message: 'กรอกข้อมูลให้ครบ' });
    }

    const existed = await prisma.user.findUnique({ where: { email } });
    if (existed) {
      return res.status(409).json({ message: 'อีเมลนี้มีผู้ใช้แล้ว' });
    }

    // เข้ารหัสรหัสผ่าน
    const hash = await bcrypt.hash(password, 10);
    
    // สร้างผู้ใช้ใหม่ (ปรับ field ให้ตรง schema ของคุณ)
    const newUser = await prisma.user.create({
      data: {
        name,
        email,
        password: hash,
        phone: phone ?? null,   // เอาออกได้ถ้า schema ไม่มีคอลัมน์นี้
        // role: 'USER',        // ใส่ถ้า schema ไม่มี default
      },
      select: { id: true, name: true, email: true }
    });
    
    const token = signToken({ id: newUser.id, email: newUser.email });
    return res.json({ token, user: newUser });

    } catch (e: any) {
    // Prisma duplicate unique
    if (e?.code === 'P2002' && e?.meta?.target?.includes('email')) {
      return res.status(409).json({ message: 'อีเมลนี้มีผู้ใช้แล้ว' });
    }

    console.error('Register error:', e?.code, e?.message, e);
    return res.status(500).json({ message: 'เกิดข้อผิดพลาดในการสมัครสมาชิก' });
  }
});

app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body || {};
    if (!email || !password) return res.status(400).json({ message: 'กรอกอีเมลและรหัสผ่าน' });

    const user = await prisma.user.findUnique({
      where: { email }
    });
    
    if (!user || !user.password) return res.status(401).json({ message: 'อีเมลหรือรหัสผ่านไม่ถูกต้อง' });

    const ok = await bcrypt.compare(password, user.password);
    if (!ok) return res.status(401).json({ message: 'อีเมลหรือรหัสผ่านไม่ถูกต้อง' });

    const token = signToken({ id: user.id, email: user.email });
    res.json({ token, user: { id: user.id, name: user.name, email: user.email } });
  } catch (e) {
    console.error('Login error:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาด' });
  }
});

app.get('/api/auth/me', authMiddleware, async (req: any, res) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user.id }
    });
    res.json(user);
  } catch (e) {
    res.status(500).json({ message: 'เกิดข้อผิดพลาด' });
  }
});

// Forgot Password - Request reset
app.post('/api/auth/forgot-password', async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ message: 'กรุณากรอกอีเมล' });

    const user = await prisma.user.findUnique({
      where: { email }
    });

    if (!user) {
      // Don't reveal if email exists or not for security
      return res.json({ message: 'หากอีเมลนี้มีอยู่ในระบบ เราจะส่งลิงก์รีเซ็ตรหัสผ่านให้' });
    }

    // Generate reset token
    const resetToken = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
    const resetExpires = new Date(Date.now() + 3600000); // 1 hour

    // Save reset token to database
    await prisma.user.update({
      where: { id: user.id },
      data: {
        resetPasswordToken: resetToken,
        resetPasswordExpires: resetExpires
      }
    });

    // Create reset URL
    const resetUrl = `${req.headers.origin || 'http://localhost:3000'}/reset-password?token=${resetToken}`;

    // Send email using built-in Node.js modules
    await sendPasswordResetEmail(email, user.name, resetUrl);

    res.json({ message: 'หากอีเมลนี้มีอยู่ในระบบ เราจะส่งลิงก์รีเซ็ตรหัสผ่านให้' });
  } catch (e: any) {
    console.error('Forgot password error:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาด' });
  }
});

// Reset Password - Verify token and reset password
app.post('/api/auth/reset-password', async (req, res) => {
  try {
    const { token, password } = req.body;
    if (!token || !password) {
      return res.status(400).json({ message: 'กรุณากรอกข้อมูลให้ครบ' });
    }

    if (password.length < 8) {
      return res.status(400).json({ message: 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร' });
    }

    // Find user with valid reset token
    const user = await prisma.user.findFirst({
      where: {
        resetPasswordToken: token,
        resetPasswordExpires: {
          gt: new Date()
        }
      }
    });

    if (!user) {
      return res.status(400).json({ message: 'ลิงก์รีเซ็ตรหัสผ่านไม่ถูกต้องหรือหมดอายุแล้ว' });
    }

    // Hash new password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Update password and clear reset token
    await prisma.user.update({
      where: { id: user.id },
      data: {
        password: hashedPassword,
        resetPasswordToken: null,
        resetPasswordExpires: null
      }
    });

    res.json({ message: 'รีเซ็ตรหัสผ่านสำเร็จ' });
  } catch (e: any) {
    console.error('Reset password error:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาด' });
  }
});

// Favorites API - Add product to favorites
app.post('/api/favorites', authMiddleware, async (req: any, res) => {
  try {
    const { productId } = req.body;
    const userId = req.user.id;

    if (!productId) {
      return res.status(400).json({ message: 'กรุณาระบุสินค้า' });
    }

    // ตรวจสอบว่าสินค้ามีอยู่หรือไม่
    const product = await prisma.product.findUnique({
      where: { id: parseInt(productId) }
    });

    if (!product) {
      return res.status(404).json({ message: 'ไม่พบสินค้า' });
    }

    // ตรวจสอบว่าสินค้าอยู่ใน favorites แล้วหรือไม่
    const existingFavorite = await prisma.favorite.findUnique({
      where: {
        userId_productId: {
          userId: userId,
          productId: parseInt(productId)
        }
      }
    });

    if (existingFavorite) {
      return res.status(400).json({ message: 'สินค้านี้อยู่ในรายการโปรดแล้ว' });
    }

    // เพิ่มสินค้าเข้า favorites
    const favorite = await prisma.favorite.create({
      data: {
        userId: userId,
        productId: parseInt(productId)
      },
      include: {
        product: true
      }
    });

    res.json({ message: 'เพิ่มสินค้าเข้ารายการโปรดสำเร็จ', favorite });
  } catch (e: any) {
    console.error('Add favorite error:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาด' });
  }
});

// Favorites API - Remove product from favorites
app.delete('/api/favorites/:productId', authMiddleware, async (req: any, res) => {
  try {
    const { productId } = req.params;
    const userId = req.user.id;

    // ตรวจสอบว่าสินค้าอยู่ใน favorites หรือไม่
    const favorite = await prisma.favorite.findUnique({
      where: {
        userId_productId: {
          userId: userId,
          productId: parseInt(productId)
        }
      }
    });

    if (!favorite) {
      return res.status(404).json({ message: 'ไม่พบสินค้าในรายการโปรด' });
    }

    // ลบสินค้าออกจาก favorites
    await prisma.favorite.delete({
      where: {
        userId_productId: {
          userId: userId,
          productId: parseInt(productId)
        }
      }
    });

    res.json({ message: 'ลบสินค้าออกจากรายการโปรดสำเร็จ' });
  } catch (e: any) {
    console.error('Remove favorite error:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาด' });
  }
});

// Favorites API - Get user's favorites
app.get('/api/favorites', authMiddleware, async (req: any, res) => {
  try {
    const userId = req.user.id;

    const favorites = await prisma.favorite.findMany({
      where: { userId: userId },
      include: {
        product: {
          select: {
            id: true,
            name: true,
            model: true,
            price: true,
            originalPrice: true,
            image: true,
            category: true,
            description: true,
            stock: true,
            rating: true,
            reviews: true,
            isBestSeller: true,
            isOnSale: true,
            discount: true
          }
        }
      },
      orderBy: { createdAt: 'desc' }
    });

    res.json(favorites);
  } catch (e: any) {
    console.error('Get favorites error:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลรายการโปรด' });
  }
});

// Favorites API - Check if product is in favorites
app.get('/api/favorites/:productId', authMiddleware, async (req: any, res) => {
  try {
    const { productId } = req.params;
    const userId = req.user.id;

    const favorite = await prisma.favorite.findUnique({
      where: {
        userId_productId: {
          userId: userId,
          productId: parseInt(productId)
        }
      }
    });

    res.json({ isFavorite: !!favorite });
  } catch (e: any) {
    console.error('Check favorite error:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการตรวจสอบรายการโปรด' });
  }
});

// Admin API - Get all users
app.get('/api/admin/users', authMiddleware, adminMiddleware, async (req: any, res) => {
  try {
    const users = await prisma.user.findMany({
      select: {
        id: true,
        name: true,
        email: true,
        phone: true,
        address: true,
        avatar: true,
        role: true,
        createdAt: true,
        updatedAt: true
      },
      orderBy: { createdAt: 'desc' }
    });
    res.json(users);
  } catch (e) {
    console.error('Error fetching users:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้' });
  }
});

// Admin API - Update user role
app.put('/api/admin/users/:id/role', authMiddleware, adminMiddleware, async (req: any, res) => {
  try {
    const { id } = req.params;
    const { role } = req.body;
    
    if (!role || !['USER', 'ADMIN'].includes(role)) {
      return res.status(400).json({ message: 'Role ไม่ถูกต้อง' });
    }
    
    const updatedUser = await prisma.user.update({
      where: { id: parseInt(id) },
      data: { role }
    });
    
    res.json({ message: 'อัปเดตสิทธิ์ผู้ใช้สำเร็จ', user: updatedUser });
  } catch (e) {
    console.error('Error updating user role:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการอัปเดตสิทธิ์' });
  }
});

// ===== Admin Products Management =====

// Admin API - Get all products
app.get('/api/admin/products', authMiddleware, adminMiddleware, async (req: any, res) => {
  try {
    const products = await prisma.product.findMany({
      orderBy: { createdAt: 'desc' }
    });
    res.json(products);
  } catch (e) {
    console.error('Error fetching products:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลสินค้า' });
  }
});

// Admin API - Create product
app.post('/api/admin/products', authMiddleware, adminMiddleware, async (req: any, res) => {
  try {
    const { 
      name, model, price, originalPrice, image, category, description, 
      stock, rating, reviews, isBestSeller, isOnSale, discount 
    } = req.body;
    
    if (!name || !model || !price || !image || !category || !description) {
      return res.status(400).json({ message: 'กรุณากรอกข้อมูลที่จำเป็น' });
    }
    
    const product = await prisma.product.create({
      data: {
        name,
        model,
        price: parseFloat(price),
        originalPrice: parseFloat(originalPrice || price),
        image,
        category,
        description,
        stock: parseInt(stock) || 0,
        rating: parseFloat(rating) || 0,
        reviews: parseInt(reviews) || 0,
        isBestSeller: isBestSeller || false,
        isOnSale: isOnSale || false,
        discount: parseInt(discount) || 0
      }
    });
    
    res.json({ message: 'เพิ่มสินค้าสำเร็จ', product });
  } catch (e) {
    console.error('Error creating product:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการเพิ่มสินค้า' });
  }
});

// Admin API - Update product
app.put('/api/admin/products/:id', authMiddleware, adminMiddleware, async (req: any, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;
    
    // Convert numeric fields
    if (updateData.price) updateData.price = parseFloat(updateData.price);
    if (updateData.originalPrice) updateData.originalPrice = parseFloat(updateData.originalPrice);
    if (updateData.stock) updateData.stock = parseInt(updateData.stock);
    if (updateData.rating) updateData.rating = parseFloat(updateData.rating);
    if (updateData.reviews) updateData.reviews = parseInt(updateData.reviews);
    if (updateData.discount) updateData.discount = parseInt(updateData.discount);
    
    const product = await prisma.product.update({
      where: { id: parseInt(id) },
      data: updateData
    });
    
    res.json({ message: 'อัปเดตสินค้าสำเร็จ', product });
  } catch (e) {
    console.error('Error updating product:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการอัปเดตสินค้า' });
  }
});

// Admin API - Delete product
app.delete('/api/admin/products/:id', authMiddleware, adminMiddleware, async (req: any, res) => {
  try {
    const { id } = req.params;
    
    await prisma.product.delete({
      where: { id: parseInt(id) }
    });
    
    res.json({ message: 'ลบสินค้าสำเร็จ' });
  } catch (e) {
    console.error('Error deleting product:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการลบสินค้า' });
  }
});

// Admin API - Update product stock
app.put('/api/admin/products/:id/stock', authMiddleware, adminMiddleware, async (req: any, res) => {
  try {
    const { id } = req.params;
    const { action, quantity } = req.body;
    
    if (!action || !quantity || !['increase', 'decrease', 'set'].includes(action)) {
      return res.status(400).json({ message: 'ข้อมูลไม่ถูกต้อง' });
    }
    
    const product = await prisma.product.findUnique({
      where: { id: parseInt(id) }
    });
    
    if (!product) {
      return res.status(404).json({ message: 'ไม่พบสินค้า' });
    }
    
    let newStock = product.stock;
    
    switch (action) {
      case 'increase':
        newStock = product.stock + parseInt(quantity);
        break;
      case 'decrease':
        newStock = Math.max(0, product.stock - parseInt(quantity));
        break;
      case 'set':
        newStock = parseInt(quantity);
        break;
    }
    
    const updatedProduct = await prisma.product.update({
      where: { id: parseInt(id) },
      data: { stock: newStock }
    });
    
    res.json({ 
      message: 'อัปเดตจำนวนสินค้าสำเร็จ', 
      product: updatedProduct,
      oldStock: product.stock,
      newStock: newStock
    });
  } catch (e) {
    console.error('Error updating product stock:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการอัปเดตจำนวนสินค้า' });
  }
});

// ===== Admin Orders Management =====

// Admin API - Get all orders with user details
app.get('/api/admin/orders', authMiddleware, adminMiddleware, async (req: any, res) => {
  try {
    const orders = await prisma.order.findMany({
      include: {
        user: {
          select: {
            id: true,
            name: true,
            email: true,
            phone: true
          }
        },
        orderItems: {
          include: {
            product: {
              select: {
                id: true,
                name: true,
                model: true,
                image: true
              }
            }
          }
        }
      },
      orderBy: { createdAt: 'desc' }
    });
    res.json(orders);
  } catch (e) {
    console.error('Error fetching orders:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลคำสั่งซื้อ' });
  }
});

// Admin API - Update order status
app.put('/api/admin/orders/:id/status', authMiddleware, adminMiddleware, async (req: any, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    
    if (!['PENDING', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED'].includes(status)) {
      return res.status(400).json({ message: 'สถานะไม่ถูกต้อง' });
    }
    
    const order = await prisma.order.update({
      where: { id },
      data: { status }
    });
    
    res.json({ message: 'อัปเดตสถานะคำสั่งซื้อสำเร็จ', order });
  } catch (e) {
    console.error('Error updating order status:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการอัปเดตสถานะ' });
  }
});

// Admin API - Get order details
app.get('/api/admin/orders/:id', authMiddleware, adminMiddleware, async (req: any, res) => {
  try {
    const { id } = req.params;
    
    const order = await prisma.order.findUnique({
      where: { id },
      include: {
        user: {
          select: {
            id: true,
            name: true,
            email: true,
            phone: true,
            address: true
          }
        },
        orderItems: {
          include: {
            product: {
              select: {
                id: true,
                name: true,
                model: true,
                image: true,
                price: true
              }
            }
          }
        }
      }
    });
    
    if (!order) {
      return res.status(404).json({ message: 'ไม่พบคำสั่งซื้อ' });
    }
    
    res.json(order);
  } catch (e) {
    console.error('Error fetching order details:', e);
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลคำสั่งซื้อ' });
  }
});

// Error handling middleware
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error(err.stack);
  res.status(500).json({ 
    message: 'เกิดข้อผิดพลาดในระบบ',
    error: process.env.NODE_ENV === 'development' ? err.message : {}
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ message: 'ไม่พบ API endpoint ที่ต้องการ' });
});

// Start server
app.listen(PORT, async () => {
  console.log(`🚀 Server is running on port ${PORT}`);
  
  // ตรวจสอบการตั้งค่า email
  if (EMAIL_USER && EMAIL_PASS) {
    console.log('📧 Email service is configured');
  } else {
    console.log('⚠️  Email service is not configured');
    console.log('   Please set EMAIL_USER and EMAIL_PASS in your .env file');
  }
  
  console.log(`📊 API Documentation:`);
  console.log(`   GET  /api/products - รายการสินค้าทั้งหมด`);
  console.log(`   GET  /api/products/bestsellers - สินค้าขายดี`);
  console.log(`   GET  /api/cart - ข้อมูลตะกร้าสินค้า`);
  console.log(`   POST /api/cart - เพิ่มสินค้าลงตะกร้า`);
  console.log(`   GET  /api/user - ข้อมูลผู้ใช้`);
  console.log(`   GET  /api/orders - ประวัติคำสั่งซื้อ`);
  console.log(`   GET  /api/promotions - โปรโมชั่น`);
  console.log(`   POST /api/contact - ส่งข้อความติดต่อ`);
  console.log(`   POST /api/auth/forgot-password - ลืมรหัสผ่าน`);
  console.log(`   POST /api/auth/reset-password - รีเซ็ตรหัสผ่าน`);
});

// Graceful shutdown
process.on('SIGINT', async () => {
  await prisma.$disconnect();
  process.exit(0);
}); 