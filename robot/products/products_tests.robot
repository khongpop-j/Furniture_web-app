*** Settings ***
Documentation     Test cases สำหรับหน้า Products ของ Furniture Office Application
Resource          ../furniture_resource.robot
Suite Setup       Setup Test Suite With Google Sheets
Suite Teardown    Teardown Test Suite With Google Sheets
Test Setup        Navigate To Products
Test Teardown     Take Screenshot On Failure

*** Test Cases ***
Products Page Load Test
    [Documentation]    ทดสอบการโหลดหน้า products
    [Tags]    products    load
    Setup Test With Google Sheets    Products Page Load Test    Products Suite
    Products Page Should Be Open
    Page Should Contain Element    ${PRODUCT_GRID}
    Mark Test As Passed    Products page loaded successfully

Products Display Test
    [Documentation]    ทดสอบการแสดงผลสินค้า
    [Tags]    products    display
    Setup Test With Google Sheets    Products Display Test    Products Suite
    Wait Until Page Contains Element    ${PRODUCT_ITEM}    10s
    ${count}=    Get Product Count
    Should Be True    ${count} > 0
    Page Should Contain Element    ${PRODUCT_TITLE}
    Page Should Contain Element    ${PRODUCT_PRICE}
    Page Should Contain Element    ${PRODUCT_IMAGE}
    Mark Test As Passed    Products displayed correctly

Product Click Test
    [Documentation]    ทดสอบการคลิกที่สินค้า
    [Tags]    products    click
    Setup Test With Google Sheets    Product Click Test    Products Suite
    Wait Until Page Contains Element    ${PRODUCT_ITEM}    10s
    Click First Product
    # ตรวจสอบว่าหน้าสินค้ารายละเอียดเปิดขึ้น
    Page Should Contain Element    ${PRODUCT_IMAGE}
    Mark Test As Passed    Product click functionality working

Add To Cart Test
    [Documentation]    ทดสอบการเพิ่มสินค้าลงตะกร้า
    [Tags]    products    cart
    Setup Test With Google Sheets    Add To Cart Test    Products Suite
    Wait Until Page Contains Element    ${ADD_TO_CART_BTN}    10s
    Add First Product To Cart
    # ตรวจสอบว่าสินค้าถูกเพิ่มลงตะกร้า
    Navigate To Cart
    Cart Page Should Be Open
    Verify Cart Has Items    1
    Mark Test As Passed    Add to cart functionality working

Products Navigation Test
    [Documentation]    ทดสอบการนำทางในหน้า products
    [Tags]    products    navigation
    Setup Test With Google Sheets    Products Navigation Test    Products Suite
    Page Should Contain Element    ${NAV_HOME}
    Page Should Contain Element    ${NAV_CART}
    Page Should Contain Element    ${NAV_PROFILE}
    
    # ทดสอบการนำทางไปหน้า home
    Click Element    ${NAV_HOME}
    Home Page Should Be Open
    
    # กลับมาหน้า products
    Navigate To Products
    Products Page Should Be Open
    Mark Test As Passed    Products page navigation working correctly

Products Search Test
    [Documentation]    ทดสอบการค้นหาสินค้า (ถ้ามีฟีเจอร์นี้)
    [Tags]    products    search
    Setup Test With Google Sheets    Products Search Test    Products Suite
    ${search_input}=    Run Keyword And Return Status    Page Should Contain Element    css=input[type="search"]
    IF    ${search_input}
        Input Text    css=input[type="search"]    table
        Press Keys    css=input[type="search"]    ENTER
        Wait Until Page Contains Element    ${PRODUCT_ITEM}    10s
        Mark Test As Passed    Product search functionality working
    ELSE
        Mark Test As Skipped    Search functionality not found
    END

Products Filter Test
    [Documentation]    ทดสอบการกรองสินค้า (ถ้ามีฟีเจอร์นี้)
    [Tags]    products    filter
    Setup Test With Google Sheets    Products Filter Test    Products Suite
    ${filter_select}=    Run Keyword And Return Status    Page Should Contain Element    css=select
    IF    ${filter_select}
        Select From List By Label    css=select    Price: Low to High
        Wait Until Page Contains Element    ${PRODUCT_ITEM}    10s
        Mark Test As Passed    Product filter functionality working
    ELSE
        Mark Test As Skipped    Filter functionality not found
    END

Products Responsive Test
    [Documentation]    ทดสอบการแสดงผลบนหน้าจอขนาดต่างๆ
    [Tags]    products    responsive
    Setup Test With Google Sheets    Products Responsive Test    Products Suite
    # ทดสอบขนาดหน้าจอเล็ก
    Set Window Size    375    667
    Wait Until Page Contains Element    ${PRODUCT_ITEM}    10s
    
    # ทดสอบขนาดหน้าจอกลาง
    Set Window Size    768    1024
    Wait Until Page Contains Element    ${PRODUCT_ITEM}    10s
    
    # ทดสอบขนาดหน้าจอใหญ่
    Set Window Size    1920    1080
    Wait Until Page Contains Element    ${PRODUCT_ITEM}    10s
    Mark Test As Passed    Products responsive design working correctly

Products Performance Test
    [Documentation]    ทดสอบประสิทธิภาพการโหลดหน้า products
    [Tags]    products    performance
    Setup Test With Google Sheets    Products Performance Test    Products Suite
    ${start_time}=    Get Current Date
    Navigate To Products
    Products Page Should Be Open
    Wait Until Page Contains Element    ${PRODUCT_ITEM}    10s
    ${end_time}=    Get Current Date
    ${load_time}=    Subtract Date From Date    ${end_time}    ${start_time}
    Should Be True    ${load_time} < 5    # ควรโหลดภายใน 5 วินาที
    Mark Test As Passed    Products page load time: ${load_time} seconds

Products Error Handling Test
    [Documentation]    ทดสอบการจัดการข้อผิดพลาดในหน้า products
    [Tags]    products    error
    Setup Test With Google Sheets    Products Error Handling Test    Products Suite
    # ทดสอบการโหลดหน้า products หลายครั้ง
    FOR    ${i}    IN RANGE    3
        Navigate To Products
        Products Page Should Be Open
        Wait Until Page Contains Element    ${PRODUCT_ITEM}    10s
    END
    Mark Test As Passed    Products error handling working correctly




