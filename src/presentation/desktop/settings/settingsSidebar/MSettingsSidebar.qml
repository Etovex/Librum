import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import CustomComponents
import Librum.style
import Librum.icons
import Librum.fonts

Item {
    id: root
    property MSettingsSidebarItem aboutItem: aboutItem
    property MSettingsSidebarItem appearanceItem: appearanceItem
    property MSettingsSidebarItem behaviorSettingsItem: behaviorSettingsItem
    property MSettingsSidebarItem shortcutsItem: shortcutsItem
    property MSettingsSidebarItem updatesItem: updatesItem
    property MSettingsSidebarItem accountItem: accountItem
    property MSettingsSidebarItem storageItem: storageItem
    property MSettingsSidebarItem supportUsItem: supportUsItem
    property MSettingsSidebarItem currentItem: aboutItem

    implicitWidth: 238
    implicitHeight: Window.height


    /*
      Adds a border to the whole settings sidebar
      */
    Rectangle {
        id: background
        anchors.fill: parent
        color: Style.colorSettingsSidebarBackground

        Rectangle {
            id: rightBorder
            width: 1
            height: parent.height
            anchors.right: parent.right
            color: Style.colorContainerBorder
        }
    }

    MFlickWrapper {
        id: flickWrapper
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            spacing: 0

            Label {
                Layout.topMargin: 28
                Layout.leftMargin: 25
                text: qsTr("Settings")
                font.pointSize: Fonts.size19
                font.bold: true
                color: Style.colorTitle
            }

            Rectangle {
                id: titleSeparator
                Layout.preferredWidth: 56
                Layout.preferredHeight: 2
                Layout.topMargin: 15
                Layout.leftMargin: 26
                color: Style.colorDarkSeparator
            }

            Label {
                Layout.topMargin: 38
                Layout.leftMargin: 25
                //: Keep it capitalized
                text: qsTr("GLOBAL SETTINGS")
                font.pointSize: Fonts.size10
                font.weight: Font.Bold
                color: Style.colorLightText
            }

            MSettingsSidebarItem {
                id: aboutItem
                Layout.preferredHeight: 32
                Layout.preferredWidth: internal.sidebarItemWidth
                Layout.topMargin: 14
                Layout.leftMargin: 1
                selected: true
                imageLeftMargin: 26
                imageWidth: 14
                labelLeftMargin: 12
                textContent: qsTr("About")
                defaultIcon: Icons.settingsSidebarAbout
                selectedIcon: Icons.settingsSidebarAboutSelected

                onClicked: loadSettingsPage(aboutPage, root.aboutItem)
            }

            MSettingsSidebarItem {
                id: appearanceItem
                Layout.preferredHeight: 32
                Layout.preferredWidth: internal.sidebarItemWidth
                Layout.topMargin: 5
                Layout.leftMargin: 1
                imageLeftMargin: 25
                imageWidth: 18
                labelLeftMargin: 8
                textContent: qsTr("Appearance")
                defaultIcon: Icons.settingsSidebarAppearance
                selectedIcon: Icons.settingsSidebarAppearanceSelected

                onClicked: loadSettingsPage(appearancePage, root.appearanceItem)
            }

            MSettingsSidebarItem {
                id: behaviorSettingsItem
                Layout.preferredHeight: 32
                Layout.preferredWidth: internal.sidebarItemWidth
                Layout.topMargin: 5
                Layout.leftMargin: 1
                imageLeftMargin: 24
                imageWidth: 19
                labelLeftMargin: 8
                textContent: qsTr("Behavior")
                defaultIcon: Icons.settingsSidebarSettings
                selectedIcon: Icons.settingsSidebarSettingsSelected

                onClicked: loadSettingsPage(behaviorSettingsPage,
                                            root.behaviorSettingsItem)
            }

            MSettingsSidebarItem {
                id: shortcutsItem
                Layout.preferredHeight: 32
                Layout.preferredWidth: internal.sidebarItemWidth
                Layout.topMargin: 5
                Layout.leftMargin: 1
                imageLeftMargin: 26
                imageWidth: 16
                labelLeftMargin: 9
                textContent: qsTr("Shortcuts")
                defaultIcon: Icons.settingsSidebarShortcuts
                selectedIcon: Icons.settingsSidebarShortcutsSelected

                onClicked: loadSettingsPage(shortcutsPage, root.shortcutsItem)
            }

            MSettingsSidebarItem {
                id: updatesItem
                Layout.preferredHeight: 32
                Layout.preferredWidth: internal.sidebarItemWidth
                Layout.topMargin: 5
                Layout.leftMargin: 1
                imageLeftMargin: 25
                imageWidth: 16
                labelLeftMargin: 10
                textContent: qsTr("Updates")
                defaultIcon: Icons.settingsSidebarUpdates
                selectedIcon: Icons.settingsSidebarUpdatesSelected

                onClicked: loadSettingsPage(updatesPage, root.updatesItem)
            }

            Label {
                Layout.topMargin: 25
                Layout.leftMargin: 25
                //: Keep it capitalized
                text: qsTr("USER & ACCOUNT")
                font.pointSize: Fonts.size10
                font.bold: true
                color: Style.colorLightText
            }

            MSettingsSidebarItem {
                id: accountItem
                Layout.preferredHeight: 32
                Layout.preferredWidth: internal.sidebarItemWidth
                Layout.topMargin: 12
                Layout.leftMargin: 1
                imageLeftMargin: 25
                imageWidth: 13
                labelTopMargin: 2
                labelLeftMargin: 13
                textContent: qsTr("Account")
                defaultIcon: Icons.settingsSidebarAccount
                selectedIcon: Icons.settingsSidebarAccountSelected

                onClicked: loadSettingsPage(accountPage, root.accountItem)
            }

            MSettingsSidebarItem {
                id: storageItem
                Layout.preferredHeight: 32
                Layout.preferredWidth: internal.sidebarItemWidth
                Layout.topMargin: 5
                Layout.leftMargin: 1
                imageLeftMargin: 26
                imageWidth: 14
                labelLeftMargin: 11
                textContent: qsTr("Storage")
                defaultIcon: Icons.settingsSidebarStorage
                selectedIcon: Icons.settingsSidebarStorageSelected

                onClicked: loadSettingsPage(storagePage, root.storageItem)
            }

            MSettingsSidebarItem {
                id: supportUsItem
                Layout.preferredHeight: 32
                Layout.preferredWidth: internal.sidebarItemWidth
                Layout.topMargin: 5
                Layout.bottomMargin: 12
                Layout.leftMargin: 1
                imageLeftMargin: 25
                imageWidth: 18
                labelLeftMargin: 8
                textContent: qsTr("Support us")
                defaultIcon: Icons.settingsSidebarSupportUs
                selectedIcon: Icons.settingsSidebarSupportUsSelected

                onClicked: loadSettingsPage(supportUsPage, root.supportUsItem)
            }
        }
    }

    QtObject {
        id: internal
        property int sidebarItemWidth: root.width - 2
    }

    function changeSelectedSettingsItem(newItem) {
        root.currentItem.selected = false
        root.currentItem = newItem
        root.currentItem.selected = true
    }
}
