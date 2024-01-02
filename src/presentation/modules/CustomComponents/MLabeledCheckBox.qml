import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Librum.style
import Librum.icons


/**
 A component which extends MCheckBox by adding a label next to it
 */
Item {
    id: root
    property int boxWidth: 22
    property int boxHeight: 22
    property alias borderColor: checkBox.borderColor
    property alias borderRadius: checkBox.borderRadius
    property alias borderWidth: checkBox.borderWidth
    property alias uncheckedBackgroundColor: checkBox.uncheckedBackgroundColor
    property alias checkedBackgroundColor: checkBox.checkedBackgroundColor
    property alias image: checkBox.image
    property alias imageSize: checkBox.imageSize
    property alias checked: checkBox.checked
    property int spacing: 5
    property string text
    property double fontSize: Fonts.size12
    property double fontWeight: Font.Normal
    property int verticalTextOffset: 0
    property color fontColor: Style.colorText
    property alias enabled: checkBox.enabled
    signal clicked

    implicitWidth: 100
    implicitHeight: layout.height

    RowLayout {
        id: layout
        spacing: root.spacing

        MCheckBox {
            id: checkBox
            Layout.preferredWidth: root.boxWidth
            Layout.preferredHeight: root.boxHeight

            onClicked: root.clicked()
        }

        Label {
            id: text
            Layout.preferredWidth: root.width
            Layout.topMargin: root.verticalTextOffset
            text: root.text
            font.weight: root.fontWeight
            font.pointSize: root.fontSize
            color: root.fontColor
            wrapMode: Text.WordWrap

            MouseArea {
                width: text.implicitWidth
                height: text.implicitHeight
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    checkBox.toggle()
                    root.clicked()
                }
            }
        }
    }

    function giveFocus() {
        root.forceActiveFocus()
    }
}
