from atf.device.ctrl import DeviceControl
from atf.device.ctrl import AWO_DEF_DELAY, AWO_DEF_RETRY, AWO_DEF_TMOUT, VMS_DEL_MSG
import device_configs
from robot.output import LOGGER


class DeviceCtrlWrapper():
    # class DeviceCtrlWrapper(DeviceControl):

    def __init__(self):
        # comment this block for API doc generation:
        # CUDO_BLOCK_START
        LOGGER.info('ATF initiate: DeviceControl binary library')
        self._w = DeviceControl()
        LOGGER.info('ATF initiate: OK')
        # CUDO_BLOCK_END
        pass

    #############################################################################################

    ######   #######  #     #  ###   #####   #######        #     ######   #     #  ###  #     #
    #     #  #        #     #   #   #     #  #             # #    #     #  ##   ##   #   ##    #
    #     #  #        #     #   #   #        #            #   #   #     #  # # # #   #   # #   #
    #     #  #####    #     #   #   #        #####       #     #  #     #  #  #  #   #   #  #  #
    #     #  #         #   #    #   #        #           #######  #     #  #     #   #   #   # #
    #     #  #          # #     #   #     #  #           #     #  #     #  #     #   #   #    ##
    ######   #######     #     ###   #####   #######     #     #  ######   #     #  ###  #     #

    #############################################################################################
    def device_setup(self):
        """
        Initiate resources for device management

        Prepares framework resources for the device management. Does not trigger any activity on the
        devices.

        To be used in Test Suite or Test Case Setup
        """
        self._w.device_setup()

    def device_cleanup(self):
        """
        Clean up device management resources.

        Releases framework resources and tears down devices (e.g. closes the Appium sessions) if a
        test has failed while an App was open.

        To be used in Test Case teardown
        """
        return self._w.device_cleanup()

    def initiate_device(self, device_alias, app_to_launch, force_restart=None):
        """
        Open an App on the given device.

        Creates an appium session for the requested App. After this the App is ready to accept requests for UI control.

        NOTE: There can be only one App open at the given time. To control several Apps on one device they must be
        controlled sequentially, e.g. open phone_app, make phone call, close phone app, open smsreader_app etc.

        Arguments
        - device_alias:      alias that will be used in the subsequent calls to control the App that is opened
        - app_to_launch:     name of the application that should be launched

        Currently supported App Names are
        - phone_app:          The Android build-in Phone App (i.e. the Dialler screen)
        - smscomposer_app:    The Android build-in Messages App (i.e. the "compose SMS" screen)
        - smsreader_app:      The Android build-in Messages App (i.e. the "Messages Inbox" screen)
        - settings_app:       The Android build-in Settings App (e.g. to change the network access type 3G Auto, 2G Only etc.)
        - browser_app:        The Android build-in Browser App
        - notif_app:          Toaster App to record and read, on screen pop-up (aka toast) notifications
                              (e.g. "call waiting")

        Returns:   Application session index, that should be used to switch between Appium sessions/applications.
        Usually this is ignored and the _device_alias_ is used instead
        """
        return self._w.initiate_device(device_alias, app_to_launch, force_restart)

    def release_device(self, device_alias):
        """
        Releases the resources allocated for the device.

        Set the device status to 0 (no app open) and closes the UI control session (appium)

        - device_alias:     Alias that was given to the device in the `Initiate Device`
        """
        self._w.release_device(device_alias)

    def get_udid_for_device(self, device_alias):
        """
        Get the device UDID

        Fetch the UDID (Unique Device ID) of the device by using the device_alias as search key.
        Intended for internal use, but could be useful for troubleshooting too.
        NOTE: The UDID is taken from the configuration files i.e. it is not fetched from the device.

        Arguments
        - device_alias:    Alias that was given to the device in the `Initiate Device`

        Returns   UDID String
        """
        return self._w.get_udid_for_device(device_alias)

    def get_device_status(self, device_alias):
        """
        Returns Device status

        - device_alias:    Alias that was given to the device in the `Initiate Device`

        returns:  Zero value means no application is open, >0 means that an app is open in the device.
        """
        return self._w.get_device_status(device_alias)

    def get_device_config(self, device_alias, app, all_configs=None):
        """
        Get App configurations for the device from the global variable file (device_configs.py)

        - device_alias   :  Alias that was given to the device in the `Initiate Device`
        - app            :  Name of the App, for the list of supported app names see `Initiate Device`
        - all_configs    :  Name of the device configuration variable struct (in most of the cases
                            the default, ``device_configs.DEVICES`` i.e. device_configs.py, can be used)

        Returns:   The settings/config dictionary for the requested Device+App pair.
        """
        if all_configs is None:
            all_configs=device_configs.DEVICES

        return self._w.get_device_config(device_alias, app, all_configs)

    def reboot_devices(self, device_lst, wait_until_rebooted=False):
        """
        Reboot devices

        Executes ``adb reboot`` for each device.
        NOTE: supported only if the adb runs on the same PC as the test scripts

        - device_lst             :   List of device aliases (i.e. the aliases that were given to the device in the `Initiate Device`)
        - wait_until_rebooted    :   After reboot should we wait thall devices are up (True/False)
        """
        return self._w.reboot_devices(device_lst, wait_until_rebooted)

    def wait_until_devices_are_available(self, device_lst):
        """
        Wait until devices are ready receive request via ADB

        Executes ``adb wait-for-device`` for each device.
        NOTE: supported only if the adb runs on the same PC as the test scripts

        - device_lst   :   List of device aliases (i.e. the aliases that were given to the device in the `Initiate Device`)
        """
        return self._w.wait_until_devices_are_available(device_lst)

    def get_active_app(self, device_alias):
        """
        Get the currently active app

        Returns the currently active app.
        NOTE: The active app is the app that was most recently started
        by the framework, i.e. the app name is not retrieved from the device.

        - device_alias   :  Alias that was given to the device in the `Initiate Device`

        returns: the name of the currently active app i.e. the app name from the `Ininitate Device`
        """
        return self._w.get_active_app(device_alias)



    #############################################################################################

     #####      #     #        #
    #     #    # #    #        #
    #         #   #   #        #
    #        #     #  #        #
    #        #######  #        #
    #     #  #     #  #        #
     #####   #     #  #######  #######

    #############################################################################################
    def verify_caller(self, device_alias, expect_txt, timeout=None):
        """
        Verify the caller when a phone rings

        Verifies that the expected text is displayed on the "ringing"/"incoming call" screen.
        The expected text can be anywhere on the screen (i.e. as number or as named contact).

        Fails if the expected text or the "ringing"/"incoming call" screen is not displayed.

        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - expect_txt     :   the text that should be displayed on the screen
        - timeout        :   how long to wait before we Fail, default value is taken from the global variable ${CALL_TOUT}
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.verify_caller(device_alias, expect_txt, timeout)

    def start_call(self, device_alias, expect_txt=None, timeout=None, speaker=None):
        """
        Initiate a call

        Intented to be used with `Dial`. Calls (i.e. clicks on the "green" button) a number that has been dialled
        and verifies that the expect_txt is displayed.

        If the expect_txt is not set, no verification is done. This way `Dial` and `Start Call` can also be used to dial
        special codes, that do not initiate a call.
        If the expect_txt has a non-empty value then the verification uses that string for the verification.
        The expected text can be anywhere on the screen (i.e. as number or as named contact)

        Fails if the expected text or the "ringing"/"incoming call" screen is not displayed.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - expect_txt     :   The text that should be displayed on the screen
        - timeout        :   How long to wait before we Fail, default value is taken from the global variable ${CALL_TOUT}
        - speaker        :   Switch on the phone loudspeaker when the inCall UI (with the speaker button) is displayed.
                             If True, fails if the speaker button or inCall UI is not displayed
                             Default value is taken from the global variable ``${DEF_SPEAKER}``
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.start_call(device_alias, expect_txt, timeout, speaker)

    def reject_call(self, device_alias, expect_txt=None, timeout=None):
        """
        Reject an incoming call

        If executed without the expect_txt argument the call is rejected (i.e. click on the "red" button)
        without any checks.
        If the expect_txt has a non-empty value then before rejecting it is verfied that the expected
        text is displayed on the "ringing"/"incoming call" screen.
        The expected text can be anywhere on the screen (i.e. as number or as named contact)

        Fails if the expected text or the "ringing"/"incoming call" screen is not displayed.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - expect_txt     :   the text that should be displayed on the screen
        - timeout        :   how long to wait before we Fail, default value is taken from the global variable ``${CALL_TOUT}``
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.reject_call(device_alias, expect_txt, timeout)

    def end_call(self, device_alias, expect_txt=None, timeout=None, verify_call_status=True):
        """
        End a call

        If executed without the expect_txt argument the call is ended (i.e. click on the "red" button)
        without any checks.
        If the expect_txt has a non-empty value then before ending the call it is verified that the expected
        text is displayed on the "ringing"/"incoming call" screen.
        The expected text can be anywhere on the screen (i.e. as number or as named contact)

        Fails if the expected text or the "ringing"/"incoming call" screen is not displayed.

        Arguments
        - device_alias          :   Alias that was given to the device in the `Initiate Device`
        - expect_txt            :   the text that should be displayed on the screen
        - timeout               :   how long to wait before we Fail, default value is taken from the global variable ${CALL_TOUT}
        - verify_call_status    :   verify that the call UI is displayed before ending the call, default is True.
                                    False should be used if the call might have been terminated from the network side, 
                                    e.g. after playing some announcements.
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.end_call(device_alias, expect_txt, timeout, verify_call_status=verify_call_status)

    def answer_call(self, device_alias, expect_txt=None, timeout=None):
        """
        Answer an incoming call

        If executed without the expect_txt argument the call is answered (i.e. click on the "green" button)
        without any checks.
        If the expect_txt has a non-empty value then before answering it is verfied that the expected
        text is displayed on the "ringing"/"incoming call" screen.
        The expected text can be anywhere on the screen (i.e. as number or as named contact)

        Fails if the expected text or the "ringing"/"incoming call" screen is not displayed.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - expect_txt     :   the text that should be displayed on the screen
        - timeout        :   how long to wait before we Fail, default value is taken from the global variable ${CALL_TOUT}
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.answer_call(device_alias, expect_txt, timeout)

    def dial_and_call(self, device_alias, digits, expect_txt=None, timeout=None, speaker=None):
        """
        Dial and call a number

        Dials and calls a number using the Android Dialler and verifies that the expect_txt is displayed.

        If the expect_txt is not set, then the verification waits until "DIALLING" text (i.e. the device specific
        "dialling" text taken from the global devices configs) is displayed.
        
        If the expect_txt is an empty string then no verification is done (i.e. call is initiated without any checks).
        This is needed e.g. if the network is fast and connects the call before the verification sees the "DIALLING" text. 

        If the expect_txt has a non-empty value then the verification uses that string for the verification.
        The expected text can be anywhere on the screen (i.e. as number or as named contact)

        Fails if the expected text is not displayed.

        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - digits         :   a string containing the digits to be dialled
        - expect_txt     :   the text that should be displayed on the screen
        - timeout        :   how long to wait before we Fail, default value is taken from the global variable ${CALL_TOUT}
        - speaker        :   Switch on the phone loudspeaker when the inCall UI (with the speaker button) is displayed.
                             If True, fails if the speaker button or inCall UI is not displayed
                             Default value is taken from the global variable ``${DEF_SPEAKER}``
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.dial_and_call(device_alias, digits, expect_txt, timeout, speaker)

    def dial(self, device_alias, digits):
        """
        Dial a number

        Dials a number.
        NOTE: This method just dials the numbers, it does NOT call the number (i.e. press the "green" button).

        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - digits         :   a string containing the digits to be dialled
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.dial(device_alias, digits)

    def call_should_connect(self, device_alias, digits, timeout=None, speaker=None):
        """
        Call a number and wait until it connects.

        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - digits         :   a string containing the digits to be dialled
        - timeout        :   how long to wait before we Fail, default value is taken from the global variable ${CALL_TOUT}
        - speaker        :   Switch on the phone loudspeaker when the inCall UI (with the speaker button) is displayed.
                             If True, fails if the speaker button or inCall UI is not displayed
                             Default value is taken from the global variable ``${DEF_SPEAKER}``
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        return self._w.call_should_connect(device_alias, digits, timeout, speaker)

    def call_should_not_connect(self, device_alias, digits, timeout=None, speaker=None):
        """
        Call a number and expect it to fail.
        
        The Call might be terminated by the network (e.g. CALL ENDED) or it just stays in DIALLING mode (e.g. an
        announcement is played)
        NOTE: `End Call` might be needed to end the call (i.e. exit the inCall UI). This is the case if the call
        is connected to a network announcement (e.g. "the number you have dialled is not in use").

        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - digits         :   a string containing the digits to be dialled
        - timeout        :   how long to wait before we Fail, default value is taken from the global variable ${CALL_TOUT}
        - speaker        :   Switch on the phone loudspeaker when the inCall UI (with the speaker button) is displayed.
                             If True, fails if the speaker button or inCall UI is not displayed
                             Default value is taken from the global variable ``${DEF_SPEAKER}``
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        return self._w.call_should_not_connect(device_alias, digits, timeout=timeout, speaker=speaker)

    def call_should_connect_and_disconnect(self, device_alias, digits, timeout=None, speaker=None):
        """
        Call a number and disconnect after the expected text is displayed.

        Helper Method that executes `Dial and Call` and ends the call when it connects.

        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - digits         :   a string containing the digits to be dialled
        - timeout        :   how long to wait before we Fail, default value is taken from the global variable ${CALL_TOUT}
        - speaker        :   Switch on the phone loudspeaker when the inCall UI (with the speaker button) is displayed.
                             If True, fails if the speaker button or inCall UI is not displayed
                             Default value is taken from the global variable ``${DEF_SPEAKER}``
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.call_should_connect_and_disconnect(device_alias, digits, timeout, speaker)

    def call_should_be_connected(self, device_alias, timeout=None, speaker=None):
        """
        Verify that a call is connected

        Fails if the call is not not connected.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - timeout        :   how long to wait before we Fail, default value is
                             taken from the global variable ``${CALL_TOUT}``
        - speaker        :   Switch on the phone loudspeaker when the inCall UI (with the speaker button) is displayed.
                             If True, fails if the speaker button or inCall UI is not displayed
                             Default value is taken from the global variable ``${DEF_SPEAKER}``
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.call_should_be_connected(device_alias, timeout=timeout, speaker=speaker)

    def call_should_fail(self, device_alias, digits, fail_reason='ABORT', timeout=None):
        """
        Call a number and expect it to fail with an error dialog

        Dials and calls a number using the Android Dialler and verifies that the expected error message is displayed.

        The expected text can be anywhere on the screen (e.g. in an error pop-up)

        Fails if the expected text is not displayed.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - digits         :   a string containing the digits to be dialled
        - fail_reason    :   the reason for the failure, currently supported reasons are ``NETWORK``
                             (e.g. not registered, no coverage), ``BUSY`` (network side disconnect because the B-Party
                             is busy) and ``ABORT`` (network side disconnect e.g. because the number is invalid).
        - timeout        :   how long to wait before we Fail, default value is
                             taken from the global variable ``${CALL_TOUT}``
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        return self._w.call_should_fail(device_alias, digits, fail_reason=fail_reason, timeout=timeout)

    def toggle_speaker(self, device_alias):
        """
        Switch on/off Loudspeaker on the device

        Waits until the call is active (i.e. inCall UI is displayed) and then click on the "Speaker" button.
        Fails if inCall UI or Speaker button is not displayed.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.toggle_speaker(device_alias)

    def end_call_with_adb(self, device_alias):
        """
        End call using ADB shell commands, i.e. without UI control

        NOTE: supported only if the adb runs on the same PC as the test scripts

        Fails if ADB returns with a non-zero exit code.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        """
        self._w.end_call_with_adb(device_alias)

    def dial_and_call_with_adb(self, device_alias, digits):
        """
        Make a phone call using ADB shell commands, i.e. without UI control

        Fails if ADB returns with a non-zero exit code.
        NOTE: supported only if the adb runs on the same PC as the test scripts

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - digits         :   a string containing the digits to be dialled
        """
        return self._w.dial_and_call_with_adb(device_alias, digits)

    ############################################################################################

    #     #   #####    #####   ######
    #     #  #     #  #     #  #     #
    #     #  #        #        #     #
    #     #   #####    #####   #     #
    #     #        #        #  #     #
    #     #  #     #  #     #  #     #
     #####    #####    #####   ######

    ############################################################################################
    def dial_and_call_ussd(self, device_alias, digits, expect_txt, timeout=None, acknowledge=True, ack_button="OK"):
        """
        Dial and call an USSD string

        Sends a USSD request using the phone dialler and verifies that the ``expect_txt`` is displayed.

        Fails if the expected text is not displayed.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - digits         :   a string containing the digits to be dialled
        - expect_txt     :   the text that should be displayed in the USSD response dialog.
        - timeout        :   how long to wait before we Fail, default value is taken from the global
                             variable ``${USSD_TOUT}``
        - acknowledge    :   Acknowledge the USSD response dialog by clicking a button.
                             False when dealing with USSD based menus.
        - click_button   :   The text/part of the text that should be on the button that shall be
                             clicked to acknowledge the USSD dialog, default is 'OK'
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.dial_and_call_ussd(device_alias, digits, expect_txt, timeout, acknowledge, ack_button)

    def enter_ussd_menu_choice(self, device_alias, digit, expect_txt, send_button="Send", ack_button="OK", timeout=None,
                               acknowledge=True):
        """
        Enters a menu choice in a USSD menu dialog

        Sends a USSD request using the using the USSD Menu that has been invoked by `Dial and Call Ussd`.
        Verifies that the expect_txt is displayed.

        Fails if the expected text is not displayed.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - digits         :   a string containing the digit of the menu choice,
                             currently only single digits are supported
        - expect_txt     :   the text that should be displayed in the USSD response dialog.
        - send_button    :   The text/part of the text that should be on the button that shall be clicked
                             to send the Menu Choise, default is 'Send'
        - timeout        :   how long to wait before we Fail, default value is taken from the global
                             variable ``${USSD_TOUT}``
        - acknowledge    :   Acknowledge the USSD response dialog by clicking a button.
                             False when dealing with USSD based menus.
        - ack_button     :   The text/part of the text that should be on the button that shall be
                             clicked to acknowledge the USSD dialog, default is 'OK'
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.enter_ussd_menu_choice(device_alias, digit, expect_txt, send_button, ack_button, timeout, acknowledge)


    ############################################################################################

    ######   #######  #     #  #######
    #     #     #     ##   ##  #
    #     #     #     # # # #  #
    #     #     #     #  #  #  #####
    #     #     #     #     #  #
    #     #     #     #     #  #
    ######      #     #     #  #

    ############################################################################################
    def start_dtmf_decoder(self, device_alias):
        """
        Start decoding DTMF tones on the device

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        
        Pre-requisite: "phone_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.start_dtmf_decoder(device_alias)

    def verify_dtmf(self, device_alias, expect_txt, timeout=None):
        """
        Verify DTMF tones

        Verifies the that the digits sent with `send dtmf` are received on the device

        Arguments
        - device_alias  :   Alias that was given to the device in the `Initiate Device`
        - expect_txt    :   The DTMF digits that were sent with `send dtmf`
        - timeout       :   how long to wait before we Fail, default value is taken from the global
                            variable ``${DTMF_TOUT}``
        """
        self._w.verify_dtmf(device_alias, expect_txt, timeout=timeout)

    def stop_dtmf_decoder(self, device_alias):
        """
        Stop decoding DTMF tones on the device

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        """
        self._w.stop_dtmf_decoder(device_alias)


    def send_dtmf(self, device_alias, digits, send_wait=None, timeout=None, speaker=None):
        """
        Send DTMF signals

        Generates DTMF tones by pressing the dialpad keys.

        Fails if the call is not connected when trying to send DTMF.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - digits         :   A string containing the digits to be dialled
        - send_wait      :   How long to wait between DTMF tones. Some IVR's don't work without relatively long
                             (>1 second) pauses between tones.
                             Default value is taken from the global variable ``${DTMF_SLEEP}``
        - timeout        :   How long to wait before we Fail, default value is taken from the global variable ${CALL_TOUT}
        - speaker        :   Switch on the phone loudspeaker when the inCall UI (with the speaker button) is displayed.
                             If True, fails if the speaker button or inCall UI is not displayed
                             Default value is taken from the global variable ``${DEF_SPEAKER}``
        """
        return self._w.send_dtmf(device_alias, digits, send_wait=send_wait, timeout=timeout, speaker=speaker)

    ############################################################################################

     #####   #     #   #####
    #     #  ##   ##  #     #
    #        # # # #  #
     #####   #  #  #   #####
          #  #     #        #
    #     #  #     #  #     #
     #####   #     #   #####

    ############################################################################################
    def enable_SMS_delivery_receipts(self, device_alias):
        """
        Enable SMS delivery reports

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        
        Pre-requisite: "smsreader_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.enable_sms_delivery_receipts(device_alias)

    def disable_SMS_delivery_receipts(self, device_alias):
        """
        Disable SMS delivery reports

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        
        Pre-requisite: "smsreader_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.disable_sms_delivery_receipts(device_alias)

    def delete_sms_conversations(self, device_alias):
        """
        Deletes all SMS messages in the Messages inbox

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        
        Pre-requisite: "smsreader_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.delete_sms_conversations(device_alias)

    def compose_sms_and_send(self, device_alias, digits, sms_txt):
        """
        Sends an SMS

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - digits         :   a string containing the digits to be dialled
        - sms_txt        :   the text for the SMS
        
        Pre-requisite: "smscomposer_app" needs to be initiated with `Initiate Device` before using this method.
        """
        self._w.compose_sms_and_send(device_alias, digits, sms_txt)

    def verify_sms_delivery_status(self, device_alias, sms_txt, delivery_receipt=False, delivery_failure=False, timeout=None):
        """
        Verify SMS delivery status.

        Verifies that the SMS containing text ``sms_txt`` has the expected delivery status.
        This should be executed after the `Compose SMS and Send` method.
        Fails if the ``sms_txt`` or the expected delivery status is not displayed.

        Delivery Status:
        - ``delivery_receipt=False`` and ``delivery_failure=False`` (DEFAULT) expects that the SMS is marked as 'Sent'
        - ``delivery_receipt=True`` and ``delivery_failure=False`` expects that the SMS is marked as 'Delivered'. See
          also `Enable SMS Delivery Receipts`.
        - ``failed_delivery=True`` expects that the SMS is not marked as 'Sent' or 'Delivered'

        Arguments
        - device_alias      :   Alias that was given to the device in the `Initiate Device`
        - sms_txt           :   the text that the sms should contain.
        - delivery_receipt  :   Expect delivery receipt, see 'Delivery Status' above for more details
        - delivery_failure  :   Expect delivery failure, see 'Delivery Status' above for more details
        - timeout           :   how long to wait before we Fail, default value is taken
                                from the global variable ``${SMS_TOUT}``
        """
        return self._w.verify_sms_delivery_status(device_alias, sms_txt, delivery_receipt=delivery_receipt, delivery_failure=delivery_failure, timeout=timeout)

    def verify_sms(self, device_alias, expect_txt, timeout=None):
        """
        Verify SMS content.

        Verifies that the 'expect_txt' text is displayed.
        The SMS can reside in the inbox or in an opened conversation.
        Can be also used to wait for an SMS arrival.

        Fails if the expected text is not displayed before the timeout expires.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - expect_txt     :   the text that should be displayed.
        - timeout        :   how long to wait before we Fail, default value is taken
                             from the global variable ``${SMS_TOUT}``
        
        Pre-requisite: "smsreader_app" needs to be initiated with `Initiate Device` before using this method.
        """
        return self._w.verify_sms(device_alias, expect_txt, timeout)

    def sms_should_not_be_received(self, device_alias, expect_txt, timeout=None):
        """
        Wait for an SMS arrival and expect to fail.

        Helper function to test the arrival of an SMS, for details please see `Verify SMS`
        """
        return self._w.sms_should_not_be_received(device_alias, expect_txt, timeout)

    def sms_should_be_received(self, device_alias, expect_txt, timeout=None):
        """
        Wait for an SMS arrival.

        Helper function to test the arrival of an SMS, for details please see `Verify SMS`
        """
        self._w.sms_should_be_received(device_alias, expect_txt, timeout)

    def open_sms_from(self, device_alias, sender_contains_txt):
        """
        Open SMS from a specific sender

        Opens an SMS conversation thread from a certain sender from the messages inbox
        Fails if there are no messages from that sender.

        Arguments
        - device_alias           :   Alias that was given to the device in the `Initiate Device`
        - sender_contains_txt    :   the text that should be displayed in the USSD response dialog.
        
        Pre-requisite: "smsreader_app" needs to be initiated with `Initiate Device` before using this method.
        """
        return self._w.open_sms_from(device_alias, sender_contains_txt)


    ############################################################################################

    #     #  #######  #######  ###  #######  ###   #####      #     #######  ###  #######  #     #   #####
    ##    #  #     #     #      #   #         #   #     #    # #       #      #   #     #  ##    #  #     #
    # #   #  #     #     #      #   #         #   #         #   #      #      #   #     #  # #   #  #
    #  #  #  #     #     #      #   #####     #   #        #     #     #      #   #     #  #  #  #   #####
    #   # #  #     #     #      #   #         #   #        #######     #      #   #     #  #   # #        #
    #    ##  #     #     #      #   #         #   #     #  #     #     #      #   #     #  #    ##  #     #
    #     #  #######     #     ###  #        ###   #####   #     #     #     ###  #######  #     #   #####

    ############################################################################################
    def start_notification_log(self, device_alias):
        """
        Starts logging notifications (aka toast messages/pop-ups) on the device

        Notifcation log can be used record and verify the notifications displayed during a call (e.g. "call waiting")

        NOTE:
        due to Android bug, the notification logs are destroyed if the calls are made with usual UI control.
        The calls that need notification verification must be made with ADB i.e. `Dial and Call with ADB` &
        `End Call with ADB` methods.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        """
        self._w.start_notification_log(device_alias)

    def verify_notification(self, device_alias, contains_txt):
        """
        Verify notifications (aka toas messages/pop-ups) on the device

        Verify that a certain notification has been recorded in the Notification log.
        The Notification log must be started before the test calls with 'Start Notification Log'

        NOTE:
        due to Android bug, the notification logs are destroyed if the calls are made with usual UI control.
        The calls that need notification verification must be made with ADB i.e. `Dial and Call with ADB` &
        `End Call with ADB` methods.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - contains_txt   :   the text that should be part of the notification log
        """
        self._w.verify_notification(device_alias, contains_txt)


    ############################################################################################

    #     #  #######  #        ######   #######  ######    #####
    #     #  #        #        #     #  #        #     #  #     #
    #     #  #        #        #     #  #        #     #  #
    #######  #####    #        ######   #####    ######    #####
    #     #  #        #        #        #        #   #          #
    #     #  #        #        #        #        #    #   #     #
    #     #  #######  #######  #        #######  #     #   #####

    ############################################################################################
    def wait_until_detached_in_network(self, device_alias, airplane_mode=False, timeout=None):
        """
        Wait until the device is detached

        Waits until the device has no service (CS/PS/EPS).

        Arguments
        - device_alias   :  Alias that was given to the device in the `Initiate Device`
        - airplane_mode  :  Consider enabled Airplane Mode also as detached.
                            Fails if False and Airplane Mode is enabled.
        - timeout        :  How long to wait for the attach. Default is taken from the variable ${UL_TOUT}, 60s if not set.
        """
        return self._w.wait_until_detached_in_network(device_alias, airplane_mode=airplane_mode, timeout=timeout)

    def wait_until_attached_in_network(self, device_alias, type=None, data=None, timeout=None):
        """
        Wait until the device is attached

        Waits until device is attached in the network.
        If executed without `type` and `data` arguments the "service status" (e.g. "In Service") is used for the
        verification. If one or both of the arguments are present then the verification is done based on them.

        Arguments
        - device_alias   :  Alias that was given to the device in the `Initiate Device`
        - type           :  Network type where the attach should have happened (i.e. '4G'/'3G'/'2G'/'4G_only'/'3G_only'/'2G_only')
        - data           :  Mobile data connection active (True/False)
        - timeout        :  How long to wait for the attach. Default is taken from the variable ${UL_TOUT}, 60s if not set.
        """
        return self._w.wait_until_attached_in_network(device_alias, type=type, data=data, timeout=timeout)

    def trigger_update_location(self, device_alias, verify=True, adb=False):
        """
        Trigger a Location Update

        Triggers a LU by enabling and disabling the airplane mode on the device

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - verify         :   Verify coverage after airplane mode is switched off
                             (i.e. calls the number stored in the ``${NBR_COVERAGE}`` variable)
        - adb            :   use ADB shell commands (instead of the UI) for changing the airplane mode
                             NOTE: supported only if the adb runs on the same PC as the test scripts
        """
        self._w.trigger_update_location(device_alias, verify, adb)

    def enable_airplane_mode(self, device_alias, verify=True, adb=False):
        """
        Enable airplane mode

        Enables airplane mode on the device

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - verify         :   Verify coverage after airplane mode is switched on
                             (i.e. calls the number stored in the ``${NBR_COVERAGE}`` variable and
                             expect 'no network' error)
        - adb            :   use ADB shell commands (instead of the UI) for changing the airplane mode
                             NOTE: supported only if the adb runs on the same PC as the test scripts
        """
        self._w.enable_airplane_mode(device_alias, verify, adb)

    def disable_airplane_mode(self, device_alias, verify=True, adb=False):
        """
        Disable airplane mode

        Disables airplane mode on the device

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - verify         :   Verify coverage after airplane mode is switched off
                             (i.e. calls the number stored in the ``${NBR_COVERAGE}`` variable)
        - adb            :   use ADB shell commands (instead of the UI) for changing the airplane mode
                             NOTE: supported only if the adb runs on the same PC as the test scripts
        """
        self._w.disable_airplane_mode(device_alias, verify, adb)

    def take_screenshot(self, device_alias):
        """
        Takes a screenshot of the device

        Intended for debugging purposes e.g. to show what is on the device screen before a step is started.
        The screenshot will be saved in the execution directory as "screenshot_<test case name>_<timestamp>_<sequence number>".png

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        """
        self._w.take_screenshot(device_alias)

    def acknowledge_dialog(self, device_alias, ack_button=None):
        """
        Acknowledge (i.e. close) an open dialog on the device

        Can be used to close e.g. USSD and Error dialogs.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - ack_button     :   locator to the button that should be clicked for acknowledging. Default: "xpath = //android.widget.Button[contains(@text,'OK')]"
        """
        self._w.acknowledge_dialog(device_alias, ack_button=ack_button)

    def get_displayed_text(self, device_alias, locator='xpath = //android.widget.TextView', attr='text'):
        """
        Get the text currently displayed in the device.

        Intended for 'phone_app' USSD and Error dialogs, but can be used for any other textual information by
        overriding the default parameters.
        Returns a plain text string, line feeds are preserved.

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - locator        :   locator to the element that we want to get, usually the first available 'TextView' element
        - attr           :   attribute of the element that contains the text, usually 'text'
        """
        return self._w.get_displayed_text(device_alias, locator=locator, attr=attr)

    ############################################################################################

     #####   #######  #######  #######  ###  #     #   #####    #####
    #     #  #           #        #      #   ##    #  #     #  #     #
    #        #           #        #      #   # #   #  #        #
     #####   #####       #        #      #   #  #  #  #  ####   #####
          #  #           #        #      #   #   # #  #     #        #
    #     #  #           #        #      #   #    ##  #     #  #     #
     #####   #######     #        #     ###  #     #   #####    #####

    ############################################################################################
    def change_calling_line_presentation(self, dev_alias, new_type):
        """
        Change the CLIP setting on the device

        Changes the CLIP setting on the device (under "Settings"/"Call"/"Additional settings"/"Caller ID")
        Opens the Settings App before changing the settings, fails if the device has an open application session (e.g. phone_app).

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - type           :   The desired network access type. Supported types are 'network' 'hide' 'show'
        """
        self._w.change_calling_line_presentation(dev_alias, new_type)

    def change_mobile_network_type(self, dev_alias, new_type):
        """
        Change Mobile Network access type

        Changes the access method of the device.
        Opens the Settings App before changing the settings, fails if the device has an open application session (e.g. phone_app).

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - type           :   The desired network access type. Currently supported types are '4G Auto' '3G Auto' '3G Only' '2G Only'
        """
        self._w.change_mobile_network_type(dev_alias, new_type)

    def change_APN(self, dev_alias, new_apn):
        """
        Change the active Access Point Name

        Changes the APN by selecting the new APN on the device.
        Opens the Settings App before changing the settings, fails if the device has an open application session (e.g. phone_app).

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        - new_apn        :   The name of the APN to be selected. Must be 1-to-1 match (i.e. pattern and partial matches are not supported) 
        """
        self._w.change_APN(dev_alias, new_apn)
        
    def device_status_should_match(self, dev_alias, operator=None, signal=None, radio=None, service=None, roam=None, data=None):
        """
        Check device status

        Verifies device status (Settings --> About Phone --> Status) against given arguments.
        Uses pattern match.
        Matches only arguments that have non-None value. If called without non-None arguments then only status is
        returned (i.e. no matching is done)
        Returns 2-level dictionary: 1st level has the device alias as keys to the 2nd level dictionary. 2-level
        dictionary has the arguments ("radio", "signal" etc.) as keys and the values as text (e.g. "HSPA").
        Fails on first failing match.
        Opens the Settings App before changing the settings, fails if the device has an open application session (e.g. phone_app).

        Arguments
        - device_alias  :   Alias that was given to the device in the `Initiate Device`. Lists are supported.
        - operator      :   operator (network name) match pattern
        - signal        :   signal strength match pattern
        - radio         :   radio access type (e.g. "LTE", "UMTS", "HSPA") match pattern
        - service       :   service status (e.g. "in service", "radio off") match pattern
        - roam          :   roaming match pattern
        - data          :   mobile data (e.g. "disconnected", "connected")  match pattern
        """
        return self._w.status_should_match(dev_alias, operator, signal, radio, service, roam, data)

    def device_status_should_not_match(self, dev_alias, operator=None, signal=None, radio=None, service=None, roam=None, data=None):
        """
        Check device status

        Like `Device Status Should Match` but using negative matches i.e. fails if one of the patterns match.
        """
        return self._w.status_should_not_match(dev_alias, operator, signal, radio, service, roam, data)

    def device_status_should_match_regex(self, dev_alias, operator=None, signal=None, radio=None, service=None, roam=None, data=None):
        """
        Check device status

        Like `Device Status Should Match` but matching is done with regular expressions

        Arguments
        - device_alias  :   Alias that was given to the device in the `Initiate Device`. Lists are supported.
        - operator      :   operator (network name) regular expression
        - signal        :   signal strength regular expression
        - radio         :   radio access type (e.g. "LTE", "UMTS", "HSPA") regular expression
        - service       :   service status (e.g. "in service", "radio off") regular expression
        - roam          :   roaming regular expression
        - data          :   mobile data (mobile network state) regular expression
        """
        return self._w.status_should_match_regex(dev_alias, operator, signal, radio, service, roam, data)

    def device_status_should_not_match_regex(self, dev_alias, operator=None, signal=None, radio=None, service=None, roam=None, data=None):
        """
        Check device status

        Like `Device Status Should Match Regex` but using negative matches i.e. fails if one of the regular expressions match.
        """
        return self._w.status_should_not_match_regex(dev_alias, operator, signal, radio, service, roam, data)


    ##############################################################################################
    #
    #        #####   ######   #######  #######  ######      #######  #######   #####   #######
    #       #     #  #     #  #        #        #     #        #     #        #     #     #
    #       #        #     #  #        #        #     #        #     #        #           #
    #        #####   ######   #####    #####    #     #        #     #####     #####      #
    #             #  #        #        #        #     #        #     #              #     #
    #       #     #  #        #        #        #     #        #     #        #     #     #
    #        #####   #        #######  #######  ######         #     #######   #####      #
    #    
    ##############################################################################################
    def start_speed_tests(self, dev_alias, timeout=None):
        """
        Starts the speed tests

        Fails if the Speed Test Start page is not displayed (e.g. tests are running already).
        Fails if the Speed Tests don't start within the timeout (e.g. no network coverage).

        Arguments
        - device_alias           :   Alias that was given to the device in the `Initiate Device`
        - timeout                :   How long to wait for the tests to start. Default is taken from
                                     ``SPEEDTEST_START_TOUT`` variable, "5s" if not set.
        
        Pre-requisite: "speedtest_app" needs to be initiated with `Initiate Device` before using this method.
        """        
        self._w.start_speed_tests(dev_alias, timeout=timeout)
    
    def get_speed_test_results(self, dev_alias, timeout=None):
        """
        Get the results from the speed tests

        Should be used after `Start Speed Tests` to wait for the tests to finish.
        Fails if the Speed Test Result page is not displayed within timeout.

        Arguments
        - device_alias          :   Alias that was given to the device in the `Initiate Device`
        - timeout               :   How long to wait for the speed tests to finish. Default is taken from
                                    ``SPEEDTEST_TOUT`` variable, "45s" if not set.
        
        Returns a List with the results [ping (ms), download (kbps), upload (kbps), additional_info ]
        
        Example: The below would print the results on the console
        | ${p}  ${d}  ${u}  ${i} =    Get Speed Test Results      MsPost2
        | Log To Console              Ping: ${p}ms dload: ${d}kbps uload: ${u}kbps info: ${i}
        """        
        return self._w.get_speed_test_results(dev_alias, timeout=timeout)
    
    def ping_speed_should_be(self, dev_alias, threshold_min, threshold_max, timeout=None):
        """
        Verify Ping response time.
        
        Helper function on top of `Get Speed Test Results`.
        
        Arguments
        - device_alias          :   Alias that was given to the device in the `Initiate Device`
        - threshold_min         :   Minimum acceptable Ping response time in milliseconds
        - threshold_max         :   Maximum acceptable Ping response time in milliseconds
        - timeout               :   How long to wait for the speed tests to finish. Default is taken from
                                    ``SPEEDTEST_TOUT`` variable, "45s" if not set.
        """        
        self._w.ping_speed_should_be(dev_alias, threshold_min, threshold_max, timeout=timeout)
            
    def download_speed_should_be(self, dev_alias, threshold_min, threshold_max, timeout=None):
        """
        Verify download speed.
        
        Helper function on top of `Get Speed Test Results`.
        
        Arguments
        - device_alias          :   Alias that was given to the device in the `Initiate Device`
        - threshold_min         :   Minimum acceptable download speed in kbps
        - threshold_max         :   Maximum acceptable download speed in kbps
        - timeout               :   How long to wait for the speed tests to finish. Default is taken from
                                    ``SPEEDTEST_TOUT`` variable, "45s" if not set.
        """        
        self._w.download_speed_should_be(dev_alias, threshold_min, threshold_max, timeout=timeout)
            
    def upload_speed_should_be(self, dev_alias, threshold_min, threshold_max, timeout=None):
        """
        Verify upload speed.
        
        Helper function on top of `Get Speed Test Results`.
        
        Arguments
        - device_alias          :   Alias that was given to the device in the `Initiate Device`
        - threshold_min         :   Minimum acceptable upload speed in kbps
        - threshold_max         :   Maximum acceptable upload speed in kbps
        - timeout               :   How long to wait for the speed tests to finish. Default is taken from
                                    ``SPEEDTEST_TOUT`` variable, "45s" if not set.
        """        
        self._w.upload_speed_should_be(dev_alias, threshold_min, threshold_max, timeout=timeout)
            
    ############################################################################################

    #######  #     #        #######  ######   ######   #######  ######
    #     #  ##    #        #        #     #  #     #  #     #  #     #
    #     #  # #   #        #        #     #  #     #  #     #  #     #
    #     #  #  #  #        #####    ######   ######   #     #  ######
    #     #  #   # #        #        #   #    #   #    #     #  #   #
    #     #  #    ##        #        #    #   #    #   #     #  #    #
    #######  #     #        #######  #     #  #     #  #######  #     #

    ############################################################################################
    def run_on_device_error(self):
        """
        Takes a screenshot on device errors

        Runs automatically on device errors (e.g. when expected text is not displayed) and takes a screenshot.
        The screenshot will be saved in the execuction directory as
        ``screenshot_<test case name>_<timestamp>_<sequence number>.png``

        Arguments
        - device_alias   :   Alias that was given to the device in the `Initiate Device`
        """
        self._w.run_on_device_error()


    ############################################################################################

    #     #  #######  ######   #    #     #     ######   #######  #     #  #     #  ######    #####
    #  #  #  #     #  #     #  #   #     # #    #     #  #     #  #     #  ##    #  #     #  #     #
    #  #  #  #     #  #     #  #  #     #   #   #     #  #     #  #     #  # #   #  #     #  #
    #  #  #  #     #  ######   ###     #     #  ######   #     #  #     #  #  #  #  #     #   #####
    #  #  #  #     #  #   #    #  #    #######  #   #    #     #  #     #  #   # #  #     #        #
    #  #  #  #     #  #    #   #   #   #     #  #    #   #     #  #     #  #    ##  #     #  #     #
     ## ##   #######  #     #  #    #  #     #  #     #  #######   #####   #     #  ######    #####

    ############################################################################################
    def text_should_be_displayed(self, text, retries=AWO_DEF_RETRY, delay=AWO_DEF_DELAY, srcloglevel=None,
                                 fail_on_error=True):
        """
        Waits for a text to be displayed on the device

        Verifies that the expected text is on the device screen/page.

        Use this method if the text should be displayed "immediately" (a few seconds)
        e.g. after pressing call button to verify the text "Dialling".

        Use `Wait Until Text Is Displayed` method if the text should be displayed after a short delay
        (several seconds) e.g. when waiting for an SMS to arrive.

        The search is done in the screen/page source-code, i.e. the expected text could also be in an UI XML/HTML
        tag name/attribute etc.

        Mainly for internal use, but could also be used directly.

        NOTE:
        This method should be used instead of the AppiumLibrary's "Page Should Contain Text", because
        sometimes Android fails deliver the page source (and the verification would fail)

        Arguments
        - text           :     The text that should be on the page
        - retries        :     How my retries shall we do. E.g. wait that the screen is updated
        - delay          :     How long to wait between retries
        - srcloglevel    :     Log the page source using this log-level, NONE for no logging.
        - fail_on_error  :     Should we fail the test on error.
                               If False, then the status of the verification is returned as a return value.

        Returns   0 - if the text was found on the page, 1 - if the text was not found.
                  Valid only if called with fail_on_error=False
        """
        return self._w.text_should_be_displayed(text, retries, delay, srcloglevel, fail_on_error)

    def element_should_be_displayed(self, locator, retries=AWO_DEF_RETRY, delay=AWO_DEF_DELAY, srcloglevel=None,
                                    fail_on_error=True):
        """
        Waits for an element to be displayed on the device

        Verifies that the expected UI element is displayed on the device screen/page.
        The element must be visible e.g. if the element is scrolled of the screen the search will fail.

        Use this method if the text should be displayed "immediately" (a few seconds)
        e.g. after pressing call button to verify the text "Dialling".

        Use `Wait Until Element Is Displayed` method if the text should be displayed after a short delay
        (several seconds) e.g. when waiting for an SMS to arrive.

        Mainly for internal use, but could also be used directly.

        NOTE:
        This method should be used instead of the AppiumLibrary's "Page Should Contain Element", because
        sometimes Android fails deliver the page source (and the verfication would fail)

        Arguments
        - locator        :     The Locator for finding the input field.
                               For more details about locators, please see AppiumLibrary documentation.
        - timeout        :     How long to wait for the text before we fail
        - delay          :     How long to wait between retries
        - srcloglevel    :     Log the page source using this log-level, NONE for no logging.
        - fail_on_error  :     Should we fail the test on error.
                               If False, then the status of the verification is returned as a return value.

        Returns   0 - if the text was found on the page, 1 - if the text was not found. 
                  Valid only if called with fail_on_error=False
        """
        return self._w.element_should_be_displayed(locator, retries, delay, srcloglevel, fail_on_error)

    def wait_until_text_is_displayed(self, text, timeout=AWO_DEF_TMOUT, delay=AWO_DEF_DELAY, srcloglevel=None,
                                     or_text="", fail_on_error=True):
        """
        Waits for a text to be displayed on the device

        Verifies that the expected text is on the device screen/page.

        Use this method if the text should be displayed after a short delay (several seconds)
        e.g. when waiting for an SMS to arrive.
        Use `Text Should be Displayed` method if the text should be displayed "immediately"
        (a few seconds) e.g. after pressing call button to verify the text "Dialling".

        The search is done in the screen/page source-code, i.e. the expected text could also be in an UI XML/HTML
        tag name/attribute etc.

        Mainly for internal use, but could also be used directly.

        NOTE:
        This method should be used instead of the AppiumLibrary's "Page Should Contain Text", because
        sometimes Android fails deliver the page source (and the verification would fail)

        Arguments
        - text           :     The text that should be on the page
        - timeout        :     How long to wait for the text before we fail
        - delay          :     How long to wait between retries
        - srcloglevel    :     Log the page source using this log-level, NONE for no logging.
        - or_text        :     Extra parameter for Android bug workaround (Sometimes the delivered page source does
                               not contain the call duration, it keeps showing the "CONNECTED" text).
                               Used for internally i.e. called with "text=00:" & "or_text=CONNECTED" to check
                               that a call is connected.
        - fail_on_error  :     Should we fail the test on error. If False, then the status of the verification is
                               returned as a return value.

        Returns   0 - if the text was found on the page, 1 - if the text was not found.
                  Valid only if called with fail_on_error=False
        """
        return self._w.wait_until_text_is_displayed(text, timeout, delay, srcloglevel, or_text, fail_on_error)

    def wait_until_element_is_displayed(self, locator, timeout=AWO_DEF_TMOUT, delay=AWO_DEF_DELAY, srcloglevel=None,
                                        fail_on_error=True):
        """
        Waits for an element to be displayed on the device

        Verifies that the expected UI element is displayed on the device screen/page.
        The element must be visible e.g. if the element is scrolled of the screen the search will fail.

        Use this method if the text should be displayed after a short delay (several seconds)
        e.g. when waiting for an SMS to arrive.
        Use `Element Should be Displayed` method if the text should be displayed "immediately"
        (a few seconds) e.g. after pressing call button to verify the text "Dialling".

        Mainly for internal use, but could also be used directly.

        NOTE:
        This method should be used instead of the AppiumLibrary's "Page Should Contain Element", because
        sometimes Android fails deliver the page source (and the verfication would fail)

        Arguments
        - locator        :     The Locator for finding the input field.
                               For more details about locators, please see AppiumLibrary documentation.
        - timeout        :     How long to wait for the text before we fail
        - delay          :     How long to wait between retries
        - srcloglevel    :     Log the page source using this log-level, NONE for no logging.
        - fail_on_error  :     Should we fail the test on error.
                               If False, then the status of the verification is returned as a return value.

        Returns   0 - if the text was found on the page, 1 - if the text was not found. 
                  Valid only if called with fail_on_error=False
        """
        return self._w.wait_until_element_is_displayed(locator, timeout, delay, srcloglevel, fail_on_error)

    def input_text_with_retry(self, locator, text, retries=AWO_DEF_RETRY, delay=AWO_DEF_DELAY, fail_on_error=True):
        """
        Input text with retries

        Tries to input text into a text field, retries if the first attempts fail.

        Mainly for internal use, but could also be used directly.

        NOTE:
        This method should be used instead of the AppiumLibrary's "Input Text", because
        sometimes Android fails deliver the page source (and the locator fails to find the text field)

        Arguments
        - locator        :     The Locator for finding the input field.
                               For more details about locators, please see AppiumLibrary documentation.
        - text           :     The text to input
        - retries        :     How many retries shall we do
        - delay          :     How long to wait between retries
        - fail_on_error  :     Should we fail the test on error.
                               If False, then the status of the verification is returned as a return value.

        Returns   0 - if the text input was successful, otherwise return 1. Valid only if called with fail_on_error=False
        """
        return self._w.input_text_with_retry(locator, text, retries, delay, fail_on_error)

    def click_element_with_retry(self, locator, retries=AWO_DEF_RETRY, delay=AWO_DEF_DELAY, fail_on_error=True):
        """
        Click Element with retries

        Tries to click on an element, retries if the first attempts fail.

        Mainly for internal use, but could also be used directly.

        NOTE:
        This method should be used instead of the AppiumLibrary's "Click Element",
        because sometimes Android fails deliver the page source (and the locator fails to find the text field)

        Arguments
        - locator        :     The Locator for finding the input field.
                               For more details about locators, please see AppiumLibrary documentation.
        - retries        :     How many retries shall we do
        - delay          :     How long to wait between retries
        - fail_on_error  :     Should we fail the test on error.
                               If False, then the status of the verification is returned as a return value.

        Returns   0 - if the text input was successful, otherwise return 1.
                  Valid only if called with fail_on_error=False
        """
        return self._w.click_element_with_retry(locator, retries, delay, fail_on_error)




    def delete_vms_messages(self, dv_alias, msg_count=VMS_DEL_MSG):
        """
        Deletes Voicemail messages in the VMS Menu

        Calls voicemail and deletes messages (by sending DTMF key 2).

        If there are no messages left to delete, VMS will play an error prompt that can be ignored.

        Arguments
        - device_alias   :   alias (or list of aliases) that was given to the device in the `Initiate Device`
        - msg_count      :   number of messages to delete, default is taken from the global variable ${VMS_DEL_MSG}
        """
        self._w.delete_vms_messages(dv_alias, msg_count)


    def _activate_rcs(self, device_alias):
        """
        x

        -  :                x
        -  :                x
        -  :                x
        -  :                x

        returns:
        """
        self._w.activate_rcs(device_alias)

    def _deactivate_rcs(self, device_alias):
        """
        x

        -  :                x
        -  :                x
        -  :                x
        -  :                x

        returns:
        """
        self._w.deactivate_rcs(device_alias)

    def _is_rcs_active(self, device_alias):
        """
        x

        -  :                x
        -  :                x
        -  :                x
        -  :                x

        returns:
        """
        return self._w.is_rcs_active(device_alias)

    def _trigger_rcs_registration(self, device_alias):
        """
        x

        -  :                x
        -  :                x
        -  :                x
        -  :                x

        returns:
        """
        self._w.trigger_rcs_registration(device_alias)

