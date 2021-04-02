# This Python file uses the following encoding: utf-8
from PyQt5 import QtWidgets
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot
from peewee import *

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

class dbManager(QObject):
    def __init__(self, db):
        QObject.__init__(self)
        self.database = db
        self.database.connect()

    def __del__(self):
        self.database.close()
        print ('деструктор dbManager вызван')

    def add_route(self, n, d, am):
        Routes.create(name = n, date_of_creation = d, amount = am)

    def remove_route(self, r_id):
        sql = "DELETE FROM points WHERE route_id=?"
        self.database.execute_sql(sql, (r_id,))
        sql = "DELETE FROM routes WHERE route_id=?"
        self.database.execute_sql(sql, (r_id,))

    @pyqtSlot(int, float, float, int)
    def add_point(self, num, lat, lon, r_id):
        Points.create(number = num, latitude = lat, longitude = lon, route = r_id)

    @pyqtSlot(int, int)
    def remove_point(self, r_id, num):
        sql = "DELETE FROM points WHERE route_id=? AND number=?"
        self.database.execute_sql(sql, (r_id, num))
        query = Points.update(number = Points.number-1).where(Points.number > num, Points.route == r_id)
        query.execute()
        print("remove_point")

    def get_routes(self):
        all_routes = Routes.select()
#        print (all_routes.sql())
        str_list = []
        for r in all_routes:
           str_list.append({'route_id': r.route_id, 'name': r.name, 'date_of_creation': r.date_of_creation.strftime("%m/%d/%Y"), 'amount': r.amount})
        return str_list

    def selectNewRoute(self, n):
        newRoute = Routes.select().where(Routes.name == n)
        print(newRoute)
        for n in newRoute:
            print("id: {} name: {} date: {} amount: {}".format(n.route_id, n.name, n.date_of_creation, n.amount))
            return {'route_id': n.route_id, 'name': n.name, 'date_of_creation': n.date_of_creation.strftime("%m/%d/%Y"), 'amount': n.amount}

    countOfRoutes = pyqtSignal(int, arguments=['count'])

#    @pyqtSlot()
    def count(self):
#        count_of_routes = Routes.select().count()
        return Routes.select().count()
#        self.countOfRoutes.emit(Routes.select().count())

    @pyqtSlot(int)
    def justPrint(self, smth):                      #                                 <-- для проверки связи qml и python
        print("[dbManager] checkConnection:", smth)

    @pyqtSlot(int, result=int)
    def getAmountOfPoints(self, r_id):
        ps = Routes.select().where(Routes.route_id == r_id)
        for p in ps:
            return p.amount

    @pyqtSlot(int, int, result=float)
    def getLatFromRouteByNumber(self, r_id, num):
        ps = Points.select().where(Points.route_id == r_id, Points.number == num)
        for p in ps:
            return p.latitude

    @pyqtSlot(int, int, result=float)
    def getLonFromRouteByNumber(self, r_id, num):
        ps = Points.select().where(Points.route_id == r_id, Points.number == num)
        for p in ps:
            return p.longitude

    @pyqtSlot(int, int)
    def updateAmountInRoutes(self, r_id, am):
        query = Routes.update(amount = am).where(Routes.route_id == r_id)
        query.execute()
        print("updateAmountInRoutes")

    @pyqtSlot(int, result=str)
    def getRouteName(self, r_id):
        ps = Routes.select().where(Routes.route_id == r_id)
        for p in ps:
            return p.name

    @pyqtSlot(int, str)
    def updateRouteName(self, r_id, n):
        query = Routes.update(name = n).where(Routes.route_id == r_id)
        query.execute()
        print("updateRouteName")
