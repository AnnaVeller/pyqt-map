import QtQuick 2.8
import QtQuick.Controls 2.1

Popup {
    padding: 10
    property real lat: 0
    property real lon: 0
    signal delThis(real lat, real lon)
    id: popup
    x: 100
    y: 100
    anchors.centerIn: parent
    width: 300
    height: 100
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
            id: info1
            anchors.top: parent.top
            height: parent.height / 4
            width: parent.width
            text: "Широта: " + lat + " градусов"
        }
        Text {
            id: info2
            anchors.top: info1.bottom
            height: parent.height / 4
            width: parent.width
            text: "Долгота: " + lon + " градусов"
        }
        Button {
            text: "Удалить точку"
            anchors.top: info2.bottom
            height: parent.height / 2
            width: parent.width
            onClicked: {
                delThis(lat, lon)
            }
            background: Rectangle {
                color: "tomato"
                radius: 4
            }
        }
    }
}
