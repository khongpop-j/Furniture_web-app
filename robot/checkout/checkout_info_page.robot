*** Settings ***
Documentation     Checkout Information Page tests (SauceDemo) - single file, robust & no-screenshot
Library           SeleniumLibrary    run_on_failure=Nothing
Suite Setup       Login And Go To Inventory
Test Setup        Reset And Open Checkout Step One
Suite Teardown    Close Browser

*** Variables ***
${BASE_URL}          https://www.saucedemo.com/
${INVENTORY_URL}     https://www.saucedemo.com/inventory.html
${CART_URL}          https://www.saucedemo.com/cart.html
${STEP_ONE_URL}      https://www.saucedemo.com/checkout-step-one.html
${STEP_TWO_URL}      https://www.saucedemo.com/checkout-step-two.html
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
${BTN_CONTINUE_SHOP} css=button[data-test="continue-shopping"]
${BTN_CHECKOUT}      css=button[data-test="checkout"]

# Checkout Step One (Information)
${FN_FIELD}          css=input[data-test="firstName"]
${LN_FIELD}          css=input[data-test="lastName"]
${ZIP_FIELD}         css=input[data-test="postalCode"]
${BTN_CONTINUE_CO}   css=input[data-test="continue"]
${BTN_CANCEL_CO}     css=button[data-test="cancel"]
${ERR_BANNER}        css=h3[data-test="error"]

# Burger / Reset
${MENU_BTN}          id=react-burger-menu-btn
${MENU_WRAP}         css=.bm-menu-wrap
${RESET_LINK}        id=reset_sidebar_link
${CLOSE_MENU}        id=react-burger-cross-btn

*** Keywords ***
# ---------- Setup / Navigation ----------
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

Add Backpack If Needed
    ${already}=    Run Keyword And Return Status    Page Should Contain Element    ${REM_BACKPACK}
    IF    not ${already}
        Wait Until Element Is Visible    ${ADD_BACKPACK}    10s
        Scroll Element Into View         ${ADD_BACKPACK}
        Click Button                     ${ADD_BACKPACK}
        Wait Until Page Contains Element    ${REM_BACKPACK}    10s
    END

Open Cart
    Click Element    ${CART_LINK}
    Wait Until Location Is    ${CART_URL}    10s

Open Checkout Step One
    Wait Until Element Is Visible    ${BTN_CHECKOUT}    10s
    Click Button    ${BTN_CHECKOUT}
    Wait Until Location Is    ${STEP_ONE_URL}    10s
    Wait Until Page Contains Element    ${FN_FIELD}    10s

Reset And Open Checkout Step One
    Reset App State
    Add Backpack If Needed
    Open Cart
    Open Checkout Step One

# ---------- Form helpers ----------
Fill Checkout Form
    [Arguments]    ${first}    ${last}    ${zip}
    Clear Element Text    ${FN_FIELD}
    Clear Element Text    ${LN_FIELD}
    Clear Element Text    ${ZIP_FIELD}
    Input Text    ${FN_FIELD}    ${first}
    Input Text    ${LN_FIELD}    ${last}
    Input Text    ${ZIP_FIELD}    ${zip}

Submit Checkout
    Click Element    ${BTN_CONTINUE_CO}

Cancel Checkout
    Click Element    ${BTN_CANCEL_CO}

Error Should Contain
    [Arguments]    ${partial_text}
    Wait Until Page Contains Element    ${ERR_BANNER}    10s
    ${msg}=    Get Text    ${ERR_BANNER}
    Should Contain    ${msg}    ${partial_text}

# ---------- Assertions ----------
Should Be On Step Two
    Wait Until Location Is    ${STEP_TWO_URL}    10s

Should Be On Cart
    Wait Until Location Is    ${CART_URL}    10s

# ---------- Test Cases ----------
*** Test Cases ***
Continue With Valid Information Navigates To Step Two
    [Tags]    checkout  happy
    Fill Checkout Form    John    Doe    10110
    Submit Checkout
    Should Be On Step Two

Cancel Button Returns To Cart
    [Tags]    checkout  navigation
    Cancel Checkout
    Should Be On Cart

Missing First Name Shows Error
    [Tags]    checkout  validation
    Fill Checkout Form    ${EMPTY}    Doe    10110
    Submit Checkout
    Error Should Contain    First Name is required

Missing Last Name Shows Error
    [Tags]    checkout  validation
    Fill Checkout Form    John    ${EMPTY}    10110
    Submit Checkout
    Error Should Contain    Last Name is required

Missing Postal Code Shows Error
    [Tags]    checkout  validation
    Fill Checkout Form    John    Doe    ${EMPTY}
    Submit Checkout
    Error Should Contain    Postal Code is required

All Empty Shows First Name Required
    [Tags]    checkout  validation
    Fill Checkout Form    ${EMPTY}    ${EMPTY}    ${EMPTY}
    Submit Checkout
    Error Should Contain    First Name is required
