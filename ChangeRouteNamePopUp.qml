import QtQuick 2.8
import QtQuick.Controls 2.1

Popup {
    padding: 10
    id: popup
    x: 100
    y: 100
    anchors.centerIn: parent
    width: 400
    height: 100
    modal: true
    focus: true
    closePolicy: Popup.CloseOnReleaseOutside
    visible: false
    property int r_id: 0
    property int r_index: 0
    property string r_name: ""
    background: Rectangle {
        color: "oldlace"
        radius: 4
    }
    Rectangle{
        anchors.fill: parent
        color: "oldlace"
        TextField{
            id: nameField
            placeholderText: qsTr("Введите новое имя маршрута")
            anchors.top: parent.top
            height: parent.height / 2
            width: parent.width
        }
        Button {
            id: but
            anchors.top: nameField.bottom
            height: parent.height / 2
            width: parent.width
            text: "Переименовать"
            onClicked: {
                console.log("Кнопка Переименовать была нажата, имя:",nameField.text)
                if (routeModel.isUniqueName(nameField.text)) {
                    dbManager.updateRouteName(r_id, nameField.text)
                    routeModel.editNameRouteInModel(r_index, nameField.text)
                    popup.close()
                    console.log("Такого имени еще нет - добавили")
                }
                else {
                    nameField.clear()
                }
            }
            background: Rectangle {
                color: "burlywood"
                radius: 4
            }
        }
    }
}
