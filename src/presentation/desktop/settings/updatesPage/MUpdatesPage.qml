import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import CustomComponents
import Librum.style
import Librum.icons
import Librum.elements
import Librum.controllers
import Librum.fonts

MFlickWrapper {
    id: root
    contentHeight: page.implicitHeight

    Page {
        id: page
        width: parent.width
        horizontalPadding: 48
        bottomPadding: 22
        background: Rectangle {
            anchors.fill: parent
            color: Style.colorPageBackground
        }

        ColumnLayout {
            id: layout
            spacing: 0
            width: parent.width

            MTitle {
                id: pageTitle
                Layout.topMargin: 64
                titleText: qsTr("Updates")
                descriptionText: qsTr("Any new update?")
                titleSize: Fonts.size25
                descriptionSize: Fonts.size13dot25
            }

            // Pages to render
            Component {
                id: updatesAvailable
                MUpdatesAvailable {}
            }
            Component {
                id: upToDate
                MUpToDate {}
            }


            /*
              The loader loads the fitting page, depending on whether the
              application is up to date or not
              */
            Loader {
                id: contentLoader
                property bool versionsDontMatch: AppInfoController.currentVersion
                                                 !== AppInfoController.newestVersion
                                                 && AppInfoController.newestVersion !== ""

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: 32
                sourceComponent: versionsDontMatch ? updatesAvailable : upToDate
            }
        }
    }
}
