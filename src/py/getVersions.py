
#ATF
from ATFCommons import ATFCommons as atfc_class
from DeviceControl import DeviceControl as dctrl_class
from Wireshark import Wireshark as ws_class
#RF
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.XML import XML
from SSHLibrary import SSHLibrary
from AppiumLibrary import AppiumLibrary

print("ATF Library Versions:")
print("---------------------")
print("ATFCommons     v%-10s (%s)" % ( atfc_class.ROBOT_LIBRARY_VERSION,  atfc_class.ROBOT_LIBRARY_BUILD))
print("DeviceControl  v%-10s (%s)" % (dctrl_class.ROBOT_LIBRARY_VERSION, dctrl_class.ROBOT_LIBRARY_BUILD))
print("Wireshark      v%-10s (%s)" % (   ws_class.ROBOT_LIBRARY_VERSION,    ws_class.ROBOT_LIBRARY_BUILD))
print("\nRF Library Versions:")
print("--------------------")
print("Core           v%s" % BuiltIn.ROBOT_LIBRARY_VERSION)  # All Standard Libs: BuiltIn, Collections etc.
print("SSHLibrary     v%s" % SSHLibrary.ROBOT_LIBRARY_VERSION)
print("AppiumLibrary  v%s" % AppiumLibrary.ROBOT_LIBRARY_VERSION)
