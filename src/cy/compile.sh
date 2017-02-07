
# sudo pip install cython

cython ../ATFCommons.py -o ATFCommons.c
gcc -shared -fPIC -O2 -I/usr/include/python2.7 -o ATFCommons.so ATFCommons.c

# use ATFCommons.so instead of ATFCommons.py:
#  import ATFCommons

