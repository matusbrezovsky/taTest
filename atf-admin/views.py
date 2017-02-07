from __future__ import print_function
import sys
from subprocess import Popen, PIPE

import flask_login as login
import flask_admin as admin
from flask_admin import helpers, expose
from flask import redirect, url_for, request, render_template

from loginform import LoginForm
from atfform import JobForm
import stub as stub


class AdminIndexView(admin.AdminIndexView):
    
    def _stubs(self):
        self.nav = {
            "tasks" : stub.get_tasks(),
            "messages" : stub.get_messages_summary(),
            "alerts" : stub.get_alerts()
        }
        
        (cols, rows) = stub.get_adv_tables()
        (scols, srows, context) = stub.get_tables()
        
        self.tables = {
            "advtables" : { "columns" : cols, "rows" : rows },
            "table" : { "columns" : scols, "rows" : srows, "context" : context}
        }
        
        self.panelswells = {
            "accordion" : stub.get_accordion_items(),
            "tabitems" : stub.get_tab_items()
        }
            
    @expose('/')
    def index(self):
        if not login.current_user.is_authenticated:
            return redirect(url_for('.login_view'))
            
        self._stubs()    
        self.header = "Dashboard"
        return render_template('sb-admin/pages/dashboard.html', admin_view=self)

    @expose('/atf', methods=('GET', 'POST'))
    def atf(self):        
        if not login.current_user.is_authenticated:
            return redirect(url_for('.login_view'))

        form = JobForm(request.form)
        msg = ""
        if request.method == 'POST':
            command1 = str(form.get_username())
            # print ("cmd: " + command1, file=sys.stderr)
            cmd = [ command1 ]
            p = Popen(cmd, shell=True, stdin=PIPE, stdout=PIPE, stderr=PIPE)
            output, err = p.communicate()
            rc = p.returncode
            msg = str(output) + str(err)
            # print("out: " + msg, file=sys.stderr)
            # print("err: " + str(err), file=sys.stderr)
            # print("rc: " + str(rc), file=sys.stderr)

        msg = msg.decode('utf-8', 'ignore')

        self._stubs()
        self.header = "ATF"
        self._template_args['form'] = form
        return render_template('sb-admin/pages/atf.html', admin_view=self, form=form, msg=msg)

    @expose('/login/', methods=('GET', 'POST'))
    def login_view(self):
        # handle user login
        form = LoginForm(request.form)
        if helpers.validate_form_on_submit(form):
            user = form.get_user()
            login.login_user(user)

        if login.current_user.is_authenticated:
            return redirect(url_for('.index'))
        self._template_args['form'] = form
        return render_template('sb-admin/pages/login.html', form=form)

    @expose('/blank')
    def blank(self):        
        if not login.current_user.is_authenticated:
            return redirect(url_for('.login_view'))
            
        self._stubs()    
        self.header = "Blank"
        return render_template('sb-admin/pages/blank.html', admin_view=self)
        
    @expose('/flot')
    def flot(self):        
        if not login.current_user.is_authenticated:
            return redirect(url_for('.login_view'))
            
        self._stubs()    
        self.header = "Flot Charts"
        return render_template('sb-admin/pages/flot.html', admin_view=self)

    @expose('/morris')
    def morris(self):        
        if not login.current_user.is_authenticated:
            return redirect(url_for('.login_view'))
            
        self._stubs()    
        self.header = "Morris Charts"
        return render_template('sb-admin/pages/morris.html', admin_view=self) 
        
    @expose('/tables')
    def tables(self):        
        if not login.current_user.is_authenticated:
            return redirect(url_for('.login_view'))
            
        self._stubs()    
        self.header = "Tables"
        return render_template('sb-admin/pages/tables.html', admin_view=self)

    @expose('/forms')
    def forms(self):        
        if not login.current_user.is_authenticated:
            return redirect(url_for('.login_view'))
            
        self._stubs()    
        self.header = "Forms"
        return render_template('sb-admin/pages/forms.html', admin_view=self)         
        
    @expose('/ui/panelswells')
    def panelswells(self):        
        if not login.current_user.is_authenticated:
            return redirect(url_for('.login_view'))
            
        self._stubs()    
        self.header = "Panels Wells"
        return render_template('sb-admin/pages/ui/panels-wells.html', admin_view=self)
        
    @expose('/ui/buttons')
    def buttons(self):        
        if not login.current_user.is_authenticated:
            return redirect(url_for('.login_view'))
            
        self._stubs()    
        self.header = "Buttons"
        return render_template('sb-admin/pages/ui/buttons.html', admin_view=self) 
                                
    @expose('/ui/notifications')
    def notifications(self):        
        if not login.current_user.is_authenticated:
            return redirect(url_for('.login_view'))
            
        self._stubs()    
        self.header = "Notifications"
        return render_template('sb-admin/pages/ui/notifications.html', admin_view=self)                         

    @expose('/ui/typography')
    def typography(self):        
        if not login.current_user.is_authenticated:
            return redirect(url_for('.login_view'))
            
        self._stubs()    
        self.header = "Typography"
        return render_template('sb-admin/pages/ui/typography.html', admin_view=self)
        
    @expose('/ui/icons')
    def icons(self):        
        if not login.current_user.is_authenticated:
            return redirect(url_for('.login_view'))
            
        self._stubs()    
        self.header = "Icons"
        return render_template('sb-admin/pages/ui/icons.html', admin_view=self)         
        
    @expose('/ui/grid')
    def grid(self):        
        if not login.current_user.is_authenticated:
            return redirect(url_for('.login_view'))
            
        self._stubs()    
        self.header = "Grid"
        return render_template('sb-admin/pages/ui/grid.html', admin_view=self)         

    @expose('/logout/')
    def logout_view(self):
        login.logout_user()
        return redirect(url_for('.index'))
        
class BlankView(admin.BaseView):
    @expose('/')
    def index(self):
        return render_template('sb-admin/pages/blank.html', admin_view=self)
