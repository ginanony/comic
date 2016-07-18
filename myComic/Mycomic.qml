import QtQuick 2.0
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Layouts 1.1
import QtQuick.Layouts 1.1
import "../events.js" as E
import ".."
Page {
  property var topPage: root
  id:root
  function refresh() {
    json.json = bridge.getList(0,5);
  }
  JSONListModel {
    id: json
    json: bridge.getList(0,5);
    query: "$[*]"
  }
  FontLoader{
    id: mainFont
    source: "qrc:///fonts/BNazanin.ttf"
  }
  JSONListModel {
    id: json2
    json: bridge.getList(5,6);
    query: "$[*]"
  }
  Flickable{
    id: flick
    anchors.topMargin: bridge.getGlobal("padding")
        anchors.bottomMargin: bridge.getGlobal("padding")
        anchors.leftMargin: Math.floor(bridge.getGlobal("padding"))
    anchors.fill: parent
    contentWidth: width
    contentHeight: grid.height+flick2.height+bridge.getGlobal("padding")+button.height+bridge.getGlobal("padding")
    GridLayout {
      width: parent.width-10
      layoutDirection: Qt.LeftToRight
      id: grid
      columns: 3
      rows: 3
      columnSpacing: bridge.getGlobal("padding")
      rowSpacing: bridge.getGlobal("padding")
      Repeater{
        model: json.model
        delegate: Image {
          id: name
          Layout.row: (index<=1)?0:Math.floor(((index+1)/3)+1)
          Layout.column: (index==0)?0:Math.floor((index+1)%3)
          source: "file://"+I_src
          Layout.fillWidth: true
          Layout.maximumHeight: parent.width/3
          Layout.columnSpan: (index==0)?2:1*1
          Layout.rowSpan: (index==0)?2:1*1
          MouseArea {
            onClicked: {
              bridge.setValue("id", I_id)
              bridge.setValue("path",I_path)
              root.topPage.present(Qt.resolvedUrl("comicView.qml"));
            }
            anchors.fill: parent
          }
        }
      }
    }
    RaisedButton {
      text: "<b>لیست کامل</b>"
      backgroundColor: "red"
      anchors.top: grid.bottom
      textColor: "white"
      anchors.left: grid.left
      onClicked: {
        root.topPage.present(Qt.resolvedUrl("../reading/MuLists.qml"));
      }

      anchors.topMargin: bridge.getGlobal("padding")
      visible: (json2.count > 1)
      id:button

    }
    Text {
      id: label
      verticalAlignment: Text.AlignRight
      anchors.top: grid.bottom
      anchors.right: grid.right
      anchors.topMargin: bridge.getGlobal("padding")
      text: "<b>کمیک ها</b>"
      font.pixelSize: 18 * A.dp
      visible: (json2.count > 1)
      font.family: mainFont.name
    }
    Flickable{
      id:flick2
      contentWidth: rr.width
      anchors.top: button.bottom
      anchors.topMargin: bridge.getGlobal("padding")
      width: parent.width
      height: rr.height
      visible: (json2.count > 2)
      Row {
        id:rr
        spacing: 10
        Repeater{
          model: json2.model
          delegate: Image {
            source: "file://"+I_src
            height: root.width/3
            width: height
            id:images
            MouseArea {
              onClicked: {
                bridge.setValue("id", I_id)
                bridge.setValue("path",I_path)
                root.topPage.present(Qt.resolvedUrl("comicView.qml"));
              }
              anchors.fill: parent
            }
            Rectangle {
              color: "#fff"
              anchors.top: parent.bottom
              anchors.topMargin: -childrenRect.height
              Text {
                text: "<b>"+I_title+"</b>"
                font.family: mainFont.name
                width:images.width
                wrapMode: Text.WrapAnywhere
                maximumLineCount: 1
                horizontalAlignment: Text.AlignHCenter
              }
              width: childrenRect.width
              height: childrenRect.height
            }
          }
        }
      }
    }
  }
}

