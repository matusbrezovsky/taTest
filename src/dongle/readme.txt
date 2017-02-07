
0. Copy SglW32.dll, SglW32.h here

1. create libSglW32.a
pexports.exe SglW32.dll > SglW32.def
dlltool --dllname SglW32.dll --def SglW32.def --output-lib libSglW32.a

2. compile
gcc dongle.c libSglW32.a
