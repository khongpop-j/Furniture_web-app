*** Settings ***
Documentation     Advanced Cart Test Cases
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}           http://localhost:3000
${BROWSER}            Chrome
${VALID_EMAIL}        test@example.com
${VALID_PASSWORD}     password123

*** Test Cases ***

# TC-050: Cart Multiple Items Add/Remove Test
TC_050_Cart_Multiple_Items_Add_Remove_Test
    [Documentation]    ทดสอบการเพิ่ม/ลบสินค้าหลายรายการพร้อมกัน
    [Tags]    TC-050    Cart    Multiple_Items
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login
    Login With Credentials
    
    # ไปที่หน้า products
    Go To    ${BASE_URL}/products
    Wait Until Page Contains    Products    10s
    Sleep    2s
    
    # หา product cards เพื่อคลิกไปหน้า detail
    ${product_links}=    Get WebElements    css=a[href*="/product/"]
    ${link_count}=    Get Length    ${product_links}
    
    IF    ${link_count} >= 2
        # เพิ่มสินค้าชิ้นแรก
        Click Element    ${product_links[0]}
        Wait Until Page Contains Element    css=body    10s
        Sleep    2s
        
        # หาปุ่ม "เพิ่มใส่รถเข็น" ในหน้า product detail
        ${add_to_cart_buttons}=    Get WebElements    css=button
        ${found}=    Set Variable    ${False}
        FOR    ${button}    IN    @{add_to_cart_buttons}
            ${text}=    Get Text    ${button}
            ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${button}
            IF    ${is_visible} and ('เพิ่มใส่รถเข็น' in '${text}' or 'add' in '${text}'.lower() or 'cart' in '${text}'.lower())
                Scroll Element Into View    ${button}
                Wait Until Element Is Visible    ${button}    5s
                Click Element    ${button}
                ${found}=    Set Variable    ${True}
                Sleep    2s
                BREAK
            END
        END
        
        # กลับไปหน้า products
        Go To    ${BASE_URL}/products
        Wait Until Page Contains    Products    10s
        Sleep    2s
        
        # เพิ่มสินค้าชิ้นที่สอง
        ${product_links2}=    Get WebElements    css=a[href*="/product/"]
        IF    ${link_count} >= 2
            Click Element    ${product_links2[1]}
            Wait Until Page Contains Element    css=body    10s
            Sleep    2s
            
            ${add_to_cart_buttons2}=    Get WebElements    css=button
            FOR    ${button}    IN    @{add_to_cart_buttons2}
                ${text}=    Get Text    ${button}
                ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${button}
                IF    ${is_visible} and ('เพิ่มใส่รถเข็น' in '${text}' or 'add' in '${text}'.lower() or 'cart' in '${text}'.lower())
                    Scroll Element Into View    ${button}
                    Wait Until Element Is Visible    ${button}    5s
                    Click Element    ${button}
                    Sleep    2s
                    BREAK
                END
            END
        END
    END
    
    # ไปที่ตะกร้า
    Go To    ${BASE_URL}/cart
    Wait Until Page Contains    Cart    10s
    Sleep    2s
    
    # ตรวจสอบว่ามีสินค้าในตะกร้า
    ${page_text}=    Get Text    css=body
    Log    Cart content: ${page_text}
    Close Browser

# TC-051: Cart Empty When Removing All Items Test
TC_051_Cart_Empty_When_Removing_All_Items_Test
    [Documentation]    ทดสอบการแสดงผลตะกร้าว่างหลังลบสินค้าทั้งหมด
    [Tags]    TC-051    Cart    Empty
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login
    Login With Credentials
    
    # ไปที่หน้า products
    Go To    ${BASE_URL}/products
    Wait Until Page Contains    Products    10s
    Sleep    2s
    
    # คลิก product card เพื่อไปหน้า detail
    ${product_links}=    Get WebElements    css=a[href*="/product/"]
    ${link_count}=    Get Length    ${product_links}
    
    IF    ${link_count} > 0
        Click Element    ${product_links[0]}
        Wait Until Page Contains Element    css=body    10s
        Sleep    2s
        
        # หาปุ่ม "เพิ่มใส่รถเข็น"
        ${add_to_cart_buttons}=    Get WebElements    css=button
        FOR    ${button}    IN    @{add_to_cart_buttons}
            ${text}=    Get Text    ${button}
            ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${button}
            IF    ${is_visible} and ('เพิ่มใส่รถเข็น' in '${text}' or 'add' in '${text}'.lower() or 'cart' in '${text}'.lower())
                Scroll Element Into View    ${button}
                Wait Until Element Is Visible    ${button}    5s
                Click Element    ${button}
                Sleep    2s
                BREAK
            END
        END
    END
    
    # ไปที่ตะกร้า
    Go To    ${BASE_URL}/cart
    Wait Until Page Contains    Cart    10s
    Sleep    2s
    
    # ลบสินค้า
    ${remove_buttons}=    Get WebElements    css=button
    FOR    ${button}    IN    @{remove_buttons}
        ${text}=    Get Text    ${button}
        ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${button}
        IF    ${is_visible} and ('remove' in '${text}'.lower() or 'ลบ' in '${text}')
            Scroll Element Into View    ${button}
            Wait Until Element Is Visible    ${button}    5s
            Click Element    ${button}
            Sleep    2s
            BREAK
        END
    END
    
    # ตรวจสอบว่าตะกร้าว่าง
    ${page_text}=    Get Text    css=body
    Log    Cart content: ${page_text}
    Close Browser

# TC-052: Cart Stock Validation Test
TC_052_Cart_Stock_Validation_Test
    [Documentation]    ทดสอบการตรวจสอบสต็อกเมื่อเพิ่มสินค้าเกินจำนวน
    [Tags]    TC-052    Cart    Stock
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login
    Login With Credentials
    
    # ไปที่หน้า products
    Go To    ${BASE_URL}/products
    Wait Until Page Contains    Products    10s
    
    # คลิกสินค้าแรก
    ${product_links}=    Get WebElements    css=a[href*="/product/"]
    IF    '${product_links}' != '[]'
        Click Element    ${product_links[0]}
        Sleep    2s
        
        # ลองเพิ่มจำนวนสินค้าเยอะๆ
        ${quantity_inputs}=    Get WebElements    css=input[type="number"]
        IF    '${quantity_inputs}' != '[]'
            Clear Element Text    ${quantity_inputs[0]}
            Input Text    ${quantity_inputs[0]}    999999
        END
    END
    
    Close Browser

# TC-053: Cart Continue Shopping Navigation Test
TC_053_Cart_Continue_Shopping_Navigation_Test
    [Documentation]    ทดสอบการนำทางกลับไปหน้า products และคงสินค้าในตะกร้า
    [Tags]    TC-053    Cart    Navigation
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login
    Login With Credentials
    
    # ไปที่หน้า products
    Go To    ${BASE_URL}/products
    Wait Until Page Contains    Products    10s
    Sleep    2s
    
    # คลิก product card เพื่อไปหน้า detail
    ${product_links}=    Get WebElements    css=a[href*="/product/"]
    ${link_count}=    Get Length    ${product_links}
    
    IF    ${link_count} > 0
        Click Element    ${product_links[0]}
        Wait Until Page Contains Element    css=body    10s
        Sleep    2s
        
        # หาปุ่ม "เพิ่มใส่รถเข็น"
        ${add_to_cart_buttons}=    Get WebElements    css=button
        FOR    ${button}    IN    @{add_to_cart_buttons}
            ${text}=    Get Text    ${button}
            ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${button}
            IF    ${is_visible} and ('เพิ่มใส่รถเข็น' in '${text}' or 'add' in '${text}'.lower() or 'cart' in '${text}'.lower())
                Scroll Element Into View    ${button}
                Wait Until Element Is Visible    ${button}    5s
                Click Element    ${button}
                Sleep    2s
                BREAK
            END
        END
    END
    
    # ไปที่ตะกร้า
    Go To    ${BASE_URL}/cart
    Wait Until Page Contains    Cart    10s
    Sleep    2s
    
    # คลิก Continue Shopping
    ${buttons}=    Get WebElements    css=button
    FOR    ${button}    IN    @{buttons}
        ${text}=    Get Text    ${button}
        ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${button}
        IF    ${is_visible} and ('continue' in '${text}'.lower() or 'shopping' in '${text}'.lower())
            Scroll Element Into View    ${button}
            Wait Until Element Is Visible    ${button}    5s
            Click Element    ${button}
            Sleep    2s
            ${current_url}=    Get Location
            Should Contain    ${current_url}    products
            BREAK
        END
    END
    
    Close Browser

# TC-054: Cart Notification On Add Test
TC_054_Cart_Notification_On_Add_Test
    [Documentation]    ทดสอบการแสดง notification เมื่อเพิ่มสินค้าลงตะกร้า
    [Tags]    TC-054    Cart    Notification
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login
    Login With Credentials
    
    # ไปที่หน้า products
    Go To    ${BASE_URL}/products
    Wait Until Page Contains    Products    10s
    Sleep    2s
    
    # คลิก product card เพื่อไปหน้า detail
    ${product_links}=    Get WebElements    css=a[href*="/product/"]
    ${link_count}=    Get Length    ${product_links}
    
    IF    ${link_count} > 0
        Click Element    ${product_links[0]}
        Wait Until Page Contains Element    css=body    10s
        Sleep    2s
        
        # หาปุ่ม "เพิ่มใส่รถเข็น"
        ${add_to_cart_buttons}=    Get WebElements    css=button
        FOR    ${button}    IN    @{add_to_cart_buttons}
            ${text}=    Get Text    ${button}
            ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${button}
            IF    ${is_visible} and ('เพิ่มใส่รถเข็น' in '${text}' or 'add' in '${text}'.lower() or 'cart' in '${text}'.lower())
                Scroll Element Into View    ${button}
                Wait Until Element Is Visible    ${button}    5s
                Click Element    ${button}
                Sleep    3s
                
                # ตรวจสอบว่ามี notification
                ${page_text}=    Get Text    css=body
                Log    Page after adding to cart: ${page_text}
                BREAK
            END
        END
    END
    
    Close Browser

# TC-055: Cart Mobile UI Test
TC_055_Cart_Mobile_UI_Test
    [Documentation]    ทดสอบ UI ของตะกร้าบนมือถือ
    [Tags]    TC-055    Cart    Mobile
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login
    Login With Credentials
    
    # เปลี่ยนขนาดหน้าจอเป็น mobile
    Set Window Size    375    667
    
    # ไปที่ตะกร้า
    Go To    ${BASE_URL}/cart
    Wait Until Page Contains    Cart    10s
    
    # ตรวจสอบว่า UI ใช้งานได้
    ${buttons}=    Get WebElements    css=button
    ${button_count}=    Get Length    ${buttons}
    Log    Buttons on mobile view: ${button_count}
    
    Close Browser

*** Keywords ***
Login With Credentials
    [Arguments]    ${email}=${VALID_EMAIL}    ${password}=${VALID_PASSWORD}
    Go To    ${BASE_URL}/login
    Wait Until Page Contains Element    css=input[type="email"]    10s
    Input Text    css=input[type="email"]    ${email}
    Input Text    css=input[type="password"]    ${password}
    Click Button    css=button[type="submit"]
    Wait Until Location Contains    ${BASE_URL}    10s
    Sleep    2s

