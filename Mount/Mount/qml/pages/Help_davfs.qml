import QtQuick 2.0
import Sailfish.Silica 1.0
import "../storage.js" as Storage
import Process 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    onStatusChanged: { //This is called every time the page is accessed in some way.
        switch (status ){
        case PageStatus.Activating:
            console.log("PageStatus.Activating") //I think I stole these debug messages from harbor-tooter. Sidenote, if anyone is reading this, I will legitimately pay someone 5 Pound Sterling using PayPal if they can fix it to work reliably with pleroma. I know it's not that much but I am broke :/
            break;
        case PageStatus.Inactive:
            console.log("PageStatus.Inactive")
            break;
        }
    }


    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: parent.width
            spacing: Theme.paddingLarge
            PageHeader {
                id: header
                title: qsTr("davfs2")
            }

            SectionHeader {
                text: "First Steps"
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingMedium
                    rightMargin: Theme.paddingMedium
                }
            }

            TextArea {
                readOnly: true
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingMedium
                    rightMargin: Theme.paddingMedium
                }
                text: "1) First install `davfs2` by NielDK from Open Repos.\n2)Create a folder where to mount your server, for example /run/media/nemo/myServer.\n
By the way, if you should you ever feel lost I urge you to go read the arch wiki. It's a fantastic resource and generally has really good documentation that's helpful even if not using Arch. Just search it for davfs2."
            }

            SectionHeader {
                text: "Details: Secrets file"
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingMedium
                    rightMargin: Theme.paddingMedium
                }
            }

            TextArea {
                readOnly: true
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingMedium
                    rightMargin: Theme.paddingMedium
                }
                text: "Next you should set up the secrets file.\n
As root, edit the file in /etc/davfs2/secrets and add your details. For a nextcloud instance on a special port, a line may look like this:\n
https://example.com:123456/nextcloud/remote.php/files john passw0rd\n\n
Once you're done, make sure you `chown root:root` and `chmod 600` the file."
            }

            SectionHeader {
                text: "Details: Certificate"
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingMedium
                    rightMargin: Theme.paddingMedium
                }
            }

            TextArea {
                readOnly: true
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingMedium
                    rightMargin: Theme.paddingMedium
                }
                text: "If you were to try and mount it manually via command line now, it should work but you might get an annoying prompt every time asking you to confirm the certificate.\n
This may be due to SFOS being outdates as hell (and not accepting letsencrypt certificates), or a thing from davfs. Either way it's annoying and will prevent this app from working.\n
Technically davfs2 should support just trusting a specific CA (trust_ca_cert), but whether you're gonna get that to work is another thing. While you will probably have to re-copy the certificate every time it's renewed, the easiest option is to just whitelist your server's certificate.\n
To do that, edit the file /etc/davfs2/davfs2.conf and the following to the file:\n
trust_server_cert        /etc/davfs2/certs/myServerCert.pem\n
Now save, and copy the public server certificate (in .pem) format over to the location you specified. For a letsencrypt certificate the file you need is probably located in /etc/letsencrypt/live/example.com/cert.pem\n
Manually mounting should now work without being asked to confirm the cert every time."
            }

            SectionHeader {
                text: "App settings"
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingMedium
                    rightMargin: Theme.paddingMedium
                }
            }

            TextArea {
                readOnly: true
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingMedium
                    rightMargin: Theme.paddingMedium
                }
                text: "To mount and unmount webdav in this app, the following settings are tested and work with a nextcloud server:\n
Device path: \"https://example.com:123456/nextcloud/remote.php/files\"\n
filesystem: set to custom: \"davfs2\"\n
Where to mount: /run/media/nemo/myServer\n
Parameters to pass: rw,user,uid=nemo

"
            }


        }

    }

}
