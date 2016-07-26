import QtQuick 2.0
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.4
import "."
import ".."

Page {
  property bool zoom: false
  property bool move: false
  property int firstDef: 0
  property int firstX: 0
  property int firstY: 0
  id: root
  onVisibleChanged: {
    bridge.setRoot(root);
  }
  function show(url){
    demo.visible = true
    demor.visible = true
    demoi.source = url
    demoi.visible = true
  }
  function hide() {
    demo.visible = false
    demor.visible = false
    //demoi.source = url
    demoi.visible = false
  }

  FocusScope {
    id: demo
    visible: false
    focus:visible
    Keys.onReleased: {
      if (event.key === Qt.Key_Back ||
          event.key === Qt.Key_Escape) {
        hide();

        event.accepted = true;
      }
    }

    z: 100
    anchors.fill: parent
    Rectangle {
      id: demor
      anchors.fill: parent
      color: Qt.rgba(0.20,0.20,0.20,0.70)
      z: 100
      visible: false
MouseArea{anchors.fill: parent; onClicked: {}}
      Column{
        spacing: 7
        anchors.centerIn: parent
        id: dloading
        width: parent.width
        Rectangle{
          id: xcdfff
          width: parent.width
          height: dbindic.height
          color: "#00000000"
        BusyIndicator {
          id:dbindic
            //anchors.leftMargin: parent.width - width / 2
            anchors.centerIn: parent
        }
        Image {
          anchors.top: dbindic.top
          anchors.left: dbindic.left
          id: dreLoad
          visible: false
          width: dbindic.width
          height: dbindic.height
          source: "qrc:///images/Refresh_icon.png"
          MouseArea {
            anchors.fill: parent
            onClicked:  {

              demoi.source = demoi.source+"?"
              dloadText.text =  "در حال دریافت اطلاعات"
              dbindic.visible = true
              parent.visible = false
            }
          }
        }
        }
          Text {
          id: dloadText
          color: "#ffffff"
          width: parent.width
          horizontalAlignment: Text.AlignHCenter
          text: "در حال دریافت اطلاعات"

        }
      }
    }
    Image {
      id: demoi
      Drag.active: true
      visible: false
      onStatusChanged: {
        if(status == Image.Ready){
          if(height > root.height-actionBar.height)
            height = root.height - (20 * A.dp) - actionBar.height
          if(sourceSize.width > root.width)
            width = root.width -(20 * A.dp)
          x = (demor.width - width)/2
          y = (demor.height - height)/2
          dloading.visible = false
        }
            switch(demoi.status){
            case Image.Loading:
              dloadText.text = "در حال دریافت اطلاعات"
              break
            case Image.Error:
                dloadText.text = "خطا! متاسفانه دریافت اطلاعات از شبکه کامل نشد."
                dbindic.visible = false
                dreLoad.visible = true
              break
            }
      }

      fillMode: Image.PreserveAspectFit
      z: 101
      MultiPointTouchArea {
        id: touch
        mouseEnabled: true
        anchors.fill: parent
        touchPoints: [
          TouchPoint { id: point1 },
          TouchPoint { id: point2 }
        ]
        onPressed: {
          if(point1.pressed && point2.pressed){
            zoom = true
            move = false
          }else{
            move = true
            zoom = false
          }
          firstX = point1.sceneX
          firstY = point1.sceneY
          firstX
          firstDef = Math.abs(point1.x - point2.x)
        }
        onReleased:  {
          zoom = false
          move = false
          if(point1.pressed && point2.pressed){
            zoom = true
            move = false

          }else{
            move = true
            zoom = false
          }
        }

        onTouchUpdated: {
          if(zoom){
          var def = Math.abs(point1.x-point2.x)
          var ind = def / firstDef;
          if(ind < 0.75)
            ind = 0.75
          if(ind > 1.5)
            ind = 1.5
          if(demoi.width >= demoi.sourceSize.width*4 && ind > 1)
            ind = 1
          if(demoi.width <= demoi.sourceSize.width/4 && ind < 1)
            ind = 1

          demoi.width *= ind
          demoi.height *= ind
          firstDef = def
          }else if(move){
            var dx =  point1.sceneX -firstX
            var dy =  point1.sceneY -firstY
//            if(dx > root.width/4)
//              dx = root.width/4
//            if(dx < -root.width/4)
//              dx = -root.width/4
//            if(dy > root.height/4)
//              dy = root.height/4
//            if(dy < -root.height/4)
//              dy = -root.height/4
//            var defx = demoi.width - root.width
//            var defy = demoi.height - root.height
//            defx = (defx<0)?0:defx
//            defy = (defy<0)?0:defy
//            if(demoi.x > root.width + defx - 25 && dx > 0)
//              dx = 0
//            if(demoi.x <  25 - defx && dx < 0)
//              dx = 0
//            if(demoi.y > root.height + defy - 25 && dy > 0)
//              dy = 0
//            if(demoi.y <  25 - defy && dy < 0)
//              dy = 0
            demoi.x += dx
            demoi.y += dy
            firstX = point1.sceneX
            firstY = point1.sceneY
          }
        }
      }
//      MouseArea {
//        id: mousearea
//        enabled: false
//        drag.target: parent
//        anchors.fill: parent
//      }
    }
  }
  actionBar: ActionBar {
    id: actionBar
    ufont: mainFont.name
    upEnabled: true
    showTitle: true
    onActionButtonClicked: back();
    z: 10
    nav:nav.nav
  }
  FontLoader{
    id: mainFont
    source: "qrc:///fonts/BNazanin.ttf"
  }
  XmlListModel {
    id: xml
    source: bridge.server()+"?p="+bridge.getValue('id')+"&view=android"
    query: "/rss/channel/item"
    XmlRole { name: "I_src"; query: "image/string()"}
    XmlRole { name: "I_title"; query: "title/string()"}
    XmlRole { name: "I_samary"; query: "samary/string()"}
    XmlRole { name: "I_size"; query: "size/string()"}
    XmlRole { name: "I_page"; query: "page/string()"}
    XmlRole { name: "I_file"; query: "file/string()"}
    XmlRole { name: "I_preview"; query: "preview/string()"}
    XmlRole { name: "I_id"; query: "id/number()"}

    onStatusChanged: {
        switch(xml.status){
        case XmlListModel.Loading:
          loadText.text = "در حال دریافت اطلاعات"
          break
        case XmlListModel.Error:
            loadText.text = "خطا! متاسفانه دریافت اطلاعات از شبکه کامل نشد."
            bindic.visible = false
            reLoad.visible = true
          break
        }
      if(xml.status == XmlListModel.Ready){
        loading.visible = false
        actionBar.title =  "<b>"+xml.get(0).I_title+"</b>"
      }

    }
  }

  Repeater{
    delegate:Newsdelegate{proot: root;z: 5;demo: show}


    model: xml
  }

  Mymenu{
    id: nav
    topPage: root
    anchors.fill: parent
    z: 100
  }

  Column{
    spacing: 7
    anchors.centerIn: parent
    id: loading
    width: parent.width
    Rectangle{
      width: parent.width
      height: bindic.height
      color: "#00000000"
    BusyIndicator {
      id:bindic
        //anchors.leftMargin: parent.width - width / 2
        anchors.centerIn: parent
    }
    Image {
      anchors.top: bindic.top
      anchors.left: bindic.left
      id: reLoad
      visible: false
      width: bindic.width
      height: bindic.height
      source: "qrc:///images/Refresh_icon.png"
      MouseArea {
        anchors.fill: parent
        onClicked:  {
          if(firstLoad)
            xml2.reload()
          else
            xml.reload()
          loadText.text =  "در حال دریافت اطلاعات"
          bindic.visible = true
          parent.visible = false
        }
      }
    }
    }
    Text {
      id: loadText
      width: parent.width
      horizontalAlignment: Text.AlignHCenter
      text: "در حال دریافت اطلاعات"
    }
  }

}
