# b5a09734               device product:kltexw model:SM_G900F device:klte  // samsung galaxy 5 - not working
# CB5124VWNG             device product:C6903 model:C6903 device:C6903 // sony xperia Z1
# 3cdfbd8ffa9e           device product:Y530-U00 model:HUAWEI_Y530_U00 device:hwY530-U00  //huawei Y530
# d81e91ba               device product:jfltexx model:GT_I9505 device:jflte // samsung galaxy 4

############################################
# globals
############################################
hang_up_call_after = '00:'

NAV_PRESS = 1
NAV_LONGPRESS = 2
NAV_SWIPE = 3
NAV_TYPE = 4
NAV_PRESS_KEYCODE = 5
NAV_LONGPRESS_KEYCODE = 6



############################################
# templates, should never be used in the actual code
############################################
# Leave unused ones with empty string i.e. ''
# appPackage	Java package of the Android app you want to run	com.example.android.myApp, com.android.settings
# appActivity	Activity name for the Android activity you want to launch from your package. This often needs to be preceded by a . (e.g., .MainActivity instead of MainActivity)	MainActivity, .Settings
# appWaitActivity	Activity name for the Android activity you want to wait for	SplashActivity
# app_wait_package	Java package of the Android app you want to wait for	com.example.android.myApp, com.android.settings
# intent_action	Intent action which will be used to start activity (default android.intent.action.MAIN)	e.g.android.intent.action.MAIN, android.intent.action.VIEW
# intent_category	Intent category which will be used to start activity (default android.intent.category.LAUNCHER)	e.g. android.intent.category.LAUNCHER, android.intent.category.APP_CONTACTS
# intent_flags	Flags that will be used to start activity (default 0x10200000)	e.g. 0x10200000
# optional_intent_arguments	Additional intent arguments that will be used to start activity. See Intent arguments	e.g. --esn <EXTRA_KEY>, --ez <EXTRA_KEY> <EXTRA_BOOLEAN_VALUE>, etc.

settings_app_template = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': '',
    'app_activity': '',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
}

settings_smscomposer_template = {
    'recipient_txt': '',
    'message_txt': '',
    'send_button': '',
}

settings_phone_template = {
    'digits_txt_field': '',
    'call_button': '',
    'endcall_button': '',
    'expected_txt': '',
    'popup_ok_button': 'android:id/button1',
    'callended_txt': '',
}

settings_template = {
    'udid': '',
    'platform_name': 'Android',
    'platform_version': '4.4',
    'phone_app': None,
    'sms_app': None,
    'autoanswer_app': None,
}

#     #  #     #     #     #     #  #######  ###     #     #  #####  #####   ####      ######    ###    ###   #####
#     #  #     #    # #    #  #  #  #         #       #   #   #      #      #   ##     #     #  #   #  #   #      #
#     #  #     #   #   #   #  #  #  #         #        # #    #      #      #  # #     #     #  #   #      #     #
#######  #     #  #     #  #  #  #  #####     #         #     #####  #####  # #  #     ######      #    ###     #
#     #  #     #  #######  #  #  #  #         #         #         #      #  ##   #     #     #    #        #   #
#     #  #     #  #     #  #  #  #  #         #         #         #      #  #    #     #     #   #     #   #   #
#     #   #####   #     #   ## ##   #######  ###        #     #####  #####   ####      ######   #####   ###    #
############################################
# settings app settings
###########################################

settings_app_huawei_Y550_L01_B237 = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.settings',
    'app_activity': '.HWSettings',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    # NW modes
    'path_to_NwSettings': [
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'Mobile networks')]" ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'etwork mode')]" ],
    ],
    'LTE': "xpath = //android.widget.CheckedTextView[starts-with(@text,'Auto LTE')]",
    '3G/2G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'Auto 3G')]",
    '3G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'3G only')]",
    '2G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'2G only')]",

    # CLIP
    'path_to_AdditionalSettings': [
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 250, 1500 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text,'Call')]" ],
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text,'Additional settings')]" ]
    ],
    'clip_menu': "xpath = //android.widget.TextView[contains(@text,'Caller ID')]",
    'clip_network': "xpath = //android.widget.CheckedTextView[contains(@text,'Network default')]",
    'clip_hide': "xpath = //android.widget.CheckedTextView[contains(@text,'Hide number')]",
    'clip_show': "xpath = //android.widget.CheckedTextView[contains(@text,'Show number')]",
}

#     #  #     #     #     #     #  #######  ###     #     #  #####  #####   ####      ######    ###   #   #   ###
#     #  #     #    # #    #  #  #  #         #       #   #   #      #      #   ##     #     #  #   #  #   #  #   #
#     #  #     #   #   #   #  #  #  #         #        # #    #      #      #  # #     #     #  #   #  #   #  #
#######  #     #  #     #  #  #  #  #####     #         #     #####  #####  # #  #     ######      #   #####  ####
#     #  #     #  #######  #  #  #  #         #         #         #      #  ##   #     #     #    #        #  #   #
#     #  #     #  #     #  #  #  #  #         #         #         #      #  #    #     #     #   #         #  #   #
#     #   #####   #     #   ## ##   #######  ###        #     #####  #####   ####      ######   #####      #   ###
#####################################################################
#  B M   S I M   C a r d s   h a v e   d i f f e r e n t   M e n u s
#####################################################################
settings_app_huawei_Y550_L01_BM_SIM = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.settings',
    'app_activity': '.HWSettings',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    # NW modes
    'path_to_NwSettings': [
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'Mobile networks')]" ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'etwork mode')]" ],
    ],
    'LTE': "xpath = //android.widget.CheckedTextView[starts-with(@text,'4G')]",
    '3G/2G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'3G/2G auto')]",
    '3G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'3G only')]",
    '2G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'2G only')]",

    # CLIP
    'path_to_AdditionalSettings': [
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 250, 1500 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text,'Call')]" ],
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text,'Additional settings')]" ]
    ],
    'clip_menu': "xpath = //android.widget.TextView[contains(@text,'Caller ID')]",
    'clip_network': "xpath = //android.widget.CheckedTextView[contains(@text,'Network default')]",
    'clip_hide': "xpath = //android.widget.CheckedTextView[contains(@text,'Hide number')]",
    'clip_show': "xpath = //android.widget.CheckedTextView[contains(@text,'Show number')]",

    # Status (operator, signal, network mode, etc.)
    'path_to_status': [
        [ NAV_SWIPE, 200, 600, 200, 100, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 100, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 100, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 300, 900 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'About phone')]" ],
        [ NAV_SWIPE, 200, 600, 200, 100, 900 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'Status')]" ],
        [ NAV_SWIPE, 200, 600, 200, 450, 900 ],
    ],
    'status_operator': "xpath = //android.widget.TextView[@text='Network']/../android.widget.TextView[2]",
    'status_signal': "xpath = //android.widget.TextView[@text='Signal strength']/../android.widget.TextView[2]",
    'status_radio': "xpath = //android.widget.TextView[@text='Mobile network type']/../android.widget.TextView[2]",
    'status_service': "xpath = //android.widget.TextView[@text='Service status']/../android.widget.TextView[2]",
    'status_roam': "xpath = //android.widget.TextView[@text='Roaming']/../android.widget.TextView[2]",
    'status_data': "xpath = //android.widget.TextView[@text='Mobile network state']/../android.widget.TextView[2]",
    'status_txt_service_airpl_on': "Radio off",
    'status_txt_service_attached': "In service",
    'status_txt_service_detached': "Out of service",
    'status_txt_nw_mode_4G_only': ".*LTE.*",
    'status_txt_nw_mode_3G_only': ".*HS.?PA.*|.*UMTS.*",
    'status_txt_nw_mode_2G_only': ".*EDGE.*",
    'status_txt_nw_mode_4G': ".*LTE.*|.*HS.?PA.*|.*UMTS.*|.*EDGE.*",
    'status_txt_nw_mode_3G': ".*HS.?PA.*|.*UMTS.*|.*EDGE.*",
    'status_txt_nw_mode_2G': ".*GSM.*|.*EDGE.*",
    'status_txt_data_True': ".*Connected.*",
    'status_txt_data_False': ".*Disonnected.*",
}


############################################
# settings app settings
###########################################
settings_app_huawei_Y550_L01 = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.settings',
    'app_activity': '.HWSettings',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    # NW modes
    'path_to_NwSettings': [
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'Mobile networks')]" ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'etwork mode')]" ],
    ],
    'LTE': "xpath = //android.widget.CheckedTextView[starts-with(@text,'Auto LTE')]",
    '3G/2G': "xpath = //android.widget.CheckedTextView[contains(@text,'2G auto')]",
    '3G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'3G only')]",
    '2G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'2G only')]",

    # CLIP
    'path_to_AdditionalSettings': [
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 250, 1500 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text,'Call')]" ],
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text,'Additional settings')]" ]
    ],
    'clip_menu': "xpath = //android.widget.TextView[contains(@text,'Caller ID')]",
    'clip_network': "xpath = //android.widget.CheckedTextView[contains(@text,'Network default')]",
    'clip_hide': "xpath = //android.widget.CheckedTextView[contains(@text,'Hide number')]",
    'clip_show': "xpath = //android.widget.CheckedTextView[contains(@text,'Show number')]",

    # Status (operator, signal, network mode, etc.)
    'path_to_status': [
        [ NAV_SWIPE, 200, 600, 200, 100, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 100, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 100, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 400, 900 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'About phone')]" ],
        [ NAV_SWIPE, 200, 600, 200, 100, 900 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'Status')]" ],
        [ NAV_SWIPE, 200, 600, 200, 450, 900 ],
    ],
    'status_operator': "xpath = //android.widget.TextView[@text='Network']/../android.widget.TextView[2]",
    'status_signal': "xpath = //android.widget.TextView[@text='Signal strength']/../android.widget.TextView[2]",
    'status_radio': "xpath = //android.widget.TextView[@text='Mobile network type']/../android.widget.TextView[2]",
    'status_service': "xpath = //android.widget.TextView[@text='Service status']/../android.widget.TextView[2]",
    'status_roam': "xpath = //android.widget.TextView[@text='Roaming']/../android.widget.TextView[2]",
    'status_data': "xpath = //android.widget.TextView[@text='Mobile network state']/../android.widget.TextView[2]",
    'status_txt_service_airpl_on': "Radio off",
    'status_txt_service_attached': "In service",
    'status_txt_service_detached': "Out of service",
    'status_txt_nw_mode_4G_only': ".*LTE.*",
    'status_txt_nw_mode_3G_only': ".*HS.?PA.*|.*UMTS.*",
    'status_txt_nw_mode_2G_only': ".*EDGE.*",
    'status_txt_nw_mode_4G': ".*LTE.*|.*HS.?PA.*|.*UMTS.*|.*EDGE.*",
    'status_txt_nw_mode_3G': ".*HS.?PA.*|.*UMTS.*|.*EDGE.*",
    'status_txt_nw_mode_2G': ".*GSM.*|.*EDGE.*",
    'status_txt_data_True': ".*Connected.*",
    'status_txt_data_False': ".*Disonnected.*",

    # Accessibility sub-menu (for Toaster-App)
    'toaster_activation_path': [
        [ NAV_PRESS, "xpath = //android.widget.Button[contains(@text,'OK')]" ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'Toaster')]" ],
        # just click on the first available Switch element (there shouldn't be more than one
        [ NAV_PRESS, "xpath = //android.widget.Switch" ],
        [ NAV_PRESS, "xpath = //android.widget.Button[contains(@text,'OK')]" ],
        [ NAV_PRESS_KEYCODE, 4 ],  # KEYCODE_BACK
        [ NAV_PRESS_KEYCODE, 4 ],  # KEYCODE_BACK
        [ NAV_PRESS_KEYCODE, 4 ],  # KEYCODE_BACK
    ],
}
#     #  #     #     #     #     #  #######  ###     #     #  #####  #####   ####      ######    ###   #   #   ###
#     #  #     #    # #    #  #  #  #         #       #   #   #      #      #   ##     #     #  #   #  #   #  #   #
#     #  #     #   #   #   #  #  #  #         #        # #    #      #      #  # #     #     #  #   #  #   #  #
#######  #     #  #     #  #  #  #  #####     #         #     #####  #####  # #  #     ######      #   #####  ####
#     #  #     #  #######  #  #  #  #         #         #         #      #  ##   #     #     #    #        #  #   #
#     #  #     #  #     #  #  #  #  #         #         #         #      #  #    #     #     #   #         #  #   #
#     #   #####   #     #   ## ##   #######  ###        #     #####  #####   ####      ######   #####      #   ###
############################################
# settings app settings
###########################################
settings_app_huawei_Y550_L01_sim_fi = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.settings',
    'app_activity': '.HWSettings',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    # NW modes
    'path_to_NwSettings': [
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'Mobile networks')]" ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'etwork mode')]" ],
    ],
    'LTE': "xpath = //android.widget.CheckedTextView[starts-with(@text,'4G/3G/2G auto')]",
    '3G/2G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'3G/2G auto')]",
    '3G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'3G only')]",
    '2G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'2G only')]",

    # CLIP
    'path_to_AdditionalSettings': [
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 300, 900 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text,'Call')]" ],
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text,'Additional settings')]" ]
    ],
    'clip_menu': "xpath = //android.widget.TextView[contains(@text,'Caller ID')]",
    'clip_network': "xpath = //android.widget.CheckedTextView[contains(@text,'Network default')]",
    'clip_hide': "xpath = //android.widget.CheckedTextView[contains(@text,'Hide number')]",
    'clip_show': "xpath = //android.widget.CheckedTextView[contains(@text,'Show number')]",

    # Status (operator, signal, network mode, etc.)
    'path_to_status': [
        [ NAV_SWIPE, 200, 600, 200, 100, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 100, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 100, 900 ],
        [ NAV_SWIPE, 200, 600, 200, 400, 900 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'About phone')]" ],
        [ NAV_SWIPE, 200, 600, 200, 100, 900 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'Status')]" ],
        [ NAV_SWIPE, 200, 600, 200, 450, 900 ],
    ],
    'status_operator': "xpath = //android.widget.TextView[@text='Network']/../android.widget.TextView[2]",
    'status_signal': "xpath = //android.widget.TextView[@text='Signal strength']/../android.widget.TextView[2]",
    'status_radio': "xpath = //android.widget.TextView[@text='Mobile network type']/../android.widget.TextView[2]",
    'status_service': "xpath = //android.widget.TextView[@text='Service status']/../android.widget.TextView[2]",
    'status_roam': "xpath = //android.widget.TextView[@text='Roaming']/../android.widget.TextView[2]",
    'status_data': "xpath = //android.widget.TextView[@text='Mobile network state']/../android.widget.TextView[2]",
    'status_txt_service_airpl_on': "Radio off",
    'status_txt_service_attached': "In service",
    'status_txt_service_detached': "Out of service",
    'status_txt_nw_mode_4G_only': ".*LTE.*",
    'status_txt_nw_mode_3G_only': ".*HS.?PA.*|.*UMTS.*",
    'status_txt_nw_mode_2G_only': ".*EDGE.*",
    'status_txt_nw_mode_4G': ".*LTE.*|.*HS.?PA.*|.*UMTS.*|.*EDGE.*",
    'status_txt_nw_mode_3G': ".*HS.?PA.*|.*UMTS.*|.*EDGE.*",
    'status_txt_nw_mode_2G': ".*GSM.*|.*EDGE.*",
    'status_txt_data_True': ".*Connected.*",
    'status_txt_data_False': ".*Disonnected.*",

    # Accessibility sub-menu (for Toaster-App)
    'toaster_activation_path': [
        [ NAV_PRESS, "xpath = //android.widget.Button[contains(@text,'OK')]" ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'Toaster')]" ],
        # just click on the first available Switch element (there shouldn't be more than one
        [ NAV_PRESS, "xpath = //android.widget.Switch" ],
        [ NAV_PRESS, "xpath = //android.widget.Button[contains(@text,'OK')]" ],
        [ NAV_PRESS_KEYCODE, 4 ],  # KEYCODE_BACK
        [ NAV_PRESS_KEYCODE, 4 ],  # KEYCODE_BACK
        [ NAV_PRESS_KEYCODE, 4 ],  # KEYCODE_BACK
    ],
}

###########################################
# browser app settings
###########################################

browser_app_huawei_Y550_L01 = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.browser',
    'app_activity': '.BrowserActivity',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    '2G': '2G only',
}

###########################################
# smscomposer app settings
###########################################
smscomposer_app_huawei_Y550_L01 = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.mms',
    'app_activity': '.ui.ComposeMessageActivity',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    'recipient_txt': 'com.android.mms:id/recipients_editor',
    'message_txt': 'com.android.mms:id/embedded_text_editor',
    'send_button': 'com.android.mms:id/send_button_sms',
    'delivery_status_sms': "xpath = //android.widget.TextView[contains(@text,'",
    'delivery_status_sent': "')]/../..//android.widget.TextView[@text='Sent']",
    'delivery_status_delivered': "')]/../..//android.widget.TextView[@text='Delivered']",
    'delivery_status_failed': "')]/../..//android.widget.TextView[@text='Failed']",
}
###########################################
# smsreader app settings
###########################################
smsreader_app_huawei_Y550_L01 = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.mms',
    'app_activity': '.ui.ConversationList',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    'no_conversations_txt': "No conversations",
    'options_xp': "//android.widget.ImageButton[contains(@content-desc,'options')]",
    'delete_xp': "//android.widget.TextView[contains(@text,'elete')]",
    'select_all_id': "com.android.mms:id/all",
    'del_all_id': "com.android.mms:id/multiselect_button_delete",
    'confirm_del_xp': "//android.widget.Button[contains(@text,'elete')]",

    'sms_delivery_receipts_path': [
        [ NAV_PRESS, "xpath = //android.widget.ImageButton[contains(@content-desc,'options')]" ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'ettings')]" ],
        [ NAV_SWIPE, 200, 600, 200, 200, 900 ],
    ],
    'sms_receipt_checkbox': "xpath = //android.widget.TextView[starts-with(@text, 'Delivery report')]/../..//android.widget.CheckBox",
}

###########################################
# phone app settings
###########################################
phone_app_huawei_Y550_L01 = {
    'app': '',
    'app_version': '',
    'no_reset': True,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.contacts',
    'app_activity': '.activities.DialtactsActivity',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': 'android.intent.action.MAIN',
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    'digits_txt_field': 'com.android.contacts:id/digits',
    'call_button': 'com.android.contacts:id/dialButton',
    'endcall_button': 'com.android.phone:id/endButton',
    'dialer_button': 'id = com.android.phone:id/dialpadButton',
    'expected_txt': hang_up_call_after,
    'dialling_txt': 'Dialling',
    'connected_txt': 'CONNECTED',
    'popup_ok_button': "xpath = //android.widget.Button[contains(@text,'OK')]",
    'popup_cancel_button': "xpath = //android.widget.Button[contains(@text,'ancel')]",
    'popup_ack_aplmode_err': "xpath = //android.widget.Button[contains(@text,'OK')]",
    'popup_aplmode_txt': 'first turn off Aeroplane',
    'popup_nonet_txt': 'network not available',
    'callended_txt': 'ended',
    'linebusy_txt': 'busy',
    'incall_name': 'com.android.phone:id/name',
    'incall_speaker': 'com.android.phone:id/audioButton',
}
#     #  #     #     #     #     #  #######  ###     #     #  #####   ###    ####
#     #  #     #    # #    #  #  #  #         #       #   #   #      #   #  #   ##
#     #  #     #   #   #   #  #  #  #         #        # #    #          #  #  # #
#######  #     #  #     #  #  #  #  #####     #         #     #####   ###   # #  #
#     #  #     #  #######  #  #  #  #         #         #         #      #  ##   #
#     #  #     #  #     #  #  #  #  #         #         #         #  #   #  #    #
#     #   #####   #     #   ## ##   #######  ###        #     #####   ###    ####

smscomposer_app_huawei_Y530_U00 = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.mms',
    'app_activity': '.ui.ComposeMessageActivity',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    'recipient_txt': 'com.android.mms:id/recipients_editor',
    'message_txt': 'com.android.mms:id/embedded_text_editor',
    'send_button': 'com.android.mms:id/send_button_sms',
}

###########################################
# smsreader app settings
###########################################
smsreader_app_huawei_Y530_U00 = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.mms',
    'app_activity': '.ui.ConversationList',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
}

###########################################
# phone app settings
###########################################
phone_app_huawei_Y530_U00 = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.contacts',
    'app_activity': '.activities.DialtactsActivity',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    'digits_txt_field': 'com.android.contacts:id/digits',
    'call_button': 'com.android.contacts:id/dialButton',
    'endcall_button': 'com.android.phone:id/endButton',
    'expected_txt': 'CONNECTED',
    'connected_txt': 'CONNECTED',
    'popup_ok_button': "xpath = //android.widget.Button[contains(@text,'OK')]",
    'popup_cancel_button': "xpath = //android.widget.Button[contains(@text,'ancel')]",
    'popup_ack_aplmode_err': "xpath = //android.widget.Button[contains(@text,'OK')]",
    'popup_aplmode_txt': 'first turn off Aeroplane',
    'popup_nonet_txt': 'network not available',
    'callended_txt': 'ended',
    'linebusy_txt': 'busy',
    'incall_name': 'com.android.phone:id/callStateLabel',
    'incall_speaker': 'com.android.phone:id/audioButton',
}

 #####      #     #     #         #####      #     #              #####   #####         #####    ###    ####    ####
#     #    # #    ##   ##        #     #    # #    #             #     #  #            #     #  #   #  #   ##  #   ##
#         #   #   # # # #        #         #   #   #             #        #            #        #   #  #  # #  #  # #
 #####   #     #  #  #  #        #  ####  #     #  #              #####   #####        #  ####   ###   # #  #  # #  #
      #  #######  #     #        #     #  #######  #                   #      #        #     #     #   ##   #  ##   #
#     #  #     #  #     #        #     #  #     #  #             #     #      #        #     #    #    #    #  #    #
 #####   #     #  #     #         #####   #     #  #######        #####   #####         #####    #      ####    ####

###########################################
# settings app settings
###########################################
settings_app_samsung_S5_G900F = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.settings',
    'app_activity': '.GridSettings',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    # NW modes
    'path_to_NwSettings': [
        [NAV_PRESS, "xpath = //android.widget.Button[contains(@content-desc,'earch')]"],
        [NAV_TYPE, "id = android:id/search_src_text", "mobile net"],
        [NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'Mobile networks')]"],
        [NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'etwork mode')]"],
    ],
    'LTE': "xpath = //android.widget.CheckedTextView[starts-with(@text,'LTE/WCDMA')]",
    '3G/2G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'WCDMA/GSM')]",
    '3G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'WCDMA only')]",
    '2G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'GSM only')]",
    # CLIP
    'path_to_AdditionalSettings': [
        [NAV_PRESS, "xpath = //android.widget.Button[contains(@content-desc,'earch')]"],
        [NAV_TYPE, "id = android:id/search_src_text", "call"],
        [NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'Call')]"],
        [NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'More settings')]"],
    ],
    'clip_menu': "xpath = //android.widget.TextView[contains(@text,'Caller ID')]",
    'clip_network': "xpath = //android.widget.CheckedTextView[contains(@text,'Network default')]",
    'clip_hide': "xpath = //android.widget.CheckedTextView[contains(@text,'Hide number')]",
    'clip_show': "xpath = //android.widget.CheckedTextView[contains(@text,'Show number')]",

    # NW modes
    'path_to_status': [
        [NAV_PRESS, "xpath = //android.widget.Button[contains(@content-desc,'earch')]"],
        [NAV_TYPE, "id = android:id/search_src_text", "status"],
        [NAV_PRESS, "xpath = //android.widget.TextView[@text='Status']"],
        [ NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'Status')]" ],
        [ NAV_SWIPE, 200, 600, 200, 450, 900 ],
    ],
    'status_operator': "xpath = //android.widget.TextView[@text='Network']/../android.widget.TextView[2]",
    'status_signal': "xpath = //android.widget.TextView[@text='Signal strength']/../android.widget.TextView[2]",
    'status_radio': "xpath = //android.widget.TextView[@text='Mobile network type']/../android.widget.TextView[2]",
    'status_service': "xpath = //android.widget.TextView[@text='Service state']/../android.widget.TextView[2]",
    'status_roam': "xpath = //android.widget.TextView[@text='Roaming']/../android.widget.TextView[2]",
    'status_data': "xpath = //android.widget.TextView[@text='Mobile network state']/../android.widget.TextView[2]",
    'status_txt_service_airpl_on': "*Radio off*",
    'status_txt_service_attached': "*In service*",
    'status_txt_service_detached': "*Out of service*",

    # Accessibility sub-menu (for Toaster-App)
    'toaster_activation_path': [
        [ NAV_PRESS, "xpath = //android.widget.Button[contains(@text,'OK')]" ],
        [ NAV_SWIPE, 200, 600, 200, 50, 900 ],
        [ NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'Toaster')]" ],
        # just click on the first available Switch element (there shouldn't be more than one
        [ NAV_PRESS, "xpath = //android.widget.Switch" ],
        [ NAV_PRESS, "xpath = //android.widget.Button[contains(@text,'OK')]" ],
        [ NAV_PRESS_KEYCODE, 4 ],  # KEYCODE_BACK
        [ NAV_PRESS_KEYCODE, 4 ],  # KEYCODE_BACK
        [ NAV_PRESS_KEYCODE, 4 ],  # KEYCODE_BACK
    ],
}

###########################################
# browser app settings
###########################################
browser_app_samsung_S5_G900F = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.browser',
    'app_activity': '.BrowserActivity',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    '2G': '2G only',
}

###########################################
# smscomposer app settings
###########################################
smscomposer_app_samsung_S5_G900F = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.mms',
    'app_activity': '.ui.ConversationComposer',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': 'android.intent.action.SENDTO',
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    'recipient_txt': 'com.android.mms:id/recipients_editor_to',
    'message_txt': 'com.android.mms:id/edit_text_bottom',
    'send_button': 'com.android.mms:id/send_button',
}

###########################################
# smsreader app settings
###########################################
smsreader_app_samsung_S5_G900F = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.mms',
    'app_activity': '.ui.ConversationComposer',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': 'android.intent.action.MAIN',
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    'no_conversations_txt': "No messages",
    'options_xp': "//android.widget.ImageButton[contains(@content-desc,'options')]",
    'delete_xp': "//android.widget.TextView[contains(@text,'elete')]",
    'select_all_id': "com.android.mms:id/select_all_checkbox",
    'del_all_id': "com.android.mms:id/done",
    'confirm_del_xp': "//android.widget.Button[contains(@text,'elete')]",
}

###########################################
# phone app settings
###########################################
phone_app_samsung_S5_G900F = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.contacts',
    'app_activity': '.activities.PeopleActivity',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': 'android.intent.action.DIAL',
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    'digits_txt_field': 'com.android.contacts:id/digits',
    'call_button': 'com.android.contacts:id/dialButton',
    'endcall_button': 'com.android.incallui:id/endButton',
    'expected_txt': hang_up_call_after,
    'dialling_txt': 'Dialing',
    'connected_txt': '00:',
    'popup_ok_button': "xpath = //android.widget.Button[contains(@text,'OK')]",
    'popup_cancel_button': "xpath = //android.widget.Button[contains(@text,'ancel')]",
    'popup_ack_aplmode_err': "xpath = //android.widget.Button[contains(@text,'ancel')]",
    # when clicking "ok" on "first turn off airplane" disables airplane mode and makes the call
    # change the pop-up ack to xpath per device and click the button with test "Cancel" ("OK" on other devices)
    'popup_aplmode_txt': 'Turn Airplane mode off',
    'popup_nonet_txt': 'ot registered on network',
    'callended_txt': 'ended',
    'linebusy_txt': 'busy',
    'incall_name': 'com.android.incallui:id/name',
    'incall_speaker': 'com.android.incallui:id/speakerButton',
}

#     #  #     #     #     #     #  #######  ###        #      #####    #####       #####   #####
#     #  #     #    # #    #  #  #  #         #        # #    #     #  #     #     #     #      #
#     #  #     #   #   #   #  #  #  #         #       #   #   #        #           #           #
#######  #     #  #     #  #  #  #  #####     #      #     #   #####   #           #  ####    #
#     #  #     #  #######  #  #  #  #         #      #######        #  #           #     #   #
#     #  #     #  #     #  #  #  #  #         #      #     #  #     #  #     #     #     #   #
#     #   #####   #     #   ## ##   #######  ###     #     #   #####    #####       #####    #

settings_app_huawei_G7_L01_en = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.settings',
    'app_activity': '.HWSettings',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    # NW modes
    'path_to_NwSettings': [
        [NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'More')]"],
        [NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'Mobile networks')]"],
        [NAV_PRESS, "xpath = //android.widget.TextView[contains(@text,'Preferred network')]"],
    ],
    'LTE': "xpath = //android.widget.CheckedTextView[starts-with(@text,'Automatic (4G')]",
    '3G/2G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'Automatic (3G')]",
    '3G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'3G only')]",
    '2G': "xpath = //android.widget.CheckedTextView[starts-with(@text,'2G only')]",
    # CLIP
    'path_to_AdditionalSettings': [
        [NAV_PRESS, "xpath = //android.widget.Button[contains(@content-desc,'earch')]"],
        [NAV_TYPE, "id = android:id/search_src_text", "call"],
        [NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'Call')]"],
        [NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'More settings')]"],
    ],

    # CLIP
    'path_to_AdditionalSettings': [
        [NAV_SWIPE, 200, 600, 200, 50, 1000],
        [NAV_SWIPE, 200, 600, 200, 50, 1000],
        [NAV_SWIPE, 200, 600, 200, 50, 1000],
        [NAV_SWIPE, 200, 600, 200, 50, 1000],
        [NAV_SWIPE, 200, 600, 200, 50, 1000],
        [NAV_SWIPE, 200, 600, 200, 150, 1000],
        [NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'More')]"],
        [NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'Call')]"],
        [NAV_SWIPE, 200, 600, 200, 50, 300],
        [NAV_SWIPE, 200, 600, 200, 50, 300],
        [NAV_PRESS, "xpath = //android.widget.TextView[starts-with(@text, 'Additional settings')]"],
    ],
    'clip_menu': "xpath = //android.widget.TextView[contains(@text,'Caller ID')]",
    'clip_network': "xpath = //android.widget.CheckedTextView[contains(@text,'Network default')]",
    'clip_hide': "xpath = //android.widget.CheckedTextView[contains(@text,'Hide number')]",
    'clip_show': "xpath = //android.widget.CheckedTextView[contains(@text,'Show number')]",
}

###########################################
# phone app settings
###########################################
phone_app_huawei_G7_L01_en = {
    'app': '',
    'app_version': '',
    'no_reset': True,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.android.contacts',
    'app_activity': '.activities.DialtactsActivity',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': 'android.intent.action.MAIN',
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    'digits_txt_field': 'com.android.contacts:id/digits',
    'call_button': 'com.android.contacts:id/dialButton',
    'endcall_button': 'com.android.incallui:id/endButton',
    'expected_txt': hang_up_call_after,
    'dialling_txt': 'Dialling',
    'connected_txt': 'CONNECTED',
    'popup_ok_button': "xpath = //android.widget.Button[contains(@text,'OK')]",
    'popup_cancel_button': "xpath = //android.widget.Button[contains(@text,'ancel')]",
    'popup_ack_aplmode_err': "xpath = //android.widget.Button[contains(@text,'OK')]",
    'popup_aplmode_txt': 'turn off Aeroplane',
    'popup_nonet_txt': 'NOT IMPLEMENTED YET',
    'callended_txt': 'NOT IMPLEMENTED YET',
    'linebusy_txt': 'NOT IMPLEMENTED YET',
    'incall_name': 'com.android.incallui:id/name',
    'incall_speaker': 'com.android.incallui:id/audioButton',
}


#     #  #######  #######  ###  #######        #     ######   ######
##    #  #     #     #      #   #             # #    #     #  #     #
# #   #  #     #     #      #   #            #   #   #     #  #     #
#  #  #  #     #     #      #   #####       #     #  ######   ######
#   # #  #     #     #      #   #           #######  #        #
#    ##  #     #     #      #   #           #     #  #        #
#     #  #######     #     ###  #           #     #  #        #
###############################################################
# Notification Log app
###############################################################
# Toaster App
notif_app_droid4_4_en = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'org.mars3142.android.toaster',
    'app_activity': '.activity.MainActivity',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    'enable_dlg_ok_xp': "//android.widget.Button[contains(@text,'OK')]",
    'del_id': "org.mars3142.android.toaster:id/action_delete",
    'confirm_del_xp': "//android.widget.Button[contains(@text,'OK')]",
}

# Notificaiton History app
OBSOLETE_notif_app_droid4_4_en = {
    'app': '',
    'app_version': '1.8.1',
    'no_reset': False,
    'dont_stop_app_on_reset': False,
    'app_package': 'com.evanhe.nhfree',
    'app_activity': '.NotificationActivity',
    'app_wait_activity': False,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': False,
    'del_xp': "//android.widget.TextView[contains(@text,'Clear')]",
    'del_all_xp': "//android.widget.TextView[contains(@text,'All')]",
    'confirm_del_xp': "//android.widget.Button[contains(@text,'OK')]",
    'phone_notif_xp': "//android.widget.TextView[contains(@text,'hone')]",
}

######    #####    #####      #######  #######  #######
#     #  #     #  #     #        #     #        #
#     #  #        #              #     #        #
######   #         #####         #     #####    #####
#   #    #              #        #     #        #
#    #   #     #  #     #        #     #        #
#     #   #####    #####         #     #######  #

rcs_tef_app_droid4_4_en = {
    # app startup
    'app': '',
    'app_version': '',
    'no_reset': False,
    'dont_stop_app_on_reset': True,
    'app_package': 'com.telefonica.rcso2',
    'app_activity': 'com.summit.beam.HomeActivityPager',
    'app_wait_activity': None,
    'app_wait_package': False,
    'intent_action': False,
    'intent_category': False,
    'intent_flags': False,
    'optional_intent_arguments': '--activity-clear-top',
    # UI elements
    'init_ready_txt': "ettings",
    'loc_settings': "xpath = //*[contains(@text,'Settings')]",
    'loc_confirm': "xpath = //*[contains(@text,'Continue')]",
    #'loc_enable_checkbox': "xpath = //node[contains(@text,'Call service')]/../..//node[@checkable='true']",
    'loc_enable_checkbox': "xpath = //android.widget.TextView[contains(@text,'Call service')]/../..//*[@checkable='true']",
    'loc_wifi_checkbox': "xpath = //android.widget.TextView[contains(@text,'Outgoing')]/../..//*[@checkable='true']",
    #'loc_enable_checkbox': "xpath = //android.widget.TextView[contains(@text,'Call service')]",
}

###############################################################
# DTMF decoder
###############################################################
dtmf_decoder_app_droid4_4_en = {
    'app': '',
    'app_version': '',
    'no_reset': False,
    'stop_app_on_reset': True,
    'app_package': 'com.encapsystems.dtmfd',
    'app_activity': '.ma',
    'app_wait_activity': False,
    'appWaitPackage': False,
    'intentAction': False,
    'intentCategory': False,
    'intentFlags': False,
    'optionalIntentArguments': False,
    'decoded_dtmf_txt': "id = com.encapsystems.dtmfd:id/recognizeredText",
    'state_button': "id = com.encapsystems.dtmfd:id/stateButton",
    'start_decode_button': "xpath = //android.widget.TextView[contains(@text,'Start')]",
    'stop_decode_button': "xpath = //android.widget.TextView[contains(@text,'Stop')]",
    'clear_txt_button': "xpath = //android.widget.TextView[contains(@text,'Clear')]",
    }

######   #######  #     #  ###   #####   #######      #####   #######  #######  #######  ###  #     #   #####    #####
#     #  #        #     #   #   #     #  #           #     #  #           #        #      #   ##    #  #     #  #     #
#     #  #        #     #   #   #        #           #        #           #        #      #   # #   #  #        #
#     #  #####    #     #   #   #        #####        #####   #####       #        #      #   #  #  #  #  ####   #####
#     #  #         #   #    #   #        #                 #  #           #        #      #   #   # #  #     #        #
#     #  #          # #     #   #     #  #           #     #  #           #        #      #   #    ##  #     #  #     #
######   #######     #     ###   #####   #######      #####   #######     #        #     ###  #     #   #####    #####
###############################################################
# Settings root entries for each device
###############################################################
settings_huawei_Y550_L01_B237 = {
    'platform_name': 'Android',
    'platform_version': '4.4',
    'phone_app': phone_app_huawei_Y550_L01,
    'smscomposer_app': smscomposer_app_huawei_Y550_L01,
    'smsreader_app': smsreader_app_huawei_Y550_L01,
    'settings_app': settings_app_huawei_Y550_L01_B237,
    'notif_app': notif_app_droid4_4_en,
    'browser_app': browser_app_huawei_Y550_L01,
    'rcs_app': rcs_tef_app_droid4_4_en,
    'dtmf_app': dtmf_decoder_app_droid4_4_en,
}
settings_huawei_Y550_L01_B246_BM_SIM  = {
    'platform_name': 'Android',
    'platform_version': '4.4',
    'phone_app': phone_app_huawei_Y550_L01,
    'smscomposer_app': smscomposer_app_huawei_Y550_L01,
    'smsreader_app': smsreader_app_huawei_Y550_L01,
    'settings_app': settings_app_huawei_Y550_L01_BM_SIM,
    'notif_app': notif_app_droid4_4_en,
    'browser_app': browser_app_huawei_Y550_L01,
    'rcs_app': rcs_tef_app_droid4_4_en,
    'dtmf_app': dtmf_decoder_app_droid4_4_en,
}
settings_huawei_Y550_L01_B246 = {
    'platform_name': 'Android',
    'platform_version': '4.4',
    'phone_app': phone_app_huawei_Y550_L01,
    'smscomposer_app': smscomposer_app_huawei_Y550_L01,
    'smsreader_app': smsreader_app_huawei_Y550_L01,
    'settings_app': settings_app_huawei_Y550_L01,
    'notif_app': notif_app_droid4_4_en,
    'browser_app': browser_app_huawei_Y550_L01,
    'rcs_app': rcs_tef_app_droid4_4_en,
    'dtmf_app': dtmf_decoder_app_droid4_4_en,
}

settings_huawei_Y550_L01_sim_fi = {
    'platform_name': 'Android',
    'platform_version': '4.4',
    'phone_app': phone_app_huawei_Y550_L01,
    'smscomposer_app': smscomposer_app_huawei_Y550_L01,
    'smsreader_app': smsreader_app_huawei_Y550_L01,
    'settings_app': settings_app_huawei_Y550_L01_sim_fi,
    'notif_app': notif_app_droid4_4_en,
    'browser_app': browser_app_huawei_Y550_L01,
    'rcs_app': rcs_tef_app_droid4_4_en,
    'dtmf_app': dtmf_decoder_app_droid4_4_en,
}


settings_huawei_Y530_U00 = {
    'platform_name': 'Android',
    'platform_version': '4.3',
    'phone_app': phone_app_huawei_Y530_U00,
    'smscomposer_app': smscomposer_app_huawei_Y530_U00,
    'smsreader_app': smsreader_app_huawei_Y530_U00,
    'settings_app': 'NOT IMPLEMENTED YET',
    'notif_app': 'NOT IMPLEMENTED YET',
    'browser_app': 'NOT IMPLEMENTED YET',
    'rcs_app': rcs_tef_app_droid4_4_en,
    'dtmf_app': dtmf_decoder_app_droid4_4_en,
}
settings_samsung_S5_G900F = {
    'platform_name': 'Android',
    'platform_version': '5.0',
    'phone_app': phone_app_samsung_S5_G900F,
    'smscomposer_app': smscomposer_app_samsung_S5_G900F,
    'smsreader_app': smsreader_app_samsung_S5_G900F,
    'settings_app': settings_app_samsung_S5_G900F,
    'notif_app': notif_app_droid4_4_en,
    'browser_app': browser_app_samsung_S5_G900F,
    'rcs_app': rcs_tef_app_droid4_4_en,
    'dtmf_app': dtmf_decoder_app_droid4_4_en,
}
settings_huawei_G7_L01_en = {
    'platform_name': 'Android',
    'platform_version': '4.4',
    'phone_app': phone_app_huawei_G7_L01_en,
    'smscomposer_app': 'NOT IMPLEMENTED YET',
    'smsreader_app': 'NOT IMPLEMENTED YET',
    'settings_app': settings_app_huawei_G7_L01_en,
    'notif_app': 'NOT IMPLEMENTED YET',
    'browser_app': 'NOT IMPLEMENTED YET',
    'rcs_app': rcs_tef_app_droid4_4_en,
    'dtmf_app': dtmf_decoder_app_droid4_4_en,
}

######   #######  #     #  ###   #####   #######     ######   #######  #######  #######
#     #  #        #     #   #   #     #  #           #     #  #     #  #     #     #
#     #  #        #     #   #   #        #           #     #  #     #  #     #     #
#     #  #####    #     #   #   #        #####       ######   #     #  #     #     #
#     #  #         #   #    #   #        #           #   #    #     #  #     #     #
#     #  #          # #     #   #     #  #           #    #   #     #  #     #     #
######   #######     #     ###   #####   #######     #     #  #######  #######     #

###############################################################
# dictionary containing all device information
###############################################################
DEVICES = {
    'huawei_Y550_L01': settings_huawei_Y550_L01_B246,
    'huawei_Y550_L01_BM_SIM': settings_huawei_Y550_L01_B246_BM_SIM,
    'huawei_Y550_L01_B237': settings_huawei_Y550_L01_B237,
    'huawei_Y550_L01_sim_fi': settings_huawei_Y550_L01_sim_fi,
    'huawei_Y530_U00': settings_huawei_Y530_U00,
    'huawei_G7_L01_en': settings_huawei_G7_L01_en,
    'samsung_S5_G900F': settings_samsung_S5_G900F,
}

