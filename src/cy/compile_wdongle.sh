

echo creating ATFCommons.c
cython ../ATFCommons.py -o ATFCommons.c

echo creating ATFCommons.pyd dongle.pyd
gcc -shared -fPIC -O2 -I/usr/include/python2.7 -o dongle.so ../dongle/dongle.c ../dongle/libSglW32.a
gcc -shared -fPIC -O2 -I/usr/include/python2.7 -o ATFCommons.so ATFCommons.c dongle.so ../dongle/libSglW32.a


# gcc -shared -O2 -Ic:\Python27\include -o ATFCommons.pyd ATFCommons.c ..\dongle\dongle.c ..\dongle\libSglW32.a "win32\libpython27.a"

echo start: cd ..; run_wrap_test.sh

