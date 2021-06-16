from django.conf.urls import url
import pymysql

class Conn:
    def __init__(self):
        self.conn = pymysql.connect(
            host="localhost", user="user", password="passwd")

    def query(self, query):
        cur = self.conn.cursor()
        cur.execute(query)  # $getSql=query
        cur.close()

def show_user(request, username):

    query = "SELECT * FROM users WHERE username = '%s'" % username
    conn = Conn()
    conn.execute(query)

urlpatterns = [url(r'^users/(?P<username>[^/]+)$', show_user)]
