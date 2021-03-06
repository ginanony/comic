import QtQuick 2.0
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import ".."
Page {
  id: root
  actionBar: ActionBar {
      id: actionBar
      ufont: mainFont.name
      upEnabled: true
      title: "<b>درباره ما</b>"
      showTitle: true
      onActionButtonClicked: back();
      z: 10
      nav:nav.nav
  }
  Flickable{
    id: flick
    anchors.topMargin: bridge.getGlobal("padding")
        anchors.bottomMargin: bridge.getGlobal("padding")
        anchors.leftMargin: Math.floor(bridge.getGlobal("padding"))
    anchors.fill: parent
    contentWidth: width
    contentHeight: wrect.height
    Rectangle {
      id: wrect
      width: flick.width-bridge.getGlobal("padding")
      height: ocolumn.height+bridge.getGlobal("padding")
      color: "white"
      border.color: "#6f6f6f"
      Column{
        spacing: bridge.getGlobal("padding")
        id:ocolumn
        width: parent.width
        anchors.margins: bridge.getGlobal("padding")
        anchors.top: wrect.top
        anchors.left: wrect.left
        anchors.right: wrect.right
      Image {
        id: logo
        source: "qrc:///images/hoze.jpg"
        fillMode: Image.PreserveAspectFit
        width: parent.width
      }
      Text {

        font.family: mainFont.name
        font.pixelSize: 16 * A.dp
        anchors.margins: bridge.getGlobal("padding")
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignJustify
        width: parent.width
        text: "<b>حوزه هنری استان لرستان واحد انیمیشن آدرس:
<br>لرستان، خرم آباد، خیابان علوی، خیابان دکتر حسابی، نبش آرش 6 روبه روی آموزش و پرورش<br>
<br>تلفن: 33435302  فکس : 33435303 </b>"
      }
      Rectangle{
        width: parent.width
        height: bridge.getGlobal("padding")*1.5
        color: "#00000000"
      }
      Row {
        width: parent.width
        spacing:  bridge.getGlobal("padding")
        Image {
          id: baazar
          source: "qrc:///images/baazar.jpg"
          width: (parent.width / 2) - bridge.getGlobal("padding")
          height: sourceSize.height / (sourceSize.width/width)
          MouseArea {
            anchors.fill: parent
            onClicked: {
              Qt.openUrlExternally("http://cafebazaar.ir")
            }
          }
        }
        Image {
          id: site
          source: "qrc:///images/hozeSite.jpg"
          width: (parent.width / 2) - bridge.getGlobal("padding")
          height: sourceSize.height / (sourceSize.width/width)
          MouseArea {
            anchors.fill: parent
            onClicked: {
              Qt.openUrlExternally("http://artlorestan.ir")
            }
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


  FontLoader{
    id: mainFont
    source: "qrc:///fonts/BNazanin.ttf"
  }
  Mymenu{
    id: nav
    topPage: root
    anchors.fill: parent
  }
}

