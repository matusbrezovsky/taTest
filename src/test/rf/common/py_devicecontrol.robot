*** Settings ***
# Resources
Resource        global_vars_template.txt

# Libraries
Library         Collections
Library         String
Library         DateTime
# these imports are now in suite setup "Do Imports"
# uncomment here for IDE code completion
#Library         DeviceControl
#Library         ATFCommons
#Resource        common_utils.txt
#Resource        common_utils.txt

Suite Setup     Do Imports
Test Setup      Unset Variables

*** Variables ***
${SKIP_DEVICE_TESTS}            False
${IGNORE_APPIUM_BUGS}           True
${SETTINGS_NWMODE_ITERATIONS}   1
${SETTINGS_CLIP_ITERATIONS}     1
${APLMODE_ITERATIONS}           1
${CALL_ITERATIONS}              5

*** Test Cases ***
add app 000
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    [Tags]  speech-path
    Skip This
    Initiate Device         MsPost1         phone_app
    Sleep                   5s
    Start Additional App    MsPost1         dtmf_app
    Sleep                   5s
    Release Device          MsPost1

rcs 000
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    [Tags]  rcs
    Initiate Device                 MsPost2     rcs_app
    Deactivate Rcs                  MsPost2
    Release Device                  MsPost2

    Initiate Device                 MsPost2     rcs_app
    Activate Rcs                    MsPost2
    Release Device                  MsPost2
    Initiate Device                 MsPost2     rcs_app
    Deactivate Rcs                  MsPost2
    Release Device                  MsPost2
    # clean start with rcs disabled
    Initiate Device                 MsPost2     rcs_app     force_restart=True
    Activate Rcs                    MsPost2
    Release Device                  MsPost2
    # clean start with rcs enabled
    Initiate Device                 MsPost2     rcs_app     force_restart=True
    Deactivate Rcs                  MsPost2
    Release Device                  MsPost2

rcs 001
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    [Tags]  rcs
    Initiate Device                 MsPost2     rcs_app
    Activate Rcs                    MsPost2
    ${s} =  Is RCS Active           MsPost2
    Run Keyword If      not ${s}    Fail        RCS status should have been active, was ${s}
    Release Device                  MsPost2

rcs 002
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    [Tags]  rcs
    Initiate Device                 MsPost2     rcs_app
    Deactivate Rcs                  MsPost2
    ${s} =  Is RCS Active           MsPost2
    Run Keyword If      ${s}        Fail        RCS status should have been deactive, was ${s}
    Release Device                  MsPost2

rcs 003
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    [Tags]  rcs
    Initiate Device                 MsPost2     rcs_app
    Trigger RCS Registration        MsPost2
    Release Device                  MsPost2

setNw 000
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    ${sub}=     Set Variable        MsPost1
    :FOR  ${i}  IN RANGE  ${SETTINGS_NWMODE_ITERATIONS}
    \   Debug Log                       ${TEST NAME} iteration: ${i}
    \   ${s}  ${e}=   run keyword and ignore error    change mobile network type      ${sub}     2G
    \   run keyword if   '${s}' == 'FAIL'    Fail    ${sub} failed on Iteration ${i}: ${e}


setNw 001
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    :FOR  ${i}  IN RANGE  ${SETTINGS_NWMODE_ITERATIONS}
    \   Debug Log                       ${TEST NAME} iteration: ${i}
    \   ${s}  ${e}=   run keyword and ignore error    change mobile network type      MsPost1     3G/2G
    \   run keyword if   '${s}' == 'FAIL'    Fail    Failed on Iteration ${i}: ${e}

setNw 002
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    :FOR  ${i}  IN RANGE  ${SETTINGS_NWMODE_ITERATIONS}
    \   Debug Log                       ${TEST NAME} iteration: ${i}
    \   ${s}  ${e}=   run keyword and ignore error    change mobile network type      MsPost1     3G
    \   run keyword if   '${s}' == 'FAIL'    Fail    Failed on Iteration ${i}: ${e}

setNw 003
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    :FOR  ${i}  IN RANGE  ${SETTINGS_NWMODE_ITERATIONS}
    \   Debug Log                       ${TEST NAME} iteration: ${i}
    \   ${s}  ${e}=   run keyword and ignore error    change mobile network type      MsPost1     LTE
    \   run keyword if   '${s}' == 'FAIL'    Fail    Failed on Iteration ${i}: ${e}


setNw 100
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Initiate Device                 MsPost1     phone_app
    run keyword and expect error    *failed - another App*      change mobile network type      MsPost1     2G
    Release Device                  MsPost1

setClip 000
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    ${sub}=     Set Variable        MsPost1
    :FOR  ${i}  IN RANGE  ${SETTINGS_CLIP_ITERATIONS}
    \   Debug Log                       ${TEST NAME} iteration: ${i}
    \   ${s}  ${e}=   run keyword and ignore error    change calling line presentation  ${sub}    show
    \   run keyword if   '${s}' == 'FAIL'    Fail    ${sub} Failed on Iteration ${i}: ${e}


setClip 001
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    :FOR  ${i}  IN RANGE  ${SETTINGS_CLIP_ITERATIONS}
    \   Debug Log                       ${TEST NAME} iteration: ${i}
    \   ${s}  ${e}=   run keyword and ignore error    change calling line presentation  MsPost1    hide
    \   run keyword if   '${s}' == 'FAIL'    Fail    Failed on Iteration ${i}: ${e}


setClip 002
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    :FOR  ${i}  IN RANGE  ${SETTINGS_CLIP_ITERATIONS}
    \   Debug Log                       ${TEST NAME} iteration: ${i}
    \   ${s}  ${e}=   run keyword and ignore error    change calling line presentation  MsPost1    network
    \   run keyword if   '${s}' == 'FAIL'    Fail    Failed on Iteration ${i}: ${e}


setClip 100
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Initiate Device                 MsPost1     phone_app
    run keyword and expect error    *failed - another App*      change calling line presentation  MsPost1    show
    Release Device                  MsPost1


sms 000
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Initiate Device             MsPost2     smsreader_app
    Delete SMS Conversations    MsPost2
    SMS Should Not Be Received  MsPost2     dummy text1
    SMS Should Not Be Received  MsPost2     dummy text2      timeout=10s
    Release Device              MsPost2

sms 001
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Initiate Device             MsPost1     smscomposer_app
    Initiate Device             MsPost2     smsreader_app

    ${tstmp}=     Get Current Date      result_format=%Y%m%d%H%M%S
    ${a_number}=  Reformat ISDN         ${MsPost1_ISDN}   format=Sn
    ${b_number}=  Reformat ISDN         ${MsPost2_ISDN}   format=PlusCc

    Compose SMS and Send    MsPost1     ${b_number}     ${tstmp}_${TEST NAME}
    Run Keyword and Expect Error        *SMS verification*  Verify SMS              MsPost2     ${tstmp}  timeout=2s
    Verify SMS              MsPost2     ${tstmp}
    Run Keyword and Expect Error        *Opening SMS*       Open SMS From           MsPost2     foobarsender
    Open SMS From           MsPost2     ${a_number}
    Verify SMS              MsPost2     ${tstmp}

    Release Device              MsPost1
    Release Device              MsPost2

sms 002
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Initiate Device             MsPost1     smscomposer_app
    Initiate Device             MsPost2     smsreader_app

    ${tstmp}=     Get Current Date      result_format=%Y%m%d%H%M%S
    ${a_number}=  Reformat ISDN         ${MsPost1_ISDN}   format=Sn
    ${b_number}=  Reformat ISDN         ${MsPost2_ISDN}   format=PlusCc

    Compose SMS and Send    MsPost1     ${b_number}     ${tstmp}_${TEST NAME}
    Run Keyword and Expect Error        *SMS verification*  SMS Should Be Received      MsPost2     ${tstmp}  timeout=2s
    SMS Should Be Received  MsPost2     ${tstmp}
    Run Keyword and Expect Error        *SMS was received*  SMS Should Not Be Received  MsPost2     ${tstmp}

    Release Device              MsPost1
    Release Device              MsPost2

reboot 000
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Reboot Devices                      MsPost1
    Wait Until Devices Are Available    MsPost1
    Sleep       60s     reason=wait for boot to complete, rebooting S5 again (in next test case) might crash adb on the PC-->all devices go offline

reboot 000a
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Reboot Devices      MsPost1  wait_until_rebooted=False
    Wait Until Devices Are Available    MsPost1
    Sleep       60s     reason=wait for boot to complete, rebooting S5 again (in next test case) might crash adb on the PC-->all devices go offline

reboot 001
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Reboot Devices      MsPost1  wait_until_rebooted=True
    Sleep       60s     reason=wait for boot to complete, rebooting S5 again (in next test case) might crash adb on the PC-->all devices go offline

reboot 010
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    ${dev}=     Create List     MsPost1  MsPost2
    Reboot Devices                      ${dev}
    Wait Until Devices Are Available    ${dev}
    Sleep       60s     reason=wait for boot to complete, rebooting S5 again (in next test case) might crash adb on the PC-->all devices go offline

reboot 010a
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    ${dev}=     Create List     MsPost1  MsPost2
    Reboot Devices                      ${dev}     wait_until_rebooted=False
    Wait Until Devices Are Available    ${dev}
    Sleep       60s     reason=wait for boot to complete, rebooting S5 again (in next test case) might crash adb on the PC-->all devices go offline

reboot 011
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    ${dev}=     Create List     MsPost1  MsPost2
    Reboot Devices                      ${dev}     wait_until_rebooted=True
    Wait Until Devices Are Available    ${dev}
    Sleep       60s     reason=wait for boot to complete, rebooting S5 again (in next test case) might crash adb on the PC-->all devices go offline

airpl 011
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Enable Airplane Mode        MsPost1     verify=False    adb=True
    Disable Airplane Mode       MsPost1     verify=False    adb=True

airpl 011a
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Run Keyword and Expect Error     *Cannot verify*     Disable Airplane Mode       MsPost1     verify=True    adb=True

airpl 011b
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Run Keyword and Expect Error     *Cannot verify*     Disable Airplane Mode       MsPost1     adb=True

airpl 030
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device                 MsPost1             smscomposer_app
    Run Keyword and Expect Error    *Cannot verify*     Disable Airplane Mode       MsPost1     adb=True
    Release Device                  MsPost1

airpl 030a
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device                 MsPost1             smscomposer_app
    Run Keyword and Expect Error    *Cannot verify*     Disable Airplane Mode       MsPost1     verify=True    adb=True
    Release Device                  MsPost1

airpl 030b
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device         MsPost1     smscomposer_app
    Enable Airplane Mode    MsPost1     verify=False    adb=True
    Sleep                   1s
    Disable Airplane Mode   MsPost1     verify=False    adb=True
    Release Device          MsPost1

## run tests with coverage verification last - otherwise the next ones might fail because there's no coverage yet
airpl 090
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device         MsPost1     phone_app
    Enable Airplane Mode    MsPost1     verify=False    adb=True
    Sleep                   1s
    Disable Airplane Mode   MsPost1     verify=False    adb=True
    Release Device          MsPost1

airpl 091
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    ${sub}=     Set Variable        MsPost1
    :FOR  ${i}  IN RANGE  ${APLMODE_ITERATIONS}
    \   Debug Log                       ${TEST NAME} iteration: ${i}
    \   Initiate Device         ${sub}     phone_app
    \   ${s}  ${e}=   run keyword and ignore error      Enable Airplane Mode    ${sub}     verify=True     adb=True    
    \   run keyword if   '${s}' == 'FAIL'    Fail       ${sub} failed on Iteration ${i}: ${e}
    \   Sleep                   1s
    \   ${s}  ${e}=   run keyword and ignore error      Disable Airplane Mode   ${sub}     verify=True     adb=True    
    \   run keyword if   '${s}' == 'FAIL'    Fail       ${sub} failed on Iteration ${i}: ${e}
    \   Release Device          ${sub}

    ${sub}=     Set Variable        MsPost2
    

airpl 091a
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    ${sub}=     Set Variable        MsPost1
    :FOR  ${i}  IN RANGE  ${APLMODE_ITERATIONS}
    \   Debug Log                       ${TEST NAME} iteration: ${i}
    \   Initiate Device         ${sub}     phone_app
    \   ${s}  ${e}=   run keyword and ignore error      Enable Airplane Mode    ${sub}                  adb=True    
    \   run keyword if   '${s}' == 'FAIL'    Fail       ${sub} failed on Iteration ${i}: ${e}
    \   Sleep                   1s
    \   ${s}  ${e}=   run keyword and ignore error      Disable Airplane Mode   ${sub}                  adb=True    
    \   run keyword if   '${s}' == 'FAIL'    Fail       ${sub} failed on Iteration ${i}: ${e}
    \   Release Device          ${sub}



airpl 110
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Pass Execution If      ${IGNORE_APPIUM_BUGS}     Skipped, because of Appium bugs

    Run Keyword and Expect Error     *Cannot change*     Enable Airplane Mode        MsPost1

airpl 111
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Pass Execution If      ${IGNORE_APPIUM_BUGS}     Skipped, because of Appium bugs

    Run Keyword and Expect Error     *Cannot change*     Enable Airplane Mode        MsPost1     verify=False    adb=False
    Run Keyword and Expect Error     *Cannot change*     Disable Airplane Mode       MsPost1     verify=False    adb=False

airpl 111a
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Pass Execution If      ${IGNORE_APPIUM_BUGS}     Skipped, because of Appium bugs

    Run Keyword and Expect Error     *Cannot change*     Disable Airplane Mode       MsPost1     verify=True    adb=False

airpl 111b
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Pass Execution If      ${IGNORE_APPIUM_BUGS}     Skipped, because of Appium bugs

    Run Keyword and Expect Error     *Cannot change*     Disable Airplane Mode       MsPost1     adb=False

airpl 130
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Pass Execution If      ${IGNORE_APPIUM_BUGS}     Skipped, because of Appium bugs

    Initiate Device                 MsPost1             smscomposer_app
    Run Keyword and Expect Error    *Cannot verify*     Disable Airplane Mode       MsPost1     adb=False
    Release Device                  MsPost1

airpl 130a
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Pass Execution If      ${IGNORE_APPIUM_BUGS}     Skipped, because of Appium bugs

    Initiate Device                 MsPost1             smscomposer_app
    Run Keyword and Expect Error    *Cannot verify*     Disable Airplane Mode       MsPost1     verify=True    adb=False
    Release Device                  MsPost1

airpl 130b
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Pass Execution If      ${IGNORE_APPIUM_BUGS}     Skipped, because of Appium bugs

    Initiate Device         MsPost1     smscomposer_app
    Enable Airplane Mode    MsPost1     verify=False    adb=False
    Sleep                   1s
    Disable Airplane Mode   MsPost1     verify=False    adb=False
    Release Device          MsPost1

## run tests with coverage verification last - otherwise the next ones might fail because there's no coverage yet
airpl 190
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Pass Execution If      ${IGNORE_APPIUM_BUGS}     Skipped, because of Appium bugs

    Initiate Device         MsPost1     phone_app
    Enable Airplane Mode    MsPost1     verify=False    adb=False
    Sleep                   1s
    Disable Airplane Mode   MsPost1     verify=False
    Release Device          MsPost1

airpl 191
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Pass Execution If      ${IGNORE_APPIUM_BUGS}     Skipped, because of Appium bugs

    Initiate Device         MsPost1     phone_app
    Enable Airplane Mode    MsPost1     verify=True
    Sleep                   1s
    Disable Airplane Mode   MsPost1     verify=True     adb=False
    Release Device          MsPost1

airpl 191a
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Pass Execution If      ${IGNORE_APPIUM_BUGS}     Skipped, because of Appium bugs

    Initiate Device         MsPost1     phone_app
    Enable Airplane Mode    MsPost1
    Sleep                   1s
    Disable Airplane Mode   MsPost1
    Release Device          MsPost1


trigger LU 000
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Pass Execution If      ${IGNORE_APPIUM_BUGS}     Skipped, because of Appium bugs

    Initiate Device             MsPost1     phone_app
    Trigger Update Location     MsPost1
    Release Device              MsPost1

trigger LU 001
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Pass Execution If      ${IGNORE_APPIUM_BUGS}     Skipped, because of Appium bugs

    Initiate Device             MsPost1     phone_app
    Trigger Update Location     MsPost1     verify=False
    Release Device              MsPost1

trigger LU 010
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This

    Initiate Device             MsPost1     phone_app
    Trigger Update Location     MsPost1     verify=True   adb=True
    Release Device              MsPost1

trigger LU 011
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    [Tags]  v2.0
    Skip This

    Trigger Update Location             MsPost1     verify=False   adb=True
    Run Keyword and Expect Error     *Cannot verify*     Wait Until Attached in Network    MsPost1
    Initiate Device             MsPost1     phone_app
    Wait Until Attached in Network    MsPost1
    Release Device              MsPost1

dial 000
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device     MsPost1     phone_app
    ${b_number} =       Reformat ISDN   ${MsPost2_ISDN}   format=PlusCc
    Dial                MsPost1         ${b_number}
    Release Device      MsPost1

dial 000a
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    [Tags]  v2.0
    Skip This
    Initiate Device     MsPost1     phone_app
    Run Keyword and Expect Error    *Unknown Digit*     Dial    MsPost1    a
    Release Device      MsPost1

dial 000b
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    ${b_number} =       Reformat ISDN   ${MsPost2_ISDN}   format=PlusCc
    Initiate Device     MsPost1     phone_app
    Dial and Call       MsPost1     ${b_number}     expect_txt=Dial
    End Call            MsPost1
    Release Device      MsPost1

dial 000c
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    ${b_number} =       Reformat ISDN   ${MsPost2_ISDN}   format=PlusCc
    Initiate Device                     MsPost1     phone_app
    Call Should Connect And Disconnect  MsPost1     ${b_number}     expect_txt=Dial
    Release Device                      MsPost1

dial 000d
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device             MsPost1     phone_app
    Call Should Not Connect     MsPost1     01234567+
    Sleep                       1s
    Call Should Not Connect     MsPost1     01234567+   timeout=3s
    Release Device              MsPost1

dial 000e
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device             MsPost1     phone_app
    :FOR  ${i}  IN RANGE  ${CALL_ITERATIONS}
    \   ${s}  ${e}=   run keyword and ignore error    Call Should Fail            MsPost1     123*
    \   run keyword if   '${s}' == 'FAIL'    Fail    Failed on Iteration ${i}: ${e}

    Release Device              MsPost1

ussd 000
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device                 MsPost1     phone_app
    Run Keyword And Expect Error    *USSD*      Dial and Call Ussd   MsPost1  ${USSD_BOGUS}     expect_txt=missing text   timeout=5s
    Dial and Call Ussd              MsPost1     ${USSD_CFU_READ}     expect_txt=${USSD_MSG_CF_READ_OK}
    Release Device                  MsPost1


call 000
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device     MsPost1     phone_app
    Initiate Device     MsPost2     phone_app

    ${a_number} =       Reformat ISDN   ${MsPost1_ISDN}   format=Sn
    ${b_number} =       Reformat ISDN   ${MsPost2_ISDN}   format=PlusCc

    Dial and Call       MsPost1     ${b_number}     expect_txt=Dial
    Reject Call         MsPost2                     expect_txt=${a_number}
    End Call            MsPost1

    Dial and Call               MsPost1     ${b_number}     expect_txt=Dial
    Verify Caller               MsPost2                     expect_txt=${a_number}
    Toggle Speaker              MsPost1
    Answer Call                 MsPost2                     expect_txt=${a_number}
    Call Should Be Connected    MsPost1
    Call Should Be Connected    MsPost2
    End Call                    MsPost1

    Release Device      MsPost1
    Release Device      MsPost2

calladb 000
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown

    ${a_number} =   Reformat ISDN       ${MsPost1_ISDN}     format=Sn
    ${b_number} =   Reformat ISDN       ${MsPost2_ISDN}     format=PlusCc
    Start Notification Log              MsPost1
    # Phone is rebooted due to Android bug - wait until we have coverage again
    Sleep                               60s                 reason=Wait for coverage

    Initiate Device                     MsPost2             phone_app
    Dial and Call with ADB              MsPost1             ${b_number}
    Answer Call                         MsPost2             expect_txt=${a_number}
    End Call With ADB                   MsPost1
    Release Device                      MsPost2

    Verify Notification                 MsPost1             call forward

devSetup 000
    Device Setup

    ${reverse_devices}=     get variable value  ${REV_DEV}     False
    ${v}=   Get From Dictionary   ${DEV_ALIASES}    MsPost1
    Run Keyword If      not ${reverse_devices}      Should Be Equal As Strings    ${v}    DEV_1
    Run Keyword If      ${reverse_devices}          Should Be Equal As Strings    ${v}    DEV_2
    ${v}=   Get From Dictionary   ${DEV_ALIASES}    MsPost2
    Run Keyword If      not ${reverse_devices}      Should Be Equal As Strings    ${v}    DEV_2
    Run Keyword If      ${reverse_devices}          Should Be Equal As Strings    ${v}    DEV_1
    ${v}=   Get From Dictionary   ${DEV_ALIASES}  MsPre1
    Run Keyword If      not ${reverse_devices}      Should Be Equal As Strings    ${v}    DEV_3
    Run Keyword If      ${reverse_devices}          Should Be Equal As Strings    ${v}    DEV_4
    ${v}=   Get From Dictionary   ${DEV_ALIASES}  MsPre2
    Run Keyword If      not ${reverse_devices}      Should Be Equal As Strings    ${v}    DEV_4
    Run Keyword If      ${reverse_devices}          Should Be Equal As Strings    ${v}    DEV_3

    ${keys}=    Get Dictionary Keys   ${dev_status}
    :FOR  ${k}   IN   @{keys}
    \   ${v}=   Get From Dictionary   ${dev_status}  ${k}
    \   Should Be Equal As Integers   ${v}    0
    \   ${v}=   Get Device Status     ${k}
    \   Should Be Equal As Integers   ${v}    0

    ${keys}=    Get Dictionary Keys   ${dev_actapp}
    :FOR  ${k}   IN   @{keys}
    \   ${v}=   Get From Dictionary   ${dev_actapp}  ${k}
    \   Should Be Equal As Strings    ${v}    noactapp

devSetup 000a
    Run Keyword And Expect Error    *TypeError*        Get From Dictionary   ${DEV_ALIASES}  MsPost1

    Run Keyword And Expect Error    *TypeError*        Get Dictionary Keys   ${dev_status}

    Run Keyword And Expect Error    *TypeError*        Get Dictionary Keys   ${dev_actapp}

devCleanup 001
    Device Setup
    Device Cleanup

    ${reverse_devices}=     get variable value  ${REV_DEV}     False
    ${v}=   Get From Dictionary   ${DEV_ALIASES}    MsPost1
    Run Keyword If      not ${reverse_devices}      Should Be Equal As Strings    ${v}    DEV_1
    Run Keyword If      ${reverse_devices}          Should Be Equal As Strings    ${v}    DEV_2
    ${v}=   Get From Dictionary   ${DEV_ALIASES}    MsPost2
    Run Keyword If      not ${reverse_devices}      Should Be Equal As Strings    ${v}    DEV_2
    Run Keyword If      ${reverse_devices}          Should Be Equal As Strings    ${v}    DEV_1
    ${v}=   Get From Dictionary   ${DEV_ALIASES}  MsPre1
    Run Keyword If      not ${reverse_devices}      Should Be Equal As Strings    ${v}    DEV_3
    Run Keyword If      ${reverse_devices}          Should Be Equal As Strings    ${v}    DEV_4
    ${v}=   Get From Dictionary   ${DEV_ALIASES}  MsPre2
    Run Keyword If      not ${reverse_devices}      Should Be Equal As Strings    ${v}    DEV_4
    Run Keyword If      ${reverse_devices}          Should Be Equal As Strings    ${v}    DEV_3

    ${keys}=    Get Dictionary Keys   ${dev_status}
    :FOR  ${k}   IN   @{keys}
    \   ${v}=   Get From Dictionary   ${dev_status}  ${k}
    \   Should Be Equal As Integers   ${v}    0
    \   ${v}=   Get Device Status     ${k}
    \   Should Be Equal As Integers   ${v}    0

    ${keys}=    Get Dictionary Keys   ${dev_actapp}
    :FOR  ${k}   IN   @{keys}
    \   ${v}=   Get From Dictionary   ${dev_actapp}  ${k}
    \   Should Be Equal As Strings    ${v}    noactapp

devCleanup 002
    [Tags]  v2.0
    Run Keyword And Expect Error    *Status not available*    Device Cleanup

devStatus 000
    [Tags]  v2.0
    Run Keyword And Expect Error    *Status not available*    Get Device Status   MsPost1

initDev 000a
    Skip This
    Device Setup
    Initiate Device     MsPost1     phone_app
    Release Device      MsPost1
    Device Cleanup

initDev 000b
    Skip This
    Device Setup
    Initiate Device     MsPost1     phone_app
    Device Cleanup

initDev 001a
    Skip This
    Device Setup
    Initiate Device     MsPost1     phone_app
    Release Device      MsPost1
    Device Cleanup
    Initiate Device     MsPost1     smsreader_app
    Release Device      MsPost1
    Device Cleanup

initDev 001b
    Skip This
    Device Setup
    Initiate Device     MsPost1     phone_app
    Device Cleanup
    Initiate Device     MsPost1     smsreader_app
    Release Device      MsPost1
    Device Cleanup

initDev 010a
    [Tags]  v2.0
    Skip This
    Run Keyword And Expect Error    *Dictionary Exception*    Initiate Device     MsPost1     phone_app

initDev 010b
    [Tags]  v2.0
    Skip This
    Device Setup
    Initiate Device     MsPost1     phone_app
    Run Keyword And Expect Error    *Not able to open App*      Initiate Device     MsPost1     smsreader_app
    Release Device      MsPost1

initApp 000
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device     MsPost1     phone_app
    Release Device      MsPost1

initApp 001
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device     MsPost1     smsreader_app
    Release Device      MsPost1

initApp 002
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device     MsPost1     smscomposer_app
    Release Device      MsPost1

initApp 003
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device     MsPost1     settings_app
    Release Device      MsPost1

initApp 004
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    ${running_on_mac}=     get variable value  ${MAC}     False
    run keyword if      ${running_on_mac}      Pass Execution   problems with appium chrome-driver on MAC
    Initiate Device     MsPost1     browser_app
    Release Device      MsPost1

appiumWorkarounds 000
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device     MsPost1     phone_app


    Text Should Be Displayed        Contacts
    Text Should Be Displayed        Contacts                 srcloglevel=INFO
    Run Keyword and Expect Error    *should have contained*  Text Should Be Displayed     Foo
    Run Keyword and Expect Error    *should have contained*  Text Should Be Displayed     Foo   retries=2
    Run Keyword and Expect Error    *should have contained*  Text Should Be Displayed     Foo   delay=0.5s
    Run Keyword and Expect Error    *should have contained*  Text Should Be Displayed     Foo   retries=2   delay=0.5s

    Wait Until Text is Displayed    Contacts
    Wait Until Text is Displayed    Contacts                 srcloglevel=INFO
    Run Keyword and Expect Error    *did not appear within*  Wait Until Text is Displayed     Foo
    Run Keyword and Expect Error    *did not appear within*  Wait Until Text is Displayed     Foo   timeout=3s
    Run Keyword and Expect Error    *did not appear within*  Wait Until Text is Displayed     Foo   delay=0.5s
    Run Keyword and Expect Error    *did not appear within*  Wait Until Text is Displayed     Foo   timeout=3s  delay=0.5s

    Wait Until Element Is Displayed     identifier = com.android.contacts:id/two
    Wait Until Element Is Displayed     identifier = com.android.contacts:id/one            srcloglevel=INFO
    Run Keyword and Expect Error        *did not appear within*         Wait Until Element Is Displayed     identifier = com.android.contacts:id/foo
    Run Keyword and Expect Error        *did not appear within*         Wait Until Element Is Displayed     identifier = com.android.contacts:id/foo    timeout=3s
    Run Keyword and Expect Error        *did not appear within*         Wait Until Element Is Displayed     identifier = com.android.contacts:id/foo    delay=0.5s
    Run Keyword and Expect Error        *did not appear within*         Wait Until Element Is Displayed     identifier = com.android.contacts:id/foo    timeout=3s  delay=0.5s

    Click Element with Retry        identifier = com.android.contacts:id/two
    Run Keyword and Expect Error    *not match any elem*                    Click Element with Retry            identifier = com.android.contacts:id/foo    retries=2
    Run Keyword and Expect Error    *not match any elem*                    Click Element with Retry            identifier = com.android.contacts:id/foo    delay=0.5s
    Run Keyword and Expect Error    *not match any elem*                    Click Element with Retry            identifier = com.android.contacts:id/foo    retries=2       delay=0.5s


    Release Device      MsPost1

appiumWorkarounds 000a
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device     MsPost1     phone_app

    ${r} =  Text Should Be Displayed     Foo   fail_on_error=False   delay=0.5s
    Should Be Equal As Integers    ${r}     1
    ${r} =  Text Should Be Displayed     Foo   fail_on_error=False
    Should Be Equal As Integers    ${r}     1
    ${r} =  Text Should Be Displayed     Foo   fail_on_error=False   retries=2
    Should Be Equal As Integers    ${r}     1
    ${r} =  Text Should Be Displayed     Foo   fail_on_error=False   retries=2   delay=0.5s
    Should Be Equal As Integers    ${r}     1

    ${r} =   Wait Until Text is Displayed     Foo   fail_on_error=False
    Should Be Equal As Integers    ${r}     1
    ${r} =   Wait Until Text is Displayed     Foo   fail_on_error=False     timeout=3s
    Should Be Equal As Integers    ${r}     1
    ${r} =   Wait Until Text is Displayed     Foo   fail_on_error=False     delay=0.5s
    Should Be Equal As Integers    ${r}     1
    ${r} =   Wait Until Text is Displayed     Foo   fail_on_error=False     timeout=3s  delay=0.5s
    Should Be Equal As Integers    ${r}     1

    ${r} =   Wait Until Element Is Displayed     identifier = com.android.contacts:id/foo    fail_on_error=False
    Should Be Equal As Integers    ${r}     1
    ${r} =   Wait Until Element Is Displayed     identifier = com.android.contacts:id/foo    fail_on_error=False    timeout=3s
    Should Be Equal As Integers    ${r}     1
    ${r} =   Wait Until Element Is Displayed     identifier = com.android.contacts:id/foo    fail_on_error=False    delay=0.5s
    Should Be Equal As Integers    ${r}     1
    ${r} =   Wait Until Element Is Displayed     identifier = com.android.contacts:id/foo    fail_on_error=False    timeout=3s  delay=0.5s
    Should Be Equal As Integers    ${r}     1

    ${r} =   Click Element with Retry            identifier = com.android.contacts:id/foo    fail_on_error=False    retries=2
    Should Be Equal As Integers    ${r}     1
    ${r} =   Click Element with Retry            identifier = com.android.contacts:id/foo    fail_on_error=False    delay=0.5s
    Should Be Equal As Integers    ${r}     1
    ${r} =   Click Element with Retry            identifier = com.android.contacts:id/foo    fail_on_error=False    retries=2       delay=0.5s
    Should Be Equal As Integers    ${r}     1


    Release Device      MsPost1

appiumWorkarounds 001
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    Skip This
    Initiate Device     MsPost1     smscomposer_app
    #Input Text with Retry
    ${dev}  ${app}=     Get Device Config   MsPost1     smscomposer_app
    Input Text with Retry          identifier = ${app['recipient_txt']}    234
    Run Keyword and Expect Error    *not match any elem*                    Input Text with Retry           identifier = com.android.mms:id/recipients_foo    444   retries=2
    Run Keyword and Expect Error    *not match any elem*                    Input Text with Retry           identifier = com.android.mms:id/recipients_foo    444   delay=0.5s
    Run Keyword and Expect Error    *not match any elem*                    Input Text with Retry           identifier = com.android.mms:id/recipients_foo    444   retries=2       delay=0.5s

    Release Device      MsPost1

appiumWorkarounds 002
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    [Tags]  v2.0
    Skip This
    Initiate Device     MsPost1     phone_app


    Element Should Be Displayed     identifier = com.android.contacts:id/two
    Element Should Be Displayed     identifier = com.android.contacts:id/two                srcloglevel=INFO
    Run Keyword and Expect Error    *should have contained*                 Element Should Be Displayed     identifier = com.android.contacts:id/Foo
    Run Keyword and Expect Error    *should have contained*                 Element Should Be Displayed     identifier = com.android.contacts:id/Foo   retries=2
    Run Keyword and Expect Error    *should have contained*                 Element Should Be Displayed     identifier = com.android.contacts:id/Foo   delay=0.5s
    Run Keyword and Expect Error    *should have contained*                 Element Should Be Displayed     identifier = com.android.contacts:id/Foo   retries=2   delay=0.5s

    Release Device      MsPost1

appiumWorkarounds 002a
    [Setup]     DefTcSetup
    [Teardown]  DefTcTeardown
    [Tags]  v2.0
    Skip This
    Initiate Device     MsPost1     phone_app

    ${r} =   Element Should Be Displayed     identifier = com.android.contacts:id/Foo   fail_on_error=False
    Should Be Equal As Integers    ${r}     1
    ${r} =   Element Should Be Displayed     identifier = com.android.contacts:id/Foo   fail_on_error=False   retries=2
    Should Be Equal As Integers    ${r}     1
    ${r} =   Element Should Be Displayed     identifier = com.android.contacts:id/Foo   fail_on_error=False   delay=0.5s
    Should Be Equal As Integers    ${r}     1
    ${r} =   Element Should Be Displayed     identifier = com.android.contacts:id/Foo   fail_on_error=False   retries=2   delay=0.5s
    Should Be Equal As Integers    ${r}     1

    Release Device      MsPost1

*** Keywords ***
Do Imports
    ${run_with_RF_resources}=   get variable value   ${RF_MODE}     False
    Run Keyword If      ${run_with_RF_resources}        import resource     device_ctrl.txt
    Run Keyword If      ${run_with_RF_resources}        import resource     common_utils.txt
    Run Keyword If      not ${run_with_RF_resources}    import library      DeviceControl
    Run Keyword If      not ${run_with_RF_resources}    import library      ATFCommons


    ${reverse_devices}=     get variable value  ${REV_DEV}     False
    ${al_lst}=              create list         MsPost1   MsPost2   MsPre1   MsPre2
    ${dv_lst}=              create list         DEV_2     DEV_1     DEV_4    DEV_3
    ${p1}=                  set variable        ${MsPost1_ISDN}
    ${p2}=                  set variable        ${MsPost2_ISDN}
    Run Keyword If      ${reverse_devices}      set global variable    ${MsPost1_ISDN}      ${p2}
    Run Keyword If      ${reverse_devices}      set global variable    ${MsPost2_ISDN}      ${p1}
    Run Keyword If      ${reverse_devices}      set global variable    ${ALIAS_LIST}        ${al_lst}
    Run Keyword If      ${reverse_devices}      set global variable    ${DEV_LIST}          ${dv_lst}

    ${dict}=    Create Dictionary
    ${len}=     Get Length   ${ALIAS_LIST}
    :FOR    ${i}  IN RANGE  0  ${len}
    \   ${key} =    Get From List       ${ALIAS_LIST}       ${i}
    \   ${value} =  Get From List       ${DEV_LIST}         ${i}
    \   Set To Dictionary   ${dict}     ${key}              ${value}
    ${dev_str}=     Catenate   Devs:
    :FOR    ${a}  IN  @{ALIAS_LIST}
    \   ${d}=       Get From Dictionary   ${dict}    ${a}
    \   ${u}=       Set Variable          ${${d}_UDID}
    \   ${t}=       Set Variable          ${${d}_DEVICE}
    \   ${dev_str}=     Catenate   ${dev_str}  ${a}=${t}(${u})
    Log to console     === S T A R T I N G \ T E S T \ S U I T E ===    WARN
    Log to console     Subs: MsPost1: ${MsPost1_ISDN} MsPost2: ${MsPost2_ISDN}    WARN
    Log to console     ${dev_str}    WARN

Unset Variables
    Set Global Variable    ${DEV_ALIASES}      ${None}
    Set Global Variable    ${dev_status}       ${None}
    Set Global Variable    ${dev_actapp}       ${None}

Skip This
    ${skip}=                    skip_test_step     \${SKIP_DEVICE_TESTS}       Skipping Device Tests
    Pass Execution If      ${skip}   Skipped

DefTcSetup
    Unset Variables
    Device Setup

DefTcTeardown
    ${skip}=                    skip_test_step     \${SKIP_DEVICE_TESTS}       Skipping Device Tests
    Return From Keyword If      ${skip}
    Device Cleanup


Reformat ISDN
    [Documentation]   Reformat an ISDN
    ...
    ...     This method converts the internal ISDN format (CC+NDC+SN) into various other formats
    ...
    ...     Supported Formats are
    ...     - "PlusCc"      Reformats 49176123456 into +49176123456
    ...     - "00Cc"        Reformats 49176123456 into 0049176123456
    ...     - "Cc"          Reformats 49176123456 into 49176123456 (no reformatting)
    ...     - "0Ndc"        Reformats 49176123456 into 0176123456
    ...     - "Sn"          Reformats 49176123456 into 123456
    ...     - "Vms"         Reformats 49176123456 into 4917633123456
    ...     - "VmsPlusCc"   Reformats 49176123456 into +4917633123456
    ...     - "Vms00Cc"     Reformats 49176123456 into 004917633123456
    ...     - "Vms0Ndc"     Reformats 49176123456 into 017633123456
    ...
    ...     Arguments
    ...     - isdn_in_CcNdcSn_format    (M)   The ISDN to be reformatted
    ...     - format                    (O)   The desired format, e.g. "0Ndc" see description above.
    ...     - ndc_len                   (O)   The length of the NDC (3 or 4), default 3
    ...
    ...     Returns   The reformatted ISDN

    [arguments]         ${isdn_in_CcNdcSn_format}    ${format}=0Ndc   ${ndc_len}=3

    ${cc}=   Get Substring      ${isdn_in_CcNdcSn_format}   0   2
    ${ndc}=  Run Keyword If     ${ndc_len} == 3     Get Substring       ${isdn_in_CcNdcSn_format}   2   5
    ...             ELSE IF     ${ndc_len} == 4     Get Substring       ${isdn_in_CcNdcSn_format}   2   6
    ...             ELSE                            Fail                Unknown NDC Length '${ndc_len}'
    ${sn}=   Run Keyword If     ${ndc_len} == 3     Get Substring       ${isdn_in_CcNdcSn_format}   5
    ...             ELSE IF     ${ndc_len} == 4     Get Substring       ${isdn_in_CcNdcSn_format}   6
    ...             ELSE                            Fail                Unknown NDC Length '${ndc_len}'

    ${isdn}=    Run Keyword If     '${format}'=='PlusCc'      Catenate    +${cc}${ndc}${sn}
    ...         ELSE IF            '${format}'=='00Cc'        Catenate    00${cc}${ndc}${sn}
    ...         ELSE IF            '${format}'=='Cc'          Catenate    ${cc}${ndc}${sn}
    ...         ELSE IF            '${format}'=='0Ndc'        Catenate    0${ndc}${sn}
    ...         ELSE IF            '${format}'=='Ndc'         Catenate    ${ndc}${sn}
    ...         ELSE IF            '${format}'=='Sn'          Catenate    ${sn}
    ...         ELSE IF            '${format}'=='Vms'         Catenate    ${cc}${ndc}33${sn}
    ...         ELSE IF            '${format}'=='VmsPlusCc'   Catenate    +${cc}${ndc}33${sn}
    ...         ELSE IF            '${format}'=='Vms00Cc'     Catenate    00${cc}${ndc}33${sn}
    ...         ELSE IF            '${format}'=='Vms0Ndc'     Catenate    0${ndc}33${sn}
    ...         ELSE                                       Fail        Unknown ISDN Format argument '${format}'

    [return]            ${isdn}

