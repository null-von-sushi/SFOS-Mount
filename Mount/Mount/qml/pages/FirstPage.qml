import QtQuick 2.0
import Sailfish.Silica 1.0
import "../storage.js" as Storage

Page {
    id: page
    backNavigation: false
    allowedOrientations: Orientation.All

    onStatusChanged: { //This is called every time the page is accessed in some way.
        switch (status ){
        case PageStatus.Activating:
            console.log("PageStatus.Activating") //I think I stole these debug messages from harbor-tooter. Sidenote, if anyone is reading this, I will legitimately pay someone 5 Pound Sterling using PayPal if they can fix it to work reliably with pleroma. I know it's not that much but I am broke :/



            /*
              Types
              mountXused
              mountXtype
              mountXdevice
              mountXpath
              mountXarguments
              mount

            */





            console.log("trying to add cards...")
            for (var i = 1; i < 101; i++) { //for loop, starting at 1, all the way to less then 101 (100). Going up by one? Kinda taken from this: https://stackoverflow.com/questions/43271820/count-to-100-using-javascript-in-a-div
                if (Storage.get("card" + i + "used", "false") == "true") {
                    console.log("i: " + i)
                    console.log("cardsUsed[0]: " + cardsUsed[0])
                    var x = i - 1
                    if ( cardsUsed[x] != "card" + i) {
                        cardsUsed.push("card" + i) //look mom, I am using arrays! Are you proud of me now?
                    }
                    var cardType = Storage.get("card" + i + "type", "other")
                    if (cardType == "Payment") {
                        sectionPayment.visible = true
                        paymentModel.append({"payText1": Storage.get("card" + i + "text1", "UNATCO"), "payText2": Storage.get("card" + i + "text2", "J.C. Denton"), "payNumber": i})
                    }
                    else if (cardType == "Loyalty") {
                        sectionLoyalty.visible = true
                        loyaltyModel.append({"loyalText1": Storage.get("card" + i + "text1", "UNATCO"), "loyalText2": Storage.get("card" + i + "text2", "J.C. Denton"), "loyalNumber": i})
                    }
                }
            }
            break;
        case PageStatus.Inactive:
            console.log("PageStatus.Inactive")
            break;
        }
    }

    function deleteCard(i) {
        Storage.set("card" + i + "used", "false")
        Storage.set("card" + i + "type", "")
        Storage.set("card" + i + "text1", "")
        Storage.set("card" + i + "text2", "")
        Storage.set("card" + i + "extra1", "")
        Storage.set("card" + i + "extra2", "")
        console.log("card" + i + "used:" + Storage.get("card" + i + "used", "undefined"))
    }


    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: "About"
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: "Enable Debug Options"
                onClicked: {
                    page.debug = "true"
                }
            }
            MenuItem {
                text: "Add Card"
                onClicked: pageStack.push(Qt.resolvedUrl("AskCardType.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: parent.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Shekels")
            }

            Slider {
                id: slider
                label: "[Debug] Permanent settings test"
                width: parent.width
                minimumValue: 0; maximumValue: 100; stepSize: 1
                valueText: value
                value: Storage.get("slidervalue", "2") //storage get
                visible:  page.debug == "true"
            }

            Button {
                id: debugButtonSave
                text: "[Debug] Save"
                visible:  page.debug == "true"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    Storage.set("slidervalue", slider.value) //storage
                }
            }

            // @disable-check M300 why the fuck does ButtonLayout show an error !?
            ButtonLayout {
                id: debugButtons
                visible:  page.debug == "true"
                Button {
                    text: "[Debug] New Pay"
                    onClicked: {
                        paymentModel.append({"payText1": "Schlongberg Sachs", "payText2": "Richie Rich", "payNumber": "9000"})
                        sectionPayment.visible = true
                    }
                }

                Button {
                    text: "[Debug] New Loyal"
                    onClicked: {
                        loyaltyModel.append({"loyalText1": "Kwick-E-Mart", "loyalText2": "Apu Nahasapeemapetilon", "loyalNumber": "9000"})
                        sectionLoyalty.visible = true
                    }
                }
            }

            SectionHeader {
                id: sectionPayment
                text: "Payment methods"
                visible: paymentModel.hasChildren() == true
            }

            Repeater {
                model: ListModel { id: paymentModel }

                //In here goes the stuff for the template

                ListItem {
                    id: payListID
                    width: parent.width
                    //contentHeight: Theme.itemSizeSmall * 1.2
                    contentHeight: topPayText.height + bottomPayText.height + 10
                    property string cardNumber: model.payNumber
                    onClicked: {
                        currentCard = cardNumber
                        pageStack.push(Qt.resolvedUrl("ShowCard.qml"))
                    }

                    Label {
                        id: topPayText
                        text: model.payText1
                        //anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Theme.fontSizeLarge
                        maximumLineCount: 1
                        truncationMode: TruncationMode.Fade
                        anchors {
                            left: parent.left
                            right: parent.right
                            leftMargin: Theme.paddingMedium
                        }
                    }



                    Label {
                        id: bottomPayText
                        text: model.payText2
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.WordWrap
                        maximumLineCount: 1
                        truncationMode: TruncationMode.Fade
                        anchors {
                            top: topPayText.bottom
                            left: parent.left
                            right: parent.right
                            leftMargin: Theme.paddingMedium
                        }
                    }





                    menu: ContextMenu {
                        MenuItem {
                            text: "Remove"
                            onClicked: {
                                payListID.remorseAction("Deleting", function() {
                                    console.log("cardNumber:" + payListID.cardNumber)
                                    deleteCard(payListID.cardNumber)
                                    paymentModel.remove(model.index)
                                })
                            }
                        }
                        MenuItem {
                            id: debugMenuPay
                            visible:  page.debug == "true"
                            text: "[Debug] Print index"
                            onClicked: {
                                console.log(model.index)
                            }
                        }
                    }
                }
            }



            SectionHeader {
                id: sectionLoyalty
                text: "Loyalty cards"
                visible: loyaltyModel.hasChildren() == true
            }

            Repeater {
                model: ListModel { id: loyaltyModel }

                //In here goes the stuff for the template

                ListItem {
                    id: loyalListID
                    width: parent.width
                    //contentHeight: Theme.itemSizeSmall * 1.2
                    contentHeight: topText.height + bottomText.height + 10
                    property string cardNumber: model.loyalNumber
                    onClicked: {
                        currentCard = cardNumber
                        pageStack.push(Qt.resolvedUrl("ShowCard.qml"))
                    }


                    Label {
                        id: topText
                        text: model.loyalText1
                        //anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Theme.fontSizeLarge
                        maximumLineCount: 1
                        truncationMode: TruncationMode.Fade
                        anchors {
                            left: parent.left
                            right: parent.right
                            leftMargin: Theme.paddingMedium
                        }
                    }



                    Label {
                        id: bottomText
                        text: model.loyalText2
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.WordWrap
                        maximumLineCount: 1
                        truncationMode: TruncationMode.Fade
                        anchors {
                            top: topText.bottom
                            left: parent.left
                            right: parent.right
                            leftMargin: Theme.paddingMedium
                        }
                    }





                    menu: ContextMenu {
                        MenuItem {
                            text: "Remove"
                            onClicked: {
                                console.log("cardNumber:" + loyalListID.cardNumber)
                                deleteCard(loyalListID.cardNumber)
                                loyalListID.remorseAction("Deleting", function() { loyaltyModel.remove(model.index) })
                            }
                        }
                        MenuItem {
                            id: debugMenuLoyal
                            visible: page.debug == "true"
                            text: "[Debug] Print index"
                            onClicked: {
                                console.log(model.index)
                            }
                        }
                    }
                }
            }




        }
    }
}
