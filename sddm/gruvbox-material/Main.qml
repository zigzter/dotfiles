import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: bg0

    readonly property color bg0: "#282828"
    readonly property color bg1: "#3c3836"
    readonly property color bg2: "#504945"
    readonly property color fg0: "#ebdbb2"
    readonly property color fg3: "#a89984"
    readonly property color fg4: "#7c6f64"
    readonly property color red: "#fb4934"
    readonly property color green: "#b8bb26"
    readonly property color yellow: "#fabd2f"
    readonly property color aqua: "#8ec07c"
    readonly property color orange: "#fe8019"

    readonly property real overlayOpacity: config.overlayOpacity ? parseFloat(config.overlayOpacity) : 0.55

    FontLoader { id: monoFont; source: "fonts/JetBrainsMonoNerdFontMono-Regular.ttf" }
    FontLoader { id: monoFontBold; source: "fonts/JetBrainsMonoNerdFontMono-Bold.ttf" }

    TextConstants { id: textConstants }

    property int sessionIndex: sessionCombo.index

    signal tryLogin()
    onTryLogin: sddm.login(usernameBox.text, passwordBox.text, sessionIndex)

    Connections {
        target: sddm
        onLoginSucceeded: {
            statusText.color = green
            statusText.text = textConstants.loginSucceeded
            statusFade.restart()
        }
        onLoginFailed: {
            statusText.color = red
            statusText.text = textConstants.loginFailed
            passwordBox.text = ""
            statusFade.restart()
        }
    }

    // Background, tiled across every connected screen
    Repeater {
        model: screenModel
        Item {
            x: geometry.x
            y: geometry.y
            width: geometry.width
            height: geometry.height

            Image {
                anchors.fill: parent
                source: config.background
                fillMode: Image.PreserveAspectCrop
            }

            Rectangle {
                anchors.fill: parent
                color: bg0
                opacity: overlayOpacity
            }
        }
    }

    // Clock
    Column {
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.14
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4

        Text {
            id: clockTime
            anchors.horizontalCenter: parent.horizontalCenter
            color: fg0
            font.family: monoFontBold.name
            font.pixelSize: 64
            font.bold: true
        }

        Text {
            id: clockDate
            anchors.horizontalCenter: parent.horizontalCenter
            color: fg3
            font.family: monoFont.name
            font.pixelSize: 16
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date()
            clockTime.text = Qt.formatDateTime(now, "HH:mm")
            clockDate.text = Qt.formatDateTime(now, "dddd, d MMMM")
        }
    }

    // Login form
    Column {
        id: loginForm
        anchors.centerIn: parent
        spacing: 14
        width: 300

        Text {
            text: "  " + textConstants.userName
            color: fg4
            font.family: monoFont.name
            font.pixelSize: 12
        }

        TextBox {
            id: usernameBox
            width: parent.width
            height: 38
            radius: 6
            color: "transparent"
            borderColor: bg2
            focusColor: aqua
            hoverColor: fg4
            textColor: fg0
            font.family: monoFont.name
            font.pixelSize: 15
            text: userModel.lastUser

            KeyNavigation.tab: passwordBox
        }

        Text {
            text: "  " + textConstants.password
            color: fg4
            font.family: monoFont.name
            font.pixelSize: 12
        }

        PasswordBox {
            id: passwordBox
            width: parent.width
            height: 38
            radius: 6
            color: "transparent"
            borderColor: bg2
            focusColor: aqua
            hoverColor: fg4
            textColor: fg0
            tooltipBG: bg1
            tooltipFG: yellow
            font.family: monoFont.name
            font.pixelSize: 15

            KeyNavigation.tab: loginButton

            Keys.onPressed: {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    root.tryLogin()
                    event.accepted = true
                }
            }
        }

        Item {
            width: parent.width
            height: 26

            Text {
                id: statusText
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                font.family: monoFont.name
                font.pixelSize: 12
                opacity: 0
            }

            SequentialAnimation {
                id: statusFade
                NumberAnimation { target: statusText; property: "opacity"; from: 0; to: 1; duration: 150 }
                PauseAnimation { duration: 2500 }
                NumberAnimation { target: statusText; property: "opacity"; from: 1; to: 0; duration: 400 }
            }

            Text {
                id: loginButton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: textConstants.login + "  "
                color: loginArea.containsMouse || loginButton.activeFocus ? aqua : fg3
                font.family: monoFont.name
                font.pixelSize: 14

                Behavior on color { ColorAnimation { duration: 100 } }

                MouseArea {
                    id: loginArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.tryLogin()
                }

                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        root.tryLogin()
                        event.accepted = true
                    }
                }
            }
        }
    }

    // Bottom bar
    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 24
        height: 32

        Text {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: sddm.hostName
            color: fg4
            font.family: monoFont.name
            font.pixelSize: 12
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: textConstants.session
                color: fg4
                font.family: monoFont.name
                font.pixelSize: 12
            }

            ComboBox {
                id: sessionCombo
                width: 170
                height: 30
                anchors.verticalCenter: parent.verticalCenter

                model: sessionModel
                index: sessionModel.lastIndex

                color: "transparent"
                borderColor: bg2
                focusColor: aqua
                hoverColor: fg4
                textColor: fg0
                menuColor: bg1
                arrowColor: "transparent"

                font.family: monoFont.name
                font.pixelSize: 13

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 9
                    anchors.verticalCenter: parent.verticalCenter
                    text: ""
                    color: fg3
                    font.family: monoFont.name
                    font.pixelSize: 10
                }
            }
        }

        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 18

            Text {
                text: ""
                color: shutdownArea.containsMouse ? red : fg4
                font.family: monoFont.name
                font.pixelSize: 18
                Behavior on color { ColorAnimation { duration: 100 } }

                MouseArea {
                    id: shutdownArea
                    anchors.fill: parent
                    anchors.margins: -6
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: sddm.powerOff()
                }
            }

            Text {
                text: ""
                color: rebootArea.containsMouse ? orange : fg4
                font.family: monoFont.name
                font.pixelSize: 18
                Behavior on color { ColorAnimation { duration: 100 } }

                MouseArea {
                    id: rebootArea
                    anchors.fill: parent
                    anchors.margins: -6
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: sddm.reboot()
                }
            }

            Text {
                visible: sddm.canSuspend
                text: ""
                color: suspendArea.containsMouse ? aqua : fg4
                font.family: monoFont.name
                font.pixelSize: 18
                Behavior on color { ColorAnimation { duration: 100 } }

                MouseArea {
                    id: suspendArea
                    anchors.fill: parent
                    anchors.margins: -6
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: sddm.suspend()
                }
            }
        }
    }

    Component.onCompleted: {
        if (usernameBox.text === "")
            usernameBox.focus = true
        else
            passwordBox.focus = true
    }
}
