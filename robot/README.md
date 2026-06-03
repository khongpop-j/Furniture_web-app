# 🏠 Furniture Office Application - Automated Testing

ระบบ Automated Testing ด้วย Robot Framework สำหรับ Furniture Office Application

## 📋 สารบัญ

- [การติดตั้ง](#การติดตั้ง)
- [การรัน Tests](#การรัน-tests)
- [โครงสร้าง Test Files](#โครงสร้าง-test-files)
- [Test Cases ที่มี](#test-cases-ที่มี)
- [การตั้งค่า](#การตั้งค่า)
- [การแก้ไขปัญหา](#การแก้ไขปัญหา)

## 🚀 การติดตั้ง

### 1. ตรวจสอบ Python
```bash
python --version
# ต้องเป็น Python 3.7 หรือใหม่กว่า
```

### 2. ติดตั้ง Dependencies
```bash
pip install -r requirements.txt
```

### 3. ตรวจสอบการติดตั้ง
```bash
python -c "import robot"
```

## 🏃‍♂️ การรัน Tests

### วิธีที่ 1: ใช้ Robot Command โดยตรง
```bash
# รัน tests ทั้งหมด
robot furniture_test_cases_fixed.robot

# รัน tests พร้อมระบุ output directory
robot --outputdir results furniture_test_cases_fixed.robot

# รัน tests เฉพาะ tags
robot --include TC-001 furniture_test_cases_fixed.robot

# รัน tests แบบ verbose
robot --loglevel DEBUG furniture_test_cases_fixed.robot
```

### วิธีที่ 2: ใช้ Python Script
```bash
# รัน tests พร้อมสรุปผล
python run_tests_simple.py
```

## 📁 โครงสร้าง Test Files

```
AutomatedTest/robot/
├── furniture_test_cases_fixed.robot      # Test suite หลัก (21 tests)
├── furniture_resource.robot              # Resource file หลัก
├── furniture_test_suite.robot            # Test suite เดิม
├── requirements.txt                      # Dependencies
├── README.md                             # คู่มือการใช้งาน
├── run_tests_simple.py                   # Python script สำหรับรัน tests
├── basic_test.robot                      # Basic test cases
├── simple_test.robot                     # Simple test cases
├── simple_login_test.robot               # Login test cases
└── results_*/                            # Result directories
    ├── report.html                       # HTML report
    ├── log.html                          # Detailed log
    └── output.xml                        # XML output
```

## 🧪 Test Cases ที่มี

### 1. Main Test Suite (`furniture_test_suite.robot`)
- 🏠 Home Page Load Test
- 🧭 Navigation Test
- 🔐 Login Flow Test
- 📝 Register Flow Test
- 🛍️ Product Interaction Test
- 🛒 Cart Functionality Test
- 🚀 Full User Journey Test
- 🔐 Login And Product Interaction Test
- ⚡ Page Load Performance Test
- ⚡ Products Page Performance Test
- 📱 Mobile Responsive Test
- 📱 Tablet Responsive Test
- 📱 Desktop Responsive Test
- 🚨 Network Error Test
- 🚨 Invalid URL Test

### 2. Login Tests (`login/login_tests.robot`)
- ✅ Valid Login Test
- ❌ Invalid Email Login Test
- ❌ Invalid Password Login Test
- ❌ Empty Email Login Test
- ❌ Empty Password Login Test
- ❌ Empty Fields Login Test
- 🔍 Login Page Elements Test
- 🔍 Login Form Validation Test
- 🧭 Login Navigation Test

### 3. Products Tests (`products/products_tests.robot`)
- 🔍 Products Page Load Test
- 🔍 Products Display Test
- 🔍 Product Click Test
- 🛒 Add To Cart Test
- 🧭 Products Navigation Test
- 🔍 Products Search Test
- 🔍 Products Filter Test
- 📱 Products Responsive Test
- ⚡ Products Performance Test
- 🚨 Products Error Handling Test

### 4. Cart Tests (`cart/cart_tests.robot`)
- 🛒 Empty Cart Test
- ➕ Add Item To Cart Test
- ➖ Remove Item From Cart Test
- 🔢 Update Cart Quantity Test
- 💰 Cart Total Calculation Test
- 💾 Cart Persistence Test
- 🧭 Cart Navigation Test
- 🛒 Cart Checkout Button Test
- 🛒 Cart Empty State Test
- 📱 Cart Responsive Test

## ⚙️ การตั้งค่า

### 1. ตั้งค่า URL และ Browser
แก้ไขไฟล์ `furniture_resource.robot`:

```robot
*** Variables ***
${BASE_URL}           http://localhost:3000    # เปลี่ยนเป็น URL ของคุณ
${BROWSER}            Chrome                   # เปลี่ยนเป็น browser ที่ต้องการ
```

### 2. ตั้งค่า Google Sheets
แก้ไขไฟล์ `google_sheets_resource.robot`:

```robot
*** Variables ***
${GOOGLE_SHEETS_ID}      1BnX1L9JOEGjCuoAmGm5xq65iowU_twHpvSO2wjtfy-Y
${CREDENTIALS_FILE}      credentials.json
${SHEET_NAME}            Test Results
${SUMMARY_SHEET_NAME}    Summary
```

### 3. ตั้งค่า Test Data
แก้ไขไฟล์ `furniture_resource.robot`:

```robot
*** Variables ***
${VALID_EMAIL}        test@example.com        # เปลี่ยนเป็น email ที่ใช้ทดสอบ
${VALID_PASSWORD}     password123             # เปลี่ยนเป็น password ที่ใช้ทดสอบ
${VALID_NAME}         Test User               # เปลี่ยนเป็นชื่อที่ใช้ทดสอบ
```

## 🏷️ Tags ที่ใช้

- `smoke` - Tests พื้นฐานที่สำคัญ
- `regression` - Tests สำหรับ regression testing
- `performance` - Tests สำหรับประสิทธิภาพ
- `responsive` - Tests สำหรับ responsive design
- `error` - Tests สำหรับ error handling
- `login` - Tests สำหรับหน้า login
- `products` - Tests สำหรับหน้า products
- `cart` - Tests สำหรับหน้า cart
- `navigation` - Tests สำหรับการนำทาง
- `valid` - Tests สำหรับข้อมูลที่ถูกต้อง
- `invalid` - Tests สำหรับข้อมูลที่ไม่ถูกต้อง
- `empty` - Tests สำหรับฟิลด์ว่าง
- `validation` - Tests สำหรับ validation
- `elements` - Tests สำหรับ elements
- `load` - Tests สำหรับการโหลดหน้า
- `display` - Tests สำหรับการแสดงผล
- `click` - Tests สำหรับการคลิก
- `add` - Tests สำหรับการเพิ่ม
- `remove` - Tests สำหรับการลบ
- `quantity` - Tests สำหรับจำนวน
- `total` - Tests สำหรับยอดรวม
- `persistence` - Tests สำหรับการคงอยู่
- `checkout` - Tests สำหรับ checkout
- `mobile` - Tests สำหรับมือถือ
- `tablet` - Tests สำหรับแท็บเล็ต
- `desktop` - Tests สำหรับเดสก์ท็อป
- `network` - Tests สำหรับเครือข่าย
- `url` - Tests สำหรับ URL

## 📊 การดูผลลัพธ์

### 1. Google Sheets
- เปิด Google Sheets: https://docs.google.com/spreadsheets/d/1BnX1L9JOEGjCuoAmGm5xq65iowU_twHpvSO2wjtfy-Y
- ดู Sheet "Test Results" สำหรับผลลัพธ์การทดสอบ
- ดู Sheet "Summary" สำหรับสถิติโดยรวม

### 2. Local Reports
หลังจากรัน tests เสร็จแล้ว จะได้ไฟล์ผลลัพธ์ในโฟลเดอร์ `results`:

- `report.html` - รายงานผลลัพธ์ (เปิดใน browser)
- `log.html` - รายละเอียดการรัน tests
- `output.xml` - ผลลัพธ์ในรูปแบบ XML

## 🚨 การแก้ไขปัญหา

### 1. Google Sheets API Error
```bash
# ตรวจสอบว่า credentials.json ถูกต้อง
# ตรวจสอบว่า Google Sheets API เปิดใช้งานแล้ว
# ตรวจสอบว่า Sheet ID ถูกต้อง
```

### 2. Browser ไม่เปิด
```bash
# ตรวจสอบว่า ChromeDriver ติดตั้งแล้วหรือไม่
# ดาวน์โหลดจาก: https://chromedriver.chromium.org/
# วางใน PATH หรือในโฟลเดอร์เดียวกับ Python
```

### 3. Tests ล้มเหลว
```bash
# ตรวจสอบว่า application ทำงานอยู่หรือไม่
# ตรวจสอบ URL ในไฟล์ furniture_resource.robot
# ตรวจสอบ elements selectors
```

### 4. Dependencies ไม่ติดตั้ง
```bash
# อัปเดต pip
python -m pip install --upgrade pip

# ติดตั้ง dependencies ใหม่
pip install -r requirements.txt --force-reinstall
```

## 🔧 การปรับแต่ง

### 1. เพิ่ม Test Cases ใหม่
1. สร้างไฟล์ `.robot` ใหม่ในโฟลเดอร์ที่เหมาะสม
2. Import `furniture_resource.robot`
3. เขียน test cases ตามรูปแบบที่มีอยู่

### 2. เพิ่ม Keywords ใหม่
1. แก้ไขไฟล์ `furniture_resource.robot`
2. เพิ่ม keywords ในส่วน `*** Keywords ***`

### 3. เพิ่ม Variables ใหม่
1. แก้ไขไฟล์ `furniture_resource.robot`
2. เพิ่ม variables ในส่วน `*** Variables ***`

## 📞 การสนับสนุน

หากมีปัญหาหรือคำถาม สามารถติดต่อได้ที่:
- 📧 Email: support@furniture-office.com
- 📱 LINE: @furniture-office
- 🌐 Website: https://furniture-office.com

---

**หมายเหตุ:** Test cases เหล่านี้ถูกออกแบบมาสำหรับ Furniture Office Application หากต้องการใช้กับ application อื่น ต้องปรับแต่ง selectors และ test data ให้เหมาะสม

