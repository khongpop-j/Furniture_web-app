*** Settings ***
Library    SeleniumLibrary
Resource   ../login/resource.robot

*** Variables ***
${INVENTORY_URL}     https://www.saucedemo.com/inventory.html
${CART_URL}          https://www.saucedemo.com/cart.html

# locators (อ้างอิง data-test ของ SauceDemo)
${FILTER_SELECT}     css=select[data-test="product-sort-container"]
${ADD_BACKPACK}      css=button[data-test="add-to-cart-sauce-labs-backpack"]
${REM_BACKPACK}      css=button[data-test="remove-sauce-labs-backpack"]
${CART_BADGE}        css=.shopping_cart_badge
${CART_LINK}         id=shopping_cart_container
${FIRST_ITEM_TITLE}  css=.inventory_item_name
${ITEM_IMG}          css=.inventory_item_img img

*** Keywords ***
Login And Go To Inventory
    [Documentation]    ล็อกอินผู้ใช้ปกติและไปหน้าสินค้า
    Open Browser To Login Page
    Input Username    ${VALID USER}
    Input Password    ${VALID PASSWORD}
    Submit Credentials
    Welcome Page Should Be Open
    Wait Until Location Is    ${INVENTORY_URL}    10s

Sort Should Be    ${option_text}
    Select From List By Label    ${FILTER_SELECT}    ${option_text}
    # รอให้ DOM อัปเดต
    Wait Until Page Contains Element    ${FIRST_ITEM_TITLE}    5s

First Item Title Should Be    ${expected}
    ${text}=    Get Text    ${FIRST_ITEM_TITLE}
    Should Be Equal    ${text}    ${expected}

Add Backpack To Cart
    Click Button    ${ADD_BACKPACK}
    Wait Until Page Contains Element    ${REM_BACKPACK}    5s

Remove Backpack From Cart
    Click Button    ${REM_BACKPACK}
    Wait Until Page Does Not Contain Element    ${REM_BACKPACK}    5s

Cart Badge Should Show    ${count}
    Wait Until Page Contains Element    ${CART_BADGE}    3s
    ${badge}=    Get Text    ${CART_BADGE}
    Should Be Equal    ${badge}    ${count}

Open First Item Detail
    Click Element    ${FIRST_ITEM_TITLE}
    Wait Until Page Contains Element    ${ITEM_IMG}    5s
