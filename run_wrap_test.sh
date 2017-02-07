

# echo %date% > c:\tmp\text_output.txt
# rem set PATH=%PATH%;dongle

# c:
cd /home/pkral3/robot/taTest

/usr/local/bin/pybot -P src/cy:.:src src/atfcommons_wrap.robot

cp *.html atf-admin/report/

