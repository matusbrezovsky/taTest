
@echo off

rem set PATH=%PATH%;dongle

c:
cd \git\taTest
rem copy /Y *.html atf-admin\report

c:\opt\Python27\Scripts\pybot.bat -P src\cy:.:src src\atfcommons_wrap.robot & copy /Y *.html atf-admin\report
