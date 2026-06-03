*** Settings ***
Documentation     Product Detail Page Test Cases
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}           http://localhost:3000
${BROWSER}            Chrome
${VALID_EMAIL}        test@example.com
${VALID_PASSWORD}     password123

*** Test Cases ***

# TC-043: Product Detail Page Load Test
TC_043_Product_Detail_Page_Load_Test
    [Documentation]    ทดสอบการโหลดหน้าสินค้า detail
    [Tags]    TC-043    Product_Detail    Load
    Open Browser    ${BASE_URL}/products    ${BROWSER}
    Maximize Browser Window
    
    # รอให้หน้า products โหลดเสร็จ
    Wait Until Page Contains    Products    10s
    
    # คลิกที่สินค้าแรก
    ${product_links}=    Get WebElements    css=a[href*="/product/"]
    ${count}=    Get Length    ${product_links}
    IF    ${count} > 0
        Click Element    ${product_links[0]}
        
        # รอให้หน้า product detail โหลด
        Wait Until Page Contains Element    css=button    10s
        Page Should Contain Element    css=img
    
        Close Browser
    ELSE
        Fail    No products found
    END

# TC-044: Product Detail Add To Cart Test
TC_044_Product_Detail_Add_To_Cart_Test
    [Documentation]    ทดสอบการเพิ่มสินค้าลงตะกร้าจากหน้า detail
    [Tags]    TC-044    Product_Detail    Cart
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Go To    ${BASE_URL}/login
    Wait Until Page Contains Element    css=input[type="email"]    10s
    Input Text    css=input[type="email"]    ${VALID_EMAIL}
    Input Text    css=input[type="password"]    ${VALID_PASSWORD}
    Click Button    css=button[type="submit"]
    Wait Until Location Contains    ${BASE_URL}    5s
    
    # ไปที่หน้า products
    Go To    ${BASE_URL}/products
    Wait Until Page Contains    Products    10s
    
    # คลิกสินค้าแรก
    ${product_links}=    Get WebElements    css=a[href*="/product/"]
    IF    '${product_links}' != '[]'
        Click Element    ${product_links[0]}
        Sleep    2s
        
        # คลิกปุ่ม Add to Cart
        ${buttons}=    Get WebElements    css=button
        ${found}=    Set Variable    ${False}
        FOR    ${button}    IN    @{buttons}
            ${text}=    Get Text    ${button}
            IF    'add' in '${text}'.lower() or 'cart' in '${text}'.lower()
                Click Element    ${button}
                ${found}=    Set Variable    ${True}
                BREAK
            END
        END
    END
    
    Close Browser

# TC-045: Product Detail Quantity Selection Test
TC_045_Product_Detail_Quantity_Selection_Test
    [Documentation]    ทดสอบการเลือกจำนวนสินค้าก่อนเพิ่มลงตะกร้า
    [Tags]    TC-045    Product_Detail    Quantity
    Open Browser    ${BASE_URL}/products    ${BROWSER}
    Maximize Browser Window
    
    # รอให้หน้า products โหลด
    Wait Until Page Contains    Products    10s
    
    # คลิกสินค้าแรก
    ${product_links}=    Get WebElements    css=a[href*="/product/"]
    ${count}=    Get Length    ${product_links}
    IF    ${count} > 0
        Click Element    ${product_links[0]}
        Sleep    2s
        
        # หา quantity selector
        ${quantity_inputs}=    Get WebElements    css=input[type="number"]
        IF    $quantity_inputs
            # ทดสอบการเปลี่ยนจำนวน
            Clear Element Text    ${quantity_inputs[0]}
            Input Text    ${quantity_inputs[0]}    2
            ${value}=    Get Value    ${quantity_inputs[0]}
            Should Be Equal    ${value}    2
        END
    END
    
    Close Browser

# TC-046: Product Detail Out Of Stock Test
TC_046_Product_Detail_Out_Of_Stock_Test
    [Documentation]    ทดสอบการแสดงผลเมื่อสินค้าหมดสต็อก
    [Tags]    TC-046    Product_Detail    Stock
    Open Browser    ${BASE_URL}/products    ${BROWSER}
    Maximize Browser Window
    
    # รอให้หน้า products โหลด
    Wait Until Page Contains    Products    10s
    
    # คลิกสินค้าอะไรก็ได้
    ${product_links}=    Get WebElements    css=a[href*="/product/"]
    ${count}=    Get Length    ${product_links}
    IF    ${count} > 0
        Click Element    ${product_links[0]}
        Sleep    2s
        
        # ตรวจสอบว่ามีการแสดงข้อมูล stock หรือไม่
        ${page_text}=    Get Text    css=body
        Log    Page content: ${page_text}
    END
    
    Close Browser

# TC-047: Product Detail Favorite Toggle Test
TC_047_Product_Detail_Favorite_Toggle_Test
    [Documentation]    ทดสอบการเพิ่ม/ลบสินค้าจากรายการโปรด
    [Tags]    TC-047    Product_Detail    Favorite
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Go To    ${BASE_URL}/login
    Wait Until Page Contains Element    css=input[type="email"]    10s
    Input Text    css=input[type="email"]    ${VALID_EMAIL}
    Input Text    css=input[type="password"]    ${VALID_PASSWORD}
    Click Button    css=button[type="submit"]
    Wait Until Location Contains    ${BASE_URL}    5s
    
    # ไปที่หน้า products
    Go To    ${BASE_URL}/products
    Wait Until Page Contains    Products    10s
    
    # คลิกสินค้าแรก
    ${product_links}=    Get WebElements    css=a[href*="/product/"]
    ${count}=    Get Length    ${product_links}
    IF    ${count} > 0
        Click Element    ${product_links[0]}
        Sleep    2s
        
        # หาปุ่ม favorite
        ${page_text}=    Get Text    css=body
        Log    Page content: ${page_text}
        
        # หา icon หัวใจหรือปุ่ม favorite
        ${heart_icons}=    Run Keyword And Return Status    Page Should Contain Element    css=.fa-heart
        ${star_icons}=    Run Keyword And Return Status    Page Should Contain Element    css=.fa-star
        
        IF    ${heart_icons} or ${star_icons}
            Log    Favorite button found
        ELSE
            Log    No favorite button found
        END
    END
    
    Close Browser

*** Keywords ***
Login With Credentials
    [Arguments]    ${email}    ${password}
    Go To    ${BASE_URL}/login
    Wait Until Page Contains Element    css=input[type="email"]    10s
    Input Text    css=input[type="email"]    ${email}
    Input Text    css=input[type="password"]    ${password}
    Click Button    css=button[type="submit"]
    Wait Until Location Contains    ${BASE_URL}    10s
    Sleep    2s

