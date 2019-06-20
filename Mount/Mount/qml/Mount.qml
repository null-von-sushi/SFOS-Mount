import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "./storage.js" as Storage

ApplicationWindow
{
    id: root
    property var amountOfEntries: []
    property string currentMountEntry: "" /*

    cardsUsed
    property string temporaryValue: ""
    property string cardOpen: "false"*/

    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.Portrait  //defaultAllowedOrientations
}


// http://www.xargs.com/qml/process.html

// official sudo
// unofficial davfs2
