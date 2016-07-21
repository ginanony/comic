import QtQuick 2.0
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Layouts 1.1
import QtQuick.Layouts 1.1
import "../events.js" as E
import ".."
Page {

  property ListModel g_model: ListModel{id:foo}
  property var model1: [1,2]
  property int page: 1
  //property ListElement t_model: ListElement{I_src:"foo"}
  property var topPage: root
  id:root

  onEnabledChanged: {
    json.json =  bridge.getList(0,bridge.getGlobal("countItem"));
  }
  actionBar: ActionBar {
    id: actionBar
    ufont: mainFont.name
    upEnabled: true
    title: "<b>کمیک های من</b>"
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
    id: json
    json: bridge.getList(0,bridge.getGlobal("countItem"));
    query: "$[*]"
    onCountChanged: {
      if(g_model.count!=0){g_model.clear()}
      var i;
      var tmp = [];
      for(i=0;i<count;i+=3){
        tmp = [];tmp[0] =model.get(i)
        if(model.get(i+1))  tmp.push(model.get(i+1))
        if(model.get(i+2))  tmp.push(model.get(i+2))

        g_model.append({ar:tmp})
      }
    }
  }
  JSONListModel {
    id: json2
    query: "$[*]"
    onStatusChanged: {
      if(json2.status == 10){
        var i;
        var tmp = [];
        for(i=0;i<count;i+=3){
          tmp = [];tmp[0] =model.get(i)
          if(model.get(i+1))  tmp.push(model.get(i+1))
          if(model.get(i+2))  tmp.push(model.get(i+2))

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
                width: (flick.width/3) - bridge.getGlobal("padding")-5
                height: (sourceSize.height / (sourceSize.width/width))
                MouseArea {
                  onClicked: {
                    bridge.setValue("id", I_id)
                    bridge.setValue("path",I_path)
                    root.topPage.present(Qt.resolvedUrl("../comicViewer/main.qml"));
                  }
                  anchors.fill: parent
                }
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
                MouseArea {
                  onClicked: {
                    bridge.setValue("id", I_id)
                    bridge.setValue("path",I_path)
                    root.topPage.present(Qt.resolvedUrl("../comicViewer/main.qml"));
                  }
                  anchors.fill: parent
                }
              }
              Rectangle{
                id: tBorder
                height: 1
                color: "#6f6f6f"
                width: wrect.width
                anchors.top: title.bottom
                anchors.topMargin: bridge.getGlobal("padding")
                MouseArea {
                  onClicked: {
                    bridge.setValue("id", I_id)
                    bridge.setValue("path",I_path)
                    root.topPage.present(Qt.resolvedUrl("../comicViewer/main.qml"));
                  }
                  anchors.fill: parent
                }
              }
              Image {
                anchors.right: tBorder.right
                anchors.top: tBorder.bottom
                id: bookIcon
                height: detBut.height * 0.75
                width: sourceSize.width / (sourceSize.height/height)
                anchors.margins: bridge.getGlobal("padding")
                source: "qrc:///images/bookimg.jpg"
                MouseArea {
                  onClicked: {
                    bridge.setValue("id", I_id)
                    bridge.setValue("path",I_path)
                    root.topPage.present(Qt.resolvedUrl("../comicViewer/main.qml"));
                  }
                  anchors.fill: parent
                }
              }
              Text {
                id: detBut
                text: "<b>خواندن داستان </b>"
                color: "#168c42"
                font.family: mainFont.name
                font.pixelSize: 16 * A.dp
                anchors.margins: bridge.getGlobal("padding")
                anchors.top: tBorder.bottom
                anchors.right: bookIcon.left
                MouseArea {
                  onClicked: {
                    bridge.setValue("id", I_id)
                    bridge.setValue("path",I_path)
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
        visible: (bridge.getList(bridge.getGlobal("countItem")*page,1)!== "")
        onClicked: {

          json2.json  = bridge.getList(bridge.getGlobal("countItem")*page,bridge.getGlobal("countItem"));
          root.page ++;
        }
        width: parent.width
      }
    }
  }
  Mymenu{
    id: nav
    topPage: root
    anchors.fill: parent
  }
}

