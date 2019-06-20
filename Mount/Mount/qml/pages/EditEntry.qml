// NameInputDialog.qml
import QtQuick 2.2
import Sailfish.Silica 1.0
import "../storage.js" as Storage

Dialog {
    canAccept: {
        name.text != ""
        name.text != " "
        name.text != "  "
        name.text != "   "
        name.text != undefined
        name.text != null
    }
    acceptDestination: Qt.resolvedUrl("FirstPage.qml")




    onStatusChanged:   { //This is called every time the page is accessed in some way.
        switch (status ){
        case PageStatus.Activating:
            console.log("PageStatus.Activating") //I think I stole these debug messages from harbor-tooter. Sidenote, if anyone is reading this, I will legitimately pay someone 5 Pound Sterling using PayPal if they can fix it to work reliably with pleroma. I know it's not that much but I am broke :/
            console.log("currentMountEntry: " + currentMountEntry)
            console.log("mount" + currentMountEntry + "type :" + Storage.get("mount" + currentMountEntry + "type", ""))
            console.log("mount" + currentMountEntry + "args :" + Storage.get("mount" + currentMountEntry + "args", ""))
            break;
        case PageStatus.Inactive:
            console.log("PageStatus.Inactive")
            break;
        }
    }



    Column {
        width: parent.width

        DialogHeader {
            title: "Add new entry"
            //cancelText: "Back"
            //acceptText: "Save"
        }

        TextField {
            id: name
            width: parent.width
            label: "Name (e.g. USB Stick)"
            labelVisible: true
            placeholderText: "Name (e.g. USB Stick)"
            EnterKey.onClicked: device.focus = true
            text: Storage.get("mount" + currentMountEntry + "name", "No Name")
        }

        TextField {
            id: device
            width: parent.width
            label: "Path of device (e.g. /dev/sda)"
            labelVisible: true
            placeholderText: "Path of device (e.g. /dev/sda)"
            EnterKey.onClicked: type.focus = true
            text: Storage.get("mount" + currentMountEntry + "device", "")
        }

        ComboBox {
            id: type
            width: parent.width
            label: 'Filesystem:'
            menu: ContextMenu {
                Repeater {
                    model: [ 'auto', 'custom' ]

                    MenuItem {
                        text: modelData
                    }
                }
            }
            currentIndex: if (Storage.get("mount" + currentMountEntry + "type", "auto") == "auto") {
                              0
                          }
                          else {
                              1
                          }
        }

        TextField {
            id: typeCustom
            visible: type.value == "custom"
            width: parent.width
            label: "Filesystem type (e.g. \"davfs\")"
            labelVisible: true
            placeholderText: "Filesystem type (e.g. \"davfs\")"
            EnterKey.onClicked: path.focus = true
            text: if (Storage.get("mount" + currentMountEntry + "type", "auto") == "auto") {
                      ""
                  }
                  else {
                      Storage.get("mount" + currentMountEntry + "type", "auto")
                  }



        }

        TextField {
            id: path
            width: parent.width
            label: "Where to mount it (e.g. /mnt/myData)"
            labelVisible: true
            placeholderText: "Where to mount it (e.g. /mnt/myData)"
            EnterKey.onClicked: args.focus = true
            text: Storage.get("mount" + currentMountEntry + "path", "")
        }

        TextField {
            id: args
            width: parent.width
            label: "Special parameters to pass (e.g. rw,uid=1234,nosuid)"
            labelVisible: true
            placeholderText: "Special parameters to pass (e.g. rw,uid=1234,nosuid)"
            text: Storage.get("mount" + currentMountEntry + "args", "")
            EnterKey.onClicked: console.log("args.text: " + args.text)
        }

    }

      onAccepted: {
        var i = currentMountEntry

        console.log("mount" + i + "used: " + Storage.get("mount" + i + "used", "false"))

        Storage.set("mount" + i + "used", "true")
        Storage.set("mount" + i + "name", name.text)

        if (type.value == "auto") {
            console.log("type: auto")
            Storage.set("mount" + i + "type", "auto")
        }

        if (type.value == "custom") {
            console.log("type: custom")
            console.log("typeCustom.text: " + typeCustom.text)
            Storage.set("mount" + i + "type", typeCustom.text)
        }

        Storage.set("mount" + i + "device", device.text)
        Storage.set("mount" + i + "path", path.text)
        Storage.set("mount" + i + "args", args.text)
        console.log("amountOfEntries.length: " + amountOfEntries.length) //test2
    }
}
