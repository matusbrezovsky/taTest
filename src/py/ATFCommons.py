from robot import utils
from robot.api import logger
from robot.libraries.Collections import _Dictionary
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.XML import XML
import robot.libraries.DateTime
from robot.libraries.String import String as rfString
import robot.libraries.Dialogs
import robot.libraries.OperatingSystem

import inspect

funcname = lambda: inspect.stack()[1][3]

class ATFCommons:

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    __version__ = '2.0.0-alpha1'

    DLGS_SLEEP_DEFAULT = '5s'
    DLGS_FAIL_ON_SKIP_DEFAULT = True

    def __init__(self):
        self._bi= BuiltIn()
        self._dc= _Dictionary()
        self._xml= XML()

    def Get_As_List(self, obj, retDictKeys=True):
        """
        Converts different types of variable into List
        Currently supported conversions:
        1) scalar to list
        2) list to list
        3) dictionary to list (returns dictionary keys)

        :param obj:     Dictionary, List or Scalar (unicode, str or int)
        :return:        List
        """
        #logger.console('\nGot arg %s' % obj.__class__)
        lst = None
        if isinstance(obj, dict):
            if retDictKeys:
                lst = self._dc.get_dictionary_keys(obj)
            else:
                lst = self._dc.get_dictionary_values(obj)
        elif isinstance(obj, list):
            lst = obj
        elif isinstance(obj, type(None)):
            lst = self._bi.create_list()
        elif isinstance(obj, unicode) or isinstance(obj, str) or isinstance(obj, int):
            lst = self._bi.create_list(obj)
        else:
            self._bi.fail(msg=funcname()+" received unknown Object type - supported types are: Dictionary, List and Scalar (unicode, str or int)")

        return lst

    def Check_If_Exists_and_Return_Type(self, obj, ignoreempty=False):
        """
        Checks if the variable is set (as Scaler, List or Dict)
        Return True if set and the variable type "Scalar/List/Dict"
        Return False if the value equals ${None} or ${null}
        Return False if the ignoreempty=False and the value equals ${EMPTY}

        :param obj:             Dictionary, List or Scalar (unicode, str or int)
        :param ignoreempty:     How to treat empty (='') value
        :return:                List with two items [0]: Exists Check result (boolean), [1]: Type as String ('Dict', 'List' or 'Scalar')
        """
        if isinstance(obj, dict):
            ret = [True, "Dict"]
        elif isinstance(obj, list):
            ret = [True, "List"]
        elif isinstance(obj, type(None)):
            ret = [False, ""]
        elif isinstance(obj, unicode) or isinstance(obj, str) or isinstance(obj, int):

            if not self._evaluate(ignoreempty) and obj == '':
                    ret = [False, ""]
            elif self._evaluate(ignoreempty) and obj == '':
                    ret = [True, "Scalar"]
            elif obj != '':
                    ret = [True, "Scalar"]
        else:
            self._bi.fail(msg=funcname()+ " received unknown Object type - supported types are: Dictionary, List and Scalar (unicode, str or int)")

        return ret

    def Check_If_Exists(self, obj, ignoreempty=False):
        """
        As `Check_If_Exists_and_Return_Type` but returns only the existence check result.
        :param obj:             see `Check_If_Exists_and_Return_Type`
        :param ignoreempty:     see `Check_If_Exists_and_Return_Type`
        :return:                see `Check_If_Exists_and_Return_Type`
        """
        ret = self.Check_If_Exists_and_Return_Type(obj, ignoreempty)

        return ret[0]

################################################################################################################################################
#
#   ######   ######    #####      #        #######   #####
#   #     #  #     #  #     #     #        #     #  #     #
#   #     #  #     #  #           #        #     #  #
#   #     #  ######   #  ####     #        #     #  #  ####
#   #     #  #     #  #     #     #        #     #  #     #
#   #     #  #     #  #     #     #        #     #  #     #
#   ######   ######    #####      #######  #######   #####
#
################################################################################################################################################
    def Debug_Log(self, logelement, debug_log=None, debug_level=None, mode='txt'):
        """
        Print debug logs into the execution log or to the console
        Global variables DBG_LOG (True/False) controls the debug log status (On/Off) and DBG_LEVEL controls the log level (e.g. INFO/WARN).
        The global variables can be overridden with the method arguments.

        :param logelement: The text to be logged (with mode=txt, default) or the XML-element (with mode=xml)
        :param debug_log: Enable log (True/False). Intended to override the global one i.e. DBG_LOG=False + debug_log=True --> debug log is printed.
        :param debug_level: The log level to be used. DEBUG/INFO prints into the log file, WARN prints to the console
        :param mode: Log mode, "txt" or "xml". The "xml" mode enables human readable logs of XML elements
        :return:  True if the log was written, otherwise False
        """
        # quit if
        # - debug_log is False
        # - global DBG_LOG is not set and debug_log argument is not set
        if not self._evaluate(debug_log, empty=True):
            return False

        glb_dbg_log = self._bi.get_variable_value('${DBG_LOG}', None)

        if debug_log == None:
            if glb_dbg_log == None or not self._evaluate(glb_dbg_log, empty=True):
                return False

        # set debug log level - will be used later in the printer/logger steps
        # TODO: add level string check INFO/WARN/CONSOLE etc
        glb_dbg_lvl = self._bi.get_variable_value('${DBG_LEVEL}', None)

        if debug_level == None:
            if glb_dbg_lvl == None:
                use_lvl = 'INFO'
            else:
                use_lvl = glb_dbg_lvl
        else:
            use_lvl = debug_level

        if mode == 'txt':
            if isinstance(logelement, dict):
                for key, value in logelement.items():
                    dbg_str = 'dbg: '+key+'-'+value
                    if use_lvl == 'CONSOLE':
                        self._bi.log_to_console(dbg_str)
                    else:
                        self._bi.log(dbg_str, level=use_lvl)
            elif isinstance(logelement, list):
                for i in logelement:
                    dbg_str = 'dbg: '+i
                    if use_lvl == 'CONSOLE':
                        self._bi.log_to_console(dbg_str)
                    else:
                        self._bi.log(dbg_str, level=use_lvl)
            else:
                dbg_str = 'dbg: '+logelement
                if use_lvl == 'CONSOLE':
                    self._bi.log_to_console(dbg_str)
                else:
                    self._bi.log(dbg_str, level=use_lvl)
        elif mode == 'xml':
            for item in logelement:
                dbg_str = self._xml.element_to_string(item)
                if use_lvl == 'CONSOLE':
                    self._bi.log_to_console(dbg_str)
                else:
                    self._bi.log(dbg_str, level=use_lvl)
        else:
            self._bi.fail(msg=funcname()+ ": unknown mode '%s'" % mode )

        return True

    def Debug_Log_XML(self, logelement, debug_log=None, debug_level=None):
        """
        Helper function to log XML elements, see `Debug Log` (mode=xml) for more details
        """
        r = self.Debug_Log(logelement, debug_log=debug_log, debug_level=debug_level, mode='xml')
        return r


################################################################################################################################################
#
#   #######  #     #  #######      ######   #######   #####   #######  #     #  ######
#      #      #   #      #         #     #  #        #     #  #         #   #   #     #
#      #       # #       #         #     #  #        #        #          # #    #     #
#      #        #        #         ######   #####    #  ####  #####       #     ######
#      #       # #       #         #   #    #        #     #  #          # #    #
#      #      #   #      #         #    #   #        #     #  #         #   #   #
#      #     #     #     #         #     #  #######   #####   #######  #     #  #
#
################################################################################################################################################
    def Text_Should_Match_All_RegEx(self, txt, list_of_REs, re_prefix='.*', re_postfix='.*', fail_on_error=True, err_msg="Text didn't contain all RegEx"):
        """
        Verify a string with a list of Regular Expressions

        Each RE in the list is tested against the text.
        Fails if one the RE's fail to match.

        :param txt: The string to match (can be single or multi-line text)
        :param list_of_REs: List of Regular Expressions that should match the String
        :param re_prefix: Pre-fix to add to each RE, default ".*"
        :param re_postfix: Post-fix to add to each RE, default ".*"
        :param fail_on_error: Should we fail on error or simply return False.
        :param err_msg: Error message to print on failure. Meaningless if fail_on_error=False
        :return: True if all REs matched, otherwise False. Valid only with fail_on_error=False
        """

        for regex in list_of_REs:
            not_operand = regex[0:5]
            the_rest = regex[5:]
            if not_operand == '!not!':
                re = the_rest
                r = self._bi.run_keyword_and_ignore_error('Should Not Match Regexp',txt,re)
            else:
                re = regex
                r = self._bi.run_keyword_and_ignore_error('Should Match Regexp',txt,re)
            if r[0] == 'FAIL':
                match_found = False
                break
            else:
                match_found = True

        if not match_found and self._evaluate(fail_on_error):
            self._bi.fail(msg = err_msg + "(failed re:" + regex + " - re's: " + str(list_of_REs) + " - txt below\n" + txt)

        return match_found

    def Text_Should_Match_At_Least_One_RegEx(self, txt, list_of_REs, re_prefix='.*', re_postfix='.*', fail_on_error=True, err_msg="Text didn't contain at least one RegEx"):
        """
        Verify a string with a list of Regular Expressions
        Each RE in the list is tested against the text.
        Fails if none the RE's fail to match.

        :param txt: The string to match (can be single or multi-line text)
        :param list_of_REs: List of Regular Expressions that should match the String
        :param re_prefix: Pre-fix to add to each RE, default ".*"
        :param re_postfix: Post-fix to add to each RE, default ".*"
        :param fail_on_error: Should we fail on error or simply return False.
        :param err_msg: Error message to print on failure. Meaningless if fail_on_error=False
        :return: True if one of the REs matched, otherwise False. Valid only with fail_on_error=False
        """

        for regex in list_of_REs:
            not_operand = regex[0:5]
            the_rest = regex[5:]
            if not_operand == '!not!':
                re = the_rest
                r = self._bi.run_keyword_and_ignore_error('Should Not Match Regexp',txt,re)
            else:
                re = regex
                r = self._bi.run_keyword_and_ignore_error('Should Match Regexp',txt,re)
            if r[0] == 'PASS':
                match_found = True
                break
            else:
                match_found = False

        if not match_found and self._evaluate(fail_on_error):
            self._bi.fail(msg = err_msg + "(failed re:" + regex + " - re's: " + str(list_of_REs) + " - txt below\n" + txt)

        return match_found


    def Text_Should_Not_Match_Any_RegEx(self, txt, list_of_REs, re_prefix='.*', re_postfix='.*', fail_on_error=True, err_msg="Text contains at least one RegEx"):
        """
        Verify a string with a list of Regular Expressions
        Each RE in the list is tested against the text.
        Fails if one of the RE's match.

        :param txt: The string to match (can be single or multi-line text)
        :param list_of_REs: List of Regular Expressions that should match the String
        :param re_prefix: Pre-fix to add to each RE, default ".*"
        :param re_postfix: Post-fix to add to each RE, default ".*"
        :param fail_on_error: Should we fail on error or simply return False.
        :param err_msg: Error message to print on failure. Meaningless if fail_on_error=False

        :return: True if none of the REs matched, otherwise False. Valid only with fail_on_error=False
        """

        for regex in list_of_REs:
            not_operand = regex[0:5]
            the_rest = regex[5:]
            if not_operand == '!not!':
                re = the_rest
                r = self._bi.run_keyword_and_ignore_error('Should Not Match Regexp',txt,re)
            else:
                re = regex
                r = self._bi.run_keyword_and_ignore_error('Should Match Regexp',txt,re)
            if r[0] == 'PASS':
                match_found = True
                break
            else:
                match_found = False

        if match_found and self._evaluate(fail_on_error):
            self._bi.fail(msg = err_msg + "(failed re:" + regex + " - re's: " + str(list_of_REs) + " - txt below\n" + txt)

        return not match_found


    def Text_Should_Match_Number_of_RegEx(self, txt, match_count, list_of_REs, re_prefix='.*', re_postfix='.*', fail_on_error=True, err_msg="Text contains at least one RegEx"):
        """
        Verify a string with a list of Regular Expressions
        Each RE in the list is tested against the text.
        Fails if the RE's match count is not as expected

        :param txt: The string to match (can be single or multi-line text)
        :param list_of_REs: List of Regular Expressions that should match the String
        :param re_prefix: Pre-fix to add to each RE, default ".*"
        :param re_postfix: Post-fix to add to each RE, default ".*"
        :param fail_on_error: Should we fail on error or simply return False.
        :param err_msg: Error message to print on failure. Meaningless if fail_on_error=False
        :return: True if the correct number of REs matched, otherwise False. Valid only with fail_on_error=False
        """

        match_found_count = 0
        for regex in list_of_REs:
            not_operand = regex[0:5]
            the_rest = regex[5:]
            if not_operand == '!not!':
                re = the_rest
                r = self._bi.run_keyword_and_ignore_error('Should Not Match Regexp',txt,re)
            else:
                re = regex
                r = self._bi.run_keyword_and_ignore_error('Should Match Regexp',txt,re)
            if r[0] == 'PASS':
                match_found_count += 1
                if match_found_count > int(match_count):
                    break

        if match_found_count != int(match_count) and self._evaluate(fail_on_error):
            self._bi.fail(msg = err_msg + "(failed re:" + regex + " - re's: " + str(list_of_REs) + " - txt below\n" + txt)

        return (match_found_count == int(match_count))


################################################################################################################################################
#
#   #######  #     #  #######     #        ###   #####   #######     ######   #######   #####   #######  #     #  ######
#      #      #   #      #        #         #   #     #     #        #     #  #        #     #  #         #   #   #     #
#      #       # #       #        #         #   #           #        #     #  #        #        #          # #    #     #
#      #        #        #        #         #    #####      #        ######   #####    #  ####  #####       #     ######
#      #       # #       #        #         #         #     #        #   #    #        #     #  #          # #    #
#      #      #   #      #        #         #   #     #     #        #    #   #        #     #  #         #   #   #
#      #     #     #     #        #######  ###   #####      #        #     #  #######   #####   #######  #     #  #
#
################################################################################################################################################
    def Any_Text_Item_in_List_Should_Contain_All_RegEx(self, list_of_txt_items, list_of_REs, re_prefix='.*', re_postfix='.*', start_at=0, fail_on_error=True, err_msg="Text Item List validation failed"):

        matched_pdu_index = -1
        i = int(start_at)
        for txt in list_of_txt_items[i:]:
            match_found = self.Text_Should_Match_All_RegEx(list_of_txt_items[i], list_of_REs, fail_on_error=False)
            if match_found:
                matched_pdu_index = i
                break
            i += 1

        #logger.console('\n%s %s' % (fail_on_error, fail_on_error.__class__))
        #logger.console('\n%s %s' % (bool(fail_on_error), bool(fail_on_error).__class__))
        if not match_found and self._evaluate(fail_on_error):
            self._bi.fail(msg = err_msg + "(Used RegEx's " + str(list_of_REs) + ")")

        return matched_pdu_index


################################################################################################################################################
#
#       ######   ###     #     #        #######   #####    #####
#       #     #   #     # #    #        #     #  #     #  #     #
#       #     #   #    #   #   #        #     #  #        #
#       #     #   #   #     #  #        #     #  #  ####   #####
#       #     #   #   #######  #        #     #  #     #        #
#       #     #   #   #     #  #        #     #  #     #  #     #
#       ######   ###  #     #  #######  #######   #####    #####
#
################################################################################################################################################
    def Prepare_Manual_Step (self, dlg_txt, skip_msg='Skipping Manual Steps'):

        skip = self._skip_test_step('DLGS_SKIP', skip_msg)
        if skip:
            return

        robot.libraries.Dialogs.pause_execution(message="Manual Step Starting:\n"+dlg_txt+"\n\nTo avoid timeout errors, please acknowledge the next dialog promptly\n\nClick to Proceed...")

    def Pause_for_Manual_Step (self, dlg_txt, fail_on_skip=None, skip_msg='Skipping Manual Steps'):

        skip = self._skip_test_step('DLGS_SKIP', skip_msg)

        # fail_on_skip precedence: 1) use KW argument if set 2) use global DLGS_FAIL_ON_SKIP if set 3) use default DLGS_FAIL_ON_SKIP_DEFAULT
        fos_global = self._bi.get_variable_value('${DLGS_FAIL_ON_SKIP}', None)
        if fail_on_skip != None:
            used_fos = self._evaluate(fail_on_skip)
        elif fos_global != None:
            used_fos = self._evaluate(fos_global)
        else:
            used_fos = self.DLGS_FAIL_ON_SKIP_DEFAULT

        ignore_err = self._evaluate(self._bi.get_variable_value('${IGNORE_ERR_MANUAL}', False))

        if skip and used_fos and not ignore_err:
            self._bi.fail(msg = "Failed because the required manual steps are skipped")
        elif skip and used_fos and ignore_err:
            self._bi.log("Ignoring errors in mandatory manual steps", level="WARN")

        if skip:
            return

        robot.libraries.Dialogs.pause_execution(message=dlg_txt+"\n\nClick to Proceed...")

    def Evaluate_Manual_Step (self, dlg_txt, err_txt, sleep_time=None, fail_on_skip=None, skip_msg='Skipping Manual Steps'):
        skip = self._skip_test_step('DLGS_SKIP', skip_msg)

        # fail_on_skip precedence: 1) use KW argument if set 2) use global DLGS_FAIL_ON_SKIP if set 3) use default DLGS_FAIL_ON_SKIP_DEFAULT
        fos_global = self._bi.get_variable_value('${DLGS_FAIL_ON_SKIP}', None)
        if fail_on_skip != None:
            used_fos = self._evaluate(fail_on_skip)
        elif fos_global != None:
            used_fos = self._evaluate(fos_global)
        else:
            used_fos = self.DLGS_FAIL_ON_SKIP_DEFAULT

        # sleep precedence: 1) use KW argument if set 2) use global DLGS_SLEEP if set 3) use default DLGS_SLEEP_DEFAULT
        sleep_global = self._bi.get_variable_value('${DLGS_SLEEP}', None)
        if sleep_time != None:
            used_sleep = sleep_time
        elif sleep_global != None:
            used_sleep = sleep_global
        else:
            used_sleep = self.DLGS_SLEEP_DEFAULT

        ignore_err = self._evaluate(self._bi.get_variable_value('${IGNORE_ERR_MANUAL}', False))

        if skip and used_fos and not ignore_err:
            self._bi.fail(msg = "Failed because the required manual steps are skipped")
        elif skip and used_fos and ignore_err:
            self._bi.log("Ignoring errors in mandatory manual steps", level="WARN")

        if skip:
            self._bi.sleep(used_sleep, reason="Sleeping "+used_sleep+" because the manual step is skipped")
            return

        s = self._bi.run_keyword_and_ignore_error("Execute Manual Step", "message= " + dlg_txt, "default_error= " + err_txt)
        if s[0] == 'FAIL':
            if ignore_err:
                self._bi.log("Ignoring Error: " + s[1], level="WARN")
            else:
                self._bi.fail(msg = s[1])


################################################################################################################################################
#
#   #######  #     #  #######   #####           #####   #######  ######   #
#   #         #   #   #        #     #         #     #     #     #     #  #
#   #          # #    #        #               #           #     #     #  #
#   #####       #     #####    #               #           #     ######   #
#   #          # #    #        #               #           #     #   #    #
#   #         #   #   #        #     #         #     #     #     #    #   #
#   #######  #     #  #######   #####           #####      #     #     #  #######
#
################################################################################################################################################
    def _check_and_log_var_status(self, var_name, log_msg, scope='Test'):
        skip_step = self._bi.get_variable_value('${'+var_name+'}', False)

        # log only once within scope (e.g. test case)
        already_logged = self._bi.get_variable_value('${'+log_msg+'_WARNING}', False)

        if self._evaluate(skip_step) and not self._evaluate(already_logged):
            self._bi.log(log_msg,level='WARN')

        if scope == 'Test':
            self._bi.set_test_variable('${'+log_msg+'_WARNING}', True)
        elif scope == 'Suite':
            self._bi.set_test_variable('${'+log_msg+'_WARNING}', True)
        elif scope == 'Global':
            self._bi.set_test_variable('${'+log_msg+'_WARNING}', True)
        else:
            raise ValueError("Received unknown Scope: '%s'." & scope)

        return True if self._evaluate(skip_step) else False

    def _skip_test_step (self, skip_step_var, log_msg):
        return self._check_and_log_var_status(skip_step_var, log_msg + ' [Test Scope]', scope='Test')

    def _skip_suite_step (self, skip_step_var, log_msg):
        return self._check_and_log_var_status(skip_step_var, log_msg + ' [Suite Scope]', scope='Suite')

    def _skip_global_step (self, skip_step_var, log_msg):
        return self._check_and_log_var_status(skip_step_var, log_msg + ' [Global Scope]', scope='Global')

    def _in_dummy_mode (self, log_msg, scope='Suite'):
        return self._check_and_log_var_status('DUMMY_MODE', log_msg, scope=scope)

    # do we need public ones?
    def skip_test_step (self, skip_step_var, log_msg):
        return self._check_and_log_var_status(skip_step_var, log_msg + ' [Test Scope]', scope='Test')

################################################################################################################################################
################################################################################################################################################
################################################################################################################################################
################################################################################################################################################
    def Create_Results_Directory(self):
        #get default directory
        resultspath = self._bi.get_variable_value('${RESULTS_ROOT_PATH}', '${EXECDIR}${/}results')

        # generate result directory name - SUITE NAME needs some parsing for the scenarios where
        # more than one suite is executed at once
        tstmp = robot.libraries.DateTime.get_current_date(result_format='%Y%m%d%H%M')
        suite = self._bi.get_variable_value('${SUITE NAME}')
        space = self._bi.get_variable_value('${SPACE}')
        dirsp = self._bi.get_variable_value('${/}')

        sc = rfString()
        str = sc.replace_string(suite, ' ', '_')
        str = sc.replace_string(str, '&', 'and')
        strl = sc.split_string(str, '.')
        suitedir = tstmp + strl[0]

        inDevMode = self._skip_suite_step('DEVELOPMENT_MODE', 'Running in DEVELOPMENT_MODE - overwriting results in directory ' + resultspath + dirsp + 'last')
        # are we running in development mode
        if inDevMode:
            full_path = resultspath + dirsp + 'last'
        else:
            full_path = resultspath + dirsp + suitedir

        self._bi.set_suite_variable('${RESULTS_LATEST}', full_path)

        robot.libraries.OperatingSystem.OperatingSystem().create_directory(full_path)

        return full_path

################################################################################################################################################
#  P R I V A T E
################################################################################################################################################

    def _evaluate (self, expression, modules=None, namespace=None, empty=None):
        # borrowed from BuildIn.py
        namespace = namespace or {}
        modules = modules.replace(' ', '').split(',') if modules else []
        namespace.update((m, __import__(m)) for m in modules if m)
        try:
            if isinstance(expression, bool):
                return bool(expression)
            if not expression:
                if empty:
                    return True
                elif not empty:
                    return False
                else:
                    raise ValueError("Expression cannot be empty.")
            if not isinstance(expression, basestring):
                raise TypeError("Expression must be a string, not '%s'."
                                % type(expression).__name__)
            return eval(expression, namespace)
        except:
            raise RuntimeError("Evaluating expression '%s' failed: %s"
                               % (expression, utils.get_error_message()))

################################################################################################################################################
#  D E P R E C A T E D
################################################################################################################################################


    def Return_Empty_Unless(self, condition, return_if_true):
        logger.console('\nDEPRECATED: ' + funcname() + 'is no longer supported: use the buildIn "Set Variable If" instead')

    def Set_Variable_If_Else(self, condition, return_if_true, return_if_false):
        logger.console('\nDEPRECATED: ' + funcname() + 'is no longer supported: use the buildIn "Set Variable If" instead')

