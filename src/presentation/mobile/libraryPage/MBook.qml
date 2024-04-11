import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Librum.style
import Librum.icons
import CustomComponents
import Librum.fonts
import Librum.globals

Item {
    id: root
    signal clicked

    implicitWidth: 120
    implicitHeight: 190
    clip: true

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: upperBookPart
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.colorBookImageBackground

            Image {
                id: downloadBookIcon
                anchors.centerIn: parent
                visible: !model.downloaded
                sourceSize.width: 32
                fillMode: Image.PreserveAspectFit
                source: Icons.downloadSelected
                opacity: 1
                z: 3
            }

            ColumnLayout {
                id: upperPartLayout
                anchors.centerIn: parent
                spacing: 0

                Image {
                    id: bookCover
                    // visible: source != ""
                    visible: false
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: -10
                    // source: cover
                    cache: false
                }
            }
        }

        Rectangle {
            id: lowerBookPart
            Layout.fillWidth: true
            Layout.preferredHeight: 42
            color: "transparent"

            ColumnLayout {
                id: bottomPartLayout
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Label {
                    id: title
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24
                    Layout.topMargin: 5
                    clip: true
                    text: model.title === "" ? qsTr("Unknown") : model.title
                    font.weight: Font.Medium
                    verticalAlignment: Text.AlignVCenter
                    color: Style.colorTitle
                    font.pointSize: Fonts.size12
                    lineHeight: 0.8
                    wrapMode: TextInput.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                }

                Label {
                    id: authors
                    Layout.fillWidth: true
                    clip: true
                    text: model.authors === "" ? qsTr("Unknown") : model.authors
                    color: Style.colorLightText
                    font.pointSize: Fonts.size11
                    elide: Text.ElideRight
                }
            }
        }
    }

    TapHandler {
        onTapped: root.clicked()
    }

    function giveFocus() {
        root.forceActiveFocus()
    }
}
