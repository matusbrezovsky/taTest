*** Settings ***
Documentation   Test Automation Demo (Android Handsets and HLR provisioning + Traces)

# Libraries
Resource                global_vars.txt
Resource                common_utils.txt
Resource                wireshark.txt
Resource                sendspml.txt
Resource                device_ctrl.txt
Resource                ssh.txt

# Test Suite & Case set up & tagging
Suite Setup      Run Before Test Suite
Test Setup       Run Before Test Case
Test Teardown    Run After Test Case
Suite Teardown   Run After Test Suite

*** Variables ***
# Subscriber aliases for subs that need to be provisioned
@{prov_subs_list}       MsDemo1   MsDemo2   MsDemo3
# Subscriber aliases for subs that have SIM-cards in connected devices
@{used_subs_list}       MsDemo1   MsDemo2

# Trace host IP
${TRC_IP}                   127.0.0.1
# Trace host aliases (both use the above IP)
${TRC1_ALIAS}               hlrHost1
${TRC2_ALIAS}               hlrHost2
# Trace Host-Interface pairs
@{trace_hosts}              ${TRC1_ALIAS}   ${TRC1_ALIAS}   ${TRC2_ALIAS}   ${TRC2_ALIAS}
@{trace_ifs}                bond0.106       bond0.107       bond0.206       bond0.207
# PGW host IP
${PGW_IP}                   127.0.0.1
# PGW host alias (using the above IP)
${PGW_ALIAS}                provHost


*** Test Cases ***

#######  #######   #####   #######   #####
   #     #        #     #     #     #     #
   #     #        #           #     #
   #     #####     #####      #      #####
   #     #              #     #           #
   #     #        #     #     #     #     #
   #     #######   #####      #      #####

MTC-001
    [Documentation]   MTC from MsDemo1 to MsDemo2
    ...     It should be verified that the DP12 is not triggered.
    ...     *** STEPS ***
    ...     1. Check if the subscriber has correct Basic Services provisioned for MsDemo2.
    ...
    ...     2. Make a Call from MsDemo1 to MsDemo2
    ...     ***  RESULTS ***
    ...     1. The subscriber should have:
    ...     at least the Basic Service TS11 in his profile:
    ...         SOAPENV:ENVELOPE/SOAPENV:BODY/SPML:SEARCHRESPONSE/OBJECTS/HLR/TS11/MSISDN: <MSISDN-Number>
    ...     and should have the correct TCSI-Entry:
    ...     SOAPENV:ENVELOPE/SOAPENV:BODY/SPML:SEARCHRESPONSE/OBJECTS/HLR/TCSI/OPERATORSERVICENAME: OGP_T_S1
    ...
    ...     2. Call is established correctly.
    ...     The SRI Response including the MSRN is sent from HLR to the MSS, because the DP12 is restricted for
    ...     HPLMN (availability = VPLMN), the DP12 is not triggered.
    ...
    [Tags]  Prio1
    [Tags]  MTC
    [Tags]  MsDemo1     MsDemo2

    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Prepare Dummy Data      pattern=MTC_001
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------

    Debug Log   Verifying Subscription...
    ${out}=     Display Sub     ${PGW_ALIAS}                imsi=${MsDemo2_ISDN}
    Should Match    ${out}      *TS11/MSISDN: ${MsDemo2_ISDN}*
    Should Match    ${out}      *TCSI/OPERATORSERVICENAME: OGP_T_S1*

    Initiate Device             MsDemo1         phone_app
    Initiate Device             MsDemo2         phone_app

    Start Trace                 ${trace_hosts}  ${trace_ifs}

    # ISDN conversion: CcNdcSn --> Sn
    ${a_number}=    Reformat ISDN   ${MsDemo1_dummy_ISDN}     format=Sn
    # ISDN conversion: CcNdcSn --> +CcNdcSn
    ${b_number}=    Reformat ISDN   ${MsDemo2_dummy_ISDN}     format=PlusCc

    Dial and Call  MsDemo1     ${b_number}   expect_txt=Dialling
    Answer Call    MsDemo2                   expect_txt=${a_number}
    End Call       MsDemo1
    Stop Trace

    Release Device     MsDemo1
    Release Device     MsDemo2

    # SRI
    Verify Trace  True   Component: invoke              localValue: sendRoutingInfo      Address digits: ${MsDemo2_ISDN}
    Verify Trace  False  Component: returnResultLast    localValue: sendRoutingInfo      routingInfo: roamingNumber    !not!termAttemptAuthorized .12.
    Verify Trace  False  end

SMS-001
    [Documentation]   MT SMS from MsDemo1 to MsDemo2
    ...     *** STEPS ***
    ...     1. Send Short Message from MsDemo1 to MsDemo2
    ...     ***  RESULTS ***
    ...     1. Short Message is successfully delivered from MsDemo1 to SMSC.
    ...     SMSC sends SRI for SMS to HLR, HLR responds with the VLR Address of MsDemo2.
    [Tags]  Prio1
    [Tags]  SMS
    [Tags]  MsDemo1     MsDemo2

    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Prepare Dummy Data      pattern=SMS_001
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------

    Initiate Device         MsDemo1     smscomposer_app
    Initiate Device         MsDemo2     smsreader_app

    ${tstmp}=     Get Current Date      result_format=%Y%m%d%H%M
    # ISDN conversion: CcNdcSn --> +CcNdcSn
    ${b_number}=  Reformat ISDN         ${MsDemo2_dummy_ISDN}   format=PlusCc

    Start Trace             ${trace_hosts}  ${trace_ifs}

    Compose SMS and Send    MsDemo1     ${b_number}     ${tstmp}_${TEST NAME}
    Verify SMS              MsDemo2     ${tstmp}        timeout=60s

    Stop Trace

    Release Device          MsDemo1
    Release Device          MsDemo2

    # SRIforSM
    Verify Trace  True   Component: invoke              localValue: sendRoutingInfoForSM      Address digits: ${MsDemo2_ISDN}
    Verify Trace  False  Component: returnResultLast    localValue: sendRoutingInfoForSM      TBCD digits: ${MsDemo2_IMSI}     Address digits: ${VLR_ISDN}
    Verify Trace  False  end

USSD-001
    [Documentation]   CFU registration for MsDemo1 Subscriber
    ...     *** STEPS *** 
    ...     1. Check for MsDemo1 that CFU supplementary services exists in HLR and is provisioned.
    ...     
    ...     2. Register call forwarding Unconditional (CFU) for MsDemo1 using USSD (FTN = MsDemo2 ISDN)
    ...     
    ...     3. Check for MsDemo1 that CFU supplementary services exists in HLR and is active.
    ...
    ...     ***  RESULTS *** 
    ...     1. The CFU status should be 4 (e.g. for the TS10-telephony): 
    ...     SOAPENV:ENVELOPE/SOAPENV:BODY/SPML:SEARCHRESPONSE/OBJECTS/HLR/CFU/BASICSERVICEGROUP: TS10-telephony
    ...     SOAPENV:ENVELOPE/SOAPENV:BODY/SPML:SEARCHRESPONSE/OBJECTS/HLR/CFU/STATUS: 4
    ...     
    ...     2. Registration is successful
    ...     
    ...     3. The CFU status should be 7 (e.g. for the TS10-telephony): 
    ...     SOAPENV:ENVELOPE/SOAPENV:BODY/SPML:SEARCHRESPONSE/OBJECTS/HLR/CFU/BASICSERVICEGROUP: TS10-telephony
    ...     SOAPENV:ENVELOPE/SOAPENV:BODY/SPML:SEARCHRESPONSE/OBJECTS/HLR/CFU/ISDNNUMBER: <MSISDN>
    ...     SOAPENV:ENVELOPE/SOAPENV:BODY/SPML:SEARCHRESPONSE/OBJECTS/HLR/CFU/STATUS: 7
    ...     SOAPENV:ENVELOPE/SOAPENV:BODY/SPML:SEARCHRESPONSE/OBJECTS/HLR/CFU/FTNOTYPE: internat
    [Tags]  Prio1
    [Tags]  USSD
    [Tags]  MsDemo1
    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Prepare Dummy Data      pattern=USSD_001
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------

    ${ftndummy}=   Reformat ISDN                491793000333
    ${ftn}=     Reformat ISDN                   ${MsDemo2_ISDN}
    ${ftndb}=   Set Variable                    ${MsDemo2_ISDN}

    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Prepare Dummy Response          pattern=cfu_prov
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------

    Debug Log   Verifying Subscription...
    ${out}=     Display Sub                     ${PGW_ALIAS}                            imsi=${MsDemo1_IMSI}
    ${srv}=     SPML Parse Service by Group     ${out}              CFU                 BASICSERVICEGROUP
    Service Should Match All RegEx              ${srv}              TS10-telephony      STATUS: 4
    Service Should Match All RegEx              ${srv}              TS60-fax            STATUS: 4
    Service Should Match All RegEx              ${srv}              BS20-dataAsync      STATUS: 4
    Service Should Match All RegEx              ${srv}              BS30-dataSync       STATUS: 4

    Initiate Device                             MsDemo1             phone_app
    Start Trace                                 ${trace_hosts}      ${trace_ifs}

    Dial and Call Ussd                          MsDemo1     ${USSD_CFU_REG}${ftndummy}#      expect_txt=${USSD_MSG_CF_REG_OK}

    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Prepare Dummy Response          pattern=cfu_act
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------
    Debug Log   Verifying Subscription...
    ${out}=     Display Sub                     ${PGW_ALIAS}                            imsi=${MsDemo1_IMSI}
    ${srv}=     SPML Parse Service by Group     ${out}      CFU                 BASICSERVICEGROUP
    Service Should Match All RegEx              ${srv}      TS10-telephony      STATUS: 7
    Service Should Match All RegEx              ${srv}      TS10-telephony      FTNOTYPE: internat      ISDNNUMBER: ${ftndb}

    Stop Trace
    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Dial and Call Ussd                          MsDemo1     ${USSD_CFU_DEL}      expect_txt=${USSD_MSG_CF_DEL_OK}
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------
    Release Device                              MsDemo1

    Verify Trace  True   Component: invoke              localValue: registerSS              ss-Code: cfu    Address digits: ${ftn}    Address digits: ${MsDemo3_IMSI}
    Verify Trace  False  Component: returnResultLast    localValue: registerSS              ss-Status: 07   Address digits: ${ftndb}
    Verify Trace  True   Component: invoke              localValue: insertSubscriberData    ss-Code: cfb    ss-Status: 0f             TBCD digits: ${MsDemo3_IMSI}
    Verify Trace  False  Component: returnResultLast
    Verify Trace  True   Component: invoke              localValue: insertSubscriberData    ss-Code: cfnry  ss-Status: 0f             TBCD digits: ${MsDemo3_IMSI}
    Verify Trace  False  Component: returnResultLast
    Verify Trace  True   Component: invoke              localValue: insertSubscriberData    ss-Code: cfnrc  ss-Status: 0f             TBCD digits: ${MsDemo3_IMSI}
    Verify Trace  False  Component: returnResultLast

PROV-001
    [Documentation]   Deactivate MsDemo2 - Verify Cancel Location
    ...     *** STEPS ***
    ...     1.  Deactivate Subscriber via provisioning.
    ...     ***  RESULTS ***
    ...     1.  Verify that Cancel Location has been sent
    [Tags]  Prio1
    [Tags]  PROV
    [Tags]  MsDemo2
    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Prepare Dummy Data          pattern=PROV_001
    Prepare Dummy Response      pattern=search
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------

    # Verify SPML
    Debug Log   Verifying Subscription...
    ${out}=     Display Sub         ${PGW_ALIAS}    imsi=${MsDemo2_IMSI}
    #SPML Should Match All RegEx     ${out}          ROUTINGCATEGORY: 25
    SPML Should Match All RegEx     ${out}          ROUTINGCATEGORY: 12

    Start Trace     ${trace_hosts}      ${trace_ifs}
    Debug Log   Deactivating Subscription...
    ${out}=     Execute SendSpml    ${PGW_ALIAS}    -i ${MsDemo2_IMSI} ${SUBS_T_DEACTIVATE}
    Should Match                    ${out}          *result= success*

    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Prepare Dummy Response      pattern=not_registered
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------

    Wait Until Keyword Succeeds   20s   5s   Imsi Should Not Be Registered  ${MsDemo2_IMSI}  host=${PGW_ALIAS}  NEs=CsPs

    Stop Trace

    # Cancel Location
    #Verify Trace  True  Component: invoke   localValue: cancelLocation  TBCD digits: ${MsDemo2_IMSI}  cancellationType: updateProcedure
    Verify Trace  True  Component: invoke   localValue: cancelLocation  TBCD digits: ${MsDemo2_IMSI}  cancellationType: subscriptionWithdraw

UL-001
    [Documentation]   LU and LU GPRS for MsDemo2
    ...     NT-HLR:
    ...     MsDemo2 created with:
    ...     •   Postpaid Subscriber (RCAT=12, RCAT_EXT=15);
    ...     •   IMSI not registered to any VLR;
    ...     •   IMSI not registered to any SGSN;
    ...
    ...     *** STEPS ***
    ...     1.  Perform a Location Update (enable+disable Airplane Mode)
    ...
    ...     ***  RESULTS ***
    ...     CS LU
    ...     •   Location Update was performed successfully
    ...     •   Check that Send_Authentication_Info_Ack was sent successfully to VLR
    ...     •   Check that no Zone Code was included in Insert_Subscriber_Data message
    ...     •   Check that the correct Service Keys were shown in trace: OCSI=3
    ...
    ...     PS LU
    ...     •   GPRS Attach was performed successfully
    ...     •   Check that the right APN settings and QOS values are sent to the SGSN
    [Tags]  Prio2
    [Tags]  UL
    [Tags]  MsDemo2

    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Prepare Dummy Data      pattern=UL_001
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------

    # Verify SPML
    Debug Log   Verifying Subscription...
    ${out}=     Display Sub         ${PGW_ALIAS}    imsi=${MsDemo2_IMSI}
    SPML Should Match All RegEx     ${out}          ROUTINGCATEGORY: 12    ROUTINGCATEGORYEXTENSION: 15

    # Make UL
    Initiate Device                 MsDemo2         phone_app
    Start Trace                     ${trace_hosts}  ${trace_ifs}

    Enable Airplane Mode            MsDemo2         wait_until_deregistered=False
    Debug Log   Deactivating Subscription...
    ${out}=    Execute SendSpml     ${PGW_ALIAS}    -i ${MsDemo2_IMSI} ${SUBS_T_DEACTIVATE}
    Should Match                    ${out}          *result= success*

    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Prepare Dummy Response          pattern=not_registered
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------

    # VLR / SGSN / MME
    Wait Until Keyword Succeeds     60s    5s       Imsi Should Not Be Registered   ${MsDemo2_IMSI}   host=${PGW_ALIAS}

    Debug Log   Activating Subscription...
    ${out}=     Execute SendSpml    ${PGW_ALIAS}    -i ${MsDemo2_IMSI} ${SUBS_T_ACTIVATE}
    Should Match                    ${out}          *result= success*

    Disable Airplane Mode           MsDemo2         wait_until_registered=False

    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Prepare Dummy Response          pattern=registered_cs_ps
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------

    Debug Log   Waiting for CS LU
    Wait Until Keyword Succeeds     120s    5s      Imsi Should Be Registered     ${MsDemo2_IMSI}     host=${PGW_ALIAS}    NEs=Cs
    Debug Log   Waiting for PS LU
    Wait Until Keyword Succeeds     120s    5s      Imsi Should Be Registered     ${MsDemo2_IMSI}     host=${PGW_ALIAS}    NEs=Ps

    Stop Trace
    Release Device                  MsDemo2

    # SAI - success = TCAP end
    Verify Trace  True   Component: invoke    localValue: sendAuthenticationInfo    TBCD digits: ${MsDemo2_IMSI}
    Verify Trace  False  Component: returnResultLast    end
    # CS LU
    Verify Trace  True   Component: invoke    localValue: updateLocation    TBCD digits: ${MsDemo2_IMSI}
    Verify Trace  False  Component: returnResultLast    end
    # PS LU
    Verify Trace  True   Component: invoke    localValue: updateGprsLocation    TBCD digits: ${MsDemo2_IMSI}
    ## NOTE: Use a variable for the verification
    Verify Trace  False  @{POST_ISD_PDP_1}
    Verify Trace  False  @{POST_ISD_PDP_2}
    Verify Trace  False  Component: returnResultLast    end


*** Keywords ***
 #####   #     #  ###  #######  #######                 #######  #######   #####   #######
#     #  #     #   #      #     #                          #     #        #     #     #
#        #     #   #      #     #              #           #     #        #           #
 #####   #     #   #      #     #####         ###          #     #####     #####      #
      #  #     #   #      #     #              #           #     #              #     #
#     #  #     #   #      #     #                          #     #        #     #     #
 #####    #####   ###     #     #######                    #     #######   #####      #

#######  #     #  #     #   #####   #######  ###  #######  #     #   #####
#        #     #  ##    #  #     #     #      #   #     #  ##    #  #     #
#        #     #  # #   #  #           #      #   #     #  # #   #  #
#####    #     #  #  #  #  #           #      #   #     #  #  #  #   #####
#        #     #  #   # #  #           #      #   #     #  #   # #        #
#        #     #  #    ##  #     #     #      #   #     #  #    ##  #     #
#         #####   #     #   #####      #     ###  #######  #     #   #####


 Run Before Test Suite
    [Documentation]   Test Suite set-up/precondition
    ...
    ...     Test Suite preparation subroutine, executed once for the test suite
    ...     i.e. once before the test case execution starts.


    #Run Keyword If          not ${DEVELOPMENT_MODE}     Reboot Devices                  ${subs_list}
    Create Results Directory

    Open Ssh Connection     ${TRC_IP}                 ${TRC1_ALIAS}     ${user}    ${passwd}
    Open Ssh Connection     ${TRC_IP}                 ${TRC2_ALIAS}     ${user}    ${passwd}
    Open Ssh Connection     ${PGW_IP}                 ${PGW_ALIAS}      ${user}    ${passwd}

    Upload sendspml tool    ${PGW_ALIAS}

    Upload Dummy Data

Run Before Test Case
    # copy dummy SPML outputs, needed for the dummy provisioning to pass
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${DUMMY_SPML_SSH_USR_PATH}demo_default_spml.txt ${SPML_LOG_PATH}/${SPML_LOG_FILEPREFIX}${TEST_NAME}${SPML_LOG_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Should Be Equal As Integers     ${rc}    0

    Prepare Subs and Devices   ${PGW_ALIAS}   lte=True

Run After Test Case
    Stop Trace              parse=False
    Collect SPML logs       ${PGW_ALIAS}   pgwproxy=False
    Device Cleanup

Run After Test Suite
    Delete Traces               ${trace_hosts}
    # SSH
    Close All Connections

    ######   #     #  #     #  #     #  #     #     ######      #     #######     #
    #     #  #     #  ##   ##  ##   ##   #   #      #     #    # #       #       # #
    #     #  #     #  # # # #  # # # #    # #       #     #   #   #      #      #   #
    #     #  #     #  #  #  #  #  #  #     #        #     #  #     #     #     #     #
    #     #  #     #  #     #  #     #     #        #     #  #######     #     #######
    #     #  #     #  #     #  #     #     #        #     #  #     #     #     #     #
    ######    #####   #     #  #     #     #        ######   #     #     #     #     #


    #     #     #     #     #  ######   #        ###  #     #   #####
    #     #    # #    ##    #  #     #  #         #   ##    #  #     #
    #     #   #   #   # #   #  #     #  #         #   # #   #  #
    #######  #     #  #  #  #  #     #  #         #   #  #  #  #  ####
    #     #  #######  #   # #  #     #  #         #   #   # #  #     #
    #     #  #     #  #    ##  #     #  #         #   #    ##  #     #
    #     #  #     #  #     #  ######   #######  ###  #     #   #####

Prepare Dummy Data
    [arguments]         ${pattern}=default

    # create ${TRC_PATH_VAL} (/tmp/ta/trace) - just in case, it might not be there
    ${sout}  ${serr}  ${rc}=    Execute Command   mkdir -m 777 -p ${TRC_PATH}   return_rc=True   return_stdout=True   return_stderr=True

    # copy dummy traces
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}demo_${pattern}_a.pcap ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[0]_@{trace_ifs}[0]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Should Be Equal As Integers     ${rc}    0
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}demo_${pattern}_b.pcap ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[1]_@{trace_ifs}[1]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Should Be Equal As Integers     ${rc}    0
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}demo_${pattern}_c.pcap ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[2]_@{trace_ifs}[2]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}demo_${pattern}_d.pcap ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[3]_@{trace_ifs}[3]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True

    Set Test Variable   ${DUMMY_FILE_PATTERN}    ${pattern}
    # copy dummy SPML outputs
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${DUMMY_SPML_SSH_USR_PATH}demo_${pattern}_spml.txt ${SPML_LOG_PATH}/${SPML_LOG_FILEPREFIX}${TEST_NAME}${SPML_LOG_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Should Be Equal As Integers     ${rc}    0

Prepare Dummy Response
    [arguments]         ${pattern}=default
    # copy dummy SPML outputs
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${DUMMY_SPML_SSH_USR_PATH}demo_${pattern}_spml.txt ${SPML_LOG_PATH}/${SPML_LOG_FILEPREFIX}${TEST_NAME}${SPML_LOG_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Should Be Equal As Integers     ${rc}    0

Revert Dummy Response
    [arguments]         ${pattern}=Default
    # copy dummy SPML outputs
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${DUMMY_SPML_SSH_USR_PATH}demo_${DUMMY_FILE_PATTERN}_spml.txt ${SPML_LOG_PATH}/${SPML_LOG_FILEPREFIX}${TEST_NAME}${SPML_LOG_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Should Be Equal As Integers     ${rc}    0


Upload Dummy Data
    Switch Connection   ${PGW_ALIAS}

    ${sout}  ${serr}  ${rc}=    Execute Command   rm -f ${DUMMY_SPML_SSH_USR_PATH}*    return_rc=True   return_stdout=True   return_stderr=True
    Put Directory       ${DUMMY_SPML_LPATH}     ${DUMMY_SPML_SSH_USR_PATH}     mode=0755   recursive=True

    Switch Connection   ${TRC1_ALIAS}

    ${sout}  ${serr}  ${rc}=    Execute Command   rm -f ${TRC_SSH_USR_PATH}*    return_rc=True   return_stdout=True   return_stderr=True
    #Should Be Equal As Integers     ${rc}    0
    Put Directory       ${TRC_LPATH}     ${TRC_SSH_USR_PATH}     mode=0755   recursive=True

Prepare Subs and Devices
    [Documentation]   Recreate Test Subscribers and trigger LUs with the devices

    [arguments]   ${host}    ${lte}=False

    Device Setup

    ${prev_act_ssh_connection}=  Switch Connection   ${host}

    ## For each Test Sub: Enable Airplane mode & delete subs
    :FOR     ${subs_alias}  IN   @{used_subs_list}
    \  Debug Log   Enabling Airplane Mode (${subs_alias}) ...
    \  ${dev_id}=  Get UDID for Device      ${subs_alias}
    \  _change_airplane_mode_via_adb        ${dev_id}       1

    ${a}=    Get Matches                    ${prov_subs_list}   *Demo*
    Delete Dummy Subscribers by Alias       ${host}             ${a}
    Create Dummy Subscribers by Alias       ${host}             ${a}    ${lte}

    ## For each Test Sub: Disable Airplane mode
    :FOR     ${subs_alias}  IN   @{used_subs_list}
    \  Debug Log   Disabling Airplane Mode (${subs_alias}) ...
    \  ${dev_id}=  Get UDID for Device      ${subs_alias}
    \  _change_airplane_mode_via_adb        ${dev_id}       0

    ## Wait until each Test Subs has an VLR entry
    Prepare Dummy Response          pattern=registered_cs_ps
    :FOR     ${subs_alias}  IN   @{used_subs_list}
    \  Wait Until Keyword Succeeds          60s            5s     Imsi Should Be Registered     ${${subs_alias}_IMSI}     host=${host}    NEs=Cs

    Switch Connection   ${prev_act_ssh_connection}

Delete Dummy Subscribers by Alias
    [Documentation]   Delete Multiple Subscribers
    [arguments]   ${host}    ${aliases}
    Debug Log       Deleting Subscribers (${host})...
    ${prev_act_ssh_connection}=  Switch Connection   ${host}

    ${al}=    Get As List  ${aliases}
    ${len}=   Get Length   ${al}
    Return From Keyword If   ${len} == 0
    ${imsis}  ${msisdns} =  _get_imsis_and_isdns_by_alias    ${al}

    ${imsi_l}=  Get As List     ${imsis}
    :FOR     ${imsi}  IN   @{imsi_l}
    \  Delete Sub       ${host}    ${imsi}

    Switch Connection   ${prev_act_ssh_connection}

Create Dummy Subscribers by Alias
    [Documentation]   Create Post-Paid subscribers with/without LTE profile
    ...
    ...     Create Post-Paid subscribers using PGW-Proxy templates
    ...
    ...     _Arguments:_
    ...     - host      (M)       ...     - host          (M)   The connection alias to be used where to run the sendspml script
    ...     - host          (M)   The connection alias to be used where to run the sendspml script
    ...     - imsis     (M)   List of IMSIs
    ...     - msisdns   (M)   List of MSISDNs
    ...     - lte       (O)   Provision also the LTE-subscription

    [arguments]   ${host}    ${aliases}    ${lte}=False
    Debug Log       Creating Subscribers (${host})...
    ${prev_act_ssh_connection}=  Switch Connection   ${host}

    ${al}=    Get As List  ${aliases}
    ${len}=   Get Length   ${al}
    Return From Keyword If   ${len} == 0
    ${imsis}  ${msisdns} =  _get_imsis_and_isdns_by_alias    ${al}

    ${imsi_l}=      Get As List     ${imsis}
    ${msisdn_l}=    Get As List     ${msisdns}
    ${len}=   Get Length   ${imsi_l}
    :FOR    ${i}  IN RANGE  0  ${len}
    \  ${ftn}=      Reformat ISDN       @{msisdn_l}[${i}]   format=Vms
    \  ${out}=      Execute SendSpml    ${host}     -i @{imsi_l}[${i}] -m @{msisdn_l}[${i}] -k ${ftn} ADD_POSTPAID.xml
    \  Should Match                     ${out}      *result= success*
    \  ${out}=      Run Keyword If      ${lte}      Execute SendSpml    ${host}     -i @{imsi_l}[${i}] ADD_LTE_SERVICE_POSTPAID.xml
    \  Run Keyword If                   ${lte}      Should Match        ${out}      *result= success*
    \  ${out}=      Execute SendSpml    ${host}     -i @{imsi_l}[${i}] ACTIVATE.xml
    \  Should Match                     ${out}      *result= success*

    Switch Connection   ${prev_act_ssh_connection}

