rem set DBG = -b debug.log
python -m robot.run %DBG% -vIGNORE_APPIUM_BUGS:False                -P src\c -P src\py -e rcs src\test\rf\common\py_devicecontrol.robot
python -m robot.run %DBG% -vIGNORE_APPIUM_BUGS:False -vREV_DEV:True -P src\c -P src\py -e rcs src\test\rf\common\py_devicecontrol.robot
