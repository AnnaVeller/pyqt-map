import sys
import os.path
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtWidgets import QApplication
import peewee
from dbManager import dbManager

from peewee import *
from datetime import date


#database = SqliteDatabase('resources.db')

class UnknownField(object):
    def __init__(self, *_, **__): pass

class BaseModel(Model):
    class Meta:
        database = SqliteDatabase('resources.db')

class Routes(BaseModel):
    amount = IntegerField(null=True)
    date_of_creation = DateField(null=True)
    name = CharField(null=True)
    route_id = AutoField()

    class Meta:
        table_name = 'routes'

class Points(BaseModel):
    latitude = FloatField(null=True)
    longitude = FloatField(null=True)
    number = IntegerField(null=True)
    route = ForeignKeyField(column_name='route_id', field='route_id', model=Routes, null=True)

    class Meta:
        table_name = 'points'
        primary_key = False

class dbManager:
    def __init__(self, db):
        self.database = db
        self.database.connect()

    def add_route(self, r_id, n, d, am):
        Routes.create(route_id = r_id, name = n, date_of_creation = d, amount = am)

    def remove_route(self, r_id):
        sql = "DELETE FROM routes WHERE route_id=?"
        self.database.execute_sql(sql, (r_id,))

    def add_point(self, num, lat, lon, r_id):
        Points.create(number = num, latitude = lat, longitude = lon, route = r_id)

    def remove_point(self, r_id, num):
        sql = "DELETE FROM points WHERE route_id=? AND number=?"
        self.database.execute_sql(sql, (r_id, num))

def on_qml_mouse_clicked(x, y):
    print('mouse clicked:', x, y)

if __name__ == "__main__":
    args = sys.argv
    qml_doc_path = None
    if len(args) > 1:
        qml_doc_path = args[1]
        print('qml doc path:', qml_doc_path)
    else:
        print('no qml doc path :(')
        exit()
    if not os.path.isfile(qml_doc_path):
        print('qml doc is not a file :(')
        exit()
    app = QApplication([])
    engine = QQmlApplicationEngine()
    engine.load(qml_doc_path)
    qml_root = engine.rootObjects()[0]
    qml_root.clicked.connect(on_qml_mouse_clicked)
    db = dbManager(SqliteDatabase('resources.db'))
    print(type(db))
#    db.init()
#    db.add_route(3, 'new', date(2005, 7, 14), 3)
#    db.remove_route(3)
#    db.add_point(4, 4, 4, 1)
    db.remove_point(1, 4)
    sys.exit(app.exec_())
