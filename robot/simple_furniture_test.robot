*** Settings ***
Documentation     Simple test for Furniture Office Application without Google Sheets
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}       http://localhost:3000
${BROWSER}        Chrome

*** Test Cases ***
Home Page Load Test
    [Documentation]    ทดสอบการโหลดหน้าแรก
    [Tags]    smoke    home
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Page Should Contain    Furniture
    Close Browser

Navigation Test
    [Documentation]    ทดสอบการนำทางระหว่างหน้า
    [Tags]    smoke    navigation
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # ทดสอบการคลิกที่ Products
    Click Element    css=a[href="/products"]
    Page Should Contain    Products
    
    # ทดสอบการคลิกที่ Cart
    Click Element    css=a[href="/cart"]
    Page Should Contain    Cart
    
    # ทดสอบการคลิกที่ Home
    Click Element    css=a[href="/"]
    Page Should Contain    Furniture
    
    Close Browser

Login Page Test
    [Documentation]    ทดสอบหน้า Login
    [Tags]    smoke    login
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    Page Should Contain    Login
    Page Should Contain Element    css=input[name="email"]
    Page Should Contain Element    css=input[name="password"]
    Close Browser

Products Page Test
    [Documentation]    ทดสอบหน้า Products
    [Tags]    smoke    products
    Open Browser    ${BASE_URL}/products    ${BROWSER}
    Maximize Browser Window
    Page Should Contain    Products
    Close Browser

Cart Page Test
    [Documentation]    ทดสอบหน้า Cart
    [Tags]    smoke    cart
    Open Browser    ${BASE_URL}/cart    ${BROWSER}
    Maximize Browser Window
    Page Should Contain    Cart
    Close Browser




