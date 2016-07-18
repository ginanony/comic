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
            id: desc
            horizontalAlignment: Text.AlignHCenter
            text: I_title
            width: gl.width
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
