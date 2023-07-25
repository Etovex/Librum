import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import CustomComponents
import Librum.style
import Librum.icons
import Librum.controllers


Pane
{
    id: root
    property bool fullScreenMode: false
    property string bookTitle: "Unknown name"
    property int currentPage: 0
    property int lastPage: 0
    property int pageCount: 0
    property alias chapterButton: chapterButton
    property alias bookmarksButton: bookmarksButton
    property alias searchButton: searchButton
    property alias currentPageSelection: currentPageSelection
    property alias fullScreenButton: fullScreenButton
    property alias optionsButton: optionsButton
    property var document
    signal backButtonClicked
    signal chapterButtonClicked
    signal bookMarkButtonClicked
    signal searchButtonClicked
    signal currentPageButtonClicked
    signal fullScreenButtonClicked
    signal optionsPopupVisibileChanged
    
    implicitHeight: 48
    padding: 8
    background: Rectangle { color: Style.colorReadingToolbarBackground; radius: 4 }
    
    onVisibleChanged: if(optionsPopup.opened) optionsPopup.close()
    
    
    Shortcut
    {
        id: openChapterSidebar
        sequences: [SettingsController.shortcuts.OpenChapters]
        onActivated: root.chapterButtonClicked()
    }
    Shortcut
    {
        id: openBookmarks
        sequences: [SettingsController.shortcuts.OpenBookmarks]
        onActivated: root.bookMarkButtonClicked()
    }
    Shortcut
    {
        id: search
        sequences: [SettingsController.shortcuts.Search]
        onActivated: root.searchButtonClicked()
    }
    Shortcut
    {
        id: startFullScreenMode
        sequences: [SettingsController.shortcuts.StartFullScreenMode]
        onActivated: root.fullScreenButtonClicked()
    }
    Shortcut
    {
        id: goBackToHome
        sequences: [SettingsController.shortcuts.GoToHome]
        onActivated: root.backButtonClicked()
    }
    
    
    RowLayout
    {
        id: layout
        anchors.fill: parent
        spacing: 8
        
        
        MButton
        {
            id: backButton
            Layout.preferredWidth: 40
            Layout.preferredHeight: 32
            backgroundColor: Style.colorReadingViewButtonBackground
            borderWidth: 0
            imagePath: Icons.readingViewBack
            imageSize: 11
            opacityOnPressed: 0.7
            
            onClicked: root.backButtonClicked()
        }
        
        MButton
        {
            id: chapterButton
            Layout.preferredWidth: 40
            Layout.preferredHeight: 32
            backgroundColor: Style.colorReadingViewButtonBackground
            borderWidth: 0
            imagePath: active ? Icons.readingViewChaptersSelected : Icons.readingViewChapters
            imageSize: 18
            opacityOnPressed: 0.7
            
            onClicked: root.chapterButtonClicked()
        }
        
        MButton
        {
            id: bookmarksButton
            Layout.preferredWidth: 40
            Layout.preferredHeight: 32
            backgroundColor: Style.colorReadingViewButtonBackground
            borderWidth: 0
            imagePath: active ? Icons.readingViewBookmarkSelected : Icons.readingViewBookmark
            imageSize: 14
            opacityOnPressed: 0.7
            
            onClicked: root.bookMarkButtonClicked()
        }
        
        Item
        {
            id: currentPageSelection
            Layout.preferredWidth: inputBox.width + pageInputLayout.spacing + totalPageText.implicitWidth
            Layout.preferredHeight: 34
            
            RowLayout
            {
                id: pageInputLayout
                anchors.fill: parent
                spacing: 8
                
                Pane
                {
                    id: inputBox
                    Layout.preferredWidth: 66
                    Layout.fillHeight: true
                    padding: 0
                    horizontalPadding: 2
                    background: Rectangle
                    {
                        id: backgroundRect
                        border.width: 2
                        border.color: Style.colorContainerBorder
                        radius: 5
                        color: Style.colorControlBackground
                    }
                    
                    
                    TextField
                    {
                        id: inputField
                        anchors.fill: parent
                        anchors.rightMargin: 2
                        anchors.leftMargin: 2
                        horizontalAlignment: TextInput.AlignHCenter
                        verticalAlignment: TextInput.AlignVCenter
                        selectByMouse: true
                        text: root.currentPage + 1
                        color: Style.colorBaseInputText
                        font.pointSize: 12
                        font.weight: Font.Normal
                        validator: IntValidator { bottom: 0; top: 99999 } // No upper border
                        background: Rectangle   
                        {
                            anchors.fill: parent
                            radius: 5
                            color: "transparent"
                        }
                        
                        // Select all the text when clicking it
                        onActiveFocusChanged: if(activeFocus) inputField.selectAll();
                        
                        // Keep in mind that the pages actually go from 0 to pageCount - 1 (zero indexed),
                        // but we present them as 1 to pageCount to the user.
                        onEditingFinished:
                        {
                            let newPage = Number(inputField.text);
                            if(root.currentPage == newPage - 1)
                                return;
                            
                            if(newPage < 1 || newPage > root.pageCount)
                            {
                                inputField.text = Qt.binding(() => root.currentPage + 1);
                                return;
                            }
                            
                            documentView.setPage(newPage - 1);
                            documentView.forceActiveFocus(); // Discard focus when finished
                        }
                    }
                }
                
                Label
                {
                    id: totalPageText
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    text: "of " + root.pageCount.toString()
                    font.pointSize: 12
                    font.weight: Font.Normal
                    color: Style.colorText
                }
            }
        }
        
        Label
        {
            id: bookTitle
            Layout.fillWidth: true
            Component.onCompleted: Layout.rightMargin = (Math.ceil(x + width/2) - Math.ceil(root.width / 2)) * 4
            Layout.alignment: Qt.AlignVCenter 
            horizontalAlignment: Text.AlignHCenter
            text: JSON.parse(SettingsController.appearanceSettings.DisplayBookTitleInTitlebar) ? root.bookTitle : ""
            color: Style.colorTitle
            font.weight: Font.DemiBold
            font.pointSize: 13
            elide: Text.ElideRight
        }
        
        
        MComboBox
        {
            id: zoomComboBox
            Layout.preferredHeight: 32
            Layout.preferredWidth: 92
            headerText: ""
            selectedItemFontColor: Style.colorTitle
            boxBackgroundColor: Style.colorReadingViewButtonBackground
            defaultIndex: 6
            dropdownIcon: Icons.dropdownDark
            dropdownIconSize: 9
            checkBoxStyle: false
            model: ListModel
            {
                ListElement { text: "15%" }
                ListElement { text: "25%" }
                ListElement { text: "33%" }
                ListElement { text: "50%" }
                ListElement { text: "66%" }
                ListElement { text: "75%" }
                ListElement { text: "100%" }
                ListElement { text: "125%" }
                ListElement { text: "150%" }
                ListElement { text: "175%" }
                ListElement { text: "250%" }
                ListElement { text: "300%" }
                ListElement { text: "400%" }
            }
            
            // Need to run a timer to create the binding, since the combobox does not set the text correctly
            // when trying to just assign it during onCompleted
            Component.onCompleted: zoomAssignment.start()
            Timer
            {
                id: zoomAssignment
                interval: 5
                onTriggered: zoomComboBox.text = Qt.binding(function () { return Math.round(root.document.zoom * 100) + "%" })
            }
            
            // Remove % sign from text
            onItemChanged:
            {
                if(text === "")
                    return;
                
                root.document.zoom = zoomComboBox.text.substring(0, zoomComboBox.text.length - 1) / 100;
                zoomAssignment.start();  // Force rebinding
            }
        }
        
        MButton
        {
            id: fullScreenButton
            Layout.preferredWidth: 40
            Layout.preferredHeight: 32
            backgroundColor: Style.colorReadingViewButtonBackground
            borderWidth: 0
            imagePath: active ? Icons.readingViewMaximizeSelected : Icons.readingViewMaximize
            imageSize: 20
            opacityOnPressed: 0.7
            
            onClicked: root.fullScreenButtonClicked()
        }
        
        MButton
        {
            id: searchButton
            Layout.preferredWidth: 40
            Layout.preferredHeight: 32
            backgroundColor: Style.colorReadingViewButtonBackground
            borderWidth: 0
            imagePath: active ? Icons.readingViewSearchSelected : Icons.readingViewSearch
            imageSize: 18
            opacityOnPressed: 0.7
            
            onClicked: root.searchButtonClicked()
        }
        
        MButton
        {
            id: optionsButton
            Layout.preferredWidth: 40
            Layout.preferredHeight: 32
            backgroundColor: Style.colorReadingViewButtonBackground
            borderWidth: 0
            imagePath: active ? Icons.readingViewOptionsPurple : Icons.readingViewOptions
            imageSize: 20
            opacityOnPressed: 0.7
            
            onClicked: optionsPopup.opened ? optionsPopup.close() : optionsPopup.open();
        }
    }
    
    MReadingOptionsPopup
    {
        id: optionsPopup
        x: optionsButton.x - width + optionsButton.width
        y: optionsButton.height + 12
        
        onOpenedChanged: root.optionsPopupVisibileChanged()
    }
}