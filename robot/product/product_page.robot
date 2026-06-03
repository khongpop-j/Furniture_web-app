*** Settings ***
Documentation     Product Page function tests (SauceDemo) - single file, stable & retry-friendly
Library           SeleniumLibrary    run_on_failure=Nothing
Suite Setup       Login And Go To Inventory
Test Setup        Reset App State To Inventory
Suite Teardown    Close Browser

*** Variables ***
${BASE_URL}        https://www.saucedemo.com/
${INVENTORY_URL}   https://www.saucedemo.com/inventory.html
${CART_URL}        https://www.saucedemo.com/cart.html
${BROWSER}         chrome

# Login
${U_FIELD}         css=input[data-test="username"]
${P_FIELD}         css=input[data-test="password"]
${LOGIN_BTN}       css=input[data-test="login-button"]

# Inventory
${FILTER_SELECT}   css=select[data-test="product-sort-container"]
${FIRST_ITEM}      css=.inventory_item_name
${CART_BADGE}      css=.shopping_cart_badge
${CART_LINK}       id=shopping_cart_container
${ADD_BACKPACK}    css=button[data-test="add-to-cart-sauce-labs-backpack"]
${REM_BACKPACK}    css=button[data-test="remove-sauce-labs-backpack"]

# Detail
${DETAIL_IMG}      css=img.inventory_details_img

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

Reset App State To Inventory
    Go To    ${INVENTORY_URL}
    Wait Until Page Contains Element    ${FIRST_ITEM}    10s
    Click Element    ${MENU_BTN}
    Wait Until Element Is Visible       ${MENU_WRAP}      10s
    Wait Until Keyword Succeeds    6x    2s    Click Element    ${RESET_LINK}
    ${closer}=    Run Keyword And Return Status    Page Should Contain Element    ${CLOSE_MENU}
    IF    ${closer}    Click Element    ${CLOSE_MENU}    END
    Reload Page
    Wait Until Page Contains Element    ${FIRST_ITEM}    10s

Sort Should Be
    [Arguments]    ${option_text}
    Wait Until Element Is Visible       ${FILTER_SELECT}   10s
    Select From List By Label           ${FILTER_SELECT}   ${option_text}
    Wait Until Page Contains Element    ${FIRST_ITEM}      5s

First Item Title Should Be
    [Arguments]    ${expected}
    ${text}=    Get Text    ${FIRST_ITEM}
    Should Be Equal    ${text}    ${expected}

Add Backpack To Cart (Idempotent)
    ${already}=    Run Keyword And Return Status    Page Should Contain Element    ${REM_BACKPACK}
    IF    not ${already}
        Wait Until Element Is Visible    ${ADD_BACKPACK}    10s
        Scroll Element Into View         ${ADD_BACKPACK}
        Click Button                     ${ADD_BACKPACK}
    END
    Wait Until Page Contains Element     ${REM_BACKPACK}   10s

Remove Backpack From Cart
    ${already}=    Run Keyword And Return Status    Page Should Contain Element    ${REM_BACKPACK}
    IF    ${already}
        Scroll Element Into View         ${REM_BACKPACK}
        Click Button                     ${REM_BACKPACK}
    END
    Wait Until Page Does Not Contain Element    ${REM_BACKPACK}    10s

Cart Badge Should Show
    [Arguments]    ${count}
    Wait Until Keyword Succeeds    5x    2s    _Assert Or Refresh Cart Badge Equals    ${count}

_Assert Or Refresh Cart Badge Equals
    [Arguments]    ${count}
    ${visible}=    Run Keyword And Return Status    Page Should Contain Element    ${CART_BADGE}
    IF    not ${visible}
        Reload Page
        Wait Until Page Contains Element    ${FIRST_ITEM}    5s
    END
    Wait Until Page Contains Element    ${CART_BADGE}    10s
    ${badge}=    Get Text    ${CART_BADGE}
    Should Be Equal    ${badge}    ${count}

Open First Item Detail
    Click Element    ${FIRST_ITEM}
    Wait Until Page Contains Element    ${DETAIL_IMG}    10s

*** Test Cases ***
Sort A To Z
    [Tags]    sort
    Sort Should Be    Name (A to Z)
    First Item Title Should Be    Sauce Labs Backpack

Sort Z To A
    [Tags]    sort
    Sort Should Be    Name (Z to A)
    First Item Title Should Be    Test.allTheThings() T-Shirt (Red)

Sort Price Low To High
    [Tags]    sort
    Sort Should Be    Price (low to high)
    First Item Title Should Be    Sauce Labs Onesie

Sort Price High To Low
    [Tags]    sort
    Sort Should Be    Price (high to low)
    First Item Title Should Be    Sauce Labs Fleece Jacket

Add To Cart Shows Badge = 1
    [Tags]    cart
    Add Backpack To Cart (Idempotent)
    Cart Badge Should Show    1

Remove From Cart Clears Badge
    [Tags]    cart
    Add Backpack To Cart (Idempotent)
    Cart Badge Should Show    1
    Remove Backpack From Cart
    Wait Until Page Does Not Contain Element    ${CART_BADGE}    15s

Open Product Detail From List
    [Tags]    detail
    Open First Item Detail
    Page Should Contain Element    ${DETAIL_IMG}

Cart Persists After Navigation
    [Tags]    cart
    Add Backpack To Cart (Idempotent)
    Click Element    ${CART_LINK}
    Wait Until Location Is    ${CART_URL}    10s
    Page Should Contain    Sauce Labs Backpack
