import QtQuick 2.0
import QuickAndroid 0.1
Item {
  property var nav: root
  property var topPage: root
  FontLoader{
    id: mainFont
    source: "qrc:///fonts/BNazanin.ttf"
  }
  ListModel{
    id: mainModel/*
    ListElement {
      title: "تنظیمات نرم افزار"
      icon: "qrc:///images/isetting.png"
      qtarget: "5"
    }*/
    ListElement {
      title: "دریافت کمیک"
      icon: "qrc:///images/iget.png"
      qtarget: "qrc:///news/getComic.qml"
    }
    ListElement {
      title: "بروز رسانی"
      icon: "qrc:///images/iupdate.png"
      qtarget: "qrc:///about/update.qml"
    }
    ListElement {
      title: "درباره ما"
      icon: "qrc:///images/iinfo.png"
      qtarget: "qrc:///about/hoze.qml"
    }
    ListElement {
      title: "سازنده نرم افزار"
      icon: "qrc:///images/iglob.png"
      qtarget: "qrc:///about/arvid.qml"
    }
    ListElement {
      title: "خروج"
      icon: "qrc:///images/ioff.png"
      qtarget: "Exit"
    }
  }

  NavigationDrawer{
    id: root
    Rectangle {
      anchors.fill: parent
      color: "#d91314"
      // Список с пунктами меню
      ListView {
        anchors.fill: parent

        anchors.topMargin: bridge.getGlobal("padding")*2
model: mainModel
        delegate: Item {
          height: 48
          anchors.left: parent.left
          anchors.right: parent.right



            Text {
              id: titl
              text: "<b>"+title+"</b>"
              anchors.fill: parent
              font.pixelSize: 16 * A.dp
              anchors.rightMargin: bridge.getGlobal("padding")*2
              font.family: mainFont.name
              color: "white"
              renderType: Text.NativeRendering
              horizontalAlignment: Text.AlignRight
              verticalAlignment: Text.AlignVCenter
            }
            Image {
              id: ico
              source: icon
              verticalAlignment: Image.AlignVCenter
              anchors.leftMargin: bridge.getGlobal("padding")*2
              height: titl.height -  bridge.getGlobal("padding") *  2.5
              width: height
              anchors.top: titl.top
              anchors.left: titl.left
              anchors.topMargin: (height>titl.height)?0:((titl.height-height)/2)
            }
            Rectangle{
              width: titl.width+bridge.getGlobal("padding")
              height: 1
              color: "#e84443"
              anchors.top: titl.bottom
            }

            MouseArea {
              anchors.fill: parent
              // По нажатию на пункт меню заменяем компонент в Loader
              onClicked: {
                root.toggle()
                if(title == "خروج"){
                  Qt.quit()
                  return
                }
                topPage.present(mainModel.get(index).qtarget)
              }
          }
        }

      }
    }
  }
}

