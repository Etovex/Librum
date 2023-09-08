import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import CustomComponents
import Librum.style
import Librum.icons
import Librum.controllers
import Librum.models


MFlickWrapper
{
    id: root
    contentHeight: page.implicitHeight
    
    
    Page
    {
        id: page
        width: parent.width
        horizontalPadding: 48
        bottomPadding: 22
        background: Rectangle { anchors.fill: parent; color: Style.colorPageBackground }
        
        Component.onCompleted: { UserController.syncWithServer() }
        
        
        ColumnLayout
        {
            id: layout        
            width: parent.width
            spacing: 0
            
            
            RowLayout
            {
                id: titleRow
                Layout.fillWidth: true
                spacing: 0
                
                
                MTitle
                {
                    id: pageTitle
                    Layout.topMargin: 64
                    titleText: "Storage"
                    descriptionText: "Your storage"
                    titleSize: 25
                    descriptionSize: 13.25
                }
                
                Item { Layout.fillWidth: true }
                
                MButton
                {
                    id: upgradeButton
                    Layout.preferredWidth: 118
                    Layout.preferredHeight: 38
                    Layout.alignment: Qt.AlignBottom
                    borderWidth: 0
                    backgroundColor: Style.colorBasePurple
                    text: "Upgrade"
                    fontSize: 12
                    fontWeight: Font.Bold
                    textColor: Style.colorFocusedButtonText
                    imagePath: Icons.heartHallow
                    imageSize: 18
                    
                    onClicked: upgradePopup.open()
                }
            }
            
            Pane
            {
                id: container
                Layout.fillWidth: true
                Layout.topMargin: 32
                padding: 28
                background: Rectangle
                {
                    color: Style.colorContainerBackground
                    border.color: Style.colorContainerBorder
                    radius: 4
                    antialiasing: true
                }
                
                
                ColumnLayout
                {
                    width: parent.width
                    spacing: 26
                    
                    RowLayout
                    {
                        width: parent.width
                        spacing: 26
                        
                        Pane
                        {
                            id: tierPane
                            Layout.fillWidth: true
                            Layout.preferredWidth: 470
                            Layout.maximumWidth: 470
                            Layout.minimumWidth: 235
                            Layout.preferredHeight: 325
                            horizontalPadding: 34
                            background: Rectangle
                            {
                                anchors.fill: parent
                                color: Style.colorPageBackground
                                radius: 4
                            }
                            
                            ColumnLayout
                            {
                                width: parent.width
                                
                                Label
                                {
                                    id: tierTitle
                                    Layout.alignment: Qt.AlignLeft
                                    Layout.topMargin: 6
                                    text: "YOUR TIER"
                                    color: Style.colorPageSubtitle
                                    font.weight: Font.Bold
                                    font.pointSize: 10.5
                                }
                                
                                Label
                                {
                                    id: tierName
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: 46
                                    text: "BASIC"
                                    color: Style.colorSubtitle
                                    font.weight: Font.Medium
                                    font.pointSize: 22
                                }
                                
                                Label
                                {
                                    id: storageAmount
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: -8
                                    text: internal.bytesToGB(UserController.bookStorageLimit) + "GB"
                                    color: Style.colorMatteTitle
                                    font.weight: Font.Bold
                                    font.pointSize: 46
                                }
                                
                                RowLayout
                                {
                                    id: upgradeButtonRow
                                    Layout.fillWidth: true
                                    Layout.topMargin: 36
                                    spacing: 12
                                    
                                    MButton
                                    {
                                        id: inlineUpgradeButton
                                        Layout.preferredWidth: 110
                                        Layout.preferredHeight: 38
                                        borderWidth: 0
                                        backgroundColor: Style.colorBasePurple
                                        text: "Upgrade"
                                        fontSize: 12
                                        fontWeight: Font.Bold
                                        textColor: Style.colorFocusedButtonText
                                        
                                        onClicked: upgradePopup.open()
                                    }
                                    
                                    MButton
                                    {
                                        id: whyOfferingTiersButton
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 38
                                        borderWidth: 1
                                        borderColor: Style.colorCheckboxBorder
                                        opacityOnPressed: 0.75
                                        backgroundColor: "transparent"
                                        text: "See why we offer multiple tiers"
                                        fontSize: 12
                                        fontWeight: Font.Medium
                                        textColor: Style.colorText
                                        
                                        onClicked: Qt.openUrlExternally(AppInfoController.website + "/whyTiers")
                                    }
                                }
                            }
                        }
                        
                        Pane
                        {
                            id: usedStoragePaneBold
                            Layout.fillWidth: true
                            Layout.minimumWidth: 340
                            Layout.preferredHeight: 325
                            horizontalPadding: 34
                            background: Rectangle
                            {
                                anchors.fill: parent
                                color: Style.colorPageBackground
                                radius: 4
                            }
                            
                            ColumnLayout
                            {
                                width: parent.width
                                spacing: 0
                                
                                Label
                                {
                                    id: usedStorageTitle
                                    Layout.alignment: Qt.AlignLeft
                                    Layout.topMargin: 6
                                    text: "USED STORAGE"
                                    color: Style.colorPageSubtitle
                                    font.weight: Font.Bold
                                    font.pointSize: 10.5
                                }
                                
                                RowLayout
                                {
                                    Layout.fillWidth: true
                                    Layout.topMargin: 85
                                    spacing: 0
                                    
                                    
                                    Item
                                    {
                                        id: usedStorageBox
                                        Layout.preferredWidth: parent.width / 2
                                        height: usedStorageText.height + usedStorageExplenationText.height
                                        
                                        Label
                                        {
                                            id: usedStorageText
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: internal.bytesToGB(UserController.usedBookStorage, 2) + "GB"
                                            color: Style.colorBasePurple
                                            font.weight: Font.Bold
                                            font.pointSize: 42
                                        }
                                        
                                        Label
                                        {
                                            id: usedStorageExplenationText
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.top: usedStorageText.bottom
                                            anchors.topMargin: 2
                                            text: "Used Storage"
                                            color: Style.colorLightText
                                            font.pointSize: 11
                                        }
                                    }
                                    
                                    Item
                                    {
                                        id: availableStorageBox
                                        Layout.fillWidth: true
                                        height: remainingStorageText.height + remainingStorageExplenationText.height
                                        
                                        Label
                                        {
                                            id: remainingStorageText
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: internal.bytesToGB(UserController.bookStorageLimit) + "GB"
                                            color: Style.colorLightText
                                            font.weight: Font.Bold
                                            font.pointSize: 42
                                        }
                                        
                                        Label
                                        {
                                            id: remainingStorageExplenationText
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.top: remainingStorageText.bottom
                                            anchors.topMargin: 2
                                            text: "Remaining Storage"
                                            color: Style.colorLightText
                                            font.pointSize: 11
                                        }
                                    }
                                }
                                
                                Rectangle
                                {
                                    id: progressBar
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 34
                                    Layout.topMargin: 32
                                    color: Style.colorLightPurple
                                    radius: 4
                                    
                                    Rectangle
                                    {
                                        id: progressBarFilling
                                        property int progress: parent.width * (UserController.usedBookStorage / UserController.bookStorageLimit)
                                        
                                        width: progress <= parent.width ? progress : parent.width
                                        height: parent.height
                                        color: Style.colorBasePurple
                                        radius: parent.radius
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    RowLayout
                    {
                        width: parent.width
                        spacing: 28
                        
                        Pane
                        {
                            id: yourBooksPane
                            Layout.fillWidth: true
                            Layout.preferredWidth: 470
                            Layout.maximumWidth: 470
                            Layout.minimumWidth: 235
                            Layout.preferredHeight: 325
                            horizontalPadding: 34
                            background: Rectangle
                            {
                                anchors.fill: parent
                                color: Style.colorPageBackground
                                radius: 4
                            }
                            
                            ColumnLayout
                            {
                                width: parent.width
                                spacing: 0
                                
                                Label
                                {
                                    id: yourBooksTitle
                                    Layout.alignment: Qt.AlignLeft
                                    Layout.topMargin: 6
                                    text: "YOUR BOOKS"
                                    color: Style.colorPageSubtitle
                                    font.weight: Font.Bold
                                    font.pointSize: 10.5
                                }
                                
                                Label
                                {
                                    id: bookCount
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: 78
                                    text: LibraryController.bookCount
                                    color: Style.colorMatteTitle
                                    font.weight: Font.Bold
                                    font.pointSize: 46
                                }
                                
                                Label
                                {
                                    id: bookCountDescription
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Books in your Library"
                                    color: Style.colorLightText
                                    font.pointSize: 12
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    MWarningPopup
    {
        id: upgradePopup
        x: Math.round(page.width / 2 - implicitWidth / 2 - settingsSidebar.width / 2 - page.horizontalPadding)
        y: Math.round(page.height / 2 - implicitHeight / 2 - page.topPadding - 50)
        visible: false
        title: "Upgrade Your Tier"
        message: "We don't offer upgrading options at the moment.\n" +
                  "If you require additional storage, please contact us at: " + AppInfoController.companyEmail
        leftButtonText: "Close"
        rightButtonText: "Email Us"
        buttonsWidth: 180
        messageBottomSpacing: 10
        
        onOpenedChanged: if(opened) upgradePopup.giveFocus()
        onRightButtonClicked: Qt.openUrlExternally("mailto:" + AppInfoController.companyEmail)
        onDecisionMade: close()
    }
    
    QtObject
    {
        id: internal
        
        // Convert bytes to GB and format them correctly, rules:
        // - Convert bytes to GB
        // - If bytes == 0, return "0"
        // - If result ends with a 0, e.g. "2.40" remove it, so "2.4"
        // - Else Round it up to "precision" amount
        function bytesToGB(bytes, precision = 1)
        {
            if (bytes === 0) {
                return "0";
              }
            
              const gibibytes = bytes / (1024 * 1024 * 1024);
              const rounded = gibibytes.toFixed(2);
              const formatted = rounded.replace(/\.?0+$/, "");
            
              return formatted;
        }
    }
}