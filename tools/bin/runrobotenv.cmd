@echo off
rem set TA_GITHOME=C:\git\ta
rem call C:\git\ta\tools\bin\setenv.cmd add
call setenv.cmd add
@echo on
call runappium.cmd
start "GIT" /D %TA_GITHOME% cmd /K git status
start "ADB" /D %TA_GITHOME% cmd /K adb devices -l
sleep 1
start "ROBOT - log" /D %TA_GITHOME%  cmd /K tail -F debug*.log
start "ROBOT - console" /D %TA_GITHOME% cmd /K python -m robot.run --version
