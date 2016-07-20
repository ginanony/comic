import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.Controls 1.3
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import "../events.js" as E
import ".."
Rectangle{
  function updateProgress(i,j){ E.updateProgress(i,j);}
  function finishDownload(s){
    E.finishDownload(s);
    var g = "dfdf";
  }
  FontLoader{
    id: mainFont
    source: "qrc:///fonts/BNazanin.ttf"
  }
  id:root
  color: "#00000000"
  property var proot: root
  visible: true
  anchors.fill: parent
  anchors.margins: bridge.getGlobal("padding")
  property bool dling: false
  property var demo: function(){}
  property string fullText: I_samary
  Component.onDestruction: {
    if(dling)
      bridge.dcdl("NDG_"+bridge.getValue("id"))
  }
  Component.onCompleted: {
    dling = false
    if(bridge.isdling("NDG_"+bridge.getValue("id"))){
      bridge.cdl("NDG_"+bridge.getValue("id"), root)
      prog.visible = true
      stat.visible = true
      dlbtn.enabled = false
      canbtn.visible = false
    }
  }
  Flickable{
    Border{
      commonBorderWidth:  bridge.getGlobal("padding")/2
      secColor: "#6f6f6f"
      secWidth: 1
    }

    anchors.fill: parent
    contentWidth: parent.width
    contentHeight: gl.height
    Column{
      id:gl
      spacing: bridge.getGlobal("padding")
      width: parent.width
      anchors.centerIn: parent
              Image {
                id:ii
                width: gl.width
                verticalAlignment: Image.AlignVCenter
                anchors.margins: bridge.getGlobal("padding")
                height: (sourceSize.height / (sourceSize.width/width))
                source: "data:image/jpg;base64,"+I_src
              }
      Text {
        font.family: mainFont.name
        font.pixelSize: 25 * A.dp
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
      Row {
        Rectangle{
          height: parent.height
          width: bridge.getGlobal("padding")
          color: "#00000000"
        }
      RaisedButton {
        backgroundColor: "#178b42"
        textColor: "white"
        id: dlbtn
        text: "دریافت کمیک"
        Layout.margins: bridge.getGlobal("padding")/2
        Layout.rightMargin: bridge.getGlobal("padding");Layout.leftMargin: bridge.getGlobal("padding")
        MouseArea {
          id:downloader
          anchors.fill: parent
          onClicked: {
            prog.visible = true
            stat.visible = true
            dling = true
            console.log(I_file)
            bridge.AddComic(I_file,
                            "NDG_"+bridge.getValue("id"),
                            root,
                            bridge.getValue("id"),
                                                       I_title,
                                                       I_samary,
                                                       I_size,
                                                       I_page,
                                                       I_src)
            dlbtn.enabled = false
            canbtn.visible = true
            stat.text =  "-- of --"
          }
        }
      }

      RaisedButton {
        id: viewer
        text: "نمایش کمیک"
        backgroundColor: "#178b42"
        textColor: "white"
        Layout.margins: bridge.getGlobal("padding")/2
        Layout.rightMargin: bridge.getGlobal("padding")
        Layout.leftMargin: bridge.getGlobal("padding")
        visible: false
        MouseArea{
          anchors.fill: parent
          onClicked: {
            present(Qt.resolvedUrl("../comicViewer/main.qml"));
          }
        }
      }
      Rectangle{
        height: parent.height
        width: bridge.getGlobal("padding")
        color: "#00000000"
      }

      RaisedButton {
        id: dlbtns
        backgroundColor: "#d91314"
        textColor: "white"
        text: "پیش نمایش"
        Layout.margins: bridge.getGlobal("padding")/2
        Layout.rightMargin: bridge.getGlobal("padding");Layout.leftMargin: bridge.getGlobal("padding")
        MouseArea {
          id:downloaders
          anchors.fill: parent
          onClicked: {
            demo(I_preview)
          }
        }
      }
      }
      Row {
        width: parent.width
      Button{
        id: canbtn
              onClicked: {
                if(bridge.cancel("NDG_"+bridge.getValue("id"))){
                prog.visible = false
                stat.visible = false
                dlbtn.enabled = true
                canbtn.visible = false
                }
              }
              text: "×"
              visible: false
            }
      ProgressBar {
        id: prog
        width: (canbtn.visible)?parent.width - canbtn.width:parent.width
        value: 0
        Layout.rightMargin: bridge.getGlobal("padding");Layout.leftMargin: bridge.getGlobal("padding")
        visible: false
        anchors.top: canbtn.top
        anchors.topMargin: (canbtn.height - height)/2
      }
      }
      Text {
        id: stat
        text: "-- of --"
        visible: false
      }
      Rectangle{
        width: parent.width
        height: bridge.getGlobal("padding")/2
        color: "#00000000"
      }
    }
  }
}
