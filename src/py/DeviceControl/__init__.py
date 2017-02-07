from atfwrappers.devices import DeviceCtrlWrapper
from atf.utils.list import AtfListener

class DeviceControl(AtfListener, DeviceCtrlWrapper):
#class DeviceControl(AtfListener, DeviceCtrlWrapper):
    """
    DeviceControl Library for steering Devices
    """

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_VERSION = '2.0-stable'
    ROBOT_LIBRARY_BUILD = '' + '123618042016_d3e2bb5_201604121517'

    def __init__(self):
        for base in DeviceControl.__bases__:
            base.__init__(self)
        #CommonsImpl.__init__(self)

