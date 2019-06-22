import QtQuick 2.0
import Sailfish.Silica 1.0
import "../storage.js" as Storage
import Process 1.0

Page {
    id: page
    backNavigation: false
    allowedOrientations: Orientation.All
    property string debug: "false"

    onStatusChanged: { //This is called every time the page is accessed in some way.
        switch (status ){
        case PageStatus.Activating:

            console.log("PageStatus.Activating") //I think I stole these debug messages from harbor-tooter. Sidenote, if anyone is reading this, I will legitimately pay someone 5 Pound Sterling using PayPal if they can fix it to work reliably with pleroma. I know it's not that much but I am broke :/


            /* DB Notes:
            mountXused
            mountXname
            mountXtype
            mountXdevice
            mountXpath
            mountXargs
            */

            entries.clear()
            console.log("Adding entries")
            for (var i = 1; i < 101; i++) {
                if (Storage.get("mount" + i + "used", "false") == "true") {
                    console.log("mount" + i + "used: " + Storage.get("mount" + i + "used", "false"))
                    console.log("amountOfEntries[0]: " + amountOfEntries[0])
                    var x = i - 1 //arrays start at 0
                    if ( amountOfEntries[x] != "mount" + i) {
                        amountOfEntries.push("mount" + i)
                    }
                    var mountType = Storage.get("mount" + i + "type", "auto")
                    entries.append({
                                       "text1": Storage.get("mount" + i + "name", "Entry" + i),
                                       "text2": Storage.get("mount" + i + "device", "") + " ⤞ " + Storage.get("mount" + i + "path", ""),
                                       "entryNumber": i,
                                       "device": Storage.get("mount" + i + "device", ""),
                                       "type": Storage.get("mount" + i + "type", "auto"),
                                       "path": Storage.get("mount" + i + "path", ""),
                                       "args": Storage.get("mount" + i + "args", "")
                                   })
                }
            }

            console.log("amountOfEntries[0]: " + amountOfEntries[0])
            console.log("amountOfEntries.length: " + amountOfEntries.length) //used.length)
            break;
        case PageStatus.Inactive:
            console.log("PageStatus.Inactive")
            break;
        }
    }

    function deleteEntry(i) {
        Storage.set("mount" + i + "used", "false")
        Storage.set("mount" + i + "name", "")
        Storage.set("mount" + i + "type", "")
        Storage.set("mount" + i + "device", "")
        Storage.set("mount" + i + "path", "")
        Storage.set("mount" + i + "path", "")
        Storage.set("mount" + i + "args", "")
        console.log("mount" + i + "used:" + Storage.get("mount" + i + "used", "false"))
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
                text: "Help"
                onClicked: pageStack.push(Qt.resolvedUrl("Help_davfs.qml"))
            }
            MenuItem {
                text: "Enable Debug Options"
                onClicked: {
                    page.debug = "true"
                }
            }
            MenuItem {
                text: "Add new entry"
                onClicked: pageStack.push(Qt.resolvedUrl("AddEntry.qml"))
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
                title: qsTr("Mount")
            }

            Label {
                id: mountFeedback
                visible:  page.debug == "true"
                //anchors.verticalCenter: parent.verticalCenter
                truncationMode: TruncationMode.Fade
            }

            Label {
                id: nativeCommandTest
                visible:  page.debug == "true"
                //anchors.verticalCenter: parent.verticalCenter
                truncationMode: TruncationMode.Fade
            }


            Process {
                id: uptimeProcess
                onReadyRead: nativeCommandTest.text = "uptime is: " + readAll();
            }

            Timer {
                interval: 1000
                repeat: true
                triggeredOnStart: true
                running: true
                onTriggered: uptimeProcess.start("/bin/cat", [ "/proc/uptime" ]);
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
                    text: "[Debug] New Entry"
                    onClicked: {
                        entries.append({"text1": "Yo Mama", "text2": "my cock ⤞ her pussy", "entryNumber": "9000"})
                    }
                }
            }


            Process {
                id: mountProcess
                onReadyRead: mountFeedback.text = readAll();
            }

            Repeater {
                model: ListModel { id: entries }

                ListItem {
                    id: entryListID
                    width: parent.width
                    //contentHeight: Theme.itemSizeSmall * 1.2
                    contentHeight: topText.height + bottomText.height + 10
                    property string entryNumber: model.entryNumber
                    property string device: model.device
                    property string type: model.type
                    property string path: model.path
                    property string args: model.args
                    //property string isMounted:
                    onClicked: {
                        //
                    }

                    Label {
                        id: topText
                        text: model.text1
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
                        text: model.text2
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
                            text: "Mount"
                            //visible:  entryListID.isMounted != "true"
                            onClicked: {
                                //mountProcess.start("/bin/mkdir", [ model.device, model.type, model.path, model.args ]);
                                //mountProcess.start("/bin/bash", [ "-c", "/bin/echo \"" + model.device + " " + model.type + " " + model.path + " " + model.args + "\" > /home/nemo/fuckk" ]);

                               // http(s)://addres:<port>/path /mount/point


                                if (model.type == "auto") {
                                    if (model.args != undefined) {
                                        mountProcess.start("/usr/bin/sudo", [ model.device, model.path], "-o", + model.args);
                                    }
                                    if (model.args == undefined) {
                                        mountProcess.start("/bin/mount", [ model.device, model.path]);
                                    }
                                }

                                if (model.type != "auto") {
                                    mountProcess.start("/bin/mount", [ model.device, model.path]);
                                }

                                var command
                                console.log("model.type: " + model.type)
                                if ( model.type != "auto") {
                                    command = command + "-t " + model.type + " " //.toString() not necessary?
                                    console.log("type is not auto, command is now: " + command )
                                }

                                console.log("model.device: " + model.device)
                                if ( model.device != undefined ) {
                                    command = command + "\"" + model.device + "\" "
                                    console.log("device was specified, command is now: " + command )
                                }

                                console.log("model.path: " + model.path)
                                if ( model.path != undefined ) {
                                    command = command + "\"" + model.path +"\" "
                                    console.log("device was specified, command is now: " + command )
                                }

                                console.log("model.args: " + model.args)
                                if ( model.args != undefined ) {
                                    command = command + "-o " + model.args +" "
                                    console.log("device was specified, command is now: " + command )
                                }

                                //mountProcess.start("/usr/bin/sudo", [ command ]);




                            }
                        }

                        MenuItem {
                            text: "Unmount"
                            //visible:  entryListID.isMounted == "true"
                            onClicked: {
                                return
                            }
                        }

                        MenuItem {
                            text: "Edit"
                            onClicked: {
                                currentMountEntry = entryListID.entryNumber
                                pageStack.push(Qt.resolvedUrl("EditEntry.qml"))
                            }
                        }

                        MenuItem {
                            text: "Delete"
                            onClicked: {
                                entryListID.remorseAction("Deleting", function() {
                                    console.log("Deleting" + entryListID.entryNumber)
                                    deleteEntry(entryListID.entryNumber)
                                    entries.remove(model.index)
                                })
                            }
                        }

                        MenuItem {
                            visible:  page.debug == "true"
                            text: "[Debug] Print index"
                            onClicked: {
                                console.log(model.index)
                            }
                        }

                        MenuItem {
                            visible:  page.debug == "true"
                            text: "[Debug] Print all properties"
                            onClicked: {
                                console.log("device: " + model.device + "\ntype: " + model.type + "\npath: " + model.path + "\nargs: " + model.args)
                            }
                        }
                    }
                }
            }
        }
    }
}
