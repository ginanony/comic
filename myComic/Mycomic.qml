import QtQuick 2.0
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import "../events.js" as E
import ".."
Page {
  property var topPage: root
  id:root
  onVisibleChanged: {
    refresh()
  }
  Column{
    id: havent
    spacing: bridge.getGlobal("padding")
    anchors.centerIn: parent
    width: parent.width
    visible: (json.count < 1)
    z:100
    Rectangle{
      width: parent.width
      height: bindic.height
      color: "#00000000"
    BusyIndicator {
      id:bindic
        //anchors.leftMargin: parent.width - width / 2
        anchors.centerIn: parent
        visible: false
    }
    Image {
      anchors.top: bindic.top
      anchors.left: bindic.left
      id: reLoad
      width: bindic.width
      height: bindic.height
      source: "qrc:///images/arrow.png"
      MouseArea {
        anchors.fill: parent
        onClicked:  {
        }
      }
    }
    }
    Text {
      id: loadText
      width: parent.width
      horizontalAlignment: Text.AlignHCenter
      text: "در حال حاضر کمیکی ندارید!"
    }
    Text {
      id: loadText2
      width: parent.width
      horizontalAlignment: Text.AlignHCenter
      text: "به قسمت کمیک جدید بروید و کمیک دریافت کنید."
    }
  }

  function refresh() {
    json.json = bridge.getList(0,5);
    json2.json = bridge.getList(5,6);
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
          fillMode: Image.PreserveAspectCrop
          Layout.row: (index<=1)?0:Math.floor(((index+1)/3)+1)
          Layout.column: (index==0)?0:Math.floor((index+1)%3)
          source: (I_path=="http://")?I_src:"file://"+I_src
          Layout.fillWidth: true
          Layout.maximumHeight: (Layout.row>0)?parent.width/3:(parent.width/3)*2
          Layout.columnSpan: (index==0)?2:1*1
          Layout.rowSpan: (index==0)?2:1*1
          MouseArea {
            onClicked: {
              bridge.setValue("id", I_id)
              if(I_path == "http://"){
                root.topPage.present(Qt.resolvedUrl("../news/newsView.qml"));
              }else{

                bridge.setValue("path",I_path)
                root.topPage.present(Qt.resolvedUrl("comicView.qml"));
              }
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
      visible: (json2.count > 0)
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
      visible: (json2.count > 0)
      font.family: mainFont.name
    }
    Flickable{
      id:flick2
      contentWidth: rr.width
      anchors.top: button.bottom
      anchors.topMargin: bridge.getGlobal("padding")
      width: parent.width
      height: rr.height
      visible: (json2.count > 0)
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

