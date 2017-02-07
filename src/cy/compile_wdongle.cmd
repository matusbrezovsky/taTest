@echo off

echo creating ATFCommons.c
cython ..\py\ATFCommons.py -o ATFCommons.c

echo creating ATFCommons.pyd dongle.pyd
gcc -shared -O2 -Ic:\Python27\include -o dongle.pyd ..\dongle\dongle.c ..\dongle\libSglW32.a "win32\libpython27.a"
gcc -shared -O2 -Ic:\Python27\include -o ATFCommons.pyd ATFCommons.c ..\dongle\dongle.c ..\dongle\libSglW32.a "win32\libpython27.a"

echo start: cd ..; run_wrap_test.cmd
