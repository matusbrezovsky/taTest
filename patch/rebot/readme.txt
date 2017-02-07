

1. Install python
https://www.python.org/ftp/python/2.7.10/python-2.7.10.msi

2. install robotframework
(to uninstall delete robot* from c:/Python27/Lib/site-packages/ then)

pip install robotframework==2.8.7
  or
pip install robotframework==2.9.2


Patch for reports format - Robot Framework 2.8.7 or 2.9.2:

cp -r rebot/* c:/Python27/Lib/site-packages/robot/htmldata/rebot/
