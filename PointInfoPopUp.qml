import QtQuick 2.8
import QtQuick.Controls 2.1

Popup {
    padding: 10
    property real lat: 0
    property real lon: 0
    property int num: 0
    property int route_id: 0
    property int thisIndexFromView: 0
    signal delThis(real lat, real lon, int oth_num)

    id: popup
    x: 100
    y: 100
    anchors.centerIn: parent
    width: 400
    height: 150
    modal: true
    focus: true
    closePolicy: Popup.CloseOnReleaseOutside
    visible: false
    signal removePoint()
    background: Rectangle {
        color: "oldlace"
        radius: 4
    }
    Rectangle{
        anchors.fill: parent
        color: "oldlace"
        Text {
            id: info00
            anchors.top: parent.top
            height: parent.height / 5
            width: parent.width
            text: "Имя маршрута: " + dbManager.getRouteName(route_id)
        }
        Text {
            id: info0
            anchors.top: info00.bottom
            height: parent.height / 5
            width: parent.width
            text: "Номер точки в маршруте: " + num
        }
        Text {
            id: info1
            anchors.top: info0.bottom
            height: parent.height / 5
            width: parent.width
            text: "Широта: " + lat + " градусов"
        }
        Text {
            id: info2
            anchors.top: info1.bottom
            height: parent.height / 5
            width: parent.width
            text: "Долгота: " + lon + " градусов"
        }
        Button {
            text: "Удалить точку"
            anchors.top: info2.bottom
            height: parent.height / 5
            width: parent.width
            onClicked: {
                                   // теперь удаляем из БД
                var new_amount_of_points = dbManager.getAmountOfPoints(route_id) - 1
                dbManager.updateAmountInRoutes(route_id, new_amount_of_points)               // уменьшаем на 1 кол-во точек в маршруте в БД
                routeModel.editAmountRouteInModel(thisIndexFromView, new_amount_of_points)   // уменьшаем на 1 кол-во точек в маршруте в ListView
                dbManager.remove_point(route_id, num)
                delThis(lat, lon, num)  // для удаления из ListView
//                info0.text =
            }
            background: Rectangle {
                color: "tomato"
                radius: 4
                opacity: 0.9
            }
        }
    }
}
