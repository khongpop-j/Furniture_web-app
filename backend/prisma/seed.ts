import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 เริ่มต้นเพิ่มข้อมูลตัวอย่าง...');

  // ลบข้อมูลเดิม
  await prisma.orderItem.deleteMany();
  await prisma.order.deleteMany();
  await prisma.cartItem.deleteMany();
  await prisma.product.deleteMany();
  await prisma.user.deleteMany();
  await prisma.promotion.deleteMany();
  await prisma.contact.deleteMany();

  // สร้างผู้ใช้
  const hashedPassword = await bcrypt.hash('password123', 10);
  const user = await prisma.user.create({
    data: {
      name: 'สมชาย ใจดี',
      email: 'somchai@example.com',
      password: hashedPassword,
      phone: '081-234-5678',
      address: '123 ถนนสุขุมวิท แขวงคลองเตย เขตคลองเตย กรุงเทพฯ 10110',
      avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150'
    }
  });

  console.log('✅ สร้างผู้ใช้เรียบร้อย');

  // สร้างสินค้า
  const products = await Promise.all([
    prisma.product.create({
      data: {
        name: 'ตู้เหล็ก 18 ช่องโล่ง',
        model: 'KEL-097',
        price: 5000.00,
        originalPrice: 6000.00,
        image: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
        category: 'ตู้เก็บเอกสาร',
        description: 'ตู้เหล็กคุณภาพสูง 18 ช่อง สำหรับเก็บเอกสารและของใช้ในสำนักงาน',
        stock: 15,
        rating: 4.5,
        reviews: 28,
        isBestSeller: true,
        isOnSale: true,
        discount: 17
      }
    }),
    prisma.product.create({
      data: {
        name: 'ชั้นวางหนังสือ แบบตรง',
        model: 'KEL-097',
        price: 3500.00,
        originalPrice: 4200.00,
        image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        category: 'ชั้นวางหนังสือ',
        description: 'ชั้นวางหนังสือแบบตรง ไม้คุณภาพดี เหมาะสำหรับห้องสมุดและสำนักงาน',
        stock: 22,
        rating: 4.3,
        reviews: 15,
        isBestSeller: true,
        isOnSale: true,
        discount: 17
      }
    }),
    prisma.product.create({
      data: {
        name: 'ชั้นวางหนังสือ แบบเอียง',
        model: 'KEL-095',
        price: 4400.00,
        originalPrice: 5200.00,
        image: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400',
        category: 'ชั้นวางหนังสือ',
        description: 'ชั้นวางหนังสือแบบเอียง ดีไซน์สวยงาม ใช้งานง่าย',
        stock: 8,
        rating: 4.7,
        reviews: 32,
        isBestSeller: false,
        isOnSale: true,
        discount: 15
      }
    }),
    prisma.product.create({
      data: {
        name: 'ตู้ชั้นวาง 80',
        model: 'KIB-156',
        price: 1690.00,
        originalPrice: 1690.00,
        image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
        category: 'ตู้จัดแสดง',
        description: 'ตู้ชั้นวางขนาด 80 ซม. เหมาะสำหรับจัดแสดงสินค้าและของใช้',
        stock: 30,
        rating: 4.1,
        reviews: 12,
        isBestSeller: false,
        isOnSale: false,
        discount: 0
      }
    }),
    prisma.product.create({
      data: {
        name: 'โต๊ะทำงาน 120 ซม.',
        model: 'DESK-120',
        price: 8900.00,
        originalPrice: 10500.00,
        image: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
        category: 'โต๊ะทำงาน',
        description: 'โต๊ะทำงานขนาด 120 ซม. ไม้คุณภาพดี มีลิ้นชักเก็บของ',
        stock: 12,
        rating: 4.8,
        reviews: 45,
        isBestSeller: true,
        isOnSale: true,
        discount: 15
      }
    }),
    prisma.product.create({
      data: {
        name: 'เก้าอี้สำนักงาน หมุนได้',
        model: 'CHAIR-001',
        price: 3200.00,
        originalPrice: 3800.00,
        image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        category: 'เก้าอี้',
        description: 'เก้าอี้สำนักงานหมุนได้ นั่งสบาย ปรับความสูงได้',
        stock: 25,
        rating: 4.4,
        reviews: 38,
        isBestSeller: true,
        isOnSale: true,
        discount: 16
      }
    }),
    prisma.product.create({
      data: {
        name: 'ตู้ลิ้นชัก 5 ลิ้นชัก',
        model: 'DRAWER-005',
        price: 2800.00,
        originalPrice: 2800.00,
        image: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400',
        category: 'ตู้ลิ้นชัก',
        description: 'ตู้ลิ้นชัก 5 ลิ้นชัก เก็บของได้มาก ใช้งานสะดวก',
        stock: 18,
        rating: 4.2,
        reviews: 20,
        isBestSeller: false,
        isOnSale: false,
        discount: 0
      }
    }),
    prisma.product.create({
      data: {
        name: 'ชั้นวางเอกสาร แบบแขวน',
        model: 'WALL-001',
        price: 1200.00,
        originalPrice: 1500.00,
        image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
        category: 'ชั้นวางเอกสาร',
        description: 'ชั้นวางเอกสารแบบแขวนประตู ประหยัดพื้นที่',
        stock: 35,
        rating: 4.0,
        reviews: 8,
        isBestSeller: false,
        isOnSale: true,
        discount: 20
      }
    })
  ]);

  console.log(`✅ สร้างสินค้า ${products.length} รายการเรียบร้อย`);

  // เพิ่มสินค้าลงตะกร้า
  await prisma.cartItem.create({
    data: {
      userId: user.id,
      productId: products[0].id,
      quantity: 1
    }
  });

  console.log('✅ เพิ่มสินค้าลงตะกร้าเรียบร้อย');

  // สร้างคำสั่งซื้อตัวอย่าง
  const order = await prisma.order.create({
    data: {
      userId: user.id,
      total: 5000.00,
      status: 'PENDING',
      shippingAddress: '123 ถนนสุขุมวิท แขวงคลองเตย เขตคลองเตย กรุงเทพฯ 10110'
    }
  });

  await prisma.orderItem.create({
    data: {
      orderId: order.id,
      productId: products[0].id,
      name: products[0].name,
      price: products[0].price,
      quantity: 1
    }
  });

  console.log('✅ สร้างคำสั่งซื้อตัวอย่างเรียบร้อย');

  // สร้างโปรโมชั่น
  const promotions = await Promise.all([
    prisma.promotion.create({
      data: {
        title: 'ลดพิเศษ 20% สำหรับตู้เก็บเอกสาร',
        description: 'ลดพิเศษ 20% สำหรับตู้เก็บเอกสารทุกรุ่น หมดเขต 31 มกราคม 2024',
        discount: 20,
        validUntil: new Date('2024-01-31'),
        image: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
        category: 'ตู้เก็บเอกสาร'
      }
    }),
    prisma.promotion.create({
      data: {
        title: 'ซื้อชั้นวางหนังสือ 2 ชั้น ฟรีชั้นที่ 3',
        description: 'ซื้อชั้นวางหนังสือ 2 ชั้น รับฟรีชั้นที่ 3 ทันที',
        discount: 33,
        validUntil: new Date('2024-02-15'),
        image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        category: 'ชั้นวางหนังสือ'
      }
    }),
    prisma.promotion.create({
      data: {
        title: 'โปรโมชั่นเก้าอี้สำนักงาน',
        description: 'ลดพิเศษ 15% สำหรับเก้าอี้สำนักงานทุกรุ่น',
        discount: 15,
        validUntil: new Date('2024-01-25'),
        image: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400',
        category: 'เก้าอี้'
      }
    })
  ]);

  console.log(`✅ สร้างโปรโมชั่น ${promotions.length} รายการเรียบร้อย`);

  console.log('🎉 เพิ่มข้อมูลตัวอย่างเสร็จสิ้น!');
}

main()
  .catch((e) => {
    console.error('❌ เกิดข้อผิดพลาด:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  }); 