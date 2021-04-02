import QtQuick 2.0
import QtLocation 5.12
import QtLocation 5.6
import QtPositioning 5.6

MapQuickItem{
    id: marker
    property real lat: 0
    property real lon: 0
    property int num: 0
    property int route_id: 0
    property int thisIndexFromView: 0
    signal delThisPoint(real lat, real lon, int n)

    anchorPoint.x: marker.width / 4 + 10
    anchorPoint.y: marker.height - 2
    sourceItem: Image{
        id: icon
        source: "marker3.png"
        sourceSize.width: 40
        sourceSize.height: 40
        MouseArea {
            anchors.fill: icon
//            hoverEnabled: true
            onClicked: {
                console.log("Entered")
                var popupComponent = Qt.createComponent("PointInfoPopUp.qml")
                var popup = popupComponent.createObject(marker)
                popup.lat = lat
                popup.lon = lon
                popup.num = num
                popup.route_id = route_id
                popup.thisIndexFromView = thisIndexFromView
                function almostDel(lat, lon, n) {
                    console.log('2 этап удаления')
                    delThisPoint(lat, lon, n)
                    marker.enabled = false
                    marker.visible = false
                    popup.close()
                }
                popup.delThis.connect(almostDel)

                popup.open()
            }
        }
    }

}
