from flask.ext.login import UserMixin

class UserNotFoundError(Exception):
    pass

class UserWrongError(Exception):
    pass

class User(UserMixin):

    USERS = {
        # username: password
        'admin': 'admin',
        'guest': '123456'
    }

    id = None
    password = None

    def __init__(self, id):
        if not id in self.USERS:
            raise UserNotFoundError()
        self.id = id
        self.password = self.USERS[id]

    @classmethod
    def getUser(self_class, id):
        return self_class(id)

    @classmethod
    def get(self_class, id, passw):
        user1 = User.getUser(id)
        if not user1.password == passw:
            raise UserWrongError()
        return user1
