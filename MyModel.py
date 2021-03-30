from PyQt5.QtCore import QAbstractListModel, Qt, pyqtSignal, pyqtSlot, QModelIndex

from datetime import date
import datetime

class RouteModel(QAbstractListModel):

    RouteIDRole = Qt.UserRole + 1
    NameRole = Qt.UserRole + 2
    DateRole = Qt.UserRole + 3
    AmountRole = Qt.UserRole + 4

    routeChanged = pyqtSignal()

    def __init__(self, dbMan, parent=None):
        super().__init__(parent)
        self.dbManager = dbMan
        self.routes = self.dbManager.get_routes()
#        [
#            {'name': 'jon', 'age': 20},
#            {'name': 'jane', 'age': 25}
#        ]

    def data(self, index, role=Qt.DisplayRole):
        row = index.row()
        if role == RouteModel.RouteIDRole:
            return self.routes[row]["route_id"]
        if role == RouteModel.NameRole:
            return self.routes[row]["name"]
        if role == RouteModel.DateRole:
            return self.routes[row]["date_of_creation"]
        if role == RouteModel.AmountRole:
            return self.routes[row]["amount"]

    def rowCount(self, parent=QModelIndex()):
        return len(self.routes)

    def roleNames(self):
        return {
            RouteModel.RouteIDRole: b'route_id',
            RouteModel.NameRole: b'name',
            RouteModel.DateRole: b'date',
            RouteModel.AmountRole: b'amount'
        }

    @pyqtSlot(str)
    def insertRoute(self, name):
        self.beginInsertRows(QModelIndex(), self.dbManager.count(), self.dbManager.count())
        self.dbManager.add_route(name, datetime.datetime.today(), 0)
        self.routes.append(self.dbManager.selectNewRoute(name))
        for str in self.routes:
            print(str)
        self.endInsertRows()

    @pyqtSlot(int, str, int)
    def editRoute(self, row, name, age):
        ix = self.index(row, 0)
        self.routes[row] = {'name': name, 'age': age}
        self.dataChanged.emit(ix, ix, self.roleNames())

    @pyqtSlot(int)
    def deleteRoute(self, row):
        self.beginRemoveColumns(QModelIndex(), row, row)
        self.dbManager.remove_route(self.routes[row]["route_id"])
        del self.routes[row]
        self.endRemoveRows()
