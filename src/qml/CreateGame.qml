import QtQuick 1.1
import "../js/util.js" as Util

FullPage {
    id: createGame
    FullPageText {
        id: titleText
        text: "CREATE GAME"
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

    // We need to wait a little to have this page added on page stack.
    Timer {
        repeat: false
        running: true
        onTriggered: opponent.waitForOpponent();
    }

    Connections {
        target: opponent
        onOpponentIsReady: Util.openPage(createGame.pageStack, "Game", true)
    }
}
