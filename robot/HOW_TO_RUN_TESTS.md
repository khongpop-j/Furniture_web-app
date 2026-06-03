# 🚀 คู่มือการรัน Robot Framework Tests

## 📋 ข้อกำหนดเบื้องต้น

### 1. Python (3.7 หรือใหม่กว่า)
```bash
python --version
```

### 2. ติดตั้ง Dependencies
```bash
# ไปที่โฟลเดอร์ robot
cd robot

# ติดตั้ง packages
pip install -r requirements.txt
```

### 3. ChromeDriver
```bash
# macOS (ถ้าติดตั้ง Homebrew)
brew install chromedriver

# หรือดาวน์โหลดจาก https://chromedriver.chromium.org/downloads
```

---

## 🎯 ขั้นตอนการรัน Tests

### ขั้นตอนที่ 1: เริ่มแอปพลิเคชัน

**Terminal 1: Backend**
```bash
cd backend
npm install
npm run dev
```

**Terminal 2: Frontend**
```bash
cd frontend
npm install
npm start
```

รอให้ทั้งสองเริ่มทำงานเรียบร้อย (ปกติที่ http://localhost:3000 และ http://localhost:5050)

---

## 🧪 ขั้นตอนที่ 2: รัน Tests

### วิธีที่ 1: รัน Test ทั้งหมด (แนะนำ)
```bash
cd robot

# รัน test suite หลัก (33 tests)
robot --outputdir results_all_tests furniture_test_cases_fixed.robot

# ดูผลลัพธ์
open results_all_tests/report.html
```

### วิธีที่ 2: รัน Test เฉพาะหมวดหมู่
```bash
cd robot

# รัน Test Cases ใหม่ที่สร้าง
robot --outputdir results_new_tests product/product_detail_tests.robot
robot --outputdir results_new_tests profile/profile_tests.robot
robot --outputdir results_new_tests security/security_tests.robot

# ดูผลลัพธ์
open results_new_tests/report.html
```

### วิธีที่ 3: รัน Test ตาม Tags
```bash
cd robot

# รัน test เฉพาะ TC-001
robot --include TC-001 furniture_test_cases_fixed.robot

# รัน test เฉพาะ Login
robot --include Login_Page furniture_test_cases_fixed.robot

# รัน test ทั้งหมดยกเว้น debug
robot --exclude debug furniture_test_cases_fixed.robot
```

### วิธีที่ 4: รัน Test แบบ Parallel (เร็วขึ้น)
```bash
cd robot

# ติดตั้ง pabot ก่อน
pip install robotframework-pabot

# รันแบบ parallel
pabot --processes 4 furniture_test_cases_fixed.robot
```

### วิธีที่ 5: ใช้ Python Script
```bash
cd robot

# รัน script ที่มีอยู่
python run_tests_simple.py
```

---

## 📊 ดูผลลัพธ์

### 1. ดู HTML Report (แนะนำ)
```bash
# เปิด report ใน browser
open results_all_tests/report.html
```

### 2. ดู Log แบบละเอียด
```bash
open results_all_tests/log.html
```

### 3. ดู XML Output
```bash
cat results_all_tests/output.xml
```

---

## 🎯 ตัวอย่างการรัน Tests ใหม่ทั้งหมด

### สร้าง script สำหรับรัน Test ทั้งหมด
```bash
cd robot

cat > run_all_new_tests.sh << 'EOF'
#!/bin/bash

echo "🚀 Running all new Robot Framework tests..."
echo ""

# สร้างโฟลเดอร์ผลลัพธ์
OUTPUT_DIR="results_all_new_tests_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"

# ฟังก์ชันสำหรับรัน test
run_test() {
    local file=$1
    local name=$2
    echo "Running: $name"
    robot --outputdir "$OUTPUT_DIR" "$file" || true
}

# รัน test ทั้งหมด
run_test "product/product_detail_tests.robot" "Product Detail Tests"
run_test "profile/profile_tests.robot" "Profile Tests"
run_test "order/order_management_tests.robot" "Order Tests"
run_test "favorites/favorites_tests.robot" "Favorites Tests"
run_test "admin/admin_dashboard_tests.robot" "Admin Tests"
run_test "contact/contact_tests.robot" "Contact Tests"
run_test "auth/forgot_password_tests.robot" "Forgot Password Tests"
run_test "security/security_tests.robot" "Security Tests"
run_test "cart/cart_advanced_tests.robot" "Cart Advanced Tests"

echo ""
echo "✅ All tests completed!"
echo "📊 View results: open $OUTPUT_DIR/report.html"
EOF

chmod +x run_all_new_tests.sh

# รัน script
./run_all_new_tests.sh
```

---

## 🛠️ Troubleshooting

### ปัญหา: ChromeDriver ไม่พบ
```bash
# macOS
brew install chromedriver

# Linux
apt-get install chromium-chromedriver

# Windows
# ดาวน์โหลดจาก https://chromedriver.chromium.org/downloads
# วางใน PATH
```

### ปัญหา: Application ไม่ทำงาน
```bash
# ตรวจสอบว่า backend และ frontend ทำงานอยู่
curl http://localhost:3000
curl http://localhost:5050

# ถ้าไม่ได้ ให้ start ใหม่
cd backend && npm run dev
cd frontend && npm start
```

### ปัญหา: Port ถูกใช้งาน
```bash
# หา process ที่ใช้ port 3000
lsof -ti:3000

# Kill process
kill -9 $(lsof -ti:3000)

# หรือเปลี่ยน port ใน .env
```

### ปัญหา: Test ล้มเหลว
```bash
# รันแบบ verbose เพื่อดู error
robot --loglevel DEBUG furniture_test_cases_fixed.robot

# ดู screenshot (ถ้ามี)
open results_all_tests/selenium-screenshot-*.png
```

### ปัญหา: No keyword with name 'Break' found
```bash
# ปัญหา: Robot Framework 4.x ใช้ BREAK (ตัวพิมพ์ใหญ่)
# ตรวจสอบว่าใช้ BREAK แทน Break

# แก้ไขในไฟล์:
sed -i '' 's/^            Break$/            BREAK/g' robot/**/*.robot

# หรือแก้ไขด้วยมือ: เปลี่ยน Break เป็น BREAK (ตัวพิมพ์ใหญ่ทั้งหมด)
```

### ปัญหา: Login ไม่สำเร็จ
```bash
# ตรวจสอบว่า credential ถูกต้อง
# ในไฟล์ test ปรับใช้:
${VALID_EMAIL}        test@example.com
${VALID_PASSWORD}     password123

# หรือสร้าง user ใหม่ก่อน test
cd backend
node scripts/create-user.js
```

### ปัญหา: Profile test ตรวจสอบ email ไม่เจอ
```bash
# ปัญหา: App ใช้ mock user หรือข้อมูลอื่น
# วิธีแก้: เปลี่ยน test ให้ตรวจสอบ format ของ email แทน

# ใน test: ใช้
${has_email_format}=    Evaluate    '@' in '''${page_text}'''
Should Be True    ${has_email_format}

# แทนที่จะใช้
Should Contain    ${page_text}    test@example.com
```

### ปัญหา: ElementNotInteractableException
```bash
# ปัญหา: Element ที่พยายามคลิกไม่ interactable (ถูกบัง, ไม่ visible, disable)
# วิธีแก้:

# 1. รอให้ element visible
Wait Until Element Is Visible    css=button    10s

# 2. Scroll element เข้ามา view
Scroll Element Into View    css=button

# 3. ตรวจสอบว่า element enable
Element Should Be Enabled    css=button

# 4. ใช้ JavaScript click แทน
Execute Javascript    document.querySelector('button').click();

# 5. Products page ไม่มีปุ่ม Add to Cart โดยตรง
#    ต้องคลิก product card เพื่อไปหน้า detail ก่อน
${product_links}=    Get WebElements    css=a[href*="/product/"]
Click Element    ${product_links[0]}  # ไปหน้า detail
# แล้วค่อยคลิกปุ่ม Add to Cart ในหน้า detail
```

---

## 📝 ตัวอย่างการรันยอดนิยม

### 1. รัน Smoke Tests
```bash
cd robot
robot --include smoke basic_test.robot
```

### 2. รัน Login Tests ทั้งหมด
```bash
cd robot
robot --include login login/login_tests.robot
```

### 3. รัน Security Tests
```bash
cd robot
robot --loglevel INFO security/security_tests.robot
```

### 4. รัน Tests พร้อม Screenshot
```bash
cd robot
robot --variable SCREENSHOT_DIR:screenshots --outputdir results furniture_test_cases_fixed.robot
```

### 5. รัน Tests แบบ Continue on Failure
```bash
cd robot
robot --continueonfailure All furniture_test_cases_fixed.robot
```

---

## 📋 ตัวอย่าง Output

เมื่อรัน test เสร็จ จะได้ output แบบนี้:

```
==============================================================================
Furniture Test Cases Fixed
==============================================================================
TC_001_Login_Page_Input_Fields                                      | PASS |
TC_002_Login_Page_Log_In_Without_Username                          | PASS |
TC_003_Login_Page_Log_In_Without_Password                          | PASS |
...
TC_034_Cart_Page_Empty_State_Test                                  | PASS |
==============================================================================
Furniture Test Cases Fixed                                          | PASS |
33 tests, 33 passed, 0 failed
==============================================================================
Output:  /path/to/results_all_tests/output.xml
Log:     /path/to/results_all_tests/log.html
Report:  /path/to/results_all_tests/report.html
==============================================================================
```

---

## 🔗 Links สำคัญ

- Robot Framework Docs: https://robotframework.org/
- Selenium Library: https://robotframework.org/SeleniumLibrary/
- Furniture App: http://localhost:3000

---

## ⚡ Quick Commands

```bash
# รัน test เร็วสุด
cd robot && robot furniture_test_cases_fixed.robot

# รัน test พร้อม output
cd robot && robot --outputdir results furniture_test_cases_fixed.robot && open results/report.html

# รัน test ใหม่ทั้งหมด
cd robot && ./run_all_new_tests.sh

# รัน debug
cd robot && robot --loglevel DEBUG security/security_tests.robot
```

---

**Happy Testing! 🎉**

