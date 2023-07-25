import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Librum.style


/**
 A radio button, usually used inside of MRadioSelector
 */
Item
{
    id: root
    property bool selected: false
    property string text
    signal clicked
    
    implicitHeight: 22
    
    
    RowLayout
    {
        id: layout
        anchors.fill: parent
        spacing: 8
        
        
        Rectangle
        {
            id: buttonBorder
            Layout.fillHeight: true
            Layout.preferredWidth: 22
            radius: width
            color: Style.colorControlBackground
            border.color: root.selected ? Style.colorBasePurple: Style.colorCheckboxBorder
            antialiasing: true
            
            
            Rectangle
            {
                id: buttonFill
                visible: root.selected
                width: parent.width / 1.7
                height: parent.height / 1.7
                anchors.centerIn: parent
                color: Style.colorBasePurple
                radius: width
                antialiasing: true
            }
            
            MouseArea
            {
                anchors.fill: parent
                
                onClicked: root.clicked()
            }
        }
        
        Label
        {
            id: label
            Layout.fillWidth: true
            Layout.maximumWidth: 200
            Layout.alignment: Qt.AlignVCenter
            text: root.text
            font.pointSize: 12
            font.weight: root.selected ? Font.Medium : Font.Normal
            color: Style.colorText
            
            MouseArea
            {
                anchors.fill: parent
                
                onClicked: root.clicked()
            }
        }
    }
}