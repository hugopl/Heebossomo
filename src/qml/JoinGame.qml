import QtQuick 1.1
import QtMobility.connectivity 1.2

import "../js/constants.js" as Constants
import "../js/util.js" as Util

FullPage {
    FullPageText {
        id: titleText
        text: "JOIN GAME"
        style: "header"

        anchors.top: parent.top
    }

    FullPageText {
        id: topic
        text: "Find a opponent!"
        style: "title"
        anchors.top: titleText.bottom
    }

    FullPageText {
        id: text1
        text: "Tap your phone with other NFC enable phone to start to play!"
        anchors.top: topic.bottom
    }


    BluetoothDiscoveryModel {
        id: btModel
        minimalDiscovery: true
//      onDiscoveryChanged: busy.running = discovery;
//        onNewServiceDiscovered: console.log("Found new service " + service.deviceAddress + " " + service.deviceName + " " + service.serviceName);
    }

    function getRandomIcon()
    {
        var icons = ["circle.png", "square.png", "triangle_up.png", "triangle_down.png", "polygon.png"];
        return "../images/" + icons[Math.floor(Math.random()*(icons.length-1))];
    }

//    ListModel {
//        id: btModel

//        ListElement {
//        }
//    }

    Component {
        id: btDelegate
        Item {
            width: parent.width
            height: 80
            Row {
                Image {
                    id: icon
                    source: getRandomIcon()
                    smooth: true
                }

                Text {
                    font.pixelSize: 32
                    font.bold: true
//                    text: "hugonoote"
                    text: service.deviceName
                    anchors.verticalCenter: icon.verticalCenter
                    anchors.leftMargin: 32
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: opponent.connectToServer(service.deviceAddress)
//                onClicked: opponent.connectToServer("00:15:83:3D:0A:57")
            }
        }
    }

    ListView {
        id: mainList
        width: parent.width - 50
        anchors.topMargin: 30
        anchors.top: text1.bottom
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.bottom: parent.bottom
        model: btModel
        delegate: btDelegate
        focus: true
        clip: true
    }

    Connections {
        target: opponent
        onOpponentIsReady: Util.openPage(pageStack, "Game", true)
    }
}
