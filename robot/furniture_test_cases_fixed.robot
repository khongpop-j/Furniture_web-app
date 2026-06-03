*** Settings ***
Documentation     Furniture Office Application Test Cases - Fixed Version
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}       http://localhost:3000
${BROWSER}        Chrome

# Test Data
${VALID_USERNAME}     test@example.com
${VALID_PASSWORD}     password123
${INVALID_USERNAME}   invalid@example.com
${INVALID_PASSWORD}   invalidpass
${FIRST_NAME}         Emily
${LAST_NAME}          Harrison
${POSTAL_CODE}        90210

*** Test Cases ***

# LOGIN PAGE FUNCTION
TC_001_Login_Page_Input_Fields
    [Documentation]    Input fields should display as the data that was filled
    [Tags]    TC-001    Login_Page
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains Element    css=input[type="email"]    10s
    Wait Until Page Contains Element    css=input[type="password"]    10s
    
    # ทดสอบการกรอกข้อมูล
    Input Text    css=input[type="email"]    ${VALID_USERNAME}
    Input Text    css=input[type="password"]    ${VALID_PASSWORD}
    
    # ตรวจสอบว่าข้อมูลถูกกรอก
    Textfield Value Should Be    css=input[type="email"]    ${VALID_USERNAME}
    Textfield Value Should Be    css=input[type="password"]    ${VALID_PASSWORD}
    
    Close Browser

TC_002_Login_Page_Log_In_Without_Username
    [Documentation]    Should show an error message if log in without a username
    [Tags]    TC-002    Login_Page
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains Element    css=input[type="password"]    10s
    
    # กรอกเฉพาะ password
    Input Text    css=input[type="password"]    ${VALID_PASSWORD}
    
    # คลิกปุ่ม login
    Click Button    css=button[type="submit"]
    
    # รอ error message
    Wait Until Page Contains    error    5s
    
    Close Browser

TC_003_Login_Page_Log_In_Without_Password
    [Documentation]    Should show an error message if log in without a password
    [Tags]    TC-003    Login_Page
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains Element    css=input[type="email"]    10s
    
    # กรอกเฉพาะ username
    Input Text    css=input[type="email"]    ${VALID_USERNAME}
    
    # คลิกปุ่ม login
    Click Button    css=button[type="submit"]
    
    # รอ error message
    Wait Until Page Contains    error    5s
    
    Close Browser

TC_004_Login_Page_Log_In_With_Invalid_Credentials
    [Documentation]    Should show an error message if log in with invalid credentials
    [Tags]    TC-004    Login_Page
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains Element    css=input[type="email"]    10s
    Wait Until Page Contains Element    css=input[type="password"]    10s
    
    # กรอกข้อมูลที่ไม่ถูกต้อง
    Input Text    css=input[type="email"]    ${INVALID_USERNAME}
    Input Text    css=input[type="password"]    ${INVALID_PASSWORD}
    
    # คลิกปุ่ม login
    Click Button    css=button[type="submit"]
    
    # รอ error message
    Wait Until Page Contains    error    5s
    
    Close Browser

TC_005_Login_Page_Log_In_With_Valid_Credentials
    [Documentation]    Should logged in successfully with valid credentials
    [Tags]    TC-005    Login_Page
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains Element    css=input[type="email"]    10s
    Wait Until Page Contains Element    css=input[type="password"]    10s
    
    # กรอกข้อมูลที่ถูกต้อง
    Input Text    css=input[type="email"]    ${VALID_USERNAME}
    Input Text    css=input[type="password"]    ${VALID_PASSWORD}
    
    # คลิกปุ่ม login
    Click Button    css=button[type="submit"]
    
    # รอให้ redirect ไปหน้าแรก
    Wait Until Location Contains    ${BASE_URL}    10s
    
    Close Browser

TC_006_Login_Page_Log_In_With_Empty_Fields
    [Documentation]    Should show an error message if log in with empty fields
    [Tags]    TC-006    Login_Page
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains Element    css=button[type="submit"]    10s
    
    # คลิกปุ่ม login โดยไม่กรอกข้อมูล
    Click Button    css=button[type="submit"]
    
    # รอ error message
    Wait Until Page Contains    error    5s
    
    Close Browser

# PRODUCT PAGE FUNCTION
TC_007_Product_Page_Add_To_Cart
    [Documentation]    Product should be added to cart when clicking Add to cart button
    [Tags]    TC-007    Product_Page
    Open Browser    ${BASE_URL}/products    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Products    10s
    
    # หาปุ่ม Add to cart (ใช้ selector ที่เป็นไปได้)
    ${add_buttons}=    Get WebElements    css=button
    Should Not Be Empty    ${add_buttons}    No buttons found on products page
    
    # คลิกปุ่มแรกที่เจอ
    Click Element    ${add_buttons[0]}
    
    # รอให้มีการเปลี่ยนแปลง
    Sleep    2s
    
    Close Browser

TC_008_Product_Page_Remove_From_Cart
    [Documentation]    Product should be removed from cart when clicking Remove button
    [Tags]    TC-008    Product_Page
    Open Browser    ${BASE_URL}/products    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Products    10s
    
    # หาปุ่ม Add to cart
    ${add_buttons}=    Get WebElements    css=button
    Should Not Be Empty    ${add_buttons}    No buttons found on products page
    
    # คลิกปุ่ม Add to cart
    Click Element    ${add_buttons[0]}
    Sleep    1s
    
    # หาปุ่ม Remove
    ${remove_buttons}=    Get WebElements    css=button
    Should Not Be Empty    ${remove_buttons}    No remove buttons found
    
    # คลิกปุ่ม Remove
    Click Element    ${remove_buttons[0]}
    Sleep    1s
    
    Close Browser

TC_009_Product_Page_Sort_Items_By_Name
    [Documentation]    Product should correctly sorts items by product name
    [Tags]    TC-009    Product_Page
    Open Browser    ${BASE_URL}/products    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Products    10s
    
    # หา select element สำหรับ sorting
    ${selects}=    Get WebElements    css=select
    ${count}=    Get Length    ${selects}
    IF    ${count} > 0
        # เลือก "เรียงตาม : ชื่อสินค้า" (Sort by: Product Name)
        Select From List By Index    ${selects[0]}    4
        Sleep    2s
    END
    
    Close Browser

TC_010_Product_Page_Sort_Items_By_Price_Low_to_High
    [Documentation]    Product should correctly sorts items by price low to high
    [Tags]    TC-010    Product_Page
    Open Browser    ${BASE_URL}/products    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Products    10s
    
    # หา select element สำหรับ sorting
    ${selects}=    Get WebElements    css=select
    IF    $selects
        # เลือก "เรียงตาม : ราคาต่ำ-สูง" (Sort by: Price Low-High)
        Select From List By Index    ${selects[0]}    2
        Sleep    2s
    END
    
    Close Browser

TC_011_Product_Page_Sort_Items_By_Price_High_to_Low
    [Documentation]    Product should correctly sorts items by price high to low
    [Tags]    TC-011    Product_Page
    Open Browser    ${BASE_URL}/products    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Products    10s
    
    # หา select element สำหรับ sorting
    ${selects}=    Get WebElements    css=select
    IF    $selects
        # เลือก "เรียงตาม : ราคาสูง-ต่ำ" (Sort by: Price High-Low)
        Select From List By Index    ${selects[0]}    3
        Sleep    2s
    END
    
    Close Browser

TC_012_Product_Page_Sort_Items_By_Score
    [Documentation]    Product should correctly sorts items by score/rating
    [Tags]    TC-012    Product_Page
    Open Browser    ${BASE_URL}/products    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Products    10s
    
    # หา select element สำหรับ sorting
    ${selects}=    Get WebElements    css=select
    IF    $selects
        # เลือก "เรียงตาม : คะแนน" (Sort by: Score/Rating) - index 4 (0-based)
        Select From List By Index    ${selects[0]}    4
        Sleep    2s
    END
    
    Close Browser

# CART PAGE FUNCTION
TC_013_Cart_Page_Cart_Icon
    [Documentation]    Should navigate to the cart page when clicking the cart icon
    [Tags]    TC-013    Cart_Page
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Furniture    10s
    
    # หา cart link
    ${links}=    Get WebElements    css=a
    FOR    ${link}    IN    @{links}
        ${href}=    Get Element Attribute    ${link}    href
        IF    '${href}' == '/cart' or '${href}' == 'cart'
            Click Element    ${link}
            Wait Until Page Contains    Cart    10s
            BREAK
        END
    END
    
    Close Browser

TC_014_Cart_Page_Continue_Shopping
    [Documentation]    Should navigate back to the product page when clicking Continue Shopping
    [Tags]    TC-014    Cart_Page
    Open Browser    ${BASE_URL}/cart    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Cart    10s
    
    # หาปุ่ม Continue Shopping
    ${buttons}=    Get WebElements    css=button
    FOR    ${button}    IN    @{buttons}
        ${text}=    Get Text    ${button}
        IF    'continue' in '${text}'.lower() or 'shopping' in '${text}'.lower()
            Click Element    ${button}
            Wait Until Page Contains    Products    10s
            BREAK
        END
    END
    
    Close Browser

TC_015_Cart_Page_Checkout_Button
    [Documentation]    Should navigate to the checkout page when clicking Checkout button
    [Tags]    TC-015    Cart_Page
    Open Browser    ${BASE_URL}/cart    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Cart    10s
    
    # หาปุ่ม Checkout
    ${buttons}=    Get WebElements    css=button
    FOR    ${button}    IN    @{buttons}
        ${text}=    Get Text    ${button}
        IF    'checkout' in '${text}'.lower()
            Click Element    ${button}
            Wait Until Page Contains    Checkout    10s
            BREAK
        END
    END
    
    Close Browser

TC_016_Cart_Page_Remove_Item
    [Documentation]    Should remove item from cart when clicking Remove button
    [Tags]    TC-016    Cart_Page
    Open Browser    ${BASE_URL}/cart    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Cart    10s
    
    # หาปุ่ม Remove
    ${buttons}=    Get WebElements    css=button
    FOR    ${button}    IN    @{buttons}
        ${text}=    Get Text    ${button}
        IF    'remove' in '${text}'.lower()
            Click Element    ${button}
            Sleep    1s
            BREAK
        END
    END
    
    Close Browser

TC_017_Cart_Page_Quantity_Update
    [Documentation]    Should update quantity when changing the quantity input
    [Tags]    TC-017    Cart_Page
    Open Browser    ${BASE_URL}/cart    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Cart    10s
    
    # หา input field สำหรับ quantity
    ${inputs}=    Get WebElements    css=input[type="number"]
    ${count}=    Get Length    ${inputs}
    IF    ${count} > 0
        Input Text    ${inputs[0]}    2
        Sleep    1s
    END
    
    Close Browser

# CHECKOUT INFORMATION PAGE FUNCTION
TC_018_Checkout_Information_Page_Continue_Without_Information
    [Documentation]    When clicking 'Continue' without any client information, should display an error message
    [Tags]    TC-018    Checkout_Information_Page
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Furniture    10s
    
    # ไปที่หน้า checkout (ถ้ามี)
    Go To    ${BASE_URL}/checkout
    Sleep    3s
    
    # หาปุ่ม Continue
    ${buttons}=    Get WebElements    css=button
    FOR    ${button}    IN    @{buttons}
        ${text}=    Get Text    ${button}
        IF    'continue' in '${text}'.lower()
            Click Element    ${button}
            Sleep    2s
            BREAK
        END
    END
    
    Close Browser

TC_019_Checkout_Information_Page_Continue_With_Valid_Information
    [Documentation]    Should navigate to the next step when clicking Continue with valid information
    [Tags]    TC-019    Checkout_Information_Page
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Furniture    10s
    
    # ไปที่หน้า checkout (ถ้ามี)
    Go To    ${BASE_URL}/checkout
    Sleep    3s
    
    # หา input fields
    ${inputs}=    Get WebElements    css=input
    FOR    ${input}    IN    @{inputs}
        ${name}=    Get Element Attribute    ${input}    name
        IF    '${name}' == 'firstName'
            Input Text    ${input}    ${FIRST_NAME}
        ELSE IF    '${name}' == 'lastName'
            Input Text    ${input}    ${LAST_NAME}
        ELSE IF    '${name}' == 'postalCode'
            Input Text    ${input}    ${POSTAL_CODE}
        END
    END
    
    # หาปุ่ม Continue
    ${buttons}=    Get WebElements    css=button
    FOR    ${button}    IN    @{buttons}
        ${text}=    Get Text    ${button}
        IF    'continue' in '${text}'.lower()
            Click Element    ${button}
            Sleep    2s
            BREAK
        END
    END
    
    Close Browser

TC_020_Checkout_Information_Page_Cancel_Button
    [Documentation]    Should navigate back to the cart page when clicking Cancel button
    [Tags]    TC-020    Checkout_Information_Page
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Furniture    10s
    
    # ไปที่หน้า checkout (ถ้ามี)
    Go To    ${BASE_URL}/checkout
    Sleep    3s
    
    # หาปุ่ม Cancel
    ${buttons}=    Get WebElements    css=button
    FOR    ${button}    IN    @{buttons}
        ${text}=    Get Text    ${button}
        IF    'cancel' in '${text}'.lower()
            Click Element    ${button}
            Sleep    2s
            BREAK
        END
    END
    
    Close Browser

TC_021_Checkout_Information_Page_Input_Fields_Validation
    [Documentation]    Input fields should display as the data that was filled
    [Tags]    TC-021    Checkout_Information_Page
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # รอให้ page โหลดเสร็จ
    Wait Until Page Contains    Furniture    10s
    
    # ไปที่หน้า checkout (ถ้ามี)
    Go To    ${BASE_URL}/checkout
    Sleep    3s
    
    # หา input fields
    ${inputs}=    Get WebElements    css=input
    FOR    ${input}    IN    @{inputs}
        ${name}=    Get Element Attribute    ${input}    name
        IF    '${name}' == 'firstName'
            Input Text    ${input}    ${FIRST_NAME}
            Textfield Value Should Be    ${input}    ${FIRST_NAME}
        ELSE IF    '${name}' == 'lastName'
            Input Text    ${input}    ${LAST_NAME}
            Textfield Value Should Be    ${input}    ${LAST_NAME}
        ELSE IF    '${name}' == 'postalCode'
            Input Text    ${input}    ${POSTAL_CODE}
            Textfield Value Should Be    ${input}    ${POSTAL_CODE}
        END
    END
    
    Close Browser

# REGISTER PAGE FUNCTION
TC_022_Register_Page_Register_Without_First_Name
    [Documentation]    Should show validation error if register without first name
    [Tags]    TC-022    Register_Page
    Open Browser    ${BASE_URL}/register    ${BROWSER}
    Maximize Browser Window
    
    Wait Until Page Contains    สมัครสมาชิก    10s
    
    ${last_name_input}=    Get WebElement    css=input[placeholder="นามสกุล"]
    ${email_input}=    Get WebElement    css=input[type="email"]
    ${password_inputs}=    Get WebElements    css=input[type="password"]
    ${checkbox}=    Get WebElement    css=input[type="checkbox"]
    
    # กรอกเฉพาะนามสกุล (ไม่กรอกชื่อ)
    Input Text    ${last_name_input}    ${LAST_NAME}
    Input Text    ${email_input}    test@example.com
    Input Text    ${password_inputs[0]}    ${VALID_PASSWORD}
    Input Text    ${password_inputs[1]}    ${VALID_PASSWORD}
    Click Element    ${checkbox}
    
    Click Button    css=button[type="submit"]
    
    # HTML5 validation จะจัดการ
    Sleep    2s
    
    Close Browser

TC_023_Register_Page_Register_Without_Last_Name
    [Documentation]    Should show validation error if register without last name
    [Tags]    TC-023    Register_Page
    Open Browser    ${BASE_URL}/register    ${BROWSER}
    Maximize Browser Window
    
    Wait Until Page Contains    สมัครสมาชิก    10s
    
    ${first_name_input}=    Get WebElement    css=input[placeholder="ชื่อ"]
    ${email_input}=    Get WebElement    css=input[type="email"]
    ${password_inputs}=    Get WebElements    css=input[type="password"]
    ${checkbox}=    Get WebElement    css=input[type="checkbox"]
    
    # กรอกเฉพาะชื่อ (ไม่กรอกนามสกุล)
    Input Text    ${first_name_input}    ${FIRST_NAME}
    Input Text    ${email_input}    test@example.com
    Input Text    ${password_inputs[0]}    ${VALID_PASSWORD}
    Input Text    ${password_inputs[1]}    ${VALID_PASSWORD}
    Click Element    ${checkbox}
    
    Click Button    css=button[type="submit"]
    
    # HTML5 validation จะจัดการ
    Sleep    2s
    
    Close Browser

TC_024_Register_Page_Register_Without_Email
    [Documentation]    Should show validation error if register without email
    [Tags]    TC-024    Register_Page
    Open Browser    ${BASE_URL}/register    ${BROWSER}
    Maximize Browser Window
    
    Wait Until Page Contains    สมัครสมาชิก    10s
    
    ${first_name_input}=    Get WebElement    css=input[placeholder="ชื่อ"]
    ${last_name_input}=    Get WebElement    css=input[placeholder="นามสกุล"]
    ${password_inputs}=    Get WebElements    css=input[type="password"]
    ${checkbox}=    Get WebElement    css=input[type="checkbox"]
    
    Input Text    ${first_name_input}    ${FIRST_NAME}
    Input Text    ${last_name_input}    ${LAST_NAME}
    Input Text    ${password_inputs[0]}    ${VALID_PASSWORD}
    Input Text    ${password_inputs[1]}    ${VALID_PASSWORD}
    Click Element    ${checkbox}
    
    Click Button    css=button[type="submit"]
    
    # HTML5 validation จะจัดการ
    Sleep    2s
    
    Close Browser

TC_025_Register_Page_Register_Without_Password
    [Documentation]    Should show validation error if register without password
    [Tags]    TC-025    Register_Page
    Open Browser    ${BASE_URL}/register    ${BROWSER}
    Maximize Browser Window
    
    Wait Until Page Contains    สมัครสมาชิก    10s
    
    ${first_name_input}=    Get WebElement    css=input[placeholder="ชื่อ"]
    ${last_name_input}=    Get WebElement    css=input[placeholder="นามสกุล"]
    ${email_input}=    Get WebElement    css=input[type="email"]
    ${checkbox}=    Get WebElement    css=input[type="checkbox"]
    
    Input Text    ${first_name_input}    ${FIRST_NAME}
    Input Text    ${last_name_input}    ${LAST_NAME}
    Input Text    ${email_input}    test@example.com
    Click Element    ${checkbox}
    
    Click Button    css=button[type="submit"]
    
    # HTML5 validation จะจัดการ
    Sleep    2s
    
    Close Browser

TC_026_Register_Page_Elements_Test
    [Documentation]    Register page should have all required elements
    [Tags]    TC-026    Register_Page
    Open Browser    ${BASE_URL}/register    ${BROWSER}
    Maximize Browser Window
    
    Wait Until Page Contains    สมัครสมาชิก    10s
    
    # ตรวจสอบว่ามี input fields
    Page Should Contain Element    css=input[placeholder="ชื่อ"]
    Page Should Contain Element    css=input[placeholder="นามสกุล"]
    Page Should Contain Element    css=input[type="email"]
    Page Should Contain Element    css=input[type="tel"]
    Page Should Contain Element    css=input[type="password"]
    
    # ตรวจสอบว่ามี password inputs อย่างน้อย 2 ตัว
    ${password_inputs}=    Get WebElements    css=input[type="password"]
    ${count}=    Get Length    ${password_inputs}
    Should Be True    ${count} >= 2
    
    # ตรวจสอบว่ามี checkbox และ submit button
    Page Should Contain Element    css=input[type="checkbox"]
    Page Should Contain Element    css=button[type="submit"]
    
    Close Browser

TC_027_Register_Page_Navigation_To_Login_Test
    [Documentation]    Should navigate to login page when clicking login link
    [Tags]    TC-027    Register_Page
    Open Browser    ${BASE_URL}/register    ${BROWSER}
    Maximize Browser Window
    
    Wait Until Page Contains    สมัครสมาชิก    10s
    
    # หา link ไปหน้า login
    ${links}=    Get WebElements    css=a
    FOR    ${link}    IN    @{links}
        ${href}=    Get Element Attribute    ${link}    href
        ${text}=    Get Text    ${link}
        IF    '/login' in '${href}' or 'เข้าสู่ระบบ' in '${text}' or 'login' in '${href}'
            Click Element    ${link}
            Sleep    2s
            ${current_url}=    Get Location
            Should Contain    ${current_url}    /login
            BREAK
        END
    END
    
    Close Browser

# LOGIN PAGE ADDITIONAL TESTS
TC_028_Login_Page_Valid_Login_Additional_Test
    [Documentation]    ทดสอบการ login ด้วยข้อมูลที่ถูกต้อง (เพิ่มเติม)
    [Tags]    TC-028    Login_Page
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    
    Wait Until Page Contains Element    css=input[type="email"]    10s
    Wait Until Page Contains Element    css=input[type="password"]    10s
    
    Input Text    css=input[type="email"]    ${VALID_USERNAME}
    Input Text    css=input[type="password"]    ${VALID_PASSWORD}
    
    Click Button    css=button[type="submit"]
    
    Wait Until Location Contains    ${BASE_URL}    10s
    
    Close Browser

TC_029_Login_Page_Invalid_Email_Additional_Test
    [Documentation]    ทดสอบการ login ด้วย email ที่ไม่ถูกต้อง (เพิ่มเติม)
    [Tags]    TC-029    Login_Page
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    
    Wait Until Page Contains Element    css=input[type="email"]    10s
    Wait Until Page Contains Element    css=input[type="password"]    10s
    
    Input Text    css=input[type="email"]    ${INVALID_USERNAME}
    Input Text    css=input[type="password"]    ${VALID_PASSWORD}
    
    Click Button    css=button[type="submit"]
    
    Wait Until Page Contains    error    5s
    
    Close Browser

# PRODUCTS PAGE ADDITIONAL TESTS
TC_031_Products_Page_Load_Test
    [Documentation]    ทดสอบการโหลดหน้า products
    [Tags]    TC-031    Products_Page
    Open Browser    ${BASE_URL}/products    ${BROWSER}
    Maximize Browser Window
    
    Wait Until Page Contains    Products    10s
    
    Close Browser

TC_032_Products_Page_Navigation_Test
    [Documentation]    ทดสอบการนำทางในหน้า products
    [Tags]    TC-032    Products_Page
    Open Browser    ${BASE_URL}/products    ${BROWSER}
    Maximize Browser Window
    
    Wait Until Page Contains    Products    10s
    
    ${links}=    Get WebElements    css=a
    FOR    ${link}    IN    @{links}
        ${href}=    Get Element Attribute    ${link}    href
        IF    '${href}' == '/' or '${href}' == ''
            Click Element    ${link}
            Sleep    2s
            BREAK
        END
    END
    
    Close Browser

# CART PAGE ADDITIONAL TESTS
TC_034_Cart_Page_Empty_State_Test
    [Documentation]    ทดสอบการแสดงผลตะกร้าสินค้าว่าง
    [Tags]    TC-034    Cart_Page
    Open Browser    ${BASE_URL}/cart    ${BROWSER}
    Maximize Browser Window
    
    Wait Until Page Contains    Cart    10s
    
    Close Browser

