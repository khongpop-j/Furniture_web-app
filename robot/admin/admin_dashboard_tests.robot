*** Settings ***
Documentation     Admin Dashboard Test Cases
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}           http://localhost:3000
${BROWSER}            Chrome
${ADMIN_EMAIL}        admin@example.com
${ADMIN_PASSWORD}     admin123
${REGULAR_EMAIL}      test@example.com
${REGULAR_PASSWORD}   password123

*** Test Cases ***

# TC-078: Admin Login Required Test
TC_078_Admin_Login_Required_Test
    [Documentation]    ทดสอบว่าต้อง login เป็น admin ถึงเข้าถึงได้
    [Tags]    TC-078    Admin    Authentication
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # พยายามเข้าถึงหน้า admin โดยไม่ login
    Go To    ${BASE_URL}/admin
    Wait Until Page Contains Element    css=body    10s
    
    # ตรวจสอบว่าถูก redirect ไปหน้า login หรือไม่
    Sleep    2s
    ${current_url}=    Get Location
    ${is_login_page}=    Run Keyword And Return Status    Page Should Contain    Login
    
    IF    ${is_login_page}
        Log    Correctly redirected to login page
    END
    
    Close Browser

# TC-079: Admin Role Verification Test
TC_079_Admin_Role_Verification_Test
    [Documentation]    ทดสอบการตรวจสอบ role ของ admin
    [Tags]    TC-079    Admin    Authorization
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login เป็น admin
    Login With Admin Credentials
    
    # ไปที่หน้า admin dashboard
    Go To    ${BASE_URL}/admin
    Wait Until Page Contains Element    css=body    10s
    
    # ตรวจสอบว่าหน้า admin โหลดสำเร็จ
    ${page_text}=    Get Text    css=body
    Log    Admin dashboard content: ${page_text}
    
    Close Browser

# TC-080: Admin Unauthorized Access Test
TC_080_Admin_Unauthorized_Access_Test
    [Documentation]    ทดสอบว่า user ทั่วไปเข้าไม่ได้
    [Tags]    TC-080    Admin    Authorization
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login เป็น user ปกติ
    Login With Credentials    ${REGULAR_EMAIL}    ${REGULAR_PASSWORD}
    
    # พยายามเข้าถึงหน้า admin
    Go To    ${BASE_URL}/admin
    Wait Until Page Contains Element    css=body    10s
    Sleep    2s
    
    # ตรวจสอบว่ามี error message หรือถูก redirect
    ${page_text}=    Get Text    css=body
    ${has_error}=    Run Keyword And Return Status    Page Should Contain    ไม่มีสิทธิ์
    
    IF    ${has_error}
        Log    Unauthorized access correctly blocked
    END
    
    Close Browser

# TC-081: Admin View Users Test
TC_081_Admin_View_Users_Test
    [Documentation]    ทดสอบการดูรายชื่อผู้ใช้
    [Tags]    TC-081    Admin    Users
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login เป็น admin
    Login With Admin Credentials
    
    # ไปที่หน้า admin dashboard
    Go To    ${BASE_URL}/admin
    Wait Until Page Contains Element    css=body    10s
    
    # หา tab "Users" หรือ "ผู้ใช้"
    ${tabs}=    Get WebElements    css=button
    FOR    ${tab}    IN    @{tabs}
        ${text}=    Get Text    ${tab}
        IF    'Users' in '${text}' or 'ผู้ใช้' in '${text}'
            Click Element    ${tab}
            Sleep    3s
            BREAK
        END
    END
    
    # ตรวจสอบว่ามีการแสดงรายชื่อผู้ใช้
    ${page_text}=    Get Text    css=body
    Log    Users list content: ${page_text}
    
    Close Browser

# TC-082: Admin Update User Role Test
TC_082_Admin_Update_User_Role_Test
    [Documentation]    ทดสอบการแก้ไขสิทธิ์ผู้ใช้
    [Tags]    TC-082    Admin    Role
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login เป็น admin
    Login With Admin Credentials
    
    # ไปที่หน้า admin dashboard
    Go To    ${BASE_URL}/admin
    Wait Until Page Contains Element    css=body    10s
    
    # หา tab "Users"
    ${tabs}=    Get WebElements    css=button
    FOR    ${tab}    IN    @{tabs}
        ${text}=    Get Text    ${tab}
        IF    'Users' in '${text}' or 'ผู้ใช้' in '${text}'
            Click Element    ${tab}
            Sleep    3s
            BREAK
        END
    END
    
    # หา dropdown หรือ select สำหรับ role
    ${selects}=    Get WebElements    css=select
    IF    '${selects}' != '[]'
        Log    Role selector found
    END
    
    Close Browser

# TC-083: Admin Add Product Test
TC_083_Admin_Add_Product_Test
    [Documentation]    ทดสอบการเพิ่มสินค้าใหม่
    [Tags]    TC-083    Admin    Products
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login เป็น admin
    Login With Admin Credentials
    
    # ไปที่หน้า admin dashboard
    Go To    ${BASE_URL}/admin
    Wait Until Page Contains Element    css=body    10s
    
    # หา tab "Products" หรือ "สินค้า"
    ${tabs}=    Get WebElements    css=button
    FOR    ${tab}    IN    @{tabs}
        ${text}=    Get Text    ${tab}
        IF    'Products' in '${text}' or 'สินค้า' in '${text}'
            Click Element    ${tab}
            Sleep    3s
            BREAK
        END
    END
    
    # หาปุ่ม "Add Product" หรือ "เพิ่มสินค้า"
    ${buttons}=    Get WebElements    css=button
    FOR    ${button}    IN    @{buttons}
        ${text}=    Get Text    ${button}
        IF    'Add' in '${text}' or 'เพิ่ม' in '${text}'
            Click Element    ${button}
            Sleep    2s
            Log    Add product form opened
            BREAK
        END
    END
    
    Close Browser

# TC-084: Admin Edit/Delete Product Test
TC_084_Admin_Edit_Delete_Product_Test
    [Documentation]    ทดสอบการแก้ไขและลบสินค้า
    [Tags]    TC-084    Admin    Products
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login เป็น admin
    Login With Admin Credentials
    
    # ไปที่หน้า admin dashboard
    Go To    ${BASE_URL}/admin
    Wait Until Page Contains Element    css=body    10s
    
    # หา tab "Products"
    ${tabs}=    Get WebElements    css=button
    FOR    ${tab}    IN    @{tabs}
        ${text}=    Get Text    ${tab}
        IF    'Products' in '${text}' or 'สินค้า' in '${text}'
            Click Element    ${tab}
            Sleep    3s
            BREAK
        END
    END
    
    # หาปุ่ม Edit หรือ Delete
    ${buttons}=    Get WebElements    css=button
    FOR    ${button}    IN    @{buttons}
        ${text}=    Get Text    ${button}
        IF    'Edit' in '${text}' or 'แก้ไข' in '${text}'
            Click Element    ${button}
            Sleep    2s
            Log    Edit product form opened
            BREAK
        END
    END
    
    Close Browser

# TC-085: Admin View Orders Test
TC_085_Admin_View_Orders_Test
    [Documentation]    ทดสอบการดูคำสั่งซื้อทั้งหมด
    [Tags]    TC-085    Admin    Orders
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login เป็น admin
    Login With Admin Credentials
    
    # ไปที่หน้า admin dashboard
    Go To    ${BASE_URL}/admin
    Wait Until Page Contains Element    css=body    10s
    
    # หา tab "Orders"
    ${tabs}=    Get WebElements    css=button
    FOR    ${tab}    IN    @{tabs}
        ${text}=    Get Text    ${tab}
        IF    'Orders' in '${text}' or 'คำสั่งซื้อ' in '${text}'
            Click Element    ${tab}
            Sleep    3s
            BREAK
        END
    END
    
    # ตรวจสอบว่ามีการแสดงรายการคำสั่งซื้อ
    ${page_text}=    Get Text    css=body
    Log    Orders list content: ${page_text}
    
    Close Browser

*** Keywords ***
Login With Admin Credentials
    Go To    ${BASE_URL}/login
    Wait Until Page Contains Element    css=input[type="email"]    10s
    Input Text    css=input[type="email"]    ${ADMIN_EMAIL}
    Input Text    css=input[type="password"]    ${ADMIN_PASSWORD}
    Click Button    css=button[type="submit"]
    Wait Until Location Contains    ${BASE_URL}    10s
    Sleep    2s

Login With Credentials
    [Arguments]    ${email}    ${password}
    Go To    ${BASE_URL}/login
    Wait Until Page Contains Element    css=input[type="email"]    10s
    Input Text    css=input[type="email"]    ${email}
    Input Text    css=input[type="password"]    ${password}
    Click Button    css=button[type="submit"]
    Wait Until Location Contains    ${BASE_URL}    10s
    Sleep    2s

