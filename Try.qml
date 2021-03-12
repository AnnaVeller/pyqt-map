import QtQuick 2.0
import QtQuick.Controls 2.0

ApplicationWindow {
    id: root
    visible: true
    width: 600
    height: 382
    property int xPos
    property int yPos
    property int click_xPos: 0
    property int click_yPos: 0
    signal clicked(int xx, int yy)
    Image {
        id: rec
        source: "map.jpg"
        width: parent.width
        height: parent.height
    }
    MouseArea {
        anchors.fill: parent
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
}
