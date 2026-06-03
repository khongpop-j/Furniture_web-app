*** Settings ***
Documentation     Checkout Overview (Step Two) tests - robust, single file, no auto-screenshot
Library           SeleniumLibrary    run_on_failure=Nothing
Library           Collections
Library           String
Suite Setup       Login And Go To Inventory
Test Setup        Reset And Open Checkout Step Two (With 2 Items)
Suite Teardown    Close Browser

*** Variables ***
${BASE_URL}          https://www.saucedemo.com/
${INVENTORY_URL}     https://www.saucedemo.com/inventory.html
${CART_URL}          https://www.saucedemo.com/cart.html
${STEP_ONE_URL}      https://www.saucedemo.com/checkout-step-one.html
${STEP_TWO_URL}      https://www.saucedemo.com/checkout-step-two.html
${COMPLETE_URL}      https://www.saucedemo.com/checkout-complete.html
${BROWSER}           chrome

# Login
${U_FIELD}           css=input[data-test="username"]
${P_FIELD}           css=input[data-test="password"]
${LOGIN_BTN}         css=input[data-test="login-button"]

# Inventory & Cart
${FIRST_ITEM}        css=.inventory_item_name
${CART_BADGE}        css=.shopping_cart_badge
${CART_LINK}         id=shopping_cart_container
${ADD_BACKPACK}      css=button[data-test="add-to-cart-sauce-labs-backpack"]
${REM_BACKPACK}      css=button[data-test="remove-sauce-labs-backpack"]
${ADD_BIKE}          css=button[data-test="add-to-cart-sauce-labs-bike-light"]
${REM_BIKE}          css=button[data-test="remove-sauce-labs-bike-light"]
${BTN_CHECKOUT}      css=button[data-test="checkout"]

# Step One (Information)
${FN_FIELD}          css=input[data-test="firstName"]
${LN_FIELD}          css=input[data-test="lastName"]
${ZIP_FIELD}         css=input[data-test="postalCode"]
${BTN_CONTINUE_CO}   css=input[data-test="continue"]
${BTN_CANCEL_CO}     css=button[data-test="cancel"]

# Step Two (Overview)
${OV_ITEM_NAME}      css=.cart_item .inventory_item_name
${OV_ITEM_PRICE}     css=.cart_item .inventory_item_price
${SUMMARY_SUB}       css=.summary_subtotal_label
${SUMMARY_TAX}       css=.summary_tax_label
${SUMMARY_TOTAL}     css=.summary_total_label
${BTN_FINISH}        css=button[data-test="finish"]

# Complete
${COMPLETE_HEADER}   css=h2.complete-header
${BTN_BACK_HOME}     css=button[data-test="back-to-products"]

# Burger / Reset
${MENU_BTN}          id=react-burger-menu-btn
${MENU_WRAP}         css=.bm-menu-wrap
${RESET_LINK}        id=reset_sidebar_link
${CLOSE_MENU}        id=react-burger-cross-btn

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

Add Item If Needed
    [Arguments]    ${add_locator}    ${remove_locator}
    ${already}=    Run Keyword And Return Status    Page Should Contain Element    ${remove_locator}
    IF    not ${already}
        Wait Until Element Is Visible    ${add_locator}    10s
        Scroll Element Into View         ${add_locator}
        Click Button                     ${add_locator}
        Wait Until Page Contains Element    ${remove_locator}    10s
    END

Open Cart
    Click Element    ${CART_LINK}
    Wait Until Location Is    ${CART_URL}    10s

Open Checkout Step One
    Wait Until Element Is Visible    ${BTN_CHECKOUT}    10s
    Click Button    ${BTN_CHECKOUT}
    Wait Until Location Is    ${STEP_ONE_URL}    10s
    Wait Until Page Contains Element  ${FN_FIELD}        10s

Fill Any Valid Information
    Input Text    ${FN_FIELD}    John
    Input Text    ${LN_FIELD}    Doe
    Input Text    ${ZIP_FIELD}   10110
    Click Element    ${BTN_CONTINUE_CO}

Open Checkout Step Two
    Wait Until Location Is    ${STEP_TWO_URL}    10s
    Wait Until Page Contains Element    ${OV_ITEM_NAME}   10s
    Wait Until Page Contains Element    ${SUMMARY_SUB}    10s

Reset And Open Checkout Step Two (With 2 Items)
    Reset App State
    Add Item If Needed    ${ADD_BACKPACK}    ${REM_BACKPACK}
    Add Item If Needed    ${ADD_BIKE}        ${REM_BIKE}
    Open Cart
    Open Checkout Step One
    Fill Any Valid Information
    Open Checkout Step Two

# ---------- Helpers ----------
Parse Amount From Label
    [Arguments]    ${label_locator}    ${prefix}
    ${txt}=    Get Text    ${label_locator}
    ${val}=    Remove String    ${txt}    ${prefix}
    ${val}=    Remove String    ${val}    $
    ${num}=    Convert To Number    ${val}
    ${num}=    Evaluate    round(${num}, 2)
    [Return]    ${num}

Sum Item Prices On Overview
    ${els}=    Get WebElements    ${OV_ITEM_PRICE}
    ${sum}=    Set Variable    0.0
    FOR    ${e}    IN    @{els}
        ${t}=    Get Text    ${e}
        ${t}=    Remove String    ${t}    $
        ${sum}=  Evaluate    float(${sum}) + float(${t})
    END
    ${sum}=    Evaluate    round(${sum}, 2)
    [Return]    ${sum}

Numbers Should Be Equal To 2dp
    [Arguments]    ${a}    ${b}
    ${as}=    Evaluate    format(${a}, '.2f')
    ${bs}=    Evaluate    format(${b}, '.2f')
    Should Be Equal    ${as}    ${bs}

# ---------- Assertions ----------
Overview Should List Items
    [Arguments]    @{expected_names}
    ${names}=    Get WebElements    ${OV_ITEM_NAME}
    ${texts}=    Create List
    FOR    ${n}    IN    @{names}
        ${t}=    Get Text    ${n}
        Append To List    ${texts}    ${t}
    END
    FOR    ${exp}    IN    @{expected_names}
        List Should Contain Value    ${texts}    ${exp}
    END

Subtotal Equals Sum Of Item Prices
    ${sum}=    Sum Item Prices On Overview
    ${subtotal}=    Parse Amount From Label    ${SUMMARY_SUB}    Item total: $
    Numbers Should Be Equal To 2dp    ${sum}    ${subtotal}

Total Equals Subtotal Plus Tax
    ${subtotal}=    Parse Amount From Label    ${SUMMARY_SUB}    Item total: $
    ${tax}=         Parse Amount From Label    ${SUMMARY_TAX}    Tax: $
    ${total}=       Parse Amount From Label    ${SUMMARY_TOTAL}   Total: $
    ${calc}=        Evaluate    round(${subtotal}+${tax}, 2)
    Numbers Should Be Equal To 2dp    ${calc}    ${total}

Finish Should Go To Complete
    Click Element    ${BTN_FINISH}
    Wait Until Location Is    ${COMPLETE_URL}    10s
    Wait Until Page Contains Element    ${COMPLETE_HEADER}    10s
    Page Should Contain    Thank you for your order!

Cancel Should Return To Cart
    Click Element    ${BTN_CANCEL_CO}
    Wait Until Location Contains    /cart.html    10s

*** Test Cases ***
Overview Lists Selected Items
    [Tags]    overv
