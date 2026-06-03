*** Settings ***
Documentation     Debug login page to see what elements are available
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}       http://localhost:3000
${BROWSER}        Chrome

*** Test Cases ***
Debug Login Page
    [Documentation]    ดู elements ที่มีในหน้า login
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    
    # ดู title ของหน้า
    ${title}=    Get Title
    Log    Page Title: ${title}
    
    # ดู source code ของหน้า
    ${source}=    Get Source
    Log    Page Source: ${source}
    
    # ดู elements ทั้งหมดที่มี
    ${elements}=    Get WebElements    css=*
    Log    Number of elements: ${elements.__len__()}
    
    # ดู input elements
    ${inputs}=    Get WebElements    css=input
    Log    Number of input elements: ${inputs.__len__()}
    
    # ดู button elements
    ${buttons}=    Get WebElements    css=button
    Log    Number of button elements: ${buttons.__len__()}
    
    # ดู form elements
    ${forms}=    Get WebElements    css=form
    Log    Number of form elements: ${forms.__len__()}
    
    # ดู text ที่มีในหน้า
    ${text}=    Get Text    css=body
    Log    Page Text: ${text}
    
    Close Browser




