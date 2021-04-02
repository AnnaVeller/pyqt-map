import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Window 2.14
import QtLocation 5.6
import QtPositioning 5.6

Window {
    id: root
    visible: true
    width: 600
    height: 600
    minimumWidth: 300
    minimumHeight: 300
    property int xPos
    property int yPos
    property int click_xPos: 0
    property int click_yPos: 0
    property int mynumber: 3

    property var myMarkers: []

    signal clicked(int xx, int yy)

    property int thisRouteID: 0
    property int thisIndexFromView: 0

    function addMarker(latitude, longitude, pointNumber, fromBD)
    {
        var Component = Qt.createComponent("MyMarker.qml")
        var item = Component.createObject(mapRect, {coordinate: QtPositioning.coordinate(latitude, longitude)})

        item.lat = latitude
        item.lon = longitude
        item.num = pointNumber
        item.route_id = thisRouteID
        item.thisIndexFromView = thisIndexFromView

        function finallyDelete(lat, lon, other_num) {
            console.log('3 этап удаления')
            routeline.removeCoordinate(QtPositioning.coordinate(lat, lon))

            console.log('удалили: ', other_num)

//            for (var i = 0; i < myMarkers.length; i++) {
//                if (myMarkers[i].num === other_num) {
////                    myMarkers[i].destroy()
//                    delete myMarkers[i]
//                }
//            }

            for (var i = 0; i < myMarkers.length; i++) {
                console.log("myMarkers: i=", i, "myMarkers.num=", myMarkers[i].num)
                if (myMarkers[i].num > other_num) {
                    myMarkers[i].num = myMarkers[i].num - 1
                    console.log("myMarkers: i=", i, "myMarkers.num=", myMarkers[i].num)
                }
            }
        }
        item.delThisPoint.connect(finallyDelete)
        myMarkers.push(item)

        map.addMapItem(item)                                                   // (добавили метку на карту)
        console.log("add fucking marker")
        routeline.addCoordinate(QtPositioning.coordinate(latitude, longitude)) // (добавили линию)

        if (fromBD === false)
        {
            console.log("Добавили новую метку через интерфейс (сейчас запишем в БД)")
            dbManager.add_point(pointNumber, latitude, longitude, thisRouteID)
            dbManager.updateAmountInRoutes(thisRouteID, pointNumber)
            routeModel.editAmountRouteInModel(thisIndexFromView, pointNumber)
        }


        routeModel.justPrint(thisRouteID)
        dbManager.justPrint(thisRouteID)
    }

    Rectangle {
        id: mapRect
        anchors.fill: parent

        Plugin {
            id: mapPlugin
            name: /*"osm"*/ "mapboxgl"/*, "esri", ...*/
        }

        Map {
            id: map
            anchors.fill: parent
            plugin: mapPlugin
            center: QtPositioning.coordinate(55.75222, 37.61556) // координаты Москвы
            zoomLevel:10
            MapPolyline {
                id: routeline
                line.width: 3
                line.color: 'red'
                path: []
            }
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            hoverEnabled: true
            onPositionChanged: {
                xPos=mouse.x
                yPos=mouse.y
            }
            onClicked: {
                console.log('latitude = '+ (map.toCoordinate(Qt.point(mouse.x,mouse.y)).latitude),
                                                   'longitude = '+ (map.toCoordinate(Qt.point(mouse.x,mouse.y)).longitude));
                root.addMarker(map.toCoordinate(Qt.point(mouse.x,mouse.y)).latitude, map.toCoordinate(Qt.point(mouse.x,mouse.y)).longitude, dbManager.getAmountOfPoints(thisRouteID)+1, false)
//                root.clicked(mouse.x, mouse.y)  // emit the parent's signal
                click_xPos=mouse.x
                click_yPos=mouse.y
            }
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
        text: map.toCoordinate(Qt.point(xPos,xPos)).latitude.toFixed(4)
    }
    Text {
        id: y
        anchors.left: yName.right
        anchors.top: x.bottom
        text: map.toCoordinate(Qt.point(xPos,xPos)).longitude.toFixed(4)
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
        text: map.toCoordinate(Qt.point(click_xPos,click_yPos)).latitude.toFixed(4)
    }
    Text {
        id: click_y
        anchors.left: click_yName.right
        anchors.top: click_x.bottom
        text: map.toCoordinate(Qt.point(click_xPos,click_yPos)).longitude.toFixed(4)
    }
}
