import QtQuick 1.1

import "../js/constants.js" as Constants
import "../js/jewels.js" as Jewels

JewelPage {
    id: mainPage
    opacity: 0.5

    property bool isRunning: false
    signal animDone()
    signal jewelKilled();

    JewelDialog {
        id: okDialog
        anchors.centerIn: background
        z: 55
    }

    Item {
        id: background;
        width: parent.width
        anchors { top: parent.top; bottom: toolBar.top }

        MouseArea {
            id: gameMouseArea
            visible: false
            anchors.fill: parent
            onPressed: Jewels.mousePressed(mouse.x, mouse.y)
            onPositionChanged: if (pressed) Jewels.mouseMoved(mouse.x, mouse.y)
        }
    }

    Item {
        anchors.fill: parent
        id: counter
        property int value: 6

        Text {
            id: counterTextOdd
            anchors.centerIn: parent
            text: parent.value
            scale: 0
            Behavior on scale {
                NumberAnimation { duration: 1000; }
            }
        }
        Text {
            id: counterTextEven
            visible: !counterTextOdd.visible
            anchors.centerIn: parent
            text: parent.value
            scale: 0
            Behavior on scale {
                NumberAnimation { duration: 1000; }
            }
        }

        Timer {
            interval: 1000
            repeat: true
            running: true;
            onTriggered: {
                if (counter.value === 0) {
                    running = false;
                    counter.visible = false;
                    gameMouseArea.visible = true;
                    mainPage.opacity = 1
                } else {
                    counter.value--;
                    var isOdd = counter.value % 2;
                    counterTextOdd.visible = isOdd;
                    var visibleElem = isOdd ? counterTextOdd : counterTextEven;
                    var invisibleElem = isOdd ? counterTextEven : counterTextOdd;
                    invisibleElem.scale = 0;
                    visibleElem.scale = 40;
                    if (!counter.value) {
                        visibleElem.text = "Go!"
                    }
                }
            }
        }
    }

    ToolBar {
        id: toolBar

        Row {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 100
            }
            Text {
                text: "What to put here?"
                font.family: Constants.font_family
                font.pixelSize: Constants.fontsize_main
                color: Constants.color_uiaccent
            }
        }
//        Image {
//            id: menuButton
//            source: "qrc:///images/icon_menu.png"
//            width: 64; height: 64

//            anchors {
//                right: parent.right
//                verticalCenter: parent.verticalCenter
//                verticalCenterOffset: -40*mainPage.buttonOffset
//                rightMargin: 20
//            }

//            MouseArea {
//                anchors.fill: parent
//                onClicked: mainMenu.toggle()
//                onPressed: menuButton.source="qrc:///images/icon_menu_pressed.png"
//                onReleased: menuButton.source="qrc:///images/icon_menu.png"
//            }

//            Behavior on anchors.verticalCenterOffset {
//                SpringAnimation {
//                    epsilon: 0.25
//                    damping: 0.1
//                    spring: 3
//                }
//            }
//        }
    }

    Rectangle {
        id: tintRectangle
        anchors.fill: parent
        color: "#3399FF"
        opacity: 0.0
        visible: opacity > 0

        z: 10

        function show() {
            var colors = ["#3399FF", "#11FF00", "#7300E6", "#FF3C26",
                          "#B300B3" /*, "#FFD500"*/];

            tintRectangle.color = colors[Jewels.random(0,4)];
            tintRectangle.opacity = 0.65;
        }

        function hide() {
            tintRectangle.opacity = 0;
        }

        Behavior on opacity {
            SmoothedAnimation { velocity: 2.0 }
        }
    }

    Connections {
        target: opponent
        onUnclearBlock: Jewels.unclearBlock();
        onLockBlock: Jewels.lockBlock();
        onOpponentDisconnected: okDialog.show("Opponent disconnected!", 1);
        onYouLoose: okDialog.show("You loose!!", 2);
    }

    Component.onCompleted: {
        Jewels.init();
        animDone.connect(Jewels.onChanges);
        jewelKilled.connect(Jewels.onChanges);
        okDialog.closed.connect(dialogClosed);
        okDialog.opened.connect(tintRectangle.show);
//        mainMenu.toggle();
    }

    function dialogClosed(mode) {
        switch (mode) {
        case 1:
        case 2: // on case 2 the game would restart
            tintRectangle.hide();
            pageStack.pop();
            break;
        }
    }


}
