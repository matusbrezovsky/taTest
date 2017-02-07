@echo off

echo creating ATFCommons.c
cython ..\py\ATFCommons.py -o ATFCommons.c

echo from ATFCommons.c creating ATFCommons.pyd
gcc -shared -O2 -Ic:\opt\Python27\include -o ATFCommons.pyd ATFCommons.c "win32\libpython27.a"

echo start: cd ..; run_wrap_test.cmd

