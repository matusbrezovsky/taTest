SET LOG_LEVEL=--log-level debug
REM SET LOG_LEVEL=--log-level warn:warn
start "Appium:4723" /D %APPIUM_HOME% cmd /K appium.cmd 4723 4823 %APPIUM_ROOT%\appium4723.log %LOG_LEVEL%
start "Appium:4724" /D %APPIUM_HOME% cmd /K appium.cmd 4724 4824 %APPIUM_ROOT%\appium4724.log %LOG_LEVEL%
REM start "Appium:4726" /D %APPIUM_HOME% cmd /K appium.cmd 4726 4826 %APPIUM_ROOT%\appium4726.log %LOG_LEVEL%
REM start "Appium:4725" /D %APPIUM_HOME% cmd /K appium.cmd 4725 4825 %APPIUM_ROOT%\appium4725.log %LOG_LEVEL%
REM start "Appium:4728" /D %APPIUM_HOME% cmd /K appium.cmd 4728 4828 %APPIUM_ROOT%\appium4728.log %LOG_LEVEL%
REM start "Appium:4727" /D %APPIUM_HOME% cmd /K appium.cmd 4727 4827 %APPIUM_ROOT%\appium4727.log %LOG_LEVEL%
