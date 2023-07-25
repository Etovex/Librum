import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Librum.style
import Librum.icons


Item
{
    id: root
    signal itemSelected(int role)
    
    implicitWidth: 104
    implicitHeight: 36
    
    
    ColumnLayout
    {
        id: layout
        anchors.fill: parent
        spacing: 4
        
        
        Pane
        {
            id: container
            Layout.fillWidth: true
            Layout.fillHeight: true
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
                id: inButtonLayout
                anchors.centerIn: parent
                spacing: 8
                
                Label
                {
                    id: sortByLabel
                    Layout.topMargin: -1
                    color: Style.colorText
                    text: "Sort by"
                    font.pointSize: 12
                    font.weight: Font.Bold
                }
                
                Image
                {
                    id: sortByArrowIcon
                    sourceSize.height: 6
                    source: Icons.dropdownLight
                    fillMode: Image.PreserveAspectFit
                    rotation: 180
                    
                    NumberAnimation
                    {
                        id: closeAnim
                        target: sortByArrowIcon
                        property: "rotation"
                        to: 180
                        duration: 175
                        easing.type: Easing.InOutQuad
                    }
                    
                    NumberAnimation
                    {
                        id: openAnim
                        target: sortByArrowIcon
                        property: "rotation"
                        to: 0
                        duration: 175
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }
    
    MouseArea
    {
        anchors.fill: parent
        
        onClicked: sortByPopup.opened ? sortByPopup.close() : sortByPopup.open()
    }
    
    MSortByPopup
    {
        id: sortByPopup
        y: root.height + 6
        closePolicy: Popup.CloseOnReleaseOutsideParent | Popup.CloseOnEscape
        
        onOpened: openAnim.start()
        onClosed: closeAnim.start()
        onItemSelected: (role) => root.itemSelected(role)
    }
    
    
    function giveFocus()
    {
        root.forceActiveFocus();
    }
}