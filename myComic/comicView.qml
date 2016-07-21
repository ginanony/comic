import QtQuick 2.0
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.Controls 1.3
import ".."
Page {
  id: root
  onVisibleChanged: {
    bridge.setRoot(root);
  }

  actionBar: ActionBar {
    id: actionBar
    ufont: mainFont.name
    upEnabled: true
    title: "<b>"+xml.model.get(0).I_title+"</b>"
    showTitle: true
    onActionButtonClicked: back();
    z: 10
    nav:nav.nav
  }
  FontLoader{
    id: mainFont
    source: "qrc:///fonts/BNazanin.ttf"
  }
  JSONListModel {
    id: xml
    json: bridge.getComic(bridge.getValue("id"));
    query: "$[*]"
  }
  Dialog {
      id: dialog
      anchors.centerIn: parent
      title: "کمیک حذف شود"
      Text {
        width: parent.width
        wrapMode: Text.WordWrap
          text: "احتمالا فایل های کمیک از روی حافظه شما پاک شده آیا می خواهید کمیک حذف شود؟"
      }
      z: 20
      rejectButtonText: "بماند"
      acceptButtonText: "حذف شود"
      onAccepted: {
        bridge.removeComic(bridge.getValue("id"));
        back()
      }
  }

  Repeater{
    delegate:
        Flickable{
      anchors.topMargin: bridge.getGlobal("padding")
      anchors.bottomMargin: bridge.getGlobal("padding")
      anchors.leftMargin: bridge.getGlobal("padding")
      anchors.rightMargin: bridge.getGlobal("padding")
      anchors.fill: parent
      id: flick
      contentWidth: width
      contentHeight: wrect.height
      Rectangle{
        id:wrect
        visible: true
        color: "white"
        border.color: "#6f6f6f"
        width: flick.width
        height: gl.height+bridge.getGlobal("padding")
        Column{

          Component.onCompleted: {
              if(!bridge.fexists(I_path+"/pages.json"))
                dialog.open()
          }
          id:gl
          spacing: bridge.getGlobal("padding")
          anchors.margins: bridge.getGlobal("padding")
          anchors.top: wrect.top
          anchors.left: wrect.left
          anchors.right: wrect.right
          width: wrect.width
          Image {
            id:ii
            width: gl.width
            height: sourceSize.height / (sourceSize.width/width)
            source: "file://"+I_src
            //width: parent.width
            //            Image {
            //              width: parent.width
            //              height: desc1.height+10
            //              source: "qrc:/imasges/grG.png"
            //              Text {
            //                id: desc1
            //                text: I_title
            //                width: parent.width
            //                horizontalAlignment: Text.AlignHCenter
            //                y: 5
            //                font.bold: true
            //                color: "#FFFFFF"
            //              }
            //            }
          }
          Text {
            font.pixelSize: 24 * A.dp
            font.family: mainFont.name
            font.weight: Font.Bold
            id: title
            horizontalAlignment: Text.AlignHCenter
            text: I_title
            width: gl.width
            Rectangle{
                      id: tBorder
                      height: 1
                      color: "#6f6f6f"
                      width: gl.width+bridge.getGlobal("padding")
                      anchors.top: title.bottom
                      x: -bridge.getGlobal("padding")/2
                      anchors.topMargin: bridge.getGlobal("padding")
                    }
          }
          Rectangle{
                  id: foo
                  clip: true
                  height: bridge.getGlobal("maxlen")
                  width: parent.width

                  Text{
                  id: desc
                  text:I_samary
                  font.family: mainFont.name
                  font.pixelSize: A.dp * 16
                  wrapMode: Text.WordWrap
                  width: parent.width

                }
                  Behavior on height {
                      NumberAnimation { duration: 700 }
                  }}
                Text {
                  id: more
                  text: qsTr("˅")
                  font.family: mainFont.name
                  font.pixelSize: A.dp * 45
                  height: A.dp * 45
                  horizontalAlignment: Text.AlignHCenter
                  width: parent.width
                  color: "#bebebe"
                  property bool actived: false
                  MouseArea {
                    anchors.fill: parent
                    onClicked: {
                      if(!parent.actived){
                        parent.text = "˄"
                        foo.height = desc.height
                        parent.actived = true
                      }else{
                        parent.text = "˅"
                        foo.height = bridge.getGlobal("maxlen")
                        parent.actived = false
                      }
                    }
                  }
                  Rectangle{
                    id: cBorder
                    height: 1
                    color: "#6f6f6f"
                    width: gl.width+bridge.getGlobal("padding")
                    x: -bridge.getGlobal("padding")/2
                    anchors.top: more.bottom
                    anchors.topMargin: bridge.getGlobal("padding")
                  }
                }

                Rectangle{
                  height: bridge.getGlobal("padding")
                  width: parent.width
                  color: "#00000000"
                }
          RaisedButton {
            id: dlbtn
            text: "نمایش داستان"
            backgroundColor: "#178b42"
            textColor: "white"
            MouseArea {
              anchors.fill: parent
              onClicked: {
                present(Qt.resolvedUrl("../comicViewer/main.qml"));
              }
            }
          }
          Rectangle{
            width: parent.width
            height: bridge.getGlobal("padding")
            color: "#00000000"
          }
        }
      }
    }
    model: xml.model
  }
  Mymenu{
    id: nav
    topPage: root
    anchors.fill: parent
  }
}
