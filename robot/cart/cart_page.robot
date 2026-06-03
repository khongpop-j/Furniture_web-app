*** Settings ***
Documentation     Cart Page function tests (SauceDemo) - single file, stable & retry-friendly
Library           SeleniumLibrary
Suite Setup       Login And Go To Inventory
Test Setup        Reset App State And Go To Cart
Suite Teardown    Close Browser

*** Variables ***
${BASE_URL}        https://www.saucedemo.com/
${INVENTORY_URL}   https://www.saucedemo.com/inventory.html
${CART_URL}        https://www.saucedemo.com/cart.html
${CHECKOUT_1_URL}  https://www.saucedemo.com/checkout-step-one.html
${BROWSER}         chrome

# Login
${U_FIELD}         css=input[data-test="username"]
${P_FIELD}         css=input[data-test="password"]
${LOGIN_BTN}       css=input[data-test="login-button"]

# Inventory
${FIRST_ITEM}      css=.inventory_item_name
${CART_BADGE}      css=.shopping_cart_badge
${CART_LINK}       id=shopping_cart_container

# Add/Remove by product (inventory & cart ใช้ data-test เดียวกัน)
${ADD_BACKPACK}    css=button[data-test="add-to-cart-sauce-labs-backpack"]
${REM_BACKPACK}    css=button[data-test="remove-sauce-labs-backpack"]
${ADD_BIKE}        css=button[data-test="add-to-cart-sauce-labs-bike-light"]
${REM_BIKE}        css=button[data-test="remove-sauce-labs-bike-light"]
${ADD_SHIRT}       css=button[data-test="add-to-cart-test.allthethings()-t-shirt-(red)"]
${REM_SHIRT}       css=button[data-test="remove-test.allthethings()-t-shirt-(red)"]

# Cart page
${CART_ITEM}       css=.cart_item
${CART_NAME}       css=.cart_item .inventory_item_name
${CART_QTY}        css=.cart_item .cart_quantity
${CART_PRICE}      css=.cart_item .inventory_item_price
${BTN_CONTINUE}    css=button[data-test="continue-shopping"]
${BTN_CHECKOUT}    css=button[data-test="checkout"]

# Burger menu / reset
${MENU_BTN}        id=react-burger-menu-btn
${MENU_WRAP}       css=.bm-menu-wrap
${RESET_LINK}      id=reset_sidebar_link
${CLOSE_MENU}      id=react-burger-cross-btn

*** Keywords ***
Login And Go To Inventory
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    ${U_FIELD}    15s
    Input Text     ${U_FIELD}    standard_user
    Input Text     ${P_FIELD}    secret_sauce
    Click Button   ${LOGIN_BTN}
    Wait Until Location Is    ${INVENTORY_URL}    15s
    Wait Until Page Contains Element    ${FIRST_ITEM}    15s

Reset App State
    Go To    ${INVENTORY_URL}
    Wait Until Page Contains Element    ${FIRST_ITEM}    10s
    Click Element    ${MENU_BTN}
    Wait Until Element Is Visible       ${MENU_WRAP}      10s
    Wait Until Keyword Succeeds    6x    2s    Click Element    ${RESET_LINK}
    ${closer}=    Run Keyword And Return Status    Page Should Contain Element    ${CLOSE_MENU}
    IF    ${closer}    Click Element    ${CLOSE_MENU}    END
    Reload Page
    Wait Until Page Contains Element    ${FIRST_ITEM}    10s

Reset App State And Go To Cart
    Reset App State
    Click Element    ${CART_LINK}
    Wait Until Location Is    ${CART_URL}    10s

# ---------- utilities ----------
Add Item If Needed
    [Arguments]    ${add_locator}    ${remove_locator}
    ${already}=    Run Keyword And Return Status    Page Should Contain Element    ${remove_locator}
    IF    not ${already}
        Wait Until Element Is Visible    ${add_locator}    10s
        Scroll Element Into View         ${add_locator}
        Click Button                     ${add_locator}
        Wait Until Page Contains Element    ${remove_locator}    10s
    END

Ensure In Inventory
    ${on_inventory}=    Run Keyword And Return Status    Location Should Be    ${INVENTORY_URL}
    IF    not ${on_inventory}
        Go To    ${INVENTORY_URL}
    END
    Wait Until Page Contains Element    ${FIRST_ITEM}    10s

Go To Cart
    Click Element    ${CART_LINK}
    Wait Until Location Is    ${CART_URL}    10s

Cart Should Contain Items
    [Arguments]    ${expected_count}
    Wait Until Keyword Succeeds    5x    2s    _Assert Cart Count    ${expected_count}

_Assert Cart Count
    [Arguments]    ${expected_count}
    ${items}=    Get Element Count    ${CART_ITEM}
    Should Be Equal As Integers    ${items}    ${expected_count}

Cart Badge Should Show
    [Arguments]    ${count}
    Wait Until Keyword Succeeds    5x    2s    _Assert Badge Equals    ${count}

_Assert Badge Equals
    [Arguments]    ${count}
    ${visible}=    Run Keyword And Return Status    Page Should Contain Element    ${CART_BADGE}
    IF    not ${visible}
        Reload Page
        ${visible}=    Run Keyword And Return Status    Page Should Contain Element    ${CART_BADGE}
    END
    Should Be True    ${visible}
    ${badge}=    Get Text    ${CART_BADGE}
    Should Be Equal    ${badge}    ${count}

Cart Should Be Empty (Robust)
    # ลองรอให้ DOM เคลียร์ แล้วคอนเฟิร์มว่าไม่มี item และ badge
    Wait Until Keyword Succeeds    5x    2s    Page Should Not Contain Element    ${CART_ITEM}
    Page Should Not Contain Element    ${CART_BADGE}

Remove All Items From Cart (Loop)
    # คลิกปุ่ม remove ทุกอันที่มี จนกว่าจะไม่เหลือ
    ${loops}=    Set Variable    0
    WHILE    ${loops} < 10
        ${buttons}=    Get WebElements    css=button[data-test^="remove-"]
        ${count}=      Get Length       ${buttons}
        Run Keyword If    ${count} == 0    Exit For Loop If    ${True}
        FOR    ${btn}    IN    @{buttons}
            Scroll Element Into View    ${btn}
            Click Element               ${btn}
            Sleep    0.2s
        END
        ${loops}=    Evaluate    ${loops} + 1
    END
    # ยืนยันไม่เหลือสินค้า
    Cart Should Be Empty (Robust)

# ---------- high-level flows ----------
Add Three Items And Go Cart
    Ensure In Inventory
    Add Item If Needed    ${ADD_BACKPACK}    ${REM_BACKPACK}
    Add Item If Needed    ${ADD_BIKE}        ${REM_BIKE}
    Add Item If Needed    ${ADD_SHIRT}       ${REM_SHIRT}
    Cart Badge Should Show    3
    Go To Cart
    Cart Should Contain Items    3

Add Backpack And Go Cart
    Ensure In Inventory
    Add Item If Needed    ${ADD_BACKPACK}    ${REM_BACKPACK}
    Cart Badge Should Show    1
    Go To Cart

*** Test Cases ***
Cart Shows Items Added From Inventory
    [Tags]    cart  smoke
    Add Three Items And Go Cart
    Page Should Contain    Sauce Labs Backpack
    Page Should Contain    Sauce Labs Bike Light
    Page Should Contain    Test.allTheThings() T-Shirt (Red)

Remove Single Item In Cart Updates Badge
    [Tags]    cart
    Add Three Items And Go Cart
    # ลบ backpack ออก 1 ชิ้น
    Wait Until Element Is Visible    ${REM_BACKPACK}    10s
    Click Button    ${REM_BACKPACK}
    Wait Until Page Does Not Contain    Sauce Labs Backpack    10s
    Cart Should Contain Items    2
    Cart Badge Should Show       2

Continue Shopping Returns To Inventory
    [Tags]    cart  navigation
    Add Backpack And Go Cart
    Click Button    ${BTN_CONTINUE}
    Wait Until Location Is    ${INVENTORY_URL}    10s
    Page Should Contain Element    ${FIRST_ITEM}

Checkout Button Goes To Step One
    [Tags]    cart  navigation
    Add Backpack And Go Cart
    Wait Until Element Is Visible    ${BTN_CHECKOUT}    10s
    Click Button    ${BTN_CHECKOUT}
    Wait Until Location Is    ${CHECKOUT_1_URL}    10s
    Go To Cart  # กลับมาที่ Cart เพื่อไม่ให้กระทบเคสอื่น

Remove All Items Clears Cart And Badge
    [Tags]    cart  clear
    Add Three Items And Go Cart
    Remove All Items From Cart (Loop)

Verify Name Qty Price Layout For Backpack
    [Tags]    cart  data
    Add Backpack And Go Cart
    ${names}=    Get WebElements    ${CART_NAME}
    ${found}=    Set Variable    ${False}
    FOR    ${el}    IN    @{names}
        ${text}=    Get Text    ${el}
        IF    '${text}' == 'Sauce Labs Backpack'
            Set Test Variable    ${found}    ${True}
        END
    END
    Should Be True    ${found}    msg=Backpack not listed in cart
    Page Should Contain Element    ${CART_QTY}
    Page Should Contain Element    ${CART_PRICE}
