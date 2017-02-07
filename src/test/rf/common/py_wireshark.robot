*** Settings ***
Documentation   Test Suite for the Wireshark commons library
...             
...             Verifies the Parse & Verify Trace methods
...             Does not verify the Start & Stop Trace        

# Test Suite & Case set up & tagging
Suite Precondition      Run Before Test Suite
Test Precondition       Run Before Test Case
Test Postcondition      Run After Test Case
Suite Postcondition     Run After Test Suite

# Libraries
Library                 OperatingSystem
Library                 SSHLibrary                  timeout=30
Library                 Wireshark
Library                 ATFCommons


*** Variables ***
${DEVELOPMENT_MODE}         True
${DUMMY_MODE}               True
${DBG_LOG}                  True
${DBG_LEVEL}                INFO

# directory where to upload the example traces on the SSH host (localhost)
# the files will be copied from this directory to the directory where tcpdump would generate them
# i.e. ${TRC_PATH_VAL} location (as defined in the wireshark library)
${TRC_SSH_USR_PATH}         ta/trace/

# ta test user account
${user}                     ta
${passwd}                   ta1234
# SSH prompt to expect
${SSHPROMPT}                $

# Trace host IP
${TRC_IP}                   127.0.0.1
# Trace host aliases (both use the above IP)
${TRC_HOST1}                trcHost1
${TRC_HOST2}                trcHost2

# Trace Host-Interface pairs
@{trace_hosts}              ${TRC_HOST1}    ${TRC_HOST1}    ${TRC_HOST2}    ${TRC_HOST2}
@{trace_ifs}                bond0.100       bond0.101       bond0.200       bond0.202
@{trace_ifs_map}            bond0.106       bond0.107       bond0.206       bond0.207
@{trace_ifs_dia}            bond0.966       bond0.967       bond0.966       bond0.970


# local example traces
${TRC_LPATH}                ${EXECDIR}${/}data${/}wireshark${/}
${TRC_GSM_MAP_000_XML}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_000.xml
${TRC_GSM_MAP_000_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_000.txt
${TRC_GSM_MAP_001_XML}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_001_ul.xml
${TRC_GSM_MAP_001_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_001_ul.txt
${TRC_GSM_MAP_002_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_002_tc_02.03.03.01Merged.txt
${TRC_GSM_MAP_003_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_003_tc_02.04.01.27Merged.txt
${TRC_GSM_MAP_004_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_004_tc_02.04.01.29Merged.txt
${TRC_GSM_MAP_005_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_005_tc_02.04.01.30Merged.txt
${TRC_GSM_MAP_006_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_2xMapInOneFrame_tc_02.03.01.01Merged.txt
${TRC_GSM_MAP_007_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_2xMapMC_tc_02.11.04.01Merged.txt

${TRC_DIAMETER_000_TXT}     ${EXECDIR}${/}data${/}wireshark${/}test_trace_diameter_02.07.01.02Merged.txt

${TRC_MAP_N_DIA_000_PCAP}   ${EXECDIR}${/}data${/}wireshark${/}test_trace_mapndiaMerged.pcap
${TRC_MAP_N_DIA_000_TXT}    ${EXECDIR}${/}data${/}wireshark${/}test_trace_mapndiaMerged.txt
${TRC_MAP_N_DIA_000_FLTD}   ${EXECDIR}${/}data${/}wireshark${/}test_trace_mapndiaMergedFiltered.pcap

${TRC_GSM_MAP_000_PCAP_FILE}    trace_a.pcap
${TRC_GSM_MAP_001_PCAP_FILE}    trace_b.pcap
${TRC_GSM_MAP_002_PCAP_FILE}    tc_02.03.03.01Merged.pcap

${TRC_GSM_MAP_000_PCAP}         ${EXECDIR}${/}data${/}wireshark${/}${TRC_GSM_MAP_000_PCAP_FILE}
${TRC_GSM_MAP_001_PCAP}         ${EXECDIR}${/}data${/}wireshark${/}${TRC_GSM_MAP_001_PCAP_FILE}
${TRC_GSM_MAP_002_PCAP}         ${EXECDIR}${/}data${/}wireshark${/}${TRC_GSM_MAP_002_PCAP_FILE}


*** Test Cases ***
starttrace000a
    [Documentation]     start & stop traces on diffent hosts & interfaces
    ...                 Special case, needs ssh running on localhost

    Open Dummy Ssh Connections

    # start dummy traces = nothing is traced
    Start Trace         ${trace_hosts}  ${trace_ifs}
    # copy traces from ~/ta/trace to /tmp/ta/trace (${TRC_PATH_VAL}
    Copy Dummy Traces
    # stop dummy traces
    Stop Trace

    Delete Traces       ${trace_hosts}
    Close All Connections

starttrace000b
    [Documentation]     start & stop traces on diffent hosts & interfaces
    ...                 Special case, needs ssh running on localhost

    Open Dummy Ssh Connections

    Start Trace         ${trace_hosts}
    # copy traces from ~/ta/trace to /tmp/ta/trace (${TRC_PATH_VAL}
    Copy Dummy Traces
    Stop Trace

    Delete Traces       ${trace_hosts}
    Close All Connections

starttrace000c
    [Documentation]     start & stop traces on diffent hosts & interfaces
    ...                 Special case, needs ssh running on localhost

    Open Dummy Ssh Connections

    Start Trace         ${trace_hosts}      ${trace_ifs_map}    protocol=gsm_map
    # copy traces from ~/ta/trace to /tmp/ta/trace (${TRC_PATH_VAL}
    Copy Dummy Traces   protocol=gsm_map
    Stop Trace

    Delete Traces       ${trace_hosts}
    Close All Connections

starttrace000d
    [Documentation]     start & stop traces on diffent hosts & interfaces
    ...                 Special case, needs ssh running on localhost

    Open Dummy Ssh Connections

    Start Trace         ${trace_hosts}      ${trace_ifs_dia}    protocol=diameter
    Copy Dummy Traces   protocol=diameter
    Stop Trace

    Delete Traces       ${trace_hosts}
    Close All Connections

starttrace001a
    [Documentation]     start & stop traces on diffent hosts & interfaces
    ...                 Special case, needs ssh running on localhost

    Open Dummy Ssh Connections

    Start Trace         ${trace_hosts}      ${trace_ifs_map}    protocol=gsm_map
    Copy Dummy Traces
    Execute Command     rm -f ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[0]_@{trace_ifs}[0]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Stop Trace

    Delete Traces       ${trace_hosts}
    Close All Connections

starttrace001b
    [Documentation]     start & stop traces on diffent hosts & interfaces
    ...                 Special case, needs ssh running on localhost

    Open Dummy Ssh Connections

    Start Trace         ${trace_hosts}      ${trace_ifs_map}    protocol=gsm_map
    Copy Dummy Traces
    Execute Command     rm -f ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[0]_@{trace_ifs}[0]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Execute Command     rm -f ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[1]_@{trace_ifs}[1]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Log To Console      Two "Getting Trace file failed" warnings should be logged
    Stop Trace

    Delete Traces       ${trace_hosts}
    Close All Connections

starttrace001c
    [Documentation]     start & stop traces on diffent hosts & interfaces
    ...                 Special case, needs ssh running on localhost

    Open Dummy Ssh Connections

    Start Trace         ${trace_hosts}      ${trace_ifs_map}    protocol=gsm_map
    Copy Dummy Traces
    Execute Command     rm -f ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[1]_@{trace_ifs}[1]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Execute Command     rm -f ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[3]_@{trace_ifs}[3]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Log To Console      Two "Getting Trace file failed" warnings should be logged
    Stop Trace

    Delete Traces       ${trace_hosts}
    Close All Connections


starttrace001d
    [Documentation]     start & stop traces on diffent hosts & interfaces
    ...                 Special case, needs ssh running on localhost

    Open Dummy Ssh Connections

    Start Trace         ${trace_hosts}      ${trace_ifs_map}    protocol=gsm_map
    Sleep               1s
    Run Keyword And Expect Error      *No such file or directory*      Stop Trace

    Delete Traces       ${trace_hosts}
    Close All Connections

starttrace010
    [Documentation]     start & stop traces on diffent hosts & interfaces
    ...                 Special case, needs ssh running on localhost
    Set Test Variable   ${SKIP_TRACE_GENERATION}       True
    Start Trace         ${trace_hosts}  ${trace_ifs}
    Stop Trace

starttrace011
    [Documentation]     start & stop traces on diffent hosts & interfaces
    ...                 Special case, needs ssh running on localhost
    Set Test Variable   ${SKIP_TRACE_GENERATION}       True
    Start Trace         ${trace_hosts}
    Stop Trace

starttrace012
    [Documentation]     start & stop traces on diffent hosts & interfaces
    ...                 Special case, needs ssh running on localhost
    Set Test Variable   ${SKIP_TRACE_GENERATION}       True
    Start Trace         ${trace_hosts}      ${trace_ifs_map}    protocol=gsm_map
    Stop Trace

starttrace013
    [Documentation]     start & stop traces on diffent hosts & interfaces
    ...                 Special case, needs ssh running on localhost
    Set Test Variable   ${SKIP_TRACE_GENERATION}       True
    Start Trace         ${trace_hosts}      ${trace_ifs_dia}    protocol=diameter
    Stop Trace

trace txt gsm_map 000a
    [Documentation]   match in first PDU
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_000_TXT}
    Should Be Equal As Integers        ${count}   20    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_000_TXT}

    ${re}=   Create List    Protocol
    ${count}=   Verify Trace    True    @{re}   
    Should Be Equal As Integers     ${count}   0    msg=Wrong packet index (${count}) returned by ${re}

    ${re}=   Create List    Component..returnResultLast
    ${count}=   Verify Trace    True    @{re}   
    Should Be Equal As Integers     ${count}   3    msg=Wrong packet index (${count}) returned by ${re}

trace txt gsm_map 000b
    [Documentation]   SRI in 1st PDU
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_000_TXT}

    ${re}=   Create List    Component: invoke    localValue: sendRoutingInfo
    ${count}=   Verify Trace    True    @{re}   
    Should Be Equal As Integers     ${count}   0    msg=Wrong packet index (${count}) returned by ${re}

    ${re}=   Create List    Component: returnResultLast    localValue: sendRoutingInfo .22.    TBCD digits: 262073900317077   Address digits: 4917604019078   forwardingOptions: 2c
    ${count}=   Verify Trace    False   @{re}   
    Should Be Equal As Integers     ${count}   3    msg=Wrong packet index (${count}) returned by ${re}


trace txt gsm_map 000c
    [Documentation]   SRI
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_000_TXT}

    ${re}=   Create List    Component: invoke 
    ${count}=   Verify Trace    True    @{re}   
    Should Be Equal As Integers     ${count}   0    msg=Wrong packet index (${count}) returned by ${re}


trace txt gsm_map 000d
    [Documentation]   SRI
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_000_TXT}

    ${re}=   Create List    FuuuBar
    ${status}   ${value}=   Run Keyword And Ignore Error    Verify Trace   True     @{re}
    Run Keyword IF          '${status}' == 'PASS'           Fail     Match did not fail with Regex ${re}

trace txt gsm_map 000e
    ${re}=   Create List    Dummy
    ${status}   ${value}=   Run Keyword And Ignore Error    Verify Trace   False    @{re}
    Run Keyword IF          '${status}' == 'PASS'           Fail     Verify Trace did not fail without opening txn first


trace txt gsm_map 001
    [Documentation]   SAI+UL (CS+PS)
    #  LU and LU GPRS for Postpaid without Genion
    #
    #  Location Update was performed successfully
    #  Check that Send_Authentication_Info_Ack was sent successfully to VLR
    #  Check that no Zone Code was included in Insert_Subscriber_Data message
    #  Check that the correct Service Keys were shown in trace: OCSI=3
    #
    #  GPRS Attach was performed successfully
    #  Check that the right APN settings and QOS values are sent to the SGSN

    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_001_TXT}
    Should Be Equal As Integers        ${count}   30    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_001_TXT}

    # SAI - success = TCAP end
    Verify Trace  True   Component: invoke              localValue: sendAuthenticationInfo    TBCD digits: 262073900317078
    Verify Trace  False  Component: returnResultLast    end
    # CS LU
    Verify Trace  True   Component: invoke    localValue: updateLocation    TBCD digits: 262073900317078
    Verify Trace  False  Component: invoke    localValue: insertSubscriberData    o-CSI    serviceKey: 3
    Verify Trace  False  Component: invoke    localValue: insertSubscriberData    o-CSI    !not!Zon
    Verify Trace  False  Component: returnResultLast    end
    # PS LU
    Verify Trace  True   Component: invoke    localValue: updateGprsLocation    TBCD digits: 262073900317078
    Verify Trace  False  Component: invoke    localValue: insertSubscriberData    class 3
    Verify Trace  False  Component: invoke    localValue: insertSubscriberData    internet
    Verify Trace  False  Component: invoke    localValue: insertSubscriberData    surf
    Verify Trace  False  Component: returnResultLast    end


trace txt gsm_map 002a
    [Documentation]   recursion
    # SRI  960 a518d903        Address digits: 4917607011479
    #      965 a518d903        t-BcsmTriggerDetectionPoint: termAttemptAuthorized (12)
    # SRI  979 1b43d904        Address digits: 4917607011479
    #      981 1b43d904        t-BcsmTriggerDetectionPoint: termAttemptAuthorized (12)
    # PRN  987 501b6867        TBCD digits: 262073900302979      Address digits: 4917607011479
    #     1061 501b6867        Address digits: 491760049180
    # SRI  985 a718d903        Address digits: 4917607011479
    #     1062 a718d903        routingInfo: roamingNumber (0)


    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_002_TXT}
    Should Be Equal As Integers        ${count}   36    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_002_TXT}

    ${i}=  Verify Trace    True   Component: invoke              localValue: sendRoutingInfo      Address digits: 4917607011479
    Should Be Equal As Integers        ${i}   22
    ${i}=  Verify Trace    False  Component: returnResultLast    localValue: sendRoutingInfo      t-CSI      termAttemptAuthorized .12.      serviceKey: 76
    Should Be Equal As Integers        ${i}   24
    ${i}=  Verify Trace    True   Component: invoke              localValue: sendRoutingInfo      Address digits: 4917607011479
    Should Be Equal As Integers        ${i}   22
    ${i}=  Verify Trace    False  Component: returnResultLast    localValue: sendRoutingInfo      t-CSI      termAttemptAuthorized .12.      serviceKey: 76
    Should Be Equal As Integers        ${i}   24
    ${i}=  Verify Trace    True   Component: invoke              localValue: sendRoutingInfo      Address digits: 4917607011479
    Should Be Equal As Integers        ${i}   22
    ${i}=  Verify Trace    False  Component: returnResultLast    localValue: sendRoutingInfo      routingInfo: roamingNumber
    Should Be Equal As Integers        ${i}   35

trace txt gsm_map 002b
    # SRI  960 a518d903        Address digits: 4917607011479
    #      965 a518d903        t-BcsmTriggerDetectionPoint: termAttemptAuthorized (12)
    # SRI  979 1b43d904        Address digits: 4917607011479
    #      981 1b43d904        t-BcsmTriggerDetectionPoint: termAttemptAuthorized (12)
    # PRN  987 501b6867        TBCD digits: 262073900302979      Address digits: 4917607011479
    #     1061 501b6867        Address digits: 491760049180
    # SRI  985 a718d903        Address digits: 4917607011479
    #     1062 a718d903        routingInfo: roamingNumber (0)


    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_002_TXT}

    Verify Trace    True   Component: invoke              localValue: sendRoutingInfo      Address digits: 4917607011479
    Verify Trace    False  Component: returnResultLast    localValue: sendRoutingInfo      t-CSI      termAttemptAuthorized .12.      serviceKey: 76
    Verify Trace    True   Component: invoke              localValue: sendRoutingInfo      Address digits: 4917607011479
    Verify Trace    False  Component: returnResultLast    localValue: sendRoutingInfo      routingInfo: roamingNumber

trace txt gsm_map 002c
    # SRI  960 a518d903        Address digits: 4917607011479
    #      965 a518d903        t-BcsmTriggerDetectionPoint: termAttemptAuthorized (12)
    # SRI  979 1b43d904        Address digits: 4917607011479
    #      981 1b43d904        t-BcsmTriggerDetectionPoint: termAttemptAuthorized (12)
    # PRN  987 501b6867        TBCD digits: 262073900302979      Address digits: 4917607011479
    #     1061 501b6867        Address digits: 491760049180
    # SRI  985 a718d903        Address digits: 4917607011479
    #     1062 a718d903        routingInfo: roamingNumber (0)


    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_002_TXT}

    ${i}=   Verify Trace Starting At    True   0      Component: invoke              localValue: sendRoutingInfo      Address digits: 4917607011479
    ${i}=   Verify Trace Starting At    False  ${i}   Component: returnResultLast    localValue: sendRoutingInfo      !not!termAttemptAuthorized .12.

trace txt gsm_map 002d
    # SRI  960 a518d903        Address digits: 4917607011479
    #      965 a518d903        t-BcsmTriggerDetectionPoint: termAttemptAuthorized (12)
    # SRI  979 1b43d904        Address digits: 4917607011479
    #      981 1b43d904        t-BcsmTriggerDetectionPoint: termAttemptAuthorized (12)
    # PRN  987 501b6867        TBCD digits: 262073900302979      Address digits: 4917607011479
    #     1061 501b6867        Address digits: 491760049180
    # SRI  985 a718d903        Address digits: 4917607011479
    #     1062 a718d903        routingInfo: roamingNumber (0)


    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_002_TXT}

    ${i}=   Verify Trace Starting At    True   0      Component: invoke              localValue: sendRoutingInfo      Address digits: 4917607011479
    ${i}=   Verify Trace Starting At    False  ${i}   Component: returnResultLast    localValue: sendRoutingInfo      t-CSI      termAttemptAuthorized .12.      serviceKey: 76
    ${i}=   Verify Trace Starting At    True   ${i}   Component: invoke              localValue: sendRoutingInfo      Address digits: 4917607011479
    ${i}=   Verify Trace Starting At    False  ${i}   Component: returnResultLast    localValue: sendRoutingInfo      t-CSI      termAttemptAuthorized .12.      serviceKey: 76
    ${i}=   Verify Trace Starting At    True   ${i}   Component: invoke              localValue: sendRoutingInfo      Address digits: 4917607011479
    ${i}=   Verify Trace Starting At    False  ${i}   Component: returnResultLast    localValue: sendRoutingInfo      routingInfo: roamingNumber


trace txt gsm_map 003a
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_003_TXT}
    Should Be Equal As Integers        ${count}   47    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_003_TXT}

    Verify Trace    True    Component: invoke               localValue: registerSS      ss-Code: cfb    Address digits: 017607011148
    Verify Trace    False   Component: returnResultLast     localValue: registerSS      ss-Code: cfb    ss-Status: 07
    Verify Trace    True    Component: invoke               localValue: activateSS      ss-Code: cw
    Verify Trace    False   Component: returnResultLast     localValue: activateSS      ss-Code: cw     ss-Status: 05

trace txt gsm_map 004a1
    # SRI  14  1260  6006d905    Address digits: 4917607011479
    # SRI  16  1267  e54bd905    Address digits: 4917607011479
    # SRI  20  1279  5f06d905    Address digits: 4917607011479
    # PRN  21  1283  501a130d    Address digits: 4917607011479
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_004_TXT}
    Should Be Equal As Integers        ${count}   30    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_004_TXT}

    Verify Trace  True   Component: invoke              localValue: sendRoutingInfo    Address digits: 4917607011479
    Verify Trace  False  Component: returnResultLast    localValue: sendRoutingInfo    t-CSI

trace txt gsm_map 004a2
    # SRI  14  1260  6006d905    Address digits: 4917607011479
    # SRI  16  1267  e54bd905    Address digits: 4917607011479
    # SRI  20  1279  5f06d905    Address digits: 4917607011479
    # PRN  21  1283  501a130d    Address digits: 4917607011479
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_004_TXT}

    Verify Trace  True   Component: invoke              localValue: sendRoutingInfo    Address digits: 4917607011479
    Verify Trace  False  Component: returnResultLast    localValue: sendRoutingInfo    roamingNumber: 91947106401947

trace txt gsm_map 004a3
    # SRI  14  1260  6006d905    Address digits: 4917607011479
    # SRI  16  1267  e54bd905    Address digits: 4917607011479
    # SRI  20  1279  5f06d905    Address digits: 4917607011479
    # PRN  21  1283  501a130d    Address digits: 4917607011479
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_004_TXT}

    Verify Trace  True   Component: invoke              localValue: sendRoutingInfo    Address digits: 4917607011479
    Verify Trace  False  Component: returnResultLast    localValue: sendRoutingInfo    !not!t-CSI


trace txt gsm_map 004b
    # SRI  14  1260  6006d905    Address digits: 4917607011479
    # SRI  16  1267  e54bd905    Address digits: 4917607011479
    # SRI  20  1279  5f06d905    Address digits: 4917607011479
    # PRN  21  1283  501a130d    Address digits: 4917607011479
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_004_TXT}

    Verify Trace  True   Component: invoke                                             Address digits: 4917607011479
    Verify Trace  False  Component: returnResultLast    localValue: sendRoutingInfo    roamingNumber: 91947106401947
    Verify Trace  False  Component: returnResultLast    end

trace txt gsm_map 005a
    # no idea what this is supposed to test - seems identical to 004 tests above
    # SRI 7106d905
    # SRI f84bd905
    # SRI 7306d905
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_005_TXT}
    Should Be Equal As Integers        ${count}   16    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_005_TXT}

    Verify Trace  True   Component: invoke              localValue: sendRoutingInfo    Address digits: 4917607011479
    Verify Trace  False  Component: returnResultLast    localValue: sendRoutingInfo    roamingNumber: 91947106401967
    Verify Trace  False  Component: returnResultLast    end

trace txt gsm_map 006a
    [documentation]   std case
    # special cases:
    # 2x SCTP PDU in one Ether Frame (CS LUP.req, SRI4SM.req) otid: 00cd00c0 + otid: 0e00c501
    # 2x MAP PDU in one SCTP Frame (SRI4SM.res, informSC.req) 
    # a) test non-special case
    # b) test 2x SCTP PDU 1st PDU (LUP)
    # c) test 2x SCTP PDU 2nd PDU (SRI4SM) - only req
    # d) test 2x SCTP PDU 2nd PDU (SRI4SM) - req+resp (resp already in the 2xMAP PDU)
    # e) test 2x MAP PDU
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_006_TXT}
    # old parsing (ether packets)
    #Should Be Equal As Integers        ${count}   53    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_006_TXT}
    # new parsing (SCTP packets)
    Should Be Equal As Integers        ${count}   56    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_006_TXT}

    ${i}=   Verify Trace Starting At    True   0      Component: invoke              localValue: sendAuthenticationInfo     TBCD digits: 262073900302977
    ${i}=   Verify Trace Starting At    False  ${i}   Component: returnResultLast    localValue: sendAuthenticationInfo     AuthenticationQuintuplet

trace txt gsm_map 006b
    [documentation]   test 2x SCTP PDU 1st PDU 00cd00c0 (LUP) 
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_006_TXT}
    # old parsing (ether packets)
    #Should Be Equal As Integers        ${count}   53    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_006_TXT}
    # new parsing (SCTP packets)
    Should Be Equal As Integers        ${count}   56    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_006_TXT}

    ${i}=   Verify Trace Starting At    True   0      Component: invoke              localValue: updateGprsLocation     TBCD digits: 262073900302977
    ${i}=   Verify Trace Starting At    False  ${i}   Component: invoke              localValue: insertSubscriberData   Address digits: 4917607011477
    ${i}=   Verify Trace Starting At    False  ${i}   Component: returnResultLast
    ${i}=   Verify Trace Starting At    False  ${i}   Component: invoke              localValue: insertSubscriberData   pdp-ContextId: 6  pdp-ContextId: 6
    ${i}=   Verify Trace Starting At    False  ${i}   Component: returnResultLast
    ${i}=   Verify Trace Starting At    False  ${i}   Component: returnResultLast    localValue: updateGprsLocation

trace txt gsm_map 006c
    [documentation]   test 2x SCTP PDU 2nd PDU 0e00c501.req (SRI4SM)
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_006_TXT}
    # old parsing (ether packets)
    #Should Be Equal As Integers        ${count}   53    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_006_TXT}
    # new parsing (SCTP packets)
    Should Be Equal As Integers        ${count}   56    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_006_TXT}

    ${i}=   Verify Trace Starting At    True   0      Component: invoke              localValue: sendRoutingInfoForSM   Address digits: 4917607011040


trace txt gsm_map 006d
    [documentation]   test 2x SCTP PDU 2nd PDU 0e00c501.req+res (SRI4SM)
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_006_TXT}
    # old parsing (ether packets)
    #Should Be Equal As Integers        ${count}   53    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_006_TXT}
    # new parsing (SCTP packets)
    Should Be Equal As Integers        ${count}   56    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_006_TXT}

    ${i}=   Verify Trace Starting At    True   0      Component: invoke              localValue: sendRoutingInfoForSM   Address digits: 4917607011040
    ${i}=   Verify Trace Starting At    False  ${i}   Component: returnResultLast    localValue: sendRoutingInfoForSM   TBCD digits: 262073900317140

trace txt gsm_map 006e1
    [documentation]   test 2x MAP PDU
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_006_TXT}
    # old parsing (ether packets)
    #Should Be Equal As Integers        ${count}   53    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_006_TXT}
    # new parsing (SCTP packets)
    Should Be Equal As Integers        ${count}   56    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_006_TXT}

    ${i}=   Verify Trace Starting At    True   0    Component: invoke              localValue: sendRoutingInfoForSM   Address digits: 4917607011040
    ${i}=   Verify Trace Starting At    False  0    Component: returnResultLast    localValue: sendRoutingInfoForSM   TBCD digits: 262073900317140      Component: invoke          localValue: informServiceCentre

trace txt gsm_map 006e2
    [documentation]   test 2x MAP PDU
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_006_TXT}
    # old parsing (ether packets)
    #Should Be Equal As Integers        ${count}   53    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_006_TXT}
    # new parsing (SCTP packets)
    Should Be Equal As Integers        ${count}   56    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_006_TXT}

    ${i}=   Verify Trace Starting At    True   0      Component: invoke              localValue: sendRoutingInfoForSM   Address digits: 4917607011040
    ${i}=   Verify Trace Starting At    False  0      Component: returnResultLast    localValue: sendRoutingInfoForSM   TBCD digits: 262073900317140      Component: invoke          localValue: informServiceCentre
    ${i}=   Verify Trace Starting At    False  0      Component: invoke              localValue: informServiceCentre

trace txt gsm_map 006e3
    [documentation]   test 2x MAP PDU
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_006_TXT}
    # old parsing (ether packets)
    #Should Be Equal As Integers        ${count}   53    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_006_TXT}
    # new parsing (SCTP packets)
    Should Be Equal As Integers        ${count}   56    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_006_TXT}

    ${i}=   Verify Trace Starting At    True   0      Component: invoke              localValue: informServiceCentre

trace txt gsm_map 007a
    [documentation]   MC trace
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_007_TXT}
    Should Be Equal As Integers        ${count}   38    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_007_TXT}

    Verify Trace  True        Component: invoke              localValue: sendRoutingInfo         Address digits: 4915900102120
    Verify Trace  False       Component: returnResultLast    localValue: sendRoutingInfo         t-CSI        serviceKey: 126
    Verify Trace  True        Component: invoke              localValue: anyTimeInterrogation    Address digits: 4917604026640
    Verify Trace  False       Component: returnResultLast    locationInformation    subscriberState
    Verify Trace  True        Component: invoke              localValue: anyTimeInterrogation    Address digits: 4917604026641
    Verify Trace  False       Component: returnResultLast    locationInformation    subscriberState
    Verify Trace  True        Component: invoke              localValue: anyTimeInterrogation    Address digits: 4917604026642
    Verify Trace  False       Component: returnResultLast    locationInformation    subscriberState
    Verify Trace  True        Component: invoke              localValue: anyTimeInterrogation    Address digits: 4917604026643
    Verify Trace  False       Component: returnError         localValue: unknownSubscriber
    Verify Trace  True        Component: invoke              localValue: anyTimeInterrogation    Address digits: 4917604026644
    Verify Trace  False       Component: returnError         localValue: unknownSubscriber
    Verify Trace  True        Component: invoke              localValue: provideSubscriberInfo   TBCD digits: 262073900318140    locationInformation    subscriberState  
    Verify Trace  False       Component: returnResultLast    locationInformation    subscriberState: assumedIdle
    Verify Trace  True        Component: invoke              localValue: provideSubscriberInfo   TBCD digits: 262073900318141    locationInformation    subscriberState
    Verify Trace  False       Component: returnResultLast    locationInformation    subscriberState: assumedIdle
    Verify Trace  True        Component: invoke              localValue: provideSubscriberInfo   TBCD digits: 262073900318142    locationInformation    subscriberState
    Verify Trace  False       Component: returnResultLast    locationInformation    subscriberState: assumedIdle
    Verify Trace  True        Component: invoke              localValue: sendRoutingInfo         Address digits: 4917604026640
    Verify Trace  False       Component: returnResultLast 


trace txt diameter 000a
    [documentation]   diameter LUP
    Set Test Variable   ${TRC_PROTOC}   diameter
    ${count}=   Parse test TXT trace   diameter    ${TRC_DIAMETER_000_TXT}
    Should Be Equal As Integers        ${count}   26    msg=Wrong number of packets (${count}) in ${TRC_DIAMETER_000_TXT}

    # SAI 
    Verify Trace  True   Command Code: 318 3GPP-Authentication-Information   User-Name: 262073900302977
    Verify Trace  False  Command Code: 318 3GPP-Authentication-Information   Result-Code: DIAMETER_SUCCESS
    # EPS LU
    Verify Trace  True   Command Code: 316 3GPP-Update-Location   User-Name: 262073900302977
    Verify Trace  False  Command Code: 316 3GPP-Update-Location   Result-Code: DIAMETER_SUCCESS



trace txt skip verification
    Set Test Variable       ${SKIP_TRACE}           True
    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=               Parse test TXT trace    gsm_map     ${TRC_GSM_MAP_000_TXT}
    ${re}=                  Create List             Protocol
    ${count}=               Verify Trace            True        @{re}   

    Should Be Equal As Integers     ${count}   -1    msg=Wrong packet index (${count}) returned by ${re}

trace txt ignore err 000
    Set Test Variable       ${IGNORE_ERR_TRACE}           True
    Set Test Variable       ${TRC_PROTOC}   gsm_map
    ${count}=               Parse test TXT trace    gsm_map     ${TRC_GSM_MAP_000_TXT}
    ${re}=                  Create List    FuuuBar
    Verify Trace            True           @{re}

trace txt ignore err 001a
    Set Test Variable       ${IGNORE_ERR_TRACE}           False
    Set Test Variable       ${TRC_PROTOC}   gsm_map
    ${count}=               Parse test TXT trace    gsm_map     ${TRC_GSM_MAP_000_TXT}
    ${re}=                  Create List    FuuuBar
    Run Keyword And Expect Error      *Trace Verification Failed*      Verify Trace            True           @{re}

trace txt ignore err 001b
    Set Test Variable       ${TRC_PROTOC}   gsm_map
    ${count}=               Parse test TXT trace    gsm_map     ${TRC_GSM_MAP_000_TXT}
    ${re}=                  Create List    FuuuBar
    Run Keyword And Expect Error      *Trace Verification Failed*      Verify Trace            True           @{re}

trace txt map_n_dia 000
    [documentation]   MAP CS+PS LUP and diameter LUP (MAP CL)
    Set Test Variable   ${TRC_PROTOC}   diameter,gsm_map,tcap
    ${count}=   Parse Trace      ${TRC_MAP_N_DIA_000_PCAP}   ${TRC_PROTOC}   outfile=${TRC_MAP_N_DIA_000_TXT}
    Should Be Equal As Integers        ${count}   124    msg=Wrong number of packets (${count}) in ${TRC_MAP_N_DIA_000_TXT}

    # MAP SAI - success = TCAP end
    Verify Trace  True   Component: invoke  localValue: sendAuthenticationInfo  TBCD digits: 262073900302977
    Verify Trace  False  Component: return  end
    # CS LU
    Verify Trace  True   Component: invoke  localValue: updateLocation          TBCD digits: 262073900302977
    Verify Trace  False  Component: return  end
    # PS LU
    Verify Trace  True   Component: invoke  localValue: updateGprsLocation      TBCD digits: 262073900302977
    Verify Trace  False  Component: return  end
    # DIA SAI
    Verify Trace  True   Command Code: 318 3GPP-Authentication-Information   User-Name: 262073900302977
    Verify Trace  False  Command Code: 318 3GPP-Authentication-Information   Result-Code: DIAMETER_SUCCESS
    # EPS LU
    Verify Trace  True   Command Code: 316 3GPP-Update-Location   User-Name: 262073900302977
    Verify Trace  False  Command Code: 316 3GPP-Update-Location   Result-Code: DIAMETER_SUCCESS
    # PS CL
    Verify Trace  True   Component: invoke  localValue: cancelLocation      TBCD digits: 262073900302977  cancellationType: updateProcedure
    Verify Trace  False  Component: return  end


trace txt map_n_dia 001
    [documentation]   MAP CS+PS LUP and diameter LUP (MAP CL)
    Set Test Variable   ${TRC_PROTOC}   diameter,gsm_map,tcap
    ${count}=   Parse Trace      ${TRC_MAP_N_DIA_000_FLTD}   ${TRC_PROTOC}   outfile=${TRC_MAP_N_DIA_000_TXT}
    Should Be Equal As Integers        ${count}  29    msg=Wrong number of packets (${count}) in ${TRC_MAP_N_DIA_000_TXT}

    # MAP SAI - success = TCAP end
    Verify Trace  True   Component: invoke  localValue: sendAuthenticationInfo  TBCD digits: 262073900302977
    Verify Trace  False  Component: return  end
    # CS LU
    Verify Trace  True   Component: invoke  localValue: updateLocation          TBCD digits: 262073900302977
    Verify Trace  False  Component: return  end
    # PS LU
    Verify Trace  True   Component: invoke  localValue: updateGprsLocation      TBCD digits: 262073900302977
    Verify Trace  False  Component: return  end
    # DIA SAI
    Verify Trace  True   Command Code: 318 3GPP-Authentication-Information   User-Name: 262073900302977
    Verify Trace  False  Command Code: 318 3GPP-Authentication-Information   Result-Code: DIAMETER_SUCCESS
    # EPS LU
    Verify Trace  True   Command Code: 316 3GPP-Update-Location   User-Name: 262073900302977
    Verify Trace  False  Command Code: 316 3GPP-Update-Location   Result-Code: DIAMETER_SUCCESS
    # PS CL
    Verify Trace  True   Component: invoke  localValue: cancelLocation      TBCD digits: 262073900302977  cancellationType: updateProcedure
    Verify Trace  False  Component: return  end


##################################################################################################################
##################################################################################################################
##################################################################################################################


trace xml gsm_map 000
    [Documentation]   Analyse wireshark trace
    ...
    ...         blaa blaa blaa

    ${count}=   Parse test XML trace   gsm_map     ${TRC_GSM_MAP_000_XML}
    Should Be Equal As Integers        ${count}   20    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_000_XML}

    #Verify Trace XML        //field[@showname='msisdn: xx91947106049170f7']
    ${xpath}=   Set Variable        //proto[@name='gsm_map' and .//field[@showname='returnResultLast']//field[@showname='localValue: sendRoutingInfo (22)'] and .//field[@showname='TBCD digits: 262073900317077'] and .//field[@showname='forwardingData']//field[@showname='Address digits: 4917604019078'] and .//field[@showname='forwardingData']//field[@showname='forwardingOptions: 2c']]
    ${count}=   Verify Trace XML    ${xpath}
    Should Be Equal As Integers     ${count}   2    msg=Wrong number of matches (${count}) returned by ${xpath}

    ${xpath}=   Set Variable        //proto[@name='gsm_map' and .//field[@showname='forwardingData']//field[@showname='Address digits: xxxxxxxxxxxxx'] ]
    ${count}=   Verify Trace XML    ${xpath}
    Should Be Equal As Integers     ${count}   1    msg=Wrong number of matches (${count}) returned by ${xpath}

    ${xpath}=   Set Variable        //proto[@name='gsm_map' and .//field[@name='gsm_map.ch.msisdn']/field[@showname='Address digits: xxxxxxxxxxxxx'] ]
    ${count}=   Verify Trace XML    ${xpath}
    Should Be Equal As Integers     ${count}   1    msg=Wrong number of matches (${count}) returned by ${xpath}

    ${xpath}=   Set Variable        //proto[@name='gsm_map' and .//field[@showname='Address digits: xxxxxxxxxxxxx'] ]
    ${count}=   Verify Trace XML    ${xpath}
    Should Be Equal As Integers     ${count}   1    msg=Wrong number of matches (${count}) returned by ${xpath}

    ${xpath}=   Set Variable        //proto[@name='gsm_map' and .//field[@showname='Address digits: 4917604019078'] ]
    ${count}=   Verify Trace XML    ${xpath}
    Should Be Equal As Integers     ${count}   7    msg=Wrong number of matches (${count}) returned by ${xpath}

    ${xpath}=   Set Variable        //proto[@name='gsm_map' and .//field[@showname='Address digits: 4917604019077'] ]
    ${count}=   Verify Trace XML    ${xpath}
    Should Be Equal As Integers     ${count}   5    msg=Wrong number of matches (${count}) returned by ${xpath}

    ${xpath}=   Set Variable        //proto[@name='gsm_map' and .//field[@showname='FuuuBar'] ]
    ${status}   ${value}=   Run Keyword And Ignore Error    Verify Trace XML   ${xpath}
    Run Keyword IF          '${status}' == 'PASS'           Fail     Match did not fail with Regex ${xpath}

    #Verify Trace XML        //proto[@name='gsm_map' and .//field[@name='gsm_map.ch.msisdn']/field/@showname='Address digits: 4917604019077' and .//field[@showname='returnResultLast']//field[@showname='localValue: sendRoutingInfo (22)'] ]
    #Verify Trace XML        //proto[@name='gsm_map']


trace xml skip verification
    Set Test Variable       ${SKIP_TRACE}           True
    ${count}=   Parse test XML trace    gsm_map     ${TRC_GSM_MAP_000_XML}
    ${xpath}=   Set Variable            //proto[@name='gsm_map' and .//field[@showname='returnResultLast']//field[@showname='localValue: sendRoutingInfo (22)'] and .//field[@showname='TBCD digits: 262073900317077'] and .//field[@showname='forwardingData']//field[@showname='Address digits: 4917604019078'] and .//field[@showname='forwardingData']//field[@showname='forwardingOptions: 2c']]
    ${count}=   Verify Trace XML        ${xpath}
    Should Be Equal As Integers         ${count}    -1    msg=Wrong number of matches (${count}) returned by ${xpath}

trace xml ignore err
    Set Test Variable       ${IGNORE_ERR_TRACE}           True
    ${count}=   Parse test XML trace    gsm_map     ${TRC_GSM_MAP_000_XML}
    ${xpath}=   Set Variable        //proto[@name='gsm_map' and .//field[@showname='FuuuBar'] ]
    Verify Trace XML   ${xpath}



*** Keywords ***
Parse test TXT trace
    [arguments]     ${proto}    ${file}
    ${count}=       Parse Trace         this_is_ignored.pcap   ${proto}    fileformat=txt   outfile=${file}
    [return]        ${count}

Open Dummy Ssh Connections
    Open Connection         ${TRC_IP}   prompt=${SSHPROMPT}  alias=${TRC_HOST1}
    Login                   ${user}   ${passwd}
    Open Connection         ${TRC_IP}   prompt=${SSHPROMPT}  alias=${TRC_HOST2}
    Login                   ${user}   ${passwd}

Upload Example Traces
    Open Connection         ${TRC_IP}   prompt=${SSHPROMPT}  alias=${TRC_HOST1}
    Login                   ${user}   ${passwd}
    ${sout}  ${serr}  ${rc}=    Execute Command   rm -f ${TRC_SSH_USR_PATH}*    return_rc=True   return_stdout=True   return_stderr=True
    #Should Be Equal As Integers     ${rc}    0
    Put Directory       ${TRC_LPATH}     ${TRC_SSH_USR_PATH}     mode=0755   recursive=True
    Close Connection

Copy Dummy Default Traces
    # copy traces from ~/ta/trace to /tmp/ta/trace ((${TRC_SSH_USR_PATH} --> ${TRC_PATH_VAL}
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_000_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[0]_@{trace_ifs}[0]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_001_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[1]_@{trace_ifs}[1]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_000_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[2]_@{trace_ifs}[2]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_001_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[3]_@{trace_ifs}[3]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True

Copy Dummy MAP Traces
    # copy traces from ~/ta/trace to /tmp/ta/trace ((${TRC_SSH_USR_PATH} --> ${TRC_PATH_VAL}
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_000_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[0]_@{trace_ifs_map}[0]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_001_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[1]_@{trace_ifs_map}[1]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_000_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[2]_@{trace_ifs_map}[2]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_001_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[3]_@{trace_ifs_map}[3]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True

Copy Dummy DIA Traces
    # copy traces from ~/ta/trace to /tmp/ta/trace ((${TRC_SSH_USR_PATH} --> ${TRC_PATH_VAL}
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_000_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[0]_@{trace_ifs_dia}[0]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_001_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[1]_@{trace_ifs_dia}[1]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_000_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[2]_@{trace_ifs_dia}[2]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_001_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[3]_@{trace_ifs_dia}[3]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True

Copy Dummy Traces
    [arguments]         ${protocol}=default
    Run Keyword If      '${protocol}' == 'default'      Copy Dummy Default Traces
    Run Keyword If      '${protocol}' == 'gsm_map'      Copy Dummy MAP Traces
    Run Keyword If      '${protocol}' == 'diameter'     Copy Dummy DIA Traces


Run Before Test Suite
    [Documentation]   Test Suite set-up/precondition
    ...
    ...     Test Suite preparation subroutine, executed once for the test suite i.e. once before the test case execution starts.
    # load correct version of the resource file
    # if set Python implementation of the libraries is tested
    # default is the RF version
    #${tstMode}=     Get Variable Value  ${TEST_PyTA}        False
    #Run Keyword If    ${tstMode}        Import Resource     wireshark_py.txt
    #Run Keyword If    not ${tstMode}    Import Resource     wireshark.txt
    ##enable ssh logging      ssh.log

    Create Results Directory
    Upload Example Traces

Run After Test Suite
    [Documentation]   Test Suite tear-down/postcondition
    ...
    ...     Test Suite tear-down subroutine, executed once for the test suite i.e. once after test case execution has ended.
    No Operation

Run Before Test Case
    [Documentation]   Test Case set-up/precondition
    ...
    ...     Test case preparation subroutine, executed before each test case.
    No Operation

Run After Test Case
    [Documentation]   Test Case tear-down/postcondition
    ...
    ...     Test case tear-down subroutine, executed before each test case.
    No Operation



Parse test XML trace
    [arguments]     ${proto}    ${file}
    ${count}=       Parse Trace XML         this_is_ignored.pcap   ${proto}    fileformat=xml   outfile=${file}
    [return]        ${count}

