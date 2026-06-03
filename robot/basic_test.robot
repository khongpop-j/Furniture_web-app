*** Settings ***
Documentation     Basic test for Furniture Office Application
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}       http://localhost:3000
${BROWSER}        Chrome

*** Test Cases ***
Home Page Test
    [Documentation]    ทดสอบการโหลดหน้าแรก
    [Tags]    basic
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Page Should Contain    Furniture
    Close Browser

Products Page Test
    [Documentation]    ทดสอบหน้า Products
    [Tags]    basic
    Open Browser    ${BASE_URL}/products    ${BROWSER}
    Maximize Browser Window
    Page Should Contain    Products
    Close Browser

Cart Page Test
    [Documentation]    ทดสอบหน้า Cart
    [Tags]    basic
    Open Browser    ${BASE_URL}/cart    ${BROWSER}
    Maximize Browser Window
    Page Should Contain    Cart
    Close Browser




