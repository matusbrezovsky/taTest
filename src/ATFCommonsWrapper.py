from ATFCommons import ATFCommons as ATFC
import ATFCommons
import sys

class ATFCommonsWrapper:

    def __init__(self):
        self._atfc= ATFC()
        reload(sys)
        sys.setdefaultencoding("utf-8")


    def Get_As_List(self, obj, retDictKeys=True):
        #self._atfc.Debug_Log("%s - %s " % (ATFCommons.funcname(), obj))
        print("%s - %s " % (ATFCommons.funcname(), obj))
        return self._atfc.Get_As_List(obj, retDictKeys)
