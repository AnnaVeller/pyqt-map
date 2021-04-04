import QtQuick 2.6
import QtQuick.Controls 2.2

import QtQuick.Window 2.14
import QtLocation 5.6
import QtPositioning 5.6

ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 400
    minimumWidth: 700
    minimumHeight: 200

    property var index_r_id: []

    Rectangle {
        id: rect
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: parent.width
        height: parent.height-40
        color: "oldlace"

        ListView {
            id: listExample
            anchors.fill: rect
            anchors.margins: 10
            spacing: 10
            model: routeModel
            delegate:
                Rectangle {
                    width: rect.width-20
                    height: 60
                    color: "linen"
                    border.color: "pink"
                    radius: 4
                    Component.onCompleted: {
                        index_r_id.push({ind: index, r_id: route_id})
                    }
                    Row {
                        anchors.left: parent.left
                        width: parent.width - 20
                        anchors.leftMargin: 1
                        height: 60
                        anchors.horizontalCenter: parent.horizontalCenter
//                        spacing: 5
                        Rectangle{
                            width: (parent.width-80) / 8
                            anchors.verticalCenter: parent.verticalCenter
                            height: 18
                            color: "linen"
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: route_id
                                color: "maroon"
                            }
                        }
                        Rectangle {
                            width: (parent.width-80) / 2
                            anchors.verticalCenter: parent.verticalCenter
                            height: 18
                            color: "linen"
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: name
                                color: "maroon"
                            }
                        }
                        Rectangle {
                            width: (parent.width-80) / 4
                            anchors.verticalCenter: parent.verticalCenter
                            height: 18
                            color: "linen"
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: date
                                color: "maroon"
                            }
                        }
                        Rectangle {
                            width: (parent.width-80) / 8
                            anchors.verticalCenter: parent.verticalCenter
                            height: 18
                            color: "linen"
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: amount
                                color: "maroon"
                            }
                        }
                        Column {
                            width: 80
                            height: 52.5
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Button{                      //                                 <--       здесь когда-нибудь будет кнопка для переименования маршрута
                                id: changeNameBut
                                width: 76
                                height: 15
                                text: "Переим."
                                onClicked: {
                                    var popupComponent = Qt.createComponent("ChangeRouteNamePopUp.qml")
                                    var popup = popupComponent.createObject(listExample)
                                    popup.r_id = route_id
                                    popup.r_name = name
                                    popup.r_index = index
                                    popup.open()
                                }
                                background: Rectangle {
                                    color: "burlywood"
                                    radius: 4
                                    opacity: 0.9
                                }
                            }
                            Button{
                                id: changeBut
                                width: 76
                                height: 15
                                text: "Карта"
                                onClicked: {
                                    root.openMap(index)                    // нужно передать index!
                                    listExample.enabled = false
                                }
                                background: Rectangle {
                                    color: "lightblue"
                                    radius: 4
                                    opacity: 0.9
                                }
                            }
                            Button{
                                id: delBut
                                width: 76
                                height: 15
                                text: "Удалить"
                                onClicked: routeModel.deleteRoute(index)
                                background: Rectangle {
                                    color: "tomato"
                                    radius: 4
                                    opacity: 0.9
                                }
                            }
                        }
                    }
                }
        }
        Rectangle {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.rightMargin: 50
            opacity: 0.5
            height: 50
            width: 450
            radius: 4
            border.color: "gray"
            color: "whitesmoke"
            Row {
                width: parent.width - 30
                height: 50
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text: "Введите имя:"
                    height: 15
                    anchors.verticalCenter: parent.verticalCenter
                }
                TextField{
                    id: nameField
                    width: 220
                    height: 25
                    placeholderText: qsTr("Введите имя нового маршрута")
                    anchors.verticalCenter: parent.verticalCenter
                }
                Button {
                    id: but
                    width: 100
                    height: 25
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Добавить"
                    onClicked: {
                        console.log("Попытка добавить маршрут: ",nameField.text)
                        if (routeModel.isUniqueName(nameField.text)) {
                            routeModel.insertRoute(nameField.text)
                            console.log("Такого имени еще нет - добавили")
                        }
                        else {
//                            nameField.selectAll()
                            nameField.clear()
                        }

                    }
                    background: Rectangle {
                        color: "darkseagreen"
                        radius: 4
                    }
                }
            }
        }
        Rectangle {
            id: labelRect
            anchors.bottom: parent.top
            anchors.right: parent.right
            width: parent.width
            height: 50
            color: "oldlace"
            Rectangle{
                anchors.left: parent.left
                anchors.top: parent.top
                height: 35
                anchors.leftMargin: 10
                anchors.topMargin: 15
                width: parent.width - 100
                Row {
                    anchors.fill: parent
                    Rectangle {
                        height: parent.height
                        width: parent.width/8
                        color: "oldlace"
                        Text {
                            id: label1
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "ID маршрута \n      из БД"
                        }
                    }
                    Rectangle {
                        height: parent.height
                        width: parent.width/2
                        color: "oldlace"
                        Text {
                            id: label2
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Имя маршрута"
                        }
                    }
                    Rectangle {
                        height: parent.height
                        width: parent.width/4
                        color: "oldlace"
                        Text {
                            id: label3
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Дата создания"
                        }
                    }
                    Rectangle {
                        color: "oldlace"
                        height: parent.height
                        width: parent.width/8
                        Text {
                            id: label4
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Количество \n      точек"
                        }
                    }
                }
            }
        }
    }

    function openMap(index) {
        var Component = Qt.createComponent("MyMap.qml")
        var item = Component.createObject(root)
        console.log("Открыли карту: index=", index, " route_id=", index_r_id[index].r_id)        // route.route_id = index_r_id[index].r_id
        item.thisRouteID = index_r_id[index].r_id
        item.thisIndexFromView = index
        var amountOfPoints = dbManager.getAmountOfPoints(index_r_id[index].r_id)                 // route.amount = amountOfPoints
        console.log("Количество точек в бд =", amountOfPoints)
        for (var i = 1; i < amountOfPoints+1; i++) {
            if (i === 1) {
                item.defaultLat = dbManager.getLatFromRouteByNumber(index_r_id[index].r_id, i)
                item.defaultLon = dbManager.getLonFromRouteByNumber(index_r_id[index].r_id, i)
            }
            if (i === amountOfPoints) {
                item.addMarker(dbManager.getLatFromRouteByNumber(index_r_id[index].r_id, i), dbManager.getLonFromRouteByNumber(index_r_id[index].r_id, i), i, true, true)
            } else {
                item.addMarker(dbManager.getLatFromRouteByNumber(index_r_id[index].r_id, i), dbManager.getLonFromRouteByNumber(index_r_id[index].r_id, i), i, true, false)
            }

            console.log("lat=", dbManager.getLatFromRouteByNumber(index_r_id[index].r_id, i), "lon=", dbManager.getLonFromRouteByNumber(index_r_id[index].r_id, i))
        }
        item.closing.connect(enebledBut)
    }

    function enebledBut() {
        listExample.enabled = true
        console.log("Закрыли карту")
    }
}
