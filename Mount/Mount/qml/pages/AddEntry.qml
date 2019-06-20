// NameInputDialog.qml
import QtQuick 2.2
import Sailfish.Silica 1.0
import "../storage.js" as Storage

Dialog {
    acceptDestination: Qt.resolvedUrl("FirstPage.qml")

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
        }

        TextField {
            id: device
            width: parent.width
            label: "Path of device (e.g. /dev/sda)"
            labelVisible: true
            placeholderText: "Path of device (e.g. /dev/sda)"
            EnterKey.onClicked: type.focus = true
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
        }

        TextField {
            id: typeCustom
            visible: type.value == "custom"
            width: parent.width
            label: "Filesystem type (e.g. \"davfs\")"
            labelVisible: true
            placeholderText: "Filesystem type (e.g. \"davfs\")"
            EnterKey.onClicked: path.focus = true
        }

        TextField {
            id: path
            width: parent.width
            label: "Where to mount it (e.g. /mnt/myData)"
            labelVisible: true
            placeholderText: "Where to mount it (e.g. /mnt/myData)"
            EnterKey.onClicked: args.focus = true
        }

        TextField {
            id: args
            width: parent.width
            label: "Special parameters to pass (e.g. rw,uid=1234,nosuid)"
            labelVisible: true
            placeholderText: "Special parameters to pass (e.g. rw,uid=1234,nosuid)"
        }

    }

      onAccepted: {
        //first we find out our number
        var i = amountOfEntries.length

        console.log("amountOfEntries.length: " + amountOfEntries.length) //test1

        i = i + 1
        console.log("mount" + i + "used: " + Storage.get("mount" + i + "used", "false"))

        Storage.set("mount" + i + "used", "true")
        Storage.set("mount" + i + "name", name.text)
        console.log("type: " + type.value)
        console.log("typeCustom: " + typeCustom.text)

        if ( type.value == "auto" ) {

            Storage.set("mount" + i + "type", "auto")
        }

        if ( type.value == "custom" ) {
            console.log("typeCustom.text: " + typeCustom.text)
            Storage.set("mount" + i + "type", typeCustom.text)
            console.log("mount" + i + "type successfully set to : " + Storage.get("mount" + i + "type", "not_set"))
        }

        Storage.set("mount" + i + "device", device.text )
        Storage.set("mount" + i + "path", path.text )
        Storage.set("mount" + i + "args", args.text )
        console.log("amountOfEntries.length: " + amountOfEntries.length) //test2
    }
}
