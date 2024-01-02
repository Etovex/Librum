import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import CustomComponents
import Librum.style
import Librum.icons
import Librum.controllers
import Librum.fonts

Page {
    id: root
    topPadding: 64
    horizontalPadding: 48
    background: Rectangle {
        anchors.fill: parent
        color: Style.colorPageBackground
    }

    onWidthChanged: if (searchButton.opened)
                        searchButton.close()

    Shortcut {
        sequence: StandardKey.New
        onActivated: addShortcutPopup.open()
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 0

        RowLayout {
            id: pageTitleRow
            Layout.fillWidth: true
            spacing: 0

            MTitle {
                id: pageTitle
                titleText: qsTr("Shortcuts")
                descriptionText: qsTr("Make your own experience")
                titleSize: Fonts.size25
                descriptionSize: Fonts.size13dot25
            }

            Item {
                Layout.fillWidth: true
            }

            MButton {
                id: addShortcutButton
                Layout.preferredHeight: 38
                Layout.topMargin: 22
                Layout.alignment: Qt.AlignBottom
                horizontalMargins: 12
                borderWidth: 0
                backgroundColor: Style.colorBasePurple
                text: qsTr("Edit shortcut")
                textColor: Style.colorFocusedButtonText
                fontWeight: Font.Bold
                fontSize: Fonts.size13
                imagePath: Icons.addWhite

                onClicked: {
                    addShortcutPopup.preselectedSettingIndex = -1
                    addShortcutPopup.open()
                }
            }
        }

        Pane {
            id: container
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: 32
            Layout.bottomMargin: 44
            topPadding: 60
            leftPadding: internal.containerPadding
            padding: 0
            clip: true
            background: Rectangle {
                color: Style.colorContainerBackground
                border.color: Style.colorContainerBorder
                radius: 4
                antialiasing: true
            }

            ColumnLayout {
                id: containerLayout
                anchors.fill: parent
                spacing: 0


                /*
                  The shortcuts header labeling the different columns
                  */
                RowLayout {
                    id: headerLayout
                    Layout.fillWidth: true
                    Layout.rightMargin: internal.containerPadding
                    spacing: 0

                    Label {
                        id: actionsLabel
                        Layout.leftMargin: 12
                        //: Keep it capitalized
                        text: qsTr("ACTION")
                        color: Style.colorLightText
                        font.pointSize: Fonts.size10dot25
                        font.bold: true
                    }

                    Item {
                        id: headerLabelSpacer
                        Layout.preferredWidth: internal.verticalSettingSpacing + 90
                    }

                    Label {
                        id: shortcutsLabel
                        //: Keep it capitalized
                        text: qsTr("SHORTCUTS")
                        color: Style.colorLightText
                        font.pointSize: Fonts.size10dot25
                        font.bold: true
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    MSearchButton {
                        id: searchButton
                        implicitWidth: 34
                        implicitHeight: 32
                        imageSize: 14
                        placeholderText: qsTr("Search for shortcuts")

                        // Make sure that the searchButton does not overlap other items
                        expansionWidth: (headerLabelSpacer.width
                                         <= 445 ? headerLabelSpacer.width : 445)

                        onTriggered: query => SettingsController.shortcutsModel.filterString = query

                        // Reset filter when closing or leaving the page
                        Component.onDestruction: SettingsController.shortcutsModel.filterString = ""
                        onOpenedChanged: if (!opened)
                                             SettingsController.shortcutsModel.filterString = ""
                    }
                }


                /*
                  The actual shortcuts view
                  */
                ScrollView {
                    id: shortcutScrollArea
                    Layout.topMargin: 20
                    Layout.rightMargin: 20
                    Layout.bottomMargin: 32
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                    ListView {
                        id: listView
                        anchors.rightMargin: 28
                        anchors.fill: parent
                        clip: true
                        model: SettingsController.shortcutsModel
                        flickDeceleration: 15000
                        maximumFlickVelocity: 1600
                        boundsBehavior: Flickable.StopAtBounds
                        delegate: MShortcutDelegate {
                            onGapWidthChanged: spacing => internal.verticalSettingSpacing = spacing
                            onEditClicked: index => {
                                               addShortcutPopup.preselectedSettingIndex = index
                                               addShortcutPopup.open()
                                           }

                            onDeleteClicked: shortcut => SettingsController.setSetting(
                                                 shortcut, "",
                                                 SettingGroups.Shortcuts)
                        }
                    }
                }
            }
        }
    }

    MAddShortcutPopup {
        id: addShortcutPopup
        x: Math.round(root.width / 2 - implicitWidth / 2 - settingsSidebar.width
                      / 2 - sidebar.width / 2 - root.horizontalPadding)
        y: Math.round(root.height / 2 - implicitHeight / 2 - 115)

        onApplied: (shortcut, value) => SettingsController.setSetting(
                       shortcut, value, SettingGroups.Shortcuts)
    }

    QtObject {
        id: internal
        property int containerPadding: 48
        property int verticalSettingSpacing: 340
    }
}
