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
    height: 382
    minimumWidth: 400
    minimumHeight: 200
    property int xPos
    property int yPos
    property int click_xPos: 0
    property int click_yPos: 0
    property int mynumber: 3
    signal clicked(int xx, int yy)
    Rectangle {
        id: mapRect
        anchors.left: parent.left
        width: parent.width-450
        height: parent.height

        Plugin {
            id: mapPlugin
            name: /*"osm"*/ "mapboxgl"/*, "esri", ...*/
            // specify plugin parameters if necessary
            // PluginParameter {
            //     name:
            //     value:
            // }
        }



        Map {
            anchors.fill: parent
            plugin: mapPlugin
            center: QtPositioning.coordinate(55.75222, 37.61556) // координаты Москвы
            zoomLevel:10
        }
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            hoverEnabled: true
            onPositionChanged: {
                xPos=mouse.x
                yPos=mouse.y
            }
            onClicked: {
                root.clicked(mouse.x, mouse.y)  // emit the parent's signal
                click_xPos=mouse.x
                click_yPos=mouse.y
            }
        }
    }
    Rectangle {
        id: rect
        anchors.left: mapRect.right
        width: 450
        height: parent.height
        color: "lightgrey"

        ListView {
            id: listExample
            anchors.right: parent.right
            width: rect.width
            height: rect.height-25

            model: routeModel
            delegate:
                Item {
                width: rect.width
                height: 60
                Row {
                    Text {
                        width: rect.width-20
                        text: "ID:" + route_id + " NAME: " + name + " DATE: " + date + " AMOUNT: " + amount
                        horizontalAlignment: Text.AlignHCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
    //                Button{
    //                    width: 20
    //                    text: "+"
    //                    onClicked: routeModel.editRoute(index, name, age+1)
    //                }
    //                Button{
    //                    width: 20
    //                    text: "-"
    //                    onClicked: routeModel.editRoute(index, name, age-1)
    //                }
                    Button{
                        width: 20
                        text: "X"
                        onClicked: routeModel.deleteRoute(index)
                    }
                }
            }
        }
        Text {
            text: "Введите имя: "
            anchors.right: nameField.left
            anchors.bottom: parent.bottom
            height: 25
        }


        TextField{
            id: nameField
            width: 150
            height: 25
            anchors.right: but.left
            anchors.bottom: parent.bottom
        }

        Button {
            id: but
            width: 50
            height: 25
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            text: "add"
            onClicked: {

                console.log("Кнопка add была нажата, имя:",nameField.text)
                routeModel.insertRoute(nameField.text)
            }
        }
    }
//    Button {
//        id: countBut
//        height: 30
//        width: iii.width
//        anchors.top: iii.bottom
//        anchors.left: mapRect.right
//        text: qsTr("count")

//        onClicked: {
//            // Вызываем слот калькулятора, чтобы вычесть числа
//            db.count()
//        }
//    }

//    Image {
//        id: rec
//        source: "map.jpg"
//        width: parent.width
//        height: parent.height
//    }
    Text {
        id: xName
        text: 'x='
    }
    Text {
        id: yName
        anchors.top: xName.bottom
        text: 'y='
    }
    Text {
        id: x
        anchors.left: xName.right
        text: xPos
    }
    Text {
        id: y
        anchors.left: yName.right
        anchors.top: x.bottom
        text: yPos
    }
    Text {
        id: click_xName
        anchors.top: yName.bottom
        text: 'clicked x='
    }
    Text {
        id: click_yName
        anchors.top: click_xName.bottom
        text: 'clicked y='
    }
    Text {
        id: click_x
        anchors.left: click_xName.right
        anchors.top: y.bottom
        text: click_xPos
    }
    Text {
        id: click_y
        anchors.left: click_yName.right
        anchors.top: click_x.bottom
        text: click_yPos
    }
//    Text {
//       anchors.top: click_y.bottom
//       id: countOfRoutes
//       text: mynumber
//   }
    // Здесь забираем результат сложения или вычитания чисел
//    Connections {
//        target: db

//        // Обработчик сигнала сложения
//        onCountOfRoutes: {
//            // sum было задано через arguments=['sum']
////            countOfRoutes.text = count
//            mynumber = count
//        }

//    }
}
