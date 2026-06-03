*** Settings ***
Documentation     Test cases สำหรับหน้า Login ของ Furniture Office Application
Resource          ../furniture_resource.robot
Suite Setup       Setup Test Suite With Google Sheets
Suite Teardown    Teardown Test Suite With Google Sheets
Test Setup        Navigate To Login
Test Teardown     Take Screenshot On Failure

*** Test Cases ***
Valid Login Test
    [Documentation]    ทดสอบการ login ด้วยข้อมูลที่ถูกต้อง
    [Tags]    login    valid
    Setup Test With Google Sheets    Valid Login Test    Login Suite
    Login With Valid Credentials
    Page Should Contain Element    ${NAV_PROFILE}
    Page Should Not Contain Element    ${NAV_LOGIN}
    Mark Test As Passed    Login successful with valid credentials

Invalid Email Login Test
    [Documentation]    ทดสอบการ login ด้วย email ที่ไม่ถูกต้อง
    [Tags]    login    invalid
    Setup Test With Google Sheets    Invalid Email Login Test    Login Suite
    Login With Invalid Credentials    ${INVALID_EMAIL}    ${VALID_PASSWORD}
    Page Should Contain Element    ${LOGIN_ERROR_MSG}
    Mark Test As Passed    Login correctly rejected invalid email

Invalid Password Login Test
    [Documentation]    ทดสอบการ login ด้วย password ที่ไม่ถูกต้อง
    [Tags]    login    invalid
    Setup Test With Google Sheets    Invalid Password Login Test    Login Suite
    Login With Invalid Credentials    ${VALID_EMAIL}    ${INVALID_PASSWORD}
    Page Should Contain Element    ${LOGIN_ERROR_MSG}
    Mark Test As Passed    Login correctly rejected invalid password

Empty Email Login Test
    [Documentation]    ทดสอบการ login โดยไม่กรอก email
    [Tags]    login    empty
    Setup Test With Google Sheets    Empty Email Login Test    Login Suite
    Input Login Password    ${VALID_PASSWORD}
    Submit Login Credentials
    Login Should Have Failed
    Mark Test As Passed    Login correctly rejected empty email

Empty Password Login Test
    [Documentation]    ทดสอบการ login โดยไม่กรอก password
    [Tags]    login    empty
    Setup Test With Google Sheets    Empty Password Login Test    Login Suite
    Input Login Email    ${VALID_EMAIL}
    Submit Login Credentials
    Login Should Have Failed
    Mark Test As Passed    Login correctly rejected empty password

Empty Fields Login Test
    [Documentation]    ทดสอบการ login โดยไม่กรอกข้อมูลใดๆ
    [Tags]    login    empty
    Setup Test With Google Sheets    Empty Fields Login Test    Login Suite
    Submit Login Credentials
    Login Should Have Failed
    Mark Test As Passed    Login correctly rejected empty fields

Login Page Elements Test
    [Documentation]    ทดสอบว่าหน้า login มี elements ที่จำเป็นครบถ้วน
    [Tags]    login    elements
    Setup Test With Google Sheets    Login Page Elements Test    Login Suite
    Page Should Contain Element    ${LOGIN_EMAIL_INPUT}
    Page Should Contain Element    ${LOGIN_PASSWORD_INPUT}
    Page Should Contain Element    ${LOGIN_SUBMIT_BTN}
    Page Should Contain    Login
    Page Should Contain    Email
    Page Should Contain    Password
    Mark Test As Passed    All required login elements present

Login Form Validation Test
    [Documentation]    ทดสอบการ validation ของฟอร์ม login
    [Tags]    login    validation
    Setup Test With Google Sheets    Login Form Validation Test    Login Suite
    # ทดสอบ email format
    Input Login Email    not-an-email
    Input Login Password    ${VALID_PASSWORD}
    Submit Login Credentials
    Login Should Have Failed
    
    # ทดสอบ password length
    Input Login Email    ${VALID_EMAIL}
    Input Login Password    short
    Submit Login Credentials
    Login Should Have Failed
    Mark Test As Passed    Login form validation working correctly

Login Navigation Test
    [Documentation]    ทดสอบการนำทางจากหน้า login
    [Tags]    login    navigation
    Setup Test With Google Sheets    Login Navigation Test    Login Suite
    Page Should Contain Element    ${NAV_HOME}
    Page Should Contain Element    ${NAV_PRODUCTS}
    Click Element    ${NAV_HOME}
    Home Page Should Be Open
    Mark Test As Passed    Login page navigation working correctly




