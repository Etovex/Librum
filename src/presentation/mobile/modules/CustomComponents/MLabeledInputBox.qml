import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Librum.style
import Librum.fonts
import Librum.icons

Item {
    id: root
    property alias text: input.text
    property bool selected: false
    property color inputFontColor: Style.colorText
    property bool readOnly: false
    property bool textHidden: false
    property int inputFontSize: Fonts.size13
    property string placeHolderText: "Input"
    property color placeHolderColor: Style.colorPlaceholderText
    property int fontWeight: Font.Normal
    property bool isPassword: false

    implicitWidth: 200
    implicitHeight: 56

    // If there is some preconfigured text, we want to move the placeholder
    // to the header position
    Component.onCompleted: {
        if (text.length == 0)
            return

        moveablePlaceholder.y = internal.yHeaderDest
        moveablePlaceholder.font.pointSize = internal.headerPlaceholderSize
        textOverlay.width = internal.widthHeaderDest
        textOverlay.x = textOverlay.expandedPosition
        internal.inHeaderMode = true
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "transparent"
        border.width: input.activeFocus ? 2 : 1
        border.color: input.activeFocus ? Style.colorBasePurple : "#9999A0"
        radius: 6

        Rectangle {
            id: textOverlay
            property int expandedWidth: movedPlaceholderReference.implicitWidth
                                        + textOverlay.sidePadding
            property int defaultPosition: 12 + expandedWidth / 2
            property int expandedPosition: 12
            property int sidePadding: 8

            width: 0
            height: 4
            y: -(height / 2)
            x: defaultPosition
            color: Style.colorPageBackground
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        TextField {
            id: input
            Layout.fillWidth: true
            selectByMouse: true
            readOnly: root.readOnly
            color: root.inputFontColor
            font.pointSize: root.inputFontSize
            leftPadding: 16
            rightPadding: 16
            echoMode: root.textHidden ? TextInput.Password : TextInput.Normal
            selectionColor: Style.colorTextSelection
            selectedTextColor: root.inputFontColor
            font.weight: root.fontWeight
            background: Rectangle {
                anchors.fill: parent
                radius: 6
                color: "transparent"
            }

            onActiveFocusChanged: {
                if (activeFocus && !internal.inHeaderMode
                        && input.text.length === 0) {
                    moveToHeaderAnim.start()
                } else if (!activeFocus && internal.inHeaderMode
                           && input.text.length === 0) {
                    moveBackAnim.start()
                }
            }

            Label {
                id: moveablePlaceholder
                property int centeredPosition

                x: input.leftPadding
                font.pointSize: root.inputFontSize
                y: centeredPosition
                color: root.placeHolderColor
                text: root.placeHolderText

                // We want to compute this only once at the start
                Component.onCompleted: centeredPosition = (parent.height - implicitHeight) / 2
            }


            /**
              Since the label in the header has a smaller size than the placeholder label
              we need to use that smaller size to calculate with. This is just a non-rendered
              object to calculate with.
             */
            Label {
                id: movedPlaceholderReference
                property int centeredPosition: (parent.height - implicitHeight) / 2

                visible: false
                x: input.leftPadding
                y: centeredPosition
                font.pointSize: internal.headerPlaceholderSize
                text: root.placeHolderText
            }
        }

        Item {
            Layout.preferredWidth: 42
            Layout.rightMargin: 8
            Layout.fillHeight: true
            visible: root.isPassword

            IconImage {
                id: passwordVisibilityTogglerIcon
                anchors.centerIn: parent
                Layout.alignment: Qt.AlignVCenter
                source: root.textHidden ? Icons.eyeOn : Icons.eyeOff
                opacity: imageArea.pressed ? 0.75 : 1
                sourceSize.width: 22
                fillMode: Image.PreserveAspectFit
                color: "#9999A0"
            }

            TapHandler {
                id: imageArea
                onTapped: root.textHidden = !root.textHidden
            }
        }
    }

    TapHandler {
        onTapped: input.forceActiveFocus()
    }

    ParallelAnimation {
        id: moveToHeaderAnim
        property int zeroRelativeToLabel: mapToItem(
                                              movedPlaceholderReference,
                                              Qt.point(
                                                  movedPlaceholderReference.x,
                                                  0)).y
        property int halfLabelHeight: movedPlaceholderReference.implicitHeight / 2

        NumberAnimation {
            target: moveablePlaceholder
            property: "y"
            to: internal.yHeaderDest
            duration: 340
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: moveablePlaceholder
            property: "font.pointSize"
            to: internal.headerPlaceholderSize
            duration: 340
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: textOverlay
            property: "width"
            to: internal.widthHeaderDest
            duration: 340
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: textOverlay
            property: "x"
            to: textOverlay.expandedPosition
            duration: 340
            easing.type: Easing.InOutQuad
        }

        onFinished: internal.inHeaderMode = true
    }

    ParallelAnimation {
        id: moveBackAnim

        NumberAnimation {
            target: moveablePlaceholder
            property: "y"
            to: moveablePlaceholder.centeredPosition
            duration: 340
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: moveablePlaceholder
            property: "font.pointSize"
            to: root.inputFontSize
            duration: 340
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: textOverlay
            property: "width"
            to: 0
            duration: 340
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: textOverlay
            property: "x"
            to: textOverlay.defaultPosition
            duration: 340
            easing.type: Easing.InOutQuad
        }

        onFinished: internal.inHeaderMode = false
    }

    QtObject {
        id: internal
        property bool inHeaderMode: false
        property int yHeaderDest: moveToHeaderAnim.zeroRelativeToLabel
                                  - moveToHeaderAnim.halfLabelHeight
                                  - movedPlaceholderReference.centeredPosition - 1
        property int widthHeaderDest: movedPlaceholderReference.implicitWidth
                                      + textOverlay.sidePadding

        property int headerPlaceholderSize: Fonts.size12dot5
        property bool textHiden: root.isPassword
    }
}
