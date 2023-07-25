import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import CustomComponents
import Librum.elements
import Librum.style
import Librum.icons
import Librum.controllers
import Librum.globals
import "toolbar"
import "manageTagsPopup"


Page
{
    id: root
    horizontalPadding: 64
    rightPadding: 70
    bottomPadding: 20
    background: Rectangle { anchors.fill: parent; color: Style.colorPageBackground }
    
    
    Shortcut
    {
        sequence: SettingsController.shortcuts.AddBook
        onActivated: importFilesDialog.open()
    }
    
    Connections
    {
        target: BookController
        
        function onStorageLimitExceeded() { uploadLimitReachedPopup.open() }
    }
    
    
    ColumnLayout
    {
        id: layout
        anchors.fill: parent
        spacing: 0
        
        
        RowLayout
        {
            id: headerRow
            Layout.fillWidth: true
            spacing: 0
            
            
            MTitle
            {
                id: pageTitle
                Layout.topMargin: 44
                titleText: "Home"
                descriptionText: "You have " + BookController.bookCount + " books"
            }
            
            Item { Layout.fillWidth: true }
            
            MButton
            {
                id: addBooksButton
                Layout.preferredWidth: 140
                Layout.preferredHeight: 40
                Layout.topMargin: 22
                Layout.alignment: Qt.AlignBottom
                borderWidth: 0
                backgroundColor: Style.colorBasePurple
                text: "Add books"
                textColor: Style.colorFocusedButtonText
                fontWeight: Font.Bold
                fontSize: 13
                imagePath: Icons.addWhite
                
                onClicked: importFilesDialog.open()
            }
        }
        
        Item { Layout.fillHeight: true; Layout.maximumHeight: 45; Layout.minimumHeight: 8 }
        
        MToolbar
        {
            id: toolbar
            visible: !internal.libraryIsEmpty
            Layout.fillWidth: true
            z: 2
            
            onSearchRequested: (query) => BookController.libraryModel.sortString = query
        }
        
        Pane
        {
            id: bookGridContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 100
            Layout.topMargin: 30
            visible: !internal.libraryIsEmpty && bookGrid.count != 0
            padding: 0
            background: Rectangle { color: "transparent" }
            
            
            GridView
            {
                id: bookGrid
                anchors.fill: parent
                cellWidth: internal.bookWidth + internal.horizontalBookSpacing
                cellHeight: internal.bookHeight + internal.verticalBookSpacing
                rightMargin: -internal.horizontalBookSpacing
                interactive: true
                boundsBehavior: Flickable.StopAtBounds
                flickDeceleration: 12500
                maximumFlickVelocity: 3500
                clip: true
                model: BookController.libraryModel
                delegate: MBook
                {
                    id: bookDelegate
                    
                    onLeftButtonClicked:
                    {
                        if(model.downloaded)
                        {
                            Globals.selectedBook = BookController.getBook(model.uuid);
                            internal.openBook();
                        }
                        else
                        {
                            BookController.downloadBookMedia(model.uuid);
                        }
                    }
                    
                    /*
                      When right-clicking a book, open the bookOptions popup
                      */
                    onRightButtonClicked:
                        (index, mouse) =>
                        {
                            // Calculate where to spawn the bookOptions popup and set its position
                            let currentMousePosition = mapToItem(bookGridContainer, mouse.x, mouse.y);
                            let absoluteMousePosition = mapToItem(root, mouse.x, mouse.y);
                            bookOptionsPopup.setSpawnPosition(currentMousePosition, absoluteMousePosition, root);
                            
                            // Open the bookOptions
                            internal.openBookOptionsPopup(model);
                        }
                    
                    /*
                      When clicking more options, open the bookOptions popup
                      */
                    onMoreOptionClicked:
                        (index, mouse) =>
                        {
                            // Calculate where to spawn the bookOptions popup and set its position
                            let currentMousePosition = mapToItem(bookGridContainer, mouse.x, mouse.y);
                            bookOptionsPopup.x = currentMousePosition.x - bookOptionsPopup.implicitWidth / 2;
                            bookOptionsPopup.y = currentMousePosition.y - bookOptionsPopup.implicitHeight - 6;
                            
                            // Open the bookOptions
                            internal.openBookOptionsPopup(model);
                        }
                }
                
                /*
                  The options menu when e.g. right-clicking a book
                  */
                MBookRightClickPopup
                {
                    id: bookOptionsPopup
                    
                    onDownloadClicked:
                    {
                        close();
                    }
                    
                    onReadBookClicked:
                    {
                        internal.openBook()
                    }
                    
                    onBookDetailsClicked:
                    {
                        bookDetailsPopup.open();
                        close();
                    }
                    
                    onSaveToFilesClicked:
                    {
                        downloadFileDialog.open();
                        close();
                    }
                    
                    onManageTagsClicked:
                    {
                        manageTagsPopup.open();
                        close();
                    }
                    
                    onMarkAsReadClicked:
                    {
                        close();
                    }
                    
                    onUninstallClicked:
                    {
                        BookController.uninstallBook(Globals.selectedBook.uuid);
                        close();
                    }
                    
                    onDeleteClicked:
                    {
                        acceptDeletionPopup.open();
                        close();
                    }
                }
            }
        }
        
        MEmptyScreenContent
        {
            id: emptyScreenContent
            visible: internal.libraryIsEmpty
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: 32
            
            onClicked: importFilesDialog.open();
        }
        
        MNoBookSatisfiesFilterItem
        {
            id: noBookSatisfiesFilterItem
            Layout.alignment: Qt.AlignHCenter
            Layout.leftMargin: -sidebar.width
            Layout.topMargin: Math.round(root.height / 3) - implicitHeight
            visible: bookGrid.count == 0 && BookController.bookCount !== 0
            
            onClearFilters:
            {
                toolbar.resetFilters();
                toolbar.resetTags();
            }
        }
        
        Item
        {
            id: bottomHeightFillter
            Layout.fillHeight: true
        }
    }
    
    MWarningPopup
    {
        id: acceptDeletionPopup
        x: Math.round(root.width / 2 - implicitWidth / 2 - sidebar.width / 2 - root.horizontalPadding)
        y: Math.round(root.height / 2 - implicitHeight / 2 - root.topPadding - 50)
        visible: false
        title: "Delete Book?"
        message: "Deleting a book is a permanent action, no one will be\n able to restore it afterwards!"
        leftButtonText: "No, Keep Book"
        rightButtonText: "Yes, Delete Book"
        buttonsWidth: 180
        messageBottomSpacing: 10
        
        onOpenedChanged: if(opened) acceptDeletionPopup.giveFocus()
        onDecisionMade: close()
        onRightButtonClicked: BookController.deleteBook(Globals.selectedBook.uuid);
    }
    
    MBookDetailsPopup
    {
        id: bookDetailsPopup
        x: Math.round(root.width / 2 - implicitWidth / 2 - sidebar.width / 2 - root.horizontalPadding)
        y: Math.round(root.height / 2 - implicitHeight / 2 - root.topPadding - 30)
    }
    
    MManageTagsPopup
    {
        id: manageTagsPopup
        x: Math.round(root.width / 2 - implicitWidth / 2 - sidebar.width / 2 - root.horizontalPadding)
        y: Math.round(root.height / 2 - implicitHeight / 2 - root.topPadding - 30)
    }
    
    FolderDialog
    {
        id: downloadFileDialog
        acceptLabel: "Save"
        options: FolderDialog.ShowDirsOnly
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        
        onAccepted: BookController.saveBookToFile(Globals.selectedBook.uuid, folder);
    }
    
    MWarningPopup
    {
        id: uploadLimitReachedPopup
        x: Math.round(root.width / 2 - implicitWidth / 2 - sidebar.width / 2 - root.horizontalPadding)
        y: Math.round(root.height / 2 - implicitHeight / 2 - root.topPadding - 50)
        visible: false
        title: "Limit Reached"
        message: "You have reached your upload limit.\nDelete unused books to free up space or upgrade."
        leftButtonText: "Ok"
        rightButtonText: "Upgrade"
        buttonsWidth: 180
        messageBottomSpacing: 16
        
        onOpenedChanged: if(opened) uploadLimitReachedPopup.giveFocus()
        onDecisionMade: close()
    }
    
    FileDialog
    {
        id: importFilesDialog
        acceptLabel: "Import"
        fileMode: FileDialog.FileMode.OpenFiles
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        nameFilters: [
            "All files (*)",
            "PDF files (*.pdf)",
            "EPUB files (*.epub)",
            "HTML files (*.html *.htm)",
            "Text files (*.txt)",
            "MOBI files (*.mobi)",
        ]
    
        onAccepted:
        {
            for(let i = 0; i < files.length; ++i)
            {
                BookController.addBook(files[i]);
            }
        }
    }
    
    QtObject
    {
        id: internal
        property bool libraryIsEmpty: BookController.bookCount === 0
        
        property int bookWidth: 190
        property int bookHeight: 300
        property int horizontalBookSpacing: 64
        property int verticalBookSpacing: 48
        
        function openBookOptionsPopup(item)
        {
            Globals.selectedBook = BookController.getBook(item.uuid);
            Globals.bookTags = Qt.binding(function () { return item.tags; });
            bookOptionsPopup.open();
        }
        
        function openBook()
        {
            if(bookOptionsPopup.opened)
                bookOptionsPopup.close();
            
            BookController.refreshLastOpenedFlag(Globals.selectedBook.uuid);
            loadPage(readingPage);
        }
    }
}