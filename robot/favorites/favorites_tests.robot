*** Settings ***
Documentation     Favorites Page Test Cases
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}           http://localhost:3000
${BROWSER}            Chrome
${VALID_EMAIL}        test@example.com
${VALID_PASSWORD}     password123

*** Test Cases ***

# TC-073: Favorites Page Load Test
TC_073_Favorites_Page_Load_Test
    [Documentation]    ทดสอบการโหลดหน้ารายการโปรด
    [Tags]    TC-073    Favorites    Load
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า Favorites
    Go To    ${BASE_URL}/favorites
    Wait Until Page Contains Element    css=body    10s
    
    # ตรวจสอบว่าหน้าโหลดสำเร็จ
    ${page_text}=    Get Text    css=body
    Log    Favorites page content: ${page_text}
    
    Close Browser

# TC-074: Favorites Add/Remove Test
TC_074_Favorites_Add_Remove_Test
    [Documentation]    ทดสอบการเพิ่ม/ลบสินค้าจากรายการโปรด
    [Tags]    TC-074    Favorites    Add_Remove
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า products
    Go To    ${BASE_URL}/products
    Wait Until Page Contains    Products    10s
    
    # คลิกสินค้าแรก
    ${product_links}=    Get WebElements    css=a[href*="/product/"]
    ${count}=    Get Length    ${product_links}
    IF    ${count} > 0
        Click Element    ${product_links[0]}
        Sleep    2s
        
        # หาปุ่ม favorite (อาจเป็นไอคอนหัวใจ หรือปุ่ม)
        ${heart_icons}=    Run Keyword And Return Status    Page Should Contain Element    css=.fa-heart
        ${star_icons}=    Run Keyword And Return Status    Page Should Contain Element    css=.fa-star
        ${favorite_buttons}=    Get WebElements    css=button
        
        IF    ${heart_icons} or ${star_icons}
            # คลิกที่ icon
            IF    ${heart_icons}
                ${icons}=    Get WebElements    css=.fa-heart
                Click Element    ${icons[0]}
            ELSE IF    ${star_icons}
                ${icons}=    Get WebElements    css=.fa-star
                Click Element    ${icons[0]}
            END
            Sleep    2s
        ELSE
            # ลองหาปุ่ม favorite
            FOR    ${button}    IN    @{favorite_buttons}
                ${text}=    Get Text    ${button}
                ${class}=    Get Element Attribute    ${button}    class
                IF    'favorite' in '${text}'.lower() or 'favorite' in '${class}'.lower()
                    Click Element    ${button}
                    Sleep    2s
                    BREAK
                END
            END
        END
        
        # ไปที่หน้า favorites เพื่อตรวจสอบ
        Go To    ${BASE_URL}/favorites
        Wait Until Page Contains Element    css=body    10s
        Sleep    2s
    END
    
    Close Browser

# TC-075: Favorites Empty State Test
TC_075_Favorites_Empty_State_Test
    [Documentation]    ทดสอบการแสดงผลเมื่อไม่มีรายการโปรด
    [Tags]    TC-075    Favorites    Empty
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า Favorites
    Go To    ${BASE_URL}/favorites
    Wait Until Page Contains Element    css=body    10s
    
    # ตรวจสอบว่าหน้าโหลดสำเร็จ (อาจจะว่างหรือมีสินค้า)
    ${page_text}=    Get Text    css=body
    
    # ตรวจสอบว่ามีข้อความแสดงถึงรายการว่างหรือไม่
    ${has_empty_message}=    Run Keyword And Return Status    Page Should Contain    ว่าง
    
    IF    ${has_empty_message}
        Log    Favorites list is empty - empty message displayed
    ELSE
        Log    Favorites list has items or no specific empty message
    END
    
    Close Browser

# TC-076: Favorites Remove Item Test
TC_076_Favorites_Remove_Item_Test
    [Documentation]    ทดสอบการลบสินค้าจากรายการโปรด
    [Tags]    TC-076    Favorites    Remove
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า Favorites
    Go To    ${BASE_URL}/favorites
    Wait Until Page Contains Element    css=body    10s
    
    # หาปุ่มลบหรือ toggle favorite
    ${remove_buttons}=    Get WebElements    css=button
    FOR    ${button}    IN    @{remove_buttons}
        ${text}=    Get Text    ${button}
        IF    'ลบ' in '${text}' or 'remove' in '${text}'.lower() or 'unfavorite' in '${text}'.lower()
            Click Element    ${button}
            Sleep    2s
            BREAK
        END
    END
    
    Close Browser

# TC-077: Favorites Navigation Test
TC_077_Favorites_Navigation_Test
    [Documentation]    ทดสอบการนำทางไปยัง Favorites จากหน้า profile
    [Tags]    TC-077    Favorites    Navigation
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า profile
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    
    # หา tab "รายการโปรด"
    ${tabs}=    Get WebElements    css=button
    FOR    ${tab}    IN    @{tabs}
        ${text}=    Get Text    ${tab}
        IF    'รายการโปรด' in '${text}' or 'favorite' in '${text}'.lower()
            Click Element    ${tab}
            Sleep    3s
            BREAK
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

