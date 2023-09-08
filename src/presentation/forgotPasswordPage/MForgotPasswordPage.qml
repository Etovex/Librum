import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import CustomComponents
import Librum.style
import Librum.icons
import Librum.controllers

MFlickWrapper
{
    id: root
    contentHeight: Window.height < layout.implicitHeight ?
                       layout.implicitHeight + page.bottomPadding : Window.height
    
    // Passing the focus to emailInput on Component.onCompleted() causes it
    // to pass controll back to root for some reason, this fixes the focus problem
    onActiveFocusChanged: if(activeFocus) emailInput.giveFocus()
    
    // Focus the emailInput when page has loaded
    Component.onCompleted: emailInput.giveFocus()
    
    Page
    {
        id: page
        anchors.fill: parent
        bottomPadding: 50
        background: Rectangle { color: Style.colorAuthenticationPageBackground }
        
        
        Shortcut
        {
            sequence: "Ctrl+Return"
            onActivated: internal.sendPasswordResetEmail()
        }
        
        Shortcut
        {
            sequence: "Ctrl+Backspace"
            onActivated: internal.backToLoginPage()
        }
        
        
        ColumnLayout
        {
            id: layout
            anchors.centerIn: parent
            spacing: -92
            
            
            Image
            {
                id: lockIllustration
                z: 2
                Layout.alignment: Qt.AlignHCenter
                source: Icons.lockProtected
                sourceSize.width: 250
                fillMode: Image.PreserveAspectFit
            }
            
            Pane
            {
                id: background
                Layout.preferredWidth: 542
                topPadding: 86
                bottomPadding: 28
                horizontalPadding: 0
                background: Rectangle
                {
                    color: Style.colorContainerBackground
                    radius: 6
                }
                
                
                ColumnLayout
                {
                    id: backgroundLayout
                    width: parent.width
                    
                    
                    Label
                    {
                        id: forgotPasswordText
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 32
                        text: "Forgot Password"
                        color: Style.colorText
                        font.bold: true
                        font.pointSize: 19
                    }
                    
                    Label
                    {
                        id: resetPasswordText
                        Layout.preferredWidth: 450
                        Layout.topMargin: 8
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Qt.AlignHCenter
                        text: "Enter your email and we'll send you a link to reset your password"
                        wrapMode: Text.WordWrap
                        color: Style.colorSubtitle
                        lineHeight: 1.1
                        font.weight: Font.Medium
                        font.pointSize: 12.5
                    }
                    
                    ColumnLayout
                    {
                        id: inputColumn
                        Layout.fillWidth: true
                        Layout.leftMargin: internal.inWindowPadding
                        Layout.rightMargin: internal.inWindowPadding
                        Layout.topMargin: 12
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 0
                        
                        MLabeledInputBox
                        {
                            id: emailInput
                            Layout.fillWidth: true
                            placeholderContent: "kaidoe@gmail.com"
                            placeholderColor: Style.colorPlaceholderText
                            headerText: ""
                        }
                        
                        Label
                        {
                            id: successText
                            Layout.topMargin: 10
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            visible: false
                            color: Style.colorGreenText
                            font.pointSize: 11.75
                        }
                        
                        MButton
                        {
                            id: sendEmailButton
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            Layout.topMargin: successText.visible ? 32 : 56
                            Layout.alignment: Qt.AlignHCenter
                            borderWidth: 0
                            backgroundColor: Style.colorBasePurple
                            text: "Send Email"
                            fontSize: 12.25
                            textColor: Style.colorFocusedButtonText
                            fontWeight: Font.Bold
                            
                            onClicked: internal.sendPasswordResetEmail()
                        }
                        
                        
                        MButton
                        {
                            id: backButton
                            Layout.preferredWidth: 145
                            Layout.preferredHeight: 42
                            Layout.alignment: Qt.AlignHCenter
                            Layout.topMargin: 18
                            centerContentHorizontally: false
                            borderWidth: 0
                            backgroundColor: "transparent"
                            opacityOnPressed: 0.7
                            text: "Back to Login"
                            fontSize: 12.20
                            fontWeight: Font.Medium
                            textColor: Style.colorUnfocusedButtonText
                            imagePath: Icons.arrowheadBackIcon
                            imageSize: 28
                            imageSpacing: 4
                            
                            onClicked: internal.backToLoginPage()
                        }
                    }
                }
            }
        }
    }
    
    QtObject
    {
        id: internal
        property int inWindowPadding: 71
        
        function sendPasswordResetEmail()
        {
            if(emailInput.text === "")
                return;
            
            UserController.forgotPassword(emailInput.text);
            
            successText.text = "Email sent! Keep an eye on your inbox.";
            successText.visible = true;
            emailInput.clearText();
        }
        
        function backToLoginPage()
        {
            loadPage(loginPage);
        }
    }
}