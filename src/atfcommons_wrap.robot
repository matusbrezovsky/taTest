*** Settings ***
# Libraries
Library          ATFCommonsWrapper
Library          Collections
Library          Dialogs
Library          XML

*** Variables ***
${var_null}      ${null}
${var_none}      ${None}
${var_empty}     ${EMPTY}
${t}             True
${f}             False
@{foo}           a=1   b=2   c=3   d=4

${SKIP_DLG_TESTS}             True


*** Test Cases ***
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
