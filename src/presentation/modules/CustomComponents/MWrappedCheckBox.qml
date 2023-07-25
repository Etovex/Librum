import QtQuick
import QtQuick.Controls
import Librum.style
import CustomComponents

/**
 A wrapper around MCheckBox to creat an extra container around it
 */
Item
{
    id: root
    property alias activated : checkBox.checked
    signal checked
    
    implicitWidth: 40
    implicitHeight: 36
    
    
    Pane
    {
        id: container
        anchors.fill: parent
        padding: 0
        background: Rectangle
        {
            color: Style.colorControlBackground
            border.width: 1
            border.color: Style.colorContainerBorder
            radius: 5
        }
        
        MCheckBox
        {
            id: checkBox
            width: 22
            height: 22
            anchors.centerIn: parent
            borderWidth: 1
            imageSize: 12
            
            onClicked: root.checked();
        }
    }
    
    
    function giveFocus()
    {
        checkBox.giveFocus();
    }    
}
