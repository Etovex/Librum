import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Librum.style
import Librum.icons
import CustomComponents

Item {
    id: root

    implicitWidth: 190
    implicitHeight: 304

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 0


        /**
          A rectangle with rounded corners which is overlapping with the top half of
          the book to create a rounded top, while the rest of the book is rectangluar
          */
        Rectangle {
            id: upperBookPartRounding
            Layout.fillWidth: true
            Layout.preferredHeight: 16
            radius: 4
            color: Style.colorBookImageBackground
        }


        /**
          The upper book half which contains the book cover
          */
        Rectangle {
            id: bookCoverRect
            Layout.fillWidth: true
            Layout.preferredHeight: 230
            Layout.topMargin: -5
            color: Style.colorBookImageBackground
            clip: true

            MProgressBar {
                id: downloadProgressBar
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 1
                anchors.rightMargin: 1
                visible: false
                z: 3
                progress: model.mediaDownloadProgress
                onProgressChanged: {
                    if (progress === 1)
                        visible = false
                    else
                        visible = true
                }
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 0

                Image {
                    id: bookCover
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: -8
                    sourceSize.height: 241
                    source: model.cover
                    fillMode: Image.PreserveAspectFit
                }
            }
        }


        /**
          The lower book half which contains the book information
          */
        Rectangle {
            id: informationRect
            Layout.fillWidth: true
            Layout.preferredHeight: 65
            color: Style.colorBookBackground
            border.width: 1
            border.color: Style.colorBookBorder

            ColumnLayout {
                id: informationRectLayout
                width: parent.width - internal.paddingInsideBook * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Label {
                    id: bookName
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    Layout.topMargin: 4
                    text: model.title
                    font.weight: Font.Medium
                    color: Style.colorTitle
                    font.pointSize: 11
                    lineHeight: 0.8
                    elide: Label.ElideRight
                    wrapMode: TextInput.WordWrap
                }

                Label {
                    id: authors
                    Layout.fillWidth: true
                    Layout.topMargin: 5
                    text: model.authors
                    color: Style.colorLightText
                    font.pointSize: 10
                    elide: Label.ElideRight
                }
            }
        }
    }

    QtObject {
        id: internal
        property int paddingInsideBook: 14
    }

    function giveFocus() {
        root.forceActiveFocus()
    }
}
