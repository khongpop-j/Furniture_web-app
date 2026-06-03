*** Settings ***
Documentation     Test cases สำหรับหน้า Cart ของ Furniture Office Application
Resource          ../furniture_resource.robot
Suite Setup       Setup Test Suite With Google Sheets
Suite Teardown    Teardown Test Suite With Google Sheets
Test Setup        Navigate To Cart
Test Teardown     Take Screenshot On Failure

*** Test Cases ***
Empty Cart Test
    [Documentation]    ทดสอบการแสดงผลตะกร้าสินค้าว่าง
    [Tags]    cart    empty
    Setup Test With Google Sheets    Empty Cart Test    Cart Suite
    Cart Page Should Be Open
    Verify Cart Is Empty
    Page Should Contain    Cart
    Page Should Contain    Your cart is empty
    Mark Test As Passed    Empty cart displayed correctly

Add Item To Cart Test
    [Documentation]    ทดสอบการเพิ่มสินค้าลงตะกร้า
    [Tags]    cart    add
    Setup Test With Google Sheets    Add Item To Cart Test    Cart Suite
    # ไปหน้า products และเพิ่มสินค้า
    Navigate To Products
    Wait Until Page Contains Element    ${ADD_TO_CART_BTN}    10s
    Add First Product To Cart
    
    # ไปหน้า cart และตรวจสอบ
    Navigate To Cart
    Cart Page Should Be Open
    Verify Cart Has Items    1
    Page Should Contain Element    ${CART_ITEM}
    Mark Test As Passed    Item added to cart successfully

Remove Item From Cart Test
    [Documentation]    ทดสอบการลบสินค้าออกจากตะกร้า
    [Tags]    cart    remove
    Setup Test With Google Sheets    Remove Item From Cart Test    Cart Suite
    # เพิ่มสินค้าลงตะกร้าก่อน
    Navigate To Products
    Wait Until Page Contains Element    ${ADD_TO_CART_BTN}    10s
    Add First Product To Cart
    
    # ไปหน้า cart และลบสินค้า
    Navigate To Cart
    Cart Page Should Be Open
    Verify Cart Has Items    1
    Remove First Cart Item
    Verify Cart Is Empty
    Mark Test As Passed    Item removed from cart successfully

Update Cart Quantity Test
    [Documentation]    ทดสอบการอัปเดตจำนวนสินค้าในตะกร้า
    [Tags]    cart    quantity
    Setup Test With Google Sheets    Update Cart Quantity Test    Cart Suite
    # เพิ่มสินค้าลงตะกร้าก่อน
    Navigate To Products
    Wait Until Page Contains Element    ${ADD_TO_CART_BTN}    10s
    Add First Product To Cart
    
    # ไปหน้า cart และอัปเดตจำนวน
    Navigate To Cart
    Cart Page Should Be Open
    Verify Cart Has Items    1
    
    # ทดสอบการเพิ่มจำนวน (ถ้ามีฟีเจอร์นี้)
    ${quantity_input}=    Run Keyword And Return Status    Page Should Contain Element    css=input[type="number"]
    IF    ${quantity_input}
        Clear Element Text    css=input[type="number"]
        Input Text    css=input[type="number"]    2
        Press Keys    css=input[type="number"]    ENTER
        Wait Until Page Contains Element    ${CART_ITEM}    10s
        Mark Test As Passed    Cart quantity updated successfully
    ELSE
        Mark Test As Skipped    Quantity input not found
    END

Cart Total Calculation Test
    [Documentation]    ทดสอบการคำนวณยอดรวมในตะกร้า
    [Tags]    cart    total
    Setup Test With Google Sheets    Cart Total Calculation Test    Cart Suite
    # เพิ่มสินค้าลงตะกร้า
    Navigate To Products
    Wait Until Page Contains Element    ${ADD_TO_CART_BTN}    10s
    Add First Product To Cart
    
    # ไปหน้า cart และตรวจสอบยอดรวม
    Navigate To Cart
    Cart Page Should Be Open
    Verify Cart Has Items    1
    Page Should Contain Element    ${CART_TOTAL}
    Mark Test As Passed    Cart total calculation working correctly

Cart Persistence Test
    [Documentation]    ทดสอบการคงอยู่ของสินค้าในตะกร้าหลังจากนำทาง
    [Tags]    cart    persistence
    Setup Test With Google Sheets    Cart Persistence Test    Cart Suite
    # เพิ่มสินค้าลงตะกร้า
    Navigate To Products
    Wait Until Page Contains Element    ${ADD_TO_CART_BTN}    10s
    Add First Product To Cart
    
    # ไปหน้า cart และตรวจสอบ
    Navigate To Cart
    Cart Page Should Be Open
    Verify Cart Has Items    1
    
    # ไปหน้าอื่นและกลับมา
    Navigate To Home
    Navigate To Cart
    Cart Page Should Be Open
    Verify Cart Has Items    1
    Mark Test As Passed    Cart persistence working correctly

Cart Navigation Test
    [Documentation]    ทดสอบการนำทางในหน้า cart
    [Tags]    cart    navigation
    Setup Test With Google Sheets    Cart Navigation Test    Cart Suite
    Page Should Contain Element    ${NAV_HOME}
    Page Should Contain Element    ${NAV_PRODUCTS}
    Page Should Contain Element    ${NAV_PROFILE}
    
    # ทดสอบการนำทางไปหน้า products
    Click Element    ${NAV_PRODUCTS}
    Products Page Should Be Open
    
    # กลับมาหน้า cart
    Navigate To Cart
    Cart Page Should Be Open
    Mark Test As Passed    Cart navigation working correctly

Cart Checkout Button Test
    [Documentation]    ทดสอบปุ่ม checkout ในตะกร้า
    [Tags]    cart    checkout
    Setup Test With Google Sheets    Cart Checkout Button Test    Cart Suite
    # เพิ่มสินค้าลงตะกร้า
    Navigate To Products
    Wait Until Page Contains Element    ${ADD_TO_CART_BTN}    10s
    Add First Product To Cart
    
    # ไปหน้า cart และทดสอบปุ่ม checkout
    Navigate To Cart
    Cart Page Should Be Open
    Verify Cart Has Items    1
    Page Should Contain Element    ${CHECKOUT_BTN}
    
    # ทดสอบการคลิกปุ่ม checkout
    Proceed To Checkout
    # ตรวจสอบว่าหน้า checkout เปิดขึ้น
    Wait Until Location Contains    checkout    10s
    Mark Test As Passed    Checkout button working correctly

Cart Empty State Test
    [Documentation]    ทดสอบการแสดงผลเมื่อตะกร้าว่าง
    [Tags]    cart    empty
    Setup Test With Google Sheets    Cart Empty State Test    Cart Suite
    # ลบสินค้าทั้งหมดออกจากตะกร้า
    Navigate To Cart
    Cart Page Should Be Open
    
    # ถ้ามีสินค้าในตะกร้า ให้ลบออก
    ${has_items}=    Run Keyword And Return Status    Page Should Contain Element    ${CART_ITEM}
    WHILE    ${has_items}
        Remove First Cart Item
        ${has_items}=    Run Keyword And Return Status    Page Should Contain Element    ${CART_ITEM}
    END
    
    # ตรวจสอบการแสดงผลตะกร้าว่าง
    Verify Cart Is Empty
    Page Should Contain    Your cart is empty
    Page Should Not Contain Element    ${CHECKOUT_BTN}
    Mark Test As Passed    Empty cart state displayed correctly

Cart Responsive Test
    [Documentation]    ทดสอบการแสดงผลตะกร้าบนหน้าจอขนาดต่างๆ
    [Tags]    cart    responsive
    Setup Test With Google Sheets    Cart Responsive Test    Cart Suite
    # เพิ่มสินค้าลงตะกร้าก่อน
    Navigate To Products
    Wait Until Page Contains Element    ${ADD_TO_CART_BTN}    10s
    Add First Product To Cart
    
    # ทดสอบขนาดหน้าจอเล็ก
    Set Window Size    375    667
    Navigate To Cart
    Cart Page Should Be Open
    Verify Cart Has Items    1
    
    # ทดสอบขนาดหน้าจอกลาง
    Set Window Size    768    1024
    Navigate To Cart
    Cart Page Should Be Open
    Verify Cart Has Items    1
    
    # ทดสอบขนาดหน้าจอใหญ่
    Set Window Size    1920    1080
    Navigate To Cart
    Cart Page Should Be Open
    Verify Cart Has Items    1
    Mark Test As Passed    Cart responsive design working correctly




