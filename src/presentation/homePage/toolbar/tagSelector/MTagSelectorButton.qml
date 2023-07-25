import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Librum.style
import Librum.icons


Item
{
    id: root
    signal tagsSelected
    signal tagsRemoved
    
    implicitWidth: 104
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
        
        
        RowLayout
        {
            id: layout
            anchors.centerIn: parent
            spacing: 6
            
            Image
            {
                id: tagIcon
                sourceSize.height: 18
                source: Icons.tag
                fillMode: Image.PreserveAspectFit
            }
            
            Label
            {
                id: tagLabel
                Layout.topMargin: -1
                color: Style.colorText
                text: "Tags"
                font.pointSize: 12
                font.weight: Font.Bold
            }
        }
    }
    
    MouseArea
    {
        anchors.fill: parent
        
        onClicked: selectionPopup.opened ? selectionPopup.close() : selectionPopup.open()
    }
    
    MTagSelectorPopup
    {
        id: selectionPopup
        y: root.height + 6
        
        onClosed:
        {
            if(selectionPopup.hasAtLeastOneTagSelected())
                root.tagsSelected();
            else
                root.tagsRemoved();
        }
    }
    
    function clearSelections()
    {
        selectionPopup.clearSelections();
    }
    
    function giveFocus()
    {
        root.forceActiveFocus();
    }
}