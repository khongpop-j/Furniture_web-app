*** Settings ***
Documentation     Simple test for Furniture Office Application
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}       http://localhost:3000
${BROWSER}        Chrome

*** Test Cases ***
Simple Home Page Test
    [Documentation]    ทดสอบการเปิดหน้าแรก
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Page Should Contain    Furniture
    Close Browser
