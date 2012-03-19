import QtQuick 1.1
import com.nokia.meego 1.1
import "../js/util.js" as Util

Page {
    orientationLock: PageOrientation.LockPortrait

    Image {
        source: "../images/heebo_logo.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.baseline: parent.top
        anchors.topMargin: 32
    }

    Grid {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10
        columns: 2

        MenuButton {
            text: "Create game"
            buttonImage: "../images/icon_newgame.png"
            pressedButtonImage: "../images/icon_newgame_pressed.png"
            onClicked: Util.openPage(pageStack, "CreateGame")
        }
        MenuButton {
            text: "Join game"
            buttonImage: "../images/icon_restart.png"
            pressedButtonImage: "../images/icon_restart_pressed.png"
            onClicked: Util.openPage(pageStack, "JoinGame")
        }

        MenuButton {
            text: "Help"
            buttonImage: "../images/icon_help.png"
            pressedButtonImage: "../images/icon_help_pressed.png"
            onClicked: Util.openPage(pageStack, "HelpPage")
        }
        MenuButton {
            text: "About"
            buttonImage: "../images/icon_about.png"
            pressedButtonImage: "../images/icon_about_pressed.png"
            onClicked: Util.openPage(pageStack, "AboutPage")
        }
    }
}
