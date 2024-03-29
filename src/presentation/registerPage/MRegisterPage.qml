import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import CustomComponents
import Librum.controllers
import Librum.style
import Librum.icons
import Librum.globals
import Librum.fonts

MFlickWrapper {
    id: root
    contentHeight: Window.height < layout.implicitHeight ? layout.implicitHeight : Window.height

    // Passing the focus to nameInput on Component.onCompleted() causes it
    // to pass controll back to root for some reason, this fixes the focus problem
    onActiveFocusChanged: if (activeFocus)
                              nameInput.giveFocus()

    Page {
        id: page
        anchors.fill: parent
        bottomPadding: 16
        background: Rectangle {
            color: Style.colorAuthenticationPageBackground
        }

        Shortcut {
            id: registerShortcut
            sequence: "Ctrl+Return"
            onActivated: internal.registerUser()
        }

        Connections {
            id: authenticationControllerConnections
            target: AuthController

            function onRegistrationFinished(errorCode, message) {
                internal.proccessRegistrationResult(errorCode, message)
            }

            function onEmailConfirmationCheckFinished(confirmed) {
                internal.processEmailConfirmationResult(confirmed)
            }
        }

        ColumnLayout {
            id: layout
            width: 543
            anchors.centerIn: parent

            Pane {
                id: background
                Layout.fillWidth: true
                topPadding: 48
                bottomPadding: 36
                horizontalPadding: 52
                background: Rectangle {
                    color: Style.colorContainerBackground
                    radius: 5
                }

                ColumnLayout {
                    id: contentLayout
                    width: parent.width
                    spacing: 0

                    MLogo {
                        id: logo
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Label {
                        id: welcomeText
                        Layout.topMargin: 24
                        Layout.alignment: Qt.AlignHCenter
                        color: Style.colorText
                        text: qsTr("Welcome!")
                        font.bold: true
                        font.pointSize: Fonts.size26
                    }

                    Label {
                        id: accountStorageText
                        Layout.fillWidth: true
                        Layout.topMargin: 8
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("Your credentials are only used to authenticate yourself. Everything will be stored in a secure database.")
                        font.pointSize: Fonts.size13
                        color: Style.colorSubtitle
                        wrapMode: Text.WordWrap
                    }

                    Pane {
                        id: credentialInputContainer
                        Layout.fillWidth: true
                        Layout.topMargin: 38
                        Layout.alignment: Qt.AlignHCenter
                        verticalPadding: 0
                        horizontalPadding: 20
                        background: Rectangle {
                            color: "transparent"
                        }

                        ColumnLayout {
                            id: inputLayout
                            width: parent.width
                            spacing: 0

                            MLabeledInputBox {
                                id: nameInput
                                Layout.fillWidth: true
                                headerText: qsTr("Name")
                                placeholderContent: "Kai Doe"
                                placeholderColor: Style.colorPlaceholderText

                                onEdited: internal.clearLoginError()
                                Keys.onPressed: event => internal.moveFocusToNextInput(
                                                    event, null, emailInput)
                            }

                            MLabeledInputBox {
                                id: emailInput
                                Layout.fillWidth: true
                                Layout.topMargin: 19
                                headerText: qsTr("Email")
                                placeholderContent: "kaidoe@gmail.com"
                                placeholderColor: Style.colorPlaceholderText

                                onEdited: internal.clearLoginError()
                                Keys.onPressed: event => internal.moveFocusToNextInput(
                                                    event, nameInput,
                                                    passwordInput)
                            }

                            MLabeledInputBox {
                                id: passwordInput
                                Layout.fillWidth: true
                                Layout.topMargin: 16
                                headerText: qsTr("Password")
                                placeholderColor: Style.colorPlaceholderText
                                image: Icons.eyeOn
                                toggledImage: Icons.eyeOff

                                onEdited: internal.clearLoginError()
                                Keys.onPressed: event => internal.moveFocusToNextInput(
                                                    event, emailInput,
                                                    acceptPolicy)
                            }

                            Label {
                                id: generalErrorText
                                Layout.topMargin: 8
                                visible: false
                                color: Style.colorErrorText
                            }

                            MAcceptPolicy {
                                id: acceptPolicy
                                Layout.fillWidth: true
                                Layout.topMargin: 24

                                onKeyUp: passwordInput.giveFocus()
                                onKeyDown: registerButton.giveFocus()
                            }

                            MButton {
                                id: registerButton
                                Layout.fillWidth: true
                                Layout.preferredHeight: 40
                                Layout.topMargin: 46
                                borderWidth: 0
                                backgroundColor: Style.colorBasePurple
                                fontSize: Fonts.size12
                                opacityOnPressed: 0.85
                                textColor: Style.colorFocusedButtonText
                                fontWeight: Font.Bold
                                text: qsTr("Let's start")

                                onClicked: internal.registerUser()
                                onFocusChanged: {
                                    if (focus)
                                        opacity = opacityOnPressed
                                    else
                                        opacity = 1
                                }

                                Keys.onReturnPressed: internal.registerUser()
                                Keys.onUpPressed: acceptPolicy.giveFocus()
                            }
                        }
                    }
                }
            }

            Label {
                id: loginRedirectionLabel
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 14
                text: qsTr("Already have an account? Login")
                font.pointSize: Fonts.size10dot5
                opacity: loginRedirecitonLinkArea.pressed ? 0.8 : 1
                color: Style.colorBasePurple

                MouseArea {
                    id: loginRedirecitonLinkArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: loadPage(loginPage)
                }
            }
        }

        Component.onCompleted: nameInput.giveFocus()
    }

    MWarningPopup {
        id: confirmEmailPopup
        x: Math.round(
               root.width / 2 - implicitWidth / 2 - page.horizontalPadding)
        y: Math.round(
               root.height / 2 - implicitHeight / 2 - page.topPadding - 65)
        visible: false
        singleButton: true
        messageBottomSpacing: 12
        title: qsTr("Confirm Your Email")
        message: qsTr("You're are almost ready to go!\nConfirm your email by clicking the link we sent you.")
        leftButtonText: qsTr("Resend")

        onOpened: fetchEmailConfirmationTimer.start()
        onLeftButtonClicked: console.log("resend!")

        Timer {
            id: fetchEmailConfirmationTimer
            interval: 3000
            repeat: true

            onTriggered: AuthController.checkIfEmailConfirmed(emailInput.text)
        }
    }

    QtObject {
        id: internal

        function registerUser() {
            if (!policyIsAccepted())
                return

            registerButton.loading = true
            AuthController.registerUser(nameInput.text, emailInput.text,
                                        passwordInput.text,
                                        acceptPolicy.checked)
        }

        function policyIsAccepted() {
            if (acceptPolicy.activated)
                return true

            acceptPolicy.setError()
            return false
        }

        function proccessRegistrationResult(errorCode, message) {
            registerButton.loading = false

            if (errorCode === ErrorCode.NoError) {
                confirmEmailPopup.open()
                confirmEmailPopup.giveFocus()
            } else {
                internal.setRegistrationErrors(errorCode, message)
            }
        }

        function processEmailConfirmationResult(confirmed) {
            if (confirmed) {
                confirmEmailPopup.close()
                fetchEmailConfirmationTimer.stop()
                loadPage(loginPage)
            }
        }

        function setRegistrationErrors(errorCode, message) {
            switch (errorCode) {
            case ErrorCode.UserWithEmailAlreadyExists:
                // Fall through
            case ErrorCode.InvalidEmailAddressFormat:
                // Fall through
            case ErrorCode.EmailAddressTooShort:
                // Fall through
            case ErrorCode.EmailAddressTooLong:
                // Fall through
                emailInput.errorText = message
                emailInput.setError()
                break
            case ErrorCode.PasswordTooShort:
                // Fall through
            case ErrorCode.PasswordTooLong:
                passwordInput.errorText = message
                passwordInput.setError()
                break
            case ErrorCode.NameTooShort:
                nameInput.errorText = message
                nameInput.setError()
                break
            case ErrorCode.NameTooLong:
                nameInput.errorText = message
                nameInput.setError()
                break
            default:
                generalErrorText.text = message
                generalErrorText.visible = true
            }
        }

        function clearLoginError() {
            nameInput.clearError()
            emailInput.clearError()
            passwordInput.clearError()

            generalErrorText.visible = false
            generalErrorText.text = ""
        }

        // Navigates to the next or previous item, depending on user input
        function moveFocusToNextInput(event, previous, next) {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Down) {
                if (next)
                    next.giveFocus()
            } else if (event.key === Qt.Key_Up) {
                if (previous)
                    previous.giveFocus()
            }
        }
    }
}
