import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import CustomComponents 1.0
import Librum.style 1.0
import Librum.controllers 1.0
import "explorerToolbar"


Page
{
    id: root
    background: Rectangle
    {
        anchors.fill: parent
        color: Style.colorPageBackground
    }
    
    Component.onCompleted: FreeBooksController.getBooksMetadata("", "");
    
    ColumnLayout
    {
        id: layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: internal.windowRightMargin
        anchors.leftMargin: internal.windowLeftMargin
        spacing: 0
        
        
        MTitle
        {
            id: pageTitle
            Layout.topMargin: 44
            titleText: "Free books"
            descriptionText: "Choose from over 60,000 books"
        }
        
        MExplorerToolbar
        {
            id: toolbar
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            Layout.topMargin: 45
        }
        
        Pane
        {
            id: bookGridContainer
            Layout.fillWidth: true
            Layout.preferredHeight: 759
            Layout.topMargin: 30
            visible: !root.empty
            padding: 0
            background: Rectangle { color: "transparent" }
            
            GridView
            {
                id: bookGrid
                anchors.fill: parent
                cellWidth: internal.bookWidth + internal.horizontalBookSpacing
                cellHeight: internal.bookHeight + internal.verticalBookSpacing
                // Negative margin removes the extra spacing at the right of the grid
                rightMargin: -internal.horizontalBookSpacing
                interactive: true
                boundsBehavior: Flickable.StopAtBounds
                flickDeceleration: 19500
                maximumFlickVelocity: 3300
                clip: true
                
                model: FreeBooksController.freeBooksModel
                delegate: MFreeBook
                {
                    MouseArea
                    {
                        anchors.fill: parent
                        
                        onClicked:
                        {
                            downloadBookPopup.title = model.title;
                            downloadBookPopup.authors = model.authors;
                            downloadBookPopup.languages = model.languages;
                            downloadBookPopup.cover = model.cover;
                            downloadBookPopup.downloadCount = model.downloadCount;
                            downloadBookPopup.open();
                        }
                    }
                }
            }
        }
    }
    
    MDownloadBookPopup
    {
        id: downloadBookPopup
        
        x: Math.round(root.width / 2 - implicitWidth / 2 - sidebar.width / 2 - root.horizontalPadding)
        y: Math.round(root.height / 2 - implicitHeight / 2 - root.topPadding - 30)
    }
    
    QtObject
    {
        id: internal
        property int windowLeftMargin: 64
        property int windowRightMargin: 70
        
        property int bookWidth: 190
        property int bookHeight: 300
        property int horizontalBookSpacing: 64
        property int verticalBookSpacing: 48
    }
}
