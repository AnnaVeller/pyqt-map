//import QtQuick 2.0
//import QtQuick.Controls 2.0

import QtQuick 2.6
import QtQuick.Controls 2.2

//import QtQuick 2.0
import QtQuick.Window 2.14
import QtLocation 5.6
import QtPositioning 5.6

ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 400
    minimumWidth: 600
    minimumHeight: 200

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "oldlace"

        ListView {
            id: listExample
            anchors.right: parent.right
            width: rect.width
            height: rect.height
            spacing: 5

            model: routeModel
            delegate:
                Rectangle {
                    width: rect.width
                    height: 60
                    color: "linen"
                    border.color: "pink"
                    Row {
                        width: parent.width - 6
                        height: 60
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 3
                        Text {
                            width: parent.width-86
                            anchors.verticalCenter: parent.verticalCenter
//                            anchors.horizontalCenter: parent.horizontalCenter
                            height: 18
                            text: "ID:" + route_id + " NAME: " + name + " DATE: " + date + " AMOUNT: " + amount
                            horizontalAlignment: Text.AlignHCenter
                        }
        //                Button{
        //                    width: 20
        //                    text: "+"
        //                    onClicked: routeModel.editRoute(index, name, age+1)
        //                }
                        Button{
                            width: 40
                            height: 40
                            anchors.verticalCenter: parent.verticalCenter
                            text: "*"
                            onClicked: {
                                root.openMap()
                            }
                            background: Rectangle {
                                color: "lightblue"
                                radius: 4
                            }
                        }
                        Button{
                            width: 40
                            height: 40
                            anchors.verticalCenter: parent.verticalCenter
                            text: "X"
                            onClicked: routeModel.deleteRoute(index)
                            background: Rectangle {
                                color: "tomato"
                                radius: 4
                            }
                        }
                    }
                }
        }
        Rectangle {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 30
            width: 350
            radius: 4
            border.color: "gray"
            color: "lightgray"
            Row {
                width: parent.width - 6
                height: 30
                spacing: 3
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text: "Введите имя: "
                    height: 15
                    anchors.verticalCenter: parent.verticalCenter
                }
                TextField{
                    id: nameField
                    width: 170
                    height: 25
                    anchors.verticalCenter: parent.verticalCenter
                }
                Button {
                    id: but
                    width: 80
                    height: 25
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Добавить"
                    onClicked: {

                        console.log("Кнопка add была нажата, имя:",nameField.text)
                        routeModel.insertRoute(nameField.text)
                    }
                    background: Rectangle {
                        color: "darkseagreen"
                        radius: 4
                    }
                }
            }
        }
    }

    function openMap() {
        var Component = Qt.createComponent("MyMap.qml")
        var item = Component.createObject(root)
    }
}
