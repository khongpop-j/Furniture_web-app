*** Settings ***
Documentation     Simple login test for Furniture Office Application
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}       http://localhost:3000
${BROWSER}        Chrome

*** Test Cases ***
Login Page Load Test
    [Documentation]    ทดสอบการโหลดหน้า Login
    [Tags]    login    basic
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    Page Should Contain    Login
    Close Browser

Login Form Elements Test
    [Documentation]    ทดสอบ elements ในฟอร์ม Login
    [Tags]    login    elements
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    
    # ตรวจสอบว่ามี input fields
    Page Should Contain Element    css=input[name="email"]
    Page Should Contain Element    css=input[name="password"]
    Page Should Contain Element    css=button[type="submit"]
    
    Close Browser

Login Form Input Test
    [Documentation]    ทดสอบการกรอกข้อมูลในฟอร์ม Login
    [Tags]    login    input
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    
    # กรอกข้อมูลทดสอบ
    Input Text    css=input[name="email"]    test@example.com
    Input Text    css=input[name="password"]    password123
    
    # ตรวจสอบว่าข้อมูลถูกกรอก
    Textfield Value Should Be    css=input[name="email"]    test@example.com
    Textfield Value Should Be    css=input[name="password"]    password123
    
    Close Browser

Login Submit Test
    [Documentation]    ทดสอบการ submit ฟอร์ม Login
    [Tags]    login    submit
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    
    # กรอกข้อมูลทดสอบ
    Input Text    css=input[name="email"]    test@example.com
    Input Text    css=input[name="password"]    password123
    
    # คลิกปุ่ม submit
    Click Button    css=button[type="submit"]
    
    # รอสักครู่เพื่อดูผลลัพธ์
    Sleep    2s
    
    Close Browser




