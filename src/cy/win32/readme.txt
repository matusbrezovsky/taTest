
1. Install python
https://www.python.org/ftp/python/2.7.10/python-2.7.10.msi

2. install cython
pip install cython

3. install robotframework
pip install robotframework

4. install mingwpy mingwpy_win32_vc100.7z
https://bitbucket.org/carlkl/mingw-w64-for-python/downloads/
set Path to mingwpy/bin

5. copy c:/Windows/SysWOW64/python27.dll .

6. generate python.def
pexports.exe python27.dll > python.def

7. create libpython27.a
dlltool --dllname python27.dll --def python27.def --output-lib libpython27.a

8. compile
gcc -shared -O2 -Ic:\opt\Python27\include -o ATFCommons.pyd ATFCommons.c "win32\libpython27.a"