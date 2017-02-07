*** Settings ***

# Libraries
Resource                common_utils.txt

*** Variables ***
${var_null}      ${null}
${var_none}      ${None}
${var_empty}     ${EMPTY}
${t}             True
${f}             False
@{foo}           a=1   b=2   c=3   d=4
${DLGS_SKIP}            True
${DLGS_FAIL_ON_SKIP}    False
${DLGS_SLEEP}           0.1s

*** Test Cases ***
#       ######   #######  #######       #######  #     #  ######   #######  #     #
#       #     #  #           #          #        ##   ##  #     #     #      #   #
#       #     #  #           #          #        # # # #  #     #     #       # #
#       ######   #####       #          #####    #  #  #  ######      #        #
#       #   #    #           #          #        #     #  #           #        #
#       #    #   #           #          #        #     #  #           #        #
#       #     #  #######     #          #######  #     #  #           #        #
RetEmpty1
    ${ret}=  Return Empty Unless   True  TrueValue
    Should Be Equal  ${ret}  TrueValue  

RetEmpty2
    ${ret}=  Return Empty Unless   False  TrueValue
    Should Be Equal  ${ret}  ${EMPTY} 




#       #####   #######  #######       ###  #######       #######  #         #####   #######
#      #     #  #           #           #   #             #        #        #     #  #
#      #        #           #           #   #             #        #        #        #
#       #####   #####       #           #   #####         #####    #         #####   #####
#            #  #           #           #   #             #        #              #  #
#      #     #  #           #           #   #             #        #        #     #  #
#       #####   #######     #          ###  #             #######  #######   #####   #######
SetVarIfElse1
    ${ret}=  Set Variable If Else  ${t}  TrueValue  FalseValue
    Should Be Equal  ${ret}  TrueValue  

SetVarIfElse2
    ${ret}=  Set Variable If Else  ${f}  TrueValue  FalseValue
    Should Be Equal  ${ret}  FalseValue  


#      #####   #     #  #######   #####   #    #       ###  ######         #######  #     #  ###   #####   #######   #####
#     #     #  #     #  #        #     #  #   #         #   #              #         #   #    #   #     #     #     #     #
#     #        #     #  #        #        #  #          #   #              #          # #     #   #           #     #
#     #        #######  #####    #        ###           #   ####           #####       #      #    #####      #      #####
#     #        #     #  #        #        #  #          #   #              #          # #     #         #     #           #
#     #     #  #     #  #        #     #  #   #         #   #              #         #   #    #   #     #     #     #     #
#      #####   #     #  #######   #####   #    #       ###  #              #######  #     #  ###   #####      #      #####

cifexist1
    ${a}=     Check If Exists  ${var_null}   
    Should Be Equal  ${a}  False  
    ${a}   ${b}=     Check If Exists and return type  ${var_null}   
    Should Be Equal  ${a}  False  
    Should Be Equal  ${b}  ${EMPTY}  

cifexist2
    ${a}=     Check If Exists  ${var_none}   
    Should Be Equal  ${a}  False  
    ${a}   ${b}=     Check If Exists and return type  ${var_none}   
    Should Be Equal  ${a}  False  
    Should Be Equal  ${b}  ${EMPTY}  

cifexist3
    ${a}=     Check If Exists  ${var_empty}  
    Should Be Equal  ${a}  False  
    ${a}   ${b}=     Check If Exists and return type  ${var_empty}  
    Should Be Equal  ${a}  False  
    Should Be Equal  ${b}  ${EMPTY}  

cifexist4
    ${a}=     Check If Exists  ${var_empty}  ignoreempty=True
    Should Be Equal  ${a}  True  
    ${a}   ${b}=     Check If Exists and return type  ${var_empty}    ignoreempty=True
    Should Be Equal  ${a}  True  
    Should Be Equal  ${b}  Scalar  

cifexist5
    ${tmp}     Create Dictionary
    ${a}=     Check If Exists  ${tmp}
    Should Be Equal  ${a}  True  
    ${a}   ${b}=     Check If Exists and return type  ${tmp}  
    Should Be Equal  ${a}  True  
    Should Be Equal  ${b}  Dict  

cifexist6
    ${tmp}     Create List
    ${a}=     Check If Exists  ${tmp}
    Should Be Equal  ${a}  True  
    ${a}   ${b}=     Check If Exists and return type  ${tmp}  
    Should Be Equal  ${a}  True  
    Should Be Equal  ${b}  List  

cifexist7
    ${tmp}      Create Dictionary   aaa  vbb
    ${a}=     Check If Exists  ${tmp}
    Should Be Equal  ${a}  True  
    ${a}   ${b}=     Check If Exists and return type  ${tmp}  
    Should Be Equal  ${a}  True  
    Should Be Equal  ${b}  Dict  

cifexist8
    ${tmp}      Create List    aaa bbbb
    ${a}=     Check If Exists  ${tmp}
    Should Be Equal  ${a}  True  
    ${a}   ${b}=     Check If Exists and return type  ${tmp}  
    Should Be Equal  ${a}  True  
    Should Be Equal  ${b}  List  


#        #####   #######  #######          #      #####        #        ###   #####   #######
#       #     #  #           #            # #    #     #       #         #   #     #     #
#       #        #           #           #   #   #             #         #   #           #
#       #  ####  #####       #          #     #   #####        #         #    #####      #
#       #     #  #           #          #######        #       #         #         #     #
#       #     #  #           #          #     #  #     #       #         #   #     #     #
#        #####   #######     #          #     #   #####        #######  ###   #####      #

gal1
    ${tmp}=     Create List   lst1   lst2   lst3   lst4
    ${list}=    Get As List   ${tmp}
    Should Be Equal  @{list}[0]  lst1  

gal2
    ${tmp}=     Create List   lst1
    ${list}=    Get As List   ${tmp}
    Should Be Equal  @{list}[0]  lst1  

gal3
    ${tmp}=     Set Variable  lst1
    ${list}=    Get As List   ${tmp}
    Should Be Equal  @{list}[0]  lst1  

gal4
    ${tmp}=     Create Dictionary   lst1   lst2   lst3   lst4
    ${list}=    Get As List   ${tmp}
    Should Be Equal  @{list}[0]  lst1  

gal5
    ${tmp}=     Create Dictionary   lst1   lst2
    ${list}=    Get As List   ${tmp}
    Should Be Equal  @{list}[0]  lst1  

gal6
    ${tmp}=     Create List
    ${list}=    Get As List   ${tmp}
    Should Be Equal  '${list}'  '[]'  
gal7
    ${tmp}=     Create Dictionary
    ${list}=    Get As List   ${tmp}
    Should Be Equal  '${list}'  '[]'  
gal8
    ${tmp}=     Set Variable  ${null}
    ${list}=    Get As List   ${tmp}
    Should Be Equal  '${list}'  '[]'  

gal9
    ${tmp}=     Set Variable  ${None}
    ${list}=    Get As List   ${tmp}
    Should Be Equal  '${list}'  '[]'  

gal10
    ${tmp}=     Set Variable  ${EMPTY}
    ${list}=    Get As List   ${tmp}
    Should Be Equal  @{list}[0]  ${EMPTY}  
    # same thing
    ${tmp}=     Set Variable
    ${list}=    Get As List   ${tmp}
    Should Be Equal  @{list}[0]  ${EMPTY}  


txtRE010
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000a   Item.000b
    Text Should Match At Least One RegEx   ${txt0}    ${re}
#    #######  #     #  #######         ######   #######   #####   #######  #     #
#       #      #   #      #            #     #  #        #     #  #         #   #
#       #       # #       #            #     #  #        #        #          # #
#       #        #        #            ######   #####    #  ####  #####       #
#       #       # #       #            #   #    #        #     #  #          # #
#       #      #   #      #            #    #   #        #     #  #         #   #
#       #     #     #     #            #     #  #######   #####   #######  #     #
#    List Item 000a\nItem 000b\n Item 000c\n
#    List Item 001a\nItem 001b\n Item 001c\n
#    List Item 001a\nItem 001b\n Item 002c\n
#    List Item 003a\nItem 003b\n Item 003c\n
#    List Item 004a\nItem 004b\n Item 004c\n
#    List Item 005a\nItem 005b\n Item 005c\n
#    List Item 006a\nItem 006b\n Item 006c\n


txtRE000
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000a   Item.000b
    Text Should Match All RegEx   ${txt0}    ${re}

txtRE001
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000c   Item.000b
    Text Should Match All RegEx   ${txt0}    ${re}

txtRE002
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000b
    Text Should Match All RegEx   ${txt0}    ${re}

txtRE003
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.0xxb
    ${status}   ${value}=   Run Keyword And Ignore Error            Text Should Match All RegEx   ${txt0}    ${re}
    Run Keyword IF          '${status}' == 'PASS'           Fail    Match did not fail with Regex ${re}

txtRE004
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000a    Item.0xxb
    ${status}   ${value}=   Run Keyword And Ignore Error            Text Should Match All RegEx   ${txt0}    ${re}
    Run Keyword IF          '${status}' == 'PASS'           Fail    Match did not fail with Regex ${re}

txtRE005
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000a    !not!Item.000b
    ${status}   ${value}=   Run Keyword And Ignore Error            Text Should Match All RegEx   ${txt0}    ${re}
    Run Keyword IF          '${status}' == 'PASS'           Fail    Match did not fail with Regex ${re}

txtRE006
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000a    !not!Item.0xxb
    Text Should Match All RegEx   ${txt0}    ${re}



txtRE011
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000c   Item.000b
    Text Should Match At Least One RegEx   ${txt0}    ${re}

txtRE012
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000b
    Text Should Match At Least One RegEx   ${txt0}    ${re}

txtRE013
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.0xxb
    ${status}   ${value}=   Run Keyword And Ignore Error            Text Should Match At Least One RegEx   ${txt0}    ${re}
    Run Keyword IF          '${status}' == 'PASS'           Fail    Match did not fail with Regex ${re}

txtRE014
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000a    Item.0xxb
    Text Should Match At Least One RegEx   ${txt0}    ${re}

txtRE015
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000a    !not!Item.000b
    Text Should Match At Least One RegEx   ${txt0}    ${re}

txtRE016
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.xxxa    !not!Item.000b
    ${status}   ${value}=   Run Keyword And Ignore Error            Text Should Match At Least One RegEx   ${txt0}    ${re}
    Run Keyword IF          '${status}' == 'PASS'           Fail    Match did not fail with Regex ${re}



txtRE020
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000a   Item.000b
    ${status}   ${value}=   Run Keyword And Ignore Error            Text Should Not Match Any RegEx   ${txt0}    ${re}
    Run Keyword IF          '${status}' == 'PASS'           Fail    Match did not fail with Regex ${re}

txtRE021
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000c   Item.000b
    ${status}   ${value}=   Run Keyword And Ignore Error            Text Should Not Match Any RegEx   ${txt0}    ${re}
    Run Keyword IF          '${status}' == 'PASS'           Fail    Match did not fail with Regex ${re}

txtRE022
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000b
    ${status}   ${value}=   Run Keyword And Ignore Error            Text Should Not Match Any RegEx   ${txt0}    ${re}
    Run Keyword IF          '${status}' == 'PASS'           Fail    Match did not fail with Regex ${re}

txtRE023
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.0xxb
    Text Should Not Match Any RegEx   ${txt0}    ${re}

txtRE024
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000a    Item.0xxb
    ${status}   ${value}=   Run Keyword And Ignore Error            Text Should Not Match Any RegEx   ${txt0}    ${re}
    Run Keyword IF          '${status}' == 'PASS'           Fail    Match did not fail with Regex ${re}

txtRE025
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000a    !not!Item.000b
    ${status}   ${value}=   Run Keyword And Ignore Error            Text Should Not Match Any RegEx   ${txt0}    ${re}
    Run Keyword IF          '${status}' == 'PASS'           Fail    Match did not fail with Regex ${re}

txtRE026
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.xxxa    !not!Item.000b
    ${status}   ${value}=   Run Keyword And Ignore Error            Text Should Match At Least One RegEx   ${txt0}    ${re}
    Run Keyword IF          '${status}' == 'PASS'           Fail    Match did not fail with Regex ${re}


txtRE030
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000a   Item.000b
    Text Should Match Number of RegEx   ${txt0}    2    ${re}

txtRE031
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000c   Item.000b
    Text Should Match Number of RegEx   ${txt0}    2    ${re}

txtRE032
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000b
    Text Should Match Number of RegEx   ${txt0}    1    ${re}

txtRE033
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.0xxb
    ${status}   ${value}=   Run Keyword And Ignore Error            Text Should Match Number of RegEx   ${txt0}    1    ${re}
    Run Keyword IF          '${status}' == 'PASS'           Fail    Match did not fail with Regex ${re}

txtRE034
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000a    Item.0xxb
    Text Should Match Number of RegEx   ${txt0}    1    ${re}

txtRE035
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000a    !not!Item.000b
    Text Should Match Number of RegEx   ${txt0}    1    ${re}

txtRE036
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.xxxa    !not!Item.000b
    Text Should Match Number of RegEx   ${txt0}    0    ${re}



#      #######  #     #  #######        #        ###   #####   #######         ######   #######   #####   #######  #     #
#         #      #   #      #           #         #   #     #     #            #     #  #        #     #  #         #   #
#         #       # #       #           #         #   #           #            #     #  #        #        #          # #
#         #        #        #           #         #    #####      #            ######   #####    #  ####  #####       #
#         #       # #       #           #         #         #     #            #   #    #        #     #  #          # #
#         #      #   #      #           #         #   #     #     #            #    #   #        #     #  #         #   #
#         #     #     #     #           #######  ###   #####      #            #     #  #######   #####   #######  #     #


txtLstRE000
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item.000   Item.000
    Any Text Item in List Should Contain All RegEx    ${lst}    ${re}

txtLstRE001
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item 000a    Item.000b
    Any Text Item in List Should Contain All RegEx    ${lst}    ${re}

txtLstRE002
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item 000a    Item.0xxb
    ${status}   ${value}=   Run Keyword And Ignore Error            Any Text Item in List Should Contain All RegEx    ${lst}    ${re}
    Run Keyword IF          '${status}' == 'PASS'           Fail    Match did not fail with Regex ${re}

txtLstRE003first
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item 000a    firstItem
    Any Text Item in List Should Contain All RegEx    ${lst}    ${re}

txtLstRE004last
    ${lst}  ${txt0}  ${txt1}  ${txt2}  ${txt3}  ${txt4}  ${txt5}  ${txt6}=     createTxtList
    ${re}=      Create List     Item 006a    lastItem
    Any Text Item in List Should Contain All RegEx    ${lst}    ${re}

#   #######  #     #  #######   #####           #####   #######  ######   #
#   #         #   #   #        #     #         #     #     #     #     #  #
#   #          # #    #        #               #           #     #     #  #
#   #####       #     #####    #               #           #     ######   #
#   #          # #    #        #               #           #     #   #    #
#   #         #   #   #        #     #         #     #     #     #    #   #
#   #######  #     #  #######   #####           #####      #     #     #  #######
execctrl000
    Set Test Variable   ${SKIP_STEP1}   True
    ${skip}=            _skip_test_step     \${SKIP_STEP1}       ThisShouldBeLoggedOnce
    Should Be True      ${skip}
    
execctrl001
    Set Test Variable   ${SKIP_STEP1}   False
    ${skip}=            _skip_test_step     \${SKIP_STEP1}       THIS SHOULD NOT BE LOGGED
    Should Not Be True  ${skip}
    
execctrl002
    ${skip}=            _skip_test_step     \${SKIP_STEP1}       THIS SHOULD NOT BE LOGGED
    Should Not Be True  ${skip}

execctrl010
    Set Test Variable   ${SKIP_STEP1}   True
    Set Test Variable   ${SKIP_STEP2}   False
    Set Test Variable   ${SKIP_STEP3}   True
    ${skip}=            _skip_test_step     \${SKIP_STEP1}       ThisShouldBeLoggedOnce
    Should Be True      ${skip}
    ${skip}=            _skip_test_step     \${SKIP_STEP2}       Skipping Step2
    Should Not Be True  ${skip}
    ${skip}=            _skip_test_step     \${SKIP_STEP3}       ThisShouldBeLoggedOnce
    Should Be True      ${skip}
    ${skip}=            _skip_test_step     \${SKIP_STEP3}       Skipping3
    Should Be True      ${skip}

execctrl999
    Set Test Variable   ${SKIP_STEP1}   True
    ${skip}=            _skip_test_step     \${SKIP_STEP1}       ThisShouldBeLoggedOnce
    Should Be True     ${skip}
    ${skip}=            _skip_test_step     \${SKIP_STEP1}       ThisShouldBeLoggedOnce
    Should Be True     ${skip}
    ${skip}=            _skip_test_step     \${SKIP_STEP1}       AndThisOneTooOnlyOnce
    Should Be True     ${skip}
    ${skip}=            _skip_test_step     \${SKIP_STEP1}       AndThisOneTooOnlyOnce
    Should Be True     ${skip}
#   
#       ######   ###     #     #        #######   #####    #####
#       #     #   #     # #    #        #     #  #     #  #     #
#       #     #   #    #   #   #        #     #  #        #
#       #     #   #   #     #  #        #     #  #  ####   #####
#       #     #   #   #######  #        #     #  #     #        #
#       #     #   #   #     #  #        #     #  #     #  #     #
#       ######   ###  #     #  #######  #######   #####    #####
#   
dlg000
    Prepare Manual Step                         dlg_txt=A manual step will follow
    Evaluate Manual Step                        dlg_txt=Click PASS, pls  err_txt=Manual Step failed!

dlg001
    Set Test Variable   ${DLGS_FAIL_ON_SKIP}    False
    Set Test Variable   ${DLGS_SLEEP}           1s
    Evaluate Manual Step                        dlg_txt=Click PASS, pls  err_txt=Manual Step failed!

dlg002
    Set Test Variable   ${DLGS_SKIP}            False
    Set Test Variable   ${DLGS_FAIL_ON_SKIP}    True
    Evaluate Manual Step                        dlg_txt=Click PASS, pls  err_txt=Manual Step failed!

dlg010
    Set Test Variable   ${DLGS_SKIP}            True
    Set Test Variable   ${DLGS_FAIL_ON_SKIP}    False
    Set Test Variable   ${DLGS_SLEEP}           1s
    Prepare Manual Step                         dlg_txt=A manual step will follow
    Evaluate Manual Step                        dlg_txt=Everything okay?  err_txt=Manual Step failed!

dlg011
    Set Test Variable   ${DLGS_SKIP}            True
    Set Test Variable   ${DLGS_FAIL_ON_SKIP}    True
    Set Test Variable   ${DLGS_SLEEP}           1s
    ${status}   ${value}=   Run Keyword And Ignore Error            Evaluate Manual Step    dlg_txt=Everything okay?  err_txt=Manual Step failed!
    Run Keyword IF          '${status}' == 'PASS'           Fail    Manual Steps should have failed
    

#       ######   #######  ######   #     #   #####        #        #######   #####
#       #     #  #        #     #  #     #  #     #       #        #     #  #     #
#       #     #  #        #     #  #     #  #             #        #     #  #
#       #     #  #####    ######   #     #  #  ####       #        #     #  #  ####
#       #     #  #        #     #  #     #  #     #       #        #     #  #     #
#       #     #  #        #     #  #     #  #     #       #        #     #  #     #
#       ######   #######  ######    #####    #####        #######  #######   #####
dbglog1a
    ${var}=             Set Variable   StringLogEntry
    dbglogVarUnset      ${var}

dbglog1b
    ${var}=             Create List    ListLogEntry1   ListLogEntry2   ListLogEntry3
    dbglogVarUnset      ${var}

dbglog1c
    ${var}=             Create Dictionary    DictKey1   LogEntry1   DictKey2   LogEntry2
    dbglogVarUnset      ${var}

dbglog2a
    Set Test Variable   ${DBG_LOG}     True
    ${var}=             Set Variable   StringLogEntry
    dbglogVarTrue       ${var}

dbglog2b
    Set Test Variable   ${DBG_LOG}     True
    ${var}=             Create List    ListLogEntry1   ListLogEntry2   ListLogEntry3
    dbglogVarTrue       ${var}

dbglog2c
    Set Test Variable   ${DBG_LOG}     True
    ${var}=             Create Dictionary    DictKey1   LogEntry1   DictKey2   LogEntry2
    dbglogVarTrue       ${var}

dbglog3a
    Set Test Variable   ${DBG_LOG}     False
    ${var}=             Set Variable   StringLogEntry
    dbglogVarUnset      ${var}

dbglog3b
    Set Test Variable   ${DBG_LOG}     False
    ${var}=             Create List    ListLogEntry1   ListLogEntry2   ListLogEntry3
    dbglogVarUnset      ${var}

dbglog3c
    Set Test Variable   ${DBG_LOG}     False
    ${var}=             Create Dictionary    DictKey1   LogEntry1   DictKey2   LogEntry2
    dbglogVarUnset      ${var}

dbglog5a
    ${xml}=             Catenate   <xml>
    ...                 <foo attr1="xxx">
    ...                     <bar attr2="yyy">bar1</bar>
    ...                     <bar attr2="zzz">bar2</bar>
    ...                 </foo>
    ...                 <foo attr1="yyy">
    ...                     <bar attr2="yyy">bar3</bar>
    ...                     <bar attr2="zzz">bar4</bar>
    ...                 </foo>
    ...                 </xml>
    ${dom}=             Parse XML      ${xml}
    dbglogXmlVarUnset   ${dom}

dbglog4a
    ${ok}=              Set Variable   This Should be printed on console
    ${nok}=             Set Variable   THIS SHOULD NOT BE PRINTED on console

    Debug Log   ${nok}  
    Debug Log   ${nok}  debug_log=True
    Debug Log   ${nok}  debug_log=False  
    Debug Log   ${nok}  debug_log=True   debug_level=INFO
    Debug Log   ${ok}   debug_log=True   debug_level=WARN
    Debug Log   ${nok}  debug_log=False  debug_level=INFO
    Debug Log   ${nok}  debug_log=False  debug_level=WARN

dbglog4b
    ${ok}=              Set Variable   This Should be printed on console
    ${nok}=             Set Variable   THIS SHOULD NOT BE PRINTED on console
    Set Test Variable   ${DBG_LOG}     False

    Debug Log   ${nok}  
    Debug Log   ${nok}  debug_log=True
    Debug Log   ${nok}  debug_log=False  
    Debug Log   ${nok}  debug_log=True   debug_level=INFO
    Debug Log   ${ok}   debug_log=True   debug_level=WARN
    Debug Log   ${nok}  debug_log=False  debug_level=INFO
    Debug Log   ${nok}  debug_log=False  debug_level=WARN

dbglog4c
    ${ok}=              Set Variable   This Should be printed on console
    ${nok}=             Set Variable   THIS SHOULD NOT BE PRINTED on console
    Set Test Variable   ${DBG_LEVEL}   INFO

    Debug Log   ${nok}  
    Debug Log   ${nok}  debug_log=True
    Debug Log   ${nok}  debug_log=False  
    Debug Log   ${nok}  debug_log=True   debug_level=INFO
    Debug Log   ${ok}   debug_log=True   debug_level=WARN
    Debug Log   ${nok}  debug_log=False  debug_level=INFO
    Debug Log   ${nok}  debug_log=False  debug_level=WARN

dbglog4d
    ${ok}=              Set Variable   This Should be printed on console
    ${nok}=             Set Variable   THIS SHOULD NOT BE PRINTED on console
    Set Test Variable   ${DBG_LOG}     True

    Debug Log   ${nok}  
    Debug Log   ${nok}  debug_log=True
    Debug Log   ${nok}  debug_log=False  
    Debug Log   ${nok}  debug_log=True   debug_level=INFO
    Debug Log   ${ok}   debug_log=True   debug_level=WARN
    Debug Log   ${nok}  debug_log=False  debug_level=INFO
    Debug Log   ${nok}  debug_log=False  debug_level=WARN

dbglog4e
    ${ok}=              Set Variable   This Should be printed on console
    ${nok}=             Set Variable   THIS SHOULD NOT BE PRINTED on console
    Set Test Variable   ${DBG_LOG}     False
    Set Test Variable   ${DBG_LEVEL}   INFO

    Debug Log   ${nok}  
    Debug Log   ${nok}  debug_log=True
    Debug Log   ${nok}  debug_log=False  
    Debug Log   ${nok}  debug_log=True   debug_level=INFO
    Debug Log   ${ok}   debug_log=True   debug_level=WARN
    Debug Log   ${nok}  debug_log=False  debug_level=INFO
    Debug Log   ${nok}  debug_log=False  debug_level=WARN

dbglog4f
    ${ok}=              Set Variable   This Should be printed on console
    ${nok}=             Set Variable   THIS SHOULD NOT BE PRINTED on console
    Set Test Variable   ${DBG_LOG}     False
    Set Test Variable   ${DBG_LEVEL}   WARN

    Debug Log   ${nok}  
    Debug Log   ${ok}   debug_log=True
    Debug Log   ${ok}   debug_log=False  
    Debug Log   ${nok}  debug_log=True   debug_level=INFO
    Debug Log   ${ok}   debug_log=True   debug_level=WARN
    Debug Log   ${nok}  debug_log=False  debug_level=INFO
    Debug Log   ${nok}  debug_log=False  debug_level=WARN

dbglog4g
    ${ok}=              Set Variable   This Should be printed on console
    ${nok}=             Set Variable   THIS SHOULD NOT BE PRINTED on console
    Set Test Variable   ${DBG_LOG}     True
    Set Test Variable   ${DBG_LEVEL}   INFO

    Debug Log   ${nok}  
    Debug Log   ${nok}  debug_log=True
    Debug Log   ${nok}  debug_log=False  
    Debug Log   ${nok}  debug_log=True   debug_level=INFO
    Debug Log   ${ok}   debug_log=True   debug_level=WARN
    Debug Log   ${nok}  debug_log=False  debug_level=INFO
    Debug Log   ${nok}  debug_log=False  debug_level=WARN

dbglog4h
    ${ok}=              Set Variable   This Should be printed on console
    ${nok}=             Set Variable   THIS SHOULD NOT BE PRINTED on console
    Set Test Variable   ${DBG_LOG}     True
    Set Test Variable   ${DBG_LEVEL}   WARN

    Debug Log   ${ok}  
    Debug Log   ${ok}  debug_log=True
    Debug Log   ${nok}  debug_log=False  
    Debug Log   ${nok}  debug_log=True   debug_level=INFO
    Debug Log   ${ok}   debug_log=True   debug_level=WARN
    Debug Log   ${nok}  debug_log=False  debug_level=INFO
    Debug Log   ${nok}  debug_log=False  debug_level=WARN



*** Keywords ***
dbglogVarUnset
    [arguments]    ${var}
    ${ret}=         Debug Log   ${var}
    Should Not Be True  ${ret}
    ${ret}=         Debug Log   ${var}      debug_log=True
    Should Be True  ${ret}
    ${ret}=         Debug Log   ${var}      debug_log=False  
    Should Not Be True  ${ret}
    ${ret}=         Debug Log   ${var}      debug_log=True   debug_level=INFO
    Should Be True  ${ret}
    ${ret}=         Debug Log   ${var}      debug_log=True   debug_level=WARN
    Should Be True  ${ret}
    ${ret}=         Debug Log   ${var}      debug_log=False  debug_level=INFO
    Should Not Be True  ${ret}
    ${ret}=         Debug Log   ${var}      debug_log=False  debug_level=WARN
    Should Not Be True  ${ret}

dbglogVarTrue
    [arguments]    ${var}
    ${ret}=         Debug Log   ${var}
    Should Be True  ${ret}
    ${ret}=         Debug Log   ${var}      debug_log=True
    Should Be True  ${ret}
    ${ret}=         Debug Log   ${var}      debug_log=False  
    Should Not Be True  ${ret}
    ${ret}=         Debug Log   ${var}      debug_log=True   debug_level=INFO
    Should Be True  ${ret}
    ${ret}=         Debug Log   ${var}      debug_log=True   debug_level=WARN
    Should Be True  ${ret}
    ${ret}=         Debug Log   ${var}      debug_log=False  debug_level=INFO
    Should Not Be True  ${ret}
    ${ret}=         Debug Log   ${var}      debug_log=False  debug_level=WARN
    Should Not Be True  ${ret}

dbglogXmlVarUnset
    [arguments]    ${var}
    ${ret}=         Debug Log XML   ${var}
    Should Not Be True  ${ret}
    ${ret}=         Debug Log XML   ${var}      debug_log=True
    Should Be True  ${ret}
    ${ret}=         Debug Log XML   ${var}      debug_log=False  
    Should Not Be True  ${ret}
    ${ret}=         Debug Log XML   ${var}      debug_log=True   debug_level=INFO
    Should Be True  ${ret}
    ${ret}=         Debug Log XML   ${var}      debug_log=True   debug_level=WARN
    Should Be True  ${ret}
    ${ret}=         Debug Log XML   ${var}      debug_log=False  debug_level=INFO
    Should Not Be True  ${ret}
    ${ret}=         Debug Log XML   ${var}      debug_log=False  debug_level=WARN
    Should Not Be True  ${ret}

createTxtList
    ${txt1}=    Catenate        Item 000a\nfirstItem 000b\n Item 000c\n 
    ${txt2}=    Catenate        Item 001a\nItem 001b\n Item 001c\n
    ${txt3}=    Catenate        Item 001a\nItem 001b\n Item 002c\n 
    ${txt4}=    Catenate        Item 003a\nItem 003b\n Item 003c\n
    ${txt5}=    Catenate        Item 004a\nItem 004b\n Item 004c\n
    ${txt6}=    Catenate        Item 005a\nItem 005b\n Item 005c\n
    ${txt7}=    Catenate        Item 006a\nlastItem 006b\n Item 006c\n
    ${list}=    Create List     ${txt1}    ${txt2}    ${txt3}    ${txt4}    ${txt5}    ${txt6}    ${txt7}           

    [return]    ${list}    ${txt1}    ${txt2}    ${txt3}    ${txt4}    ${txt5}    ${txt6}    ${txt7} 


My Dict
    [arguments]     @{args}
    ${d}=   Create Dictionary    ${args}
    [return] ${d}