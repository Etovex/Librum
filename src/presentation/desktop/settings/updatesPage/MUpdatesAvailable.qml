import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import CustomComponents
import Librum.style
import Librum.icons
import Librum.elements
import Librum.controllers
import Librum.fonts

Item {
    id: root
    height: content.height

    Connections {
        target: AppInfoController

        function onDownloadingBinariesProgressChanged(progress) {
            windowsUpdatingPopup.setDownloadProgress(progress)
        }

        function onApplicaitonUpdateFailed() {
            windowsUpdatingPopup.close()
            updateFailedPopup.open()
        }
    }

    Pane {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalPadding: 40
        topPadding: 32
        bottomPadding: 32
        background: Rectangle {
            color: Style.colorContainerBackground
            border.color: Style.colorContainerBorder
            radius: 4
            antialiasing: true
        }

        ColumnLayout {
            id: mainLayout
            width: parent.width
            spacing: 0

            Label {
                id: newUpdateTitle
                Layout.fillWidth: true
                text: qsTr("A new update is available!")
                wrapMode: Text.WordWrap
                color: Style.colorText
                font.pointSize: Fonts.size23
                font.weight: Font.Bold
            }

            Label {
                Layout.fillWidth: true
                Layout.topMargin: 7
                text: qsTr("Download the new version to get great new improvements.")
                wrapMode: Text.WordWrap
                color: Style.colorLightText
                font.pointSize: Fonts.size15
            }

            Label {
                Layout.fillWidth: true
                Layout.topMargin: 32
                text: qsTr("The newest version is:")
                wrapMode: Text.WordWrap
                color: Style.colorLightText
                font.pointSize: Fonts.size14
            }

            Label {
                Layout.fillWidth: true
                text: AppInfoController.newestVersion
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                color: Style.colorLightText
                font.pointSize: Fonts.size14
                font.bold: true
            }

            MButton {
                id: downloadButton
                Layout.preferredWidth: 152
                Layout.preferredHeight: 38
                Layout.topMargin: 14
                borderWidth: 0
                backgroundColor: Style.colorBasePurple
                imagePath: Icons.downloadSelected
                imageSize: 16
                imageSpacing: 8
                text: qsTr("Update")
                fontSize: Fonts.size13
                fontWeight: Font.Bold
                textColor: Style.colorFocusedButtonText
                opacityOnPressed: 0.8

                onClicked: {
                    if (AppInfoController.operatingSystem === "WIN") {
                        AppInfoController.updateApplication()
                        windowsUpdatingPopup.open()
                    } else {
                        unixUpdatePopup.open()
                    }
                }
            }

            Label {
                Layout.fillWidth: true
                Layout.topMargin: 56
                text: qsTr("See the exact changes on our website at:")
                wrapMode: Text.WordWrap
                color: Style.colorLightText
                font.pointSize: Fonts.size14
            }

            Label {
                Layout.preferredWidth: implicitWidth
                Layout.minimumWidth: implicitWidth
                text: AppInfoController.newsWebsite
                wrapMode: Text.WordWrap
                font.underline: true
                color: Style.colorBasePurple
                font.pointSize: Fonts.size14
                opacity: newsWebsiteLinkArea.pressed ? 0.8 : 1

                MouseArea {
                    id: newsWebsiteLinkArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: Qt.openUrlExternally(
                                   AppInfoController.newsWebsite)
                }
            }
        }
    }

    MWindowsUpdatingPopup {
        id: windowsUpdatingPopup
        x: root.width / 2 - implicitWidth / 2 - settingsSidebar.width / 2
           - content.horizontalPadding
        y: baseRoot.height / 2 - height / 2 - 160
    }

    MWarningPopup {
        id: unixUpdatePopup
        x: root.width / 2 - implicitWidth / 2 - settingsSidebar.width / 2
           - content.horizontalPadding
        y: baseRoot.height / 2 - height / 2 - 160
        visible: false
        title: qsTr("Updating on Linux")
        message: qsTr("Please use your package manager to update Librum or download the newest version from our")
                 + " " + '<a href="' + AppInfoController.website
                 + '" style="text-decoration: none; color: ' + Style.colorBasePurple + ';">' + qsTr(
                     'website') + '</a>.'
        leftButtonText: qsTr("Close")
        rightButtonText: qsTr("Email Us")
        messageBottomSpacing: 10
        minButtonWidth: 180
        richText: true

        onOpenedChanged: if (opened)
                             unixUpdatePopup.giveFocus()
        onRightButtonClicked: Qt.openUrlExternally(
                                  "mailto:" + AppInfoController.companyEmail)
        onDecisionMade: close()
    }

    MWarningPopup {
        id: updateFailedPopup
        x: root.width / 2 - implicitWidth / 2 - settingsSidebar.width / 2
           - content.horizontalPadding
        y: baseRoot.height / 2 - height / 2 - 160
        visible: false
        title: qsTr("The Update Failed")
        message: qsTr("Please try again later or download the newest version from our")
                 + " " + '<a href="' + AppInfoController.website
                 + '" style="text-decoration: none; color: ' + Style.colorBasePurple + ';">' + qsTr(
                     'website') + '</a>.'
        leftButtonText: qsTr("Close")
        rightButtonText: qsTr("Email Us")
        messageBottomSpacing: 10
        minButtonWidth: 180
        richText: true

        onOpenedChanged: if (opened)
                             updateFailedPopup.giveFocus()
        onRightButtonClicked: Qt.openUrlExternally(
                                  "mailto:" + AppInfoController.companyEmail)
        onDecisionMade: close()
    }
}
