import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import CustomComponents
import Librum.style
import Librum.icons
import Librum.controllers
import Librum.globals
import Librum.fonts

Popup {
    id: root
    implicitWidth: 516
    implicitHeight: layout.height
    padding: 0
    horizontalPadding: 52
    background: Rectangle {
        color: Style.colorPopupBackground
        radius: 6
    }
    modal: true
    Overlay.modal: Rectangle {
        color: Style.colorPopupDim
        opacity: 1
    }

    onOpenedChanged: {
        if (opened) {
            addTagBox.giveFocus()
            informationLabel.text = Qt.binding(function () {
                return Globals.bookTags.length + " " + qsTr("TAGS") + "  -  " + Globals.selectedBook.title
            })
        } else {
            addTagBox.close()
            addTagBox.clearInputField()
        }
    }

    MFlickWrapper {
        anchors.fill: parent
        contentHeight: layout.height

        ColumnLayout {
            id: layout
            width: parent.width
            spacing: 0

            MButton {
                id: closeButton
                Layout.preferredHeight: 32
                Layout.preferredWidth: 32
                Layout.topMargin: 12
                Layout.rightMargin: -38
                Layout.alignment: Qt.AlignTop | Qt.AlignRight
                backgroundColor: "transparent"
                opacityOnPressed: 0.7
                borderColor: "transparent"
                radius: 6
                borderColorOnPressed: Style.colorButtonBorder
                imagePath: Icons.closePopup
                imageSize: 14

                onClicked: root.close()
            }

            Label {
                id: popupTitle
                Layout.topMargin: 20
                text: qsTr("Manage Tags")
                font.weight: Font.Bold
                font.pointSize: Fonts.size17
                color: Style.colorTitle
            }

            MAddTagBox {
                id: addTagBox
                Layout.topMargin: 46
                Layout.fillWidth: true

                onAddTag: name => {
                              // Cant use return value, bc. it is null if tag already exists
                              UserController.addTag(name)

                              let tagUuid = UserController.getTagUuidForName(
                                  name)
                              LibraryController.addTag(
                                  Globals.selectedBook.uuid, name, tagUuid)
                          }
            }

            Label {
                id: informationLabel
                Layout.fillWidth: true
                Layout.topMargin: 32
                Layout.leftMargin: 1
                color: Style.colorSubtitle
                font.pointSize: Fonts.size9dot5
                font.weight: Font.Medium
                elide: Text.ElideRight
            }

            Rectangle {
                id: separator
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                Layout.topMargin: 4
                color: Style.colorDarkSeparator
            }

            ListView {
                id: listView
                property var currentSelected
                property string oldText

                Layout.fillWidth: true
                Layout.preferredHeight: contentHeight
                Layout.maximumHeight: 228
                Layout.minimumHeight: 76
                Layout.topMargin: 8
                maximumFlickVelocity: 550
                currentIndex: -1
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: ScrollBar {}
                model: Globals.bookTags
                delegate: MTagItem {
                    width: listView.width

                    onRemoveTag: index => {
                                     LibraryController.removeTag(
                                         Globals.selectedBook.uuid,
                                         Globals.bookTags[index].uuid)
                                 }

                    onStartedRenaming: oldText => {
                                           listView.oldText = oldText
                                       }

                    onRenamedTag: (index, text) => {
                                      let currentItem = listView.itemAtIndex(
                                          index)
                                      let uuid = UserController.getTagUuidForName(
                                          listView.oldText)

                                      let success = UserController.renameTag(
                                          uuid, text)
                                      if (success) {
                                          LibraryController.renameTags(
                                              listView.oldText, text)
                                      }
                                  }
                }
            }

            MButton {
                id: doneButton
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                Layout.topMargin: 34
                Layout.bottomMargin: 42
                borderWidth: 0
                backgroundColor: Style.colorBasePurple
                fontSize: Fonts.size12
                textColor: Style.colorFocusedButtonText
                fontWeight: Font.Bold
                text: qsTr("Done")

                onClicked: root.close()
            }
        }
    }

    function removeTag() {
        ;
    }
}
