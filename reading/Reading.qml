import QtQuick 2.0
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import "../events.js" as E
import ".."
Page {
  property ListModel g_model: ListModel{id:foo}
  property var model1: [1,2]
  property int page: 1
  property var topPage: root
  property int bheight: 0
  id:root
  function refresh() {
    json.json = bridge.getRList(0,bridge.getGlobal("countItem"));
  }
  FontLoader{
    id: mainFont
    source: "qrc:///fonts/BNazanin.ttf"
  }
  JSONListModel {
    id: json
    json: bridge.getRList(0,bridge.getGlobal("countItem"));
    query: "$[*]"
    onCountChanged: {
      if(g_model.count!=0){g_model.clear()}
      var i;
      var tmp = [];
      for(i=0;i<count;i+=2){
        tmp = [];tmp[0] =model.get(i)
        if(model.get(i+1))  tmp.push(model.get(i+1))
        g_model.append({ar:tmp})
      }
    }
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
  }
  JSONListModel {
    id: json2
    query: "$[*]"

    onStatusChanged: {
      if(json2.status == 10){
      var i;
      var tmp = [];
      for(i=0;i<count;i+=2){
        tmp = [];tmp[0] =model.get(i)
        if(model.get(i+1))  tmp.push(model.get(i+1))
        g_model.append({ar:tmp})
      }
      }
    }
  }
  Flickable{
    id: flick
    anchors.fill: parent
    contentWidth: width
    contentHeight: column.height
    anchors.topMargin: bridge.getGlobal("padding")
    anchors.bottomMargin: bridge.getGlobal("padding")
    anchors.leftMargin: Math.floor(bridge.getGlobal("padding"))
    Column {
      id:column
      add:
          Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 500 }
      }

      spacing: bridge.getGlobal("padding")
      Repeater {
        model: g_model
        delegate:Row{
          spacing: bridge.getGlobal("padding")
          Repeater {
            model: ar
            delegate:  Rectangle {
              id: wrect
              border.color: "#6f6f6f"
              width: name.width+5
              height: childrenRect.height+5+bridge.getGlobal("padding")

              Image {
                id: name
                source: "file://"+I_src
                anchors.top: wrect.top
                anchors.left: wrect.left
                anchors.topMargin: bridge.getGlobal("padding")/2
                anchors.leftMargin: (bridge.getGlobal("padding")-5)/2
                width: (flick.width/2) - bridge.getGlobal("padding")-5
                height: (sourceSize.height / (sourceSize.width/width))
              }
              Text {
                id: title
                text: "<b>"+I_title+"</b>"
                maximumLineCount:1
                anchors.top: name.bottom
                wrapMode: Text.WrapAnywhere
                font.family: mainFont.name
                font.pixelSize: 20 * A.dp
                anchors.margins: bridge.getGlobal("padding")
                width: name.width
                horizontalAlignment: Text.AlignHCenter
              }
              Rectangle{
                id: tBorder
                height: 1
                color: "#6f6f6f"
                width: wrect.width
                anchors.top: title.bottom
                anchors.topMargin: bridge.getGlobal("padding")
              }
              Image {
                anchors.right: tBorder.right
                anchors.top: tBorder.bottom
                id: bookIcon
                height: detBut.height * 0.75
                width: sourceSize.width / (sourceSize.height/height)
                anchors.margins: bridge.getGlobal("padding")
                source: "qrc:///images/bookimg.jpg"
              }
              Text {
                id: detBut
                text: "<b>خواندن از ابتدا</b>"
                color: "#d91312"
                font.family: mainFont.name
                font.pixelSize: 16 * A.dp
                anchors.margins: bridge.getGlobal("padding")
                anchors.top: tBorder.bottom
                anchors.right: bookIcon.left
                MouseArea {
                  onClicked: {
                    bridge.setValue("id", I_id)
                    bridge.setValue("path",I_path)
                    bridge.setValue("continue","NO")
                    root.topPage.present(Qt.resolvedUrl("../comicViewer/main.qml"));
                  }
                  anchors.fill: parent
                }
              }

              Image {
                anchors.right: tBorder.right
                anchors.top: detBut.bottom
                id: bookIcon2
                height: detBut2.height * 0.75
                width: sourceSize.width / (sourceSize.height/height)
                anchors.margins: bridge.getGlobal("padding")
                source: "qrc:///images/bookimg.jpg"
              }
              Text {
                id: detBut2
                text: "<b>خواندن باقی مانده</b>"
                color: "#168c42"
                font.family: mainFont.name
                font.pixelSize: 16 * A.dp
                anchors.margins: bridge.getGlobal("padding")
                anchors.top: detBut.bottom
                anchors.right: bookIcon2.left
                MouseArea {
                  onClicked: {
                    bridge.setValue("id", I_id)
                    bridge.setValue("path",I_path)
                    bridge.setValue("continue","YES")
                    root.topPage.present(Qt.resolvedUrl("../comicViewer/main.qml"));
                  }
                  anchors.fill: parent
                }
              }
            }
          }
        }
      }

      RaisedButton {
        backgroundColor: "red"
        text: "بیشتر..."
        visible: (bridge.getRList(bridge.getGlobal("countItem")*page,1)!== "")
        onClicked: {
          json2.json  = bridge.getRList(bridge.getGlobal("countItem")*page,bridge.getGlobal("countItem"));
          root.page ++;
        }

        width: parent.width
      }
    }
  }
}

