Rectangle {
    id:rec_main
    width: 300; height: 300
    color:"#fff"
    radius: 7

    Rectangle {
        id:rec_green
        width: 150; height: 150
        color:"green"
        radius: 7
        border.color: "#0000FF"
        border.width: 5
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: helloText
            text: "Hello world!"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 10; font.bold: true
        }
    }
}