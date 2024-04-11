import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import CustomComponents
import Librum.controllers
import Librum.style
import Librum.icons
import Librum.globals
import Librum.fonts

MFlickWrapper {
    id: root
    property alias pageCleanup: pageCleanup

    contentHeight: page.implicitHeight
    ScrollBar.vertical: ScrollBar {
        width: 10
        policy: "AlwaysOn"
    }

    Connections {
        target: UserController

        function onPasswordChangeFinished(success, reason) {
            if (success) {
                passwordInput.text = ""
                passwordConfirmationInput.text = ""
            } else {
                passwordInput.errorText = reason
                passwordInput.setError()
            }
        }
    }

    Page {
        id: page
        anchors.fill: parent
        horizontalPadding: 48
        topPadding: 64
        bottomPadding: 22
        background: Rectangle {
            anchors.fill: parent
            color: Style.colorPageBackground
        }

        Component.onCompleted: {
            UserController.syncWithServer()
        }

        Shortcut {
            id: saveSettings
            sequence: StandardKey.Save
            onActivated: root.saveAccountSettings()
        }

        ColumnLayout {
            id: layout
            width: parent.width
            spacing: 0

            RowLayout {
                id: titleRow
                Layout.fillWidth: true
                spacing: 0

                MTitle {
                    id: pageTitle
                    titleText: qsTr("Account")
                    descriptionText: UserController.name
                    titleSize: Fonts.size25
                    descriptionSize: Fonts.size13dot25
                }

                Item {
                    Layout.fillWidth: true
                }

                MButton {
                    id: saveButton
                    Layout.preferredHeight: 38
                    Layout.alignment: Qt.AlignBottom
                    horizontalMargins: 12
                    borderWidth: 0
                    backgroundColor: Style.colorBasePurple
                    text: qsTr("Save")
                    fontSize: Fonts.size12
                    fontWeight: Font.Bold
                    textColor: Style.colorFocusedButtonText
                    imagePath: Icons.checkWhite
                    imageSize: 14

                    onClicked: root.saveAccountSettings()
                }
            }

            Pane {
                id: profileBox
                Layout.fillWidth: true
                Layout.topMargin: 32
                topPadding: 25
                horizontalPadding: internal.boxPadding
                bottomPadding: 40
                background: Rectangle {
                    color: Style.colorContainerBackground
                    border.color: Style.colorContainerBorder
                    radius: 4
                    antialiasing: true
                }

                RowLayout {
                    id: profileLayout
                    property int horizontalSpacing: 32

                    anchors.fill: parent
                    spacing: 0

                    ColumnLayout {
                        id: profileInputLayout
                        Layout.maximumWidth: Math.round(
                                                 profileLayout.width
                                                 - profileLayout.horizontalSpacing) / 2
                        Layout.fillWidth: true
                        spacing: 0

                        Label {
                            id: profileTitle
                            text: qsTr("Profile")
                            color: Style.colorText
                            font.pointSize: Fonts.size16dot5
                            font.weight: Font.DemiBold
                        }

                        MLabeledInputBox {
                            id: nameInput
                            Layout.fillWidth: true
                            Layout.topMargin: 26
                            boxHeight: 40
                            headerText: qsTr("Name")
                            text: internal.unsavedChanges ? text : UserController.name
                            headerToBoxSpacing: 3
                            inputFontSize: Fonts.size13
                            borderWidth: 1
                            borderRadius: 4

                            onEdited: internal.unsavedChanges = true
                        }

                        MLabeledInputBox {
                            id: emailInput
                            Layout.fillWidth: true
                            Layout.topMargin: 18
                            boxHeight: 40
                            headerText: qsTr("Email")
                            text: internal.unsavedChanges ? text : UserController.email
                            headerToBoxSpacing: 3
                            inputFontSize: Fonts.size13
                            borderWidth: 1
                            borderRadius: 4
                            readOnly: true

                            onEdited: internal.unsavedChanges = true
                        }

                        MLabeledInputBox {
                            id: tier
                            Layout.fillWidth: true
                            Layout.topMargin: 18
                            boxHeight: 40
                            headerText: qsTr("Tier")
                            text: internal.unsavedChanges ? text : UserController.role
                            headerToBoxSpacing: 3
                            inputFontSize: Fonts.size13
                            borderWidth: 1
                            borderRadius: 4
                            readOnly: true

                            onEdited: internal.unsavedChanges = true
                        }
                    }

                    MSelectProfilePictureArea {
                        id: profilePictureArea
                        Layout.fillWidth: true
                        Layout.maximumWidth: 312
                        Layout.preferredHeight: 190
                        Layout.topMargin: 76
                        Layout.rightMargin: 40
                        Layout.leftMargin: 32

                        onCurrentImageChanged: {
                            // Make sure that if we DELETE the picture, and no profile picture exists,
                            // we say that there are no unsaved changes. The only situation where this happens,
                            // is when there is no picture, we add a current picture WITHOUT saving and
                            // then delete it again. Since nothing changed, we don't want to set unsavedChanges.
                            if (currentImage == "!"
                                    && UserController.profilePicture.length === 0) {
                                internal.unsavedChanges = false
                                return
                            }

                            internal.unsavedChanges = true
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }
                }
            }

            Pane {
                id: changePasswordBox
                Layout.fillWidth: true
                Layout.topMargin: 26
                topPadding: 24
                horizontalPadding: internal.boxPadding
                bottomPadding: 50
                background: Rectangle {
                    color: Style.colorContainerBackground
                    border.color: Style.colorContainerBorder
                    radius: 4
                    antialiasing: true
                }

                ColumnLayout {
                    id: passwordLayout
                    anchors.fill: parent
                    spacing: 0

                    Label {
                        id: passwordTitle
                        text: qsTr("Change password")
                        color: Style.colorText
                        font.pointSize: Fonts.size16dot5
                        font.weight: Font.DemiBold
                    }

                    RowLayout {
                        id: changePasswordInputLayout
                        Layout.fillWidth: true
                        spacing: profileLayout.horizontalSpacing
                        Layout.topMargin: 30

                        MLabeledInputBox {
                            id: passwordInput
                            Layout.fillWidth: true
                            boxHeight: 40
                            headerText: qsTr("Password")
                            headerToBoxSpacing: 3
                            inputFontSize: Fonts.size13
                            borderWidth: 1
                            borderRadius: 4
                            image: Icons.eyeOn
                            toggledImage: Icons.eyeOff

                            onEdited: {
                                internal.unsavedChanges = true

                                // Clear error for password confirmation input as well
                                passwordConfirmationInput.errorText = ""
                                passwordConfirmationInput.clearError()
                            }
                        }

                        MLabeledInputBox {
                            id: passwordConfirmationInput
                            Layout.fillWidth: true
                            boxHeight: 40
                            headerText: qsTr("Password confirmation")
                            headerToBoxSpacing: 3
                            inputFontSize: Fonts.size13
                            borderWidth: 1
                            borderRadius: 4
                            image: Icons.eyeOn
                            toggledImage: Icons.eyeOff

                            onEdited: {
                                internal.unsavedChanges = true

                                // Clear error for password input as well
                                passwordInput.errorText = ""
                                passwordInput.clearError()
                            }
                        }
                    }
                }
            }

            Pane {
                id: yourDataBox
                Layout.fillWidth: true
                Layout.topMargin: 26
                topPadding: 24
                horizontalPadding: internal.boxPadding
                bottomPadding: 38
                background: Rectangle {
                    color: Style.colorContainerBackground
                    border.color: Style.colorContainerBorder
                    radius: 4
                    antialiasing: true
                }

                ColumnLayout {
                    id: yourDataContentColumn
                    anchors.fill: parent
                    spacing: 0

                    Label {
                        id: yourDataTitle
                        text: qsTr("Your data")
                        color: Style.colorText
                        font.pointSize: Fonts.size16dot5
                        font.weight: Font.DemiBold
                    }

                    MLabeledCheckBox {
                        Layout.fillWidth: true
                        Layout.topMargin: 30
                        boxWidth: 21
                        boxHeight: 21
                        text: qsTr("Analyse your reading to make better recommendations")
                        fontSize: Fonts.size13
                        fontColor: Style.colorText
                        spacing: 12
                        checked: true

                        onClicked: internal.unsavedChanges = true
                    }

                    MLabeledCheckBox {
                        Layout.fillWidth: true
                        Layout.topMargin: 16
                        boxWidth: 21
                        boxHeight: 21
                        text: qsTr("Anonymously share information about the books you read to help us improve Librum")
                        fontSize: Fonts.size13
                        fontColor: Style.colorText
                        spacing: 12
                        checked: false

                        onClicked: internal.unsavedChanges = true
                    }

                    MLabeledCheckBox {
                        Layout.fillWidth: true
                        Layout.topMargin: 16
                        boxWidth: 21
                        boxHeight: 21
                        text: qsTr("Collect data on crashes so that we can prevent it from happening again")
                        fontSize: Fonts.size13
                        fontColor: Style.colorText
                        spacing: 12

                        onClicked: internal.unsavedChanges = true
                    }

                    MLabeledCheckBox {
                        Layout.fillWidth: true
                        Layout.topMargin: 16
                        boxWidth: 21
                        boxHeight: 21
                        text: qsTr("Collect data to display in your statistics")
                        fontSize: Fonts.size13
                        fontColor: Style.colorText
                        spacing: 12

                        onClicked: internal.unsavedChanges = true
                    }
                }
            }

            Pane {
                id: deleteAccount
                Layout.fillWidth: true
                Layout.topMargin: 26
                topPadding: 24
                horizontalPadding: internal.boxPadding
                bottomPadding: 38
                background: Rectangle {
                    color: Style.colorContainerBackground
                    border.color: Style.colorContainerBorder
                    radius: 4
                    antialiasing: true
                }

                ColumnLayout {
                    id: yourAccountColumn
                    anchors.fill: parent
                    spacing: 0

                    Label {
                        id: yourAccountTitle
                        text: qsTr("Your Account")
                        color: Style.colorText
                        font.pointSize: Fonts.size16dot5
                        font.weight: Font.DemiBold
                    }

                    MButton {
                        id: logOut
                        Layout.preferredWidth: 240
                        Layout.preferredHeight: 40
                        Layout.topMargin: 22
                        borderWidth: 2
                        borderColor: Style.colorButtonBorder
                        backgroundColor: "transparent"
                        opacityOnPressed: 0.7
                        text: qsTr("Logout")
                        textColor: Style.colorUnfocusedButtonText
                        fontWeight: Font.Bold
                        fontSize: Fonts.size12

                        onClicked: {
                            AuthController.logoutUser()
                            loadPage(loginPage)
                        }
                    }

                    MButton {
                        id: deleteButton
                        Layout.preferredWidth: 240
                        Layout.preferredHeight: 40
                        Layout.topMargin: 22
                        borderWidth: 2
                        borderColor: Style.colorErrorBorder
                        backgroundColor: "transparent"
                        opacityOnPressed: 0.7
                        text: qsTr("Delete Your Account")
                        textColor: Style.colorErrorText
                        fontWeight: Font.Bold
                        fontSize: Fonts.size12

                        onClicked: confirmAccountDeletionPopup.open()
                    }
                }
            }
        }
    }

    MConfirmAccountDeletionPopup {
        id: confirmAccountDeletionPopup
        x: Math.round(
               root.width / 2 - implicitWidth / 2 - settingsSidebar.width / 2 - sidebar.width / 2)
        y: Math.round(
               root.height / 2 - implicitHeight / 2 - (root.height > implicitHeight + 80 ? 80 : 0))
        visible: false

        onDeletionConfirmed: {
            UserController.deleteUser()
            LibraryController.deleteAllBooks()
            AuthController.logoutUser()
            loadPage(loginPage)
        }
    }

    MWarningPopup {
        id: unsavedChangesPopup
        x: Math.round(
               root.width / 2 - implicitWidth / 2 - settingsSidebar.width / 2 - sidebar.width / 2)
        y: Math.round(
               root.height / 2 - implicitHeight / 2 - (root.height > implicitHeight + 80 ? 80 : 0))
        visible: false
        title: qsTr("Whoops")
        message: qsTr("It looks like you forgot to save your changes, are you sure that you dont want to save them?")
        leftButtonText: qsTr("Save")
        rightButtonText: qsTr("Don't save")
        minButtonWidth: 180

        onOpenedChanged: if (opened)
                             unsavedChangesPopup.giveFocus()
        onDecisionMade: close()
        onLeftButtonClicked: root.saveAccountSettings()
        onRightButtonClicked: internal.unsavedChanges = false
    }


    /*
      Since MAccountPage can have unsaved change, it needs MPageCleanup to
      ensure correct saving of data on page switching.
      */
    MPageCleanup {
        id: pageCleanup
        savePageAction: () => {
                            if (internal.unsavedChanges) {
                                unsavedChangesPopup.open()
                                return true
                            }
                            return false
                        }

        savingPageFinishedSignal: unsavedChangesPopup.decisionMade
    }

    QtObject {
        id: internal
        property bool unsavedChanges: false
        property int boxPadding: 40

        function changePassword() {
            if (passwordInput.text === passwordConfirmationInput.text) {
                UserController.changePassword(passwordInput.text)
            } else {
                passwordInput.errorText = qsTr("Passwords don't match!")
                passwordInput.setError()

                passwordConfirmationInput.errorText = qsTr(
                            "Passwords don't match!")
                passwordConfirmationInput.setError()
            }
        }
    }

    function saveAccountSettings() {
        UserController.name = nameInput.text

        if (passwordInput.text !== "")
            internal.changePassword()

        if (profilePictureArea.currentImage == "!")
            UserController.deleteProfilePicture()
        else
            UserController.profilePicture = profilePictureArea.currentImage

        profilePictureArea.currentImage = ""
        internal.unsavedChanges = false
    }
}
