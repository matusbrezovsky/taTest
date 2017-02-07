from wtforms import form, fields, validators

from user import User


# Define login and registration forms (for flask-login)
class JobForm(form.Form):
    username = fields.StringField(validators=[validators.required()])
    password = fields.PasswordField(validators=[validators.required()])

    def validate_login(self, field):
        user1 = self.get_user()

        if user1 is None:
            raise validators.ValidationError('Invalid user')

        if user1.password != self.password.data:
            raise validators.ValidationError('Invalid password')

    def get_user(self):
        user1 = User.get(self.username.data, self.password.data)
        return user1

    def get_username(self):
        return self.username.data
