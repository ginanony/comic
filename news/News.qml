import QtQuick 2.0
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.4
import "../events.js" as E
import "../"

Page {
  property int page: 1
  property var topPage: root
  property bool active: true
  property bool firstLoad: false
  property var model1: []
  property ListModel g_model: ListModel{id:foo}
  id: root
  FontLoader{
    id: mainFont
    source: "qrc:///fonts/BNazanin.ttf"
  }
  XmlListModel{
    id: xml
    source: (root.active)?bridge.server()+"?view=android":""
    query: "/rss/channel/item"
    onStatusChanged: {
      switch(xml.status){
      case XmlListModel.Loading:
        loadText.text = "در حال دریافت اطلاعات"
        break
      case XmlListModel.Error:
        if(!firstLoad){
          loadText.text = "خطا! متاسفانه دریافت اطلاعات از شبکه کامل نشد."
          bindic.visible = false
          reLoad.visible = true
        }
      }

      if(xml.status == XmlListModel.Ready){
        loading.visible = false
        firstLoad = true
      }
    }
    onCountChanged: {
      if(g_model.count!=0){g_model.clear()}
      var i;
      var tmp = [];
      for(i=0;i<count;i+=2){
        tmp = [];tmp[0] =xml.get(i);
        if(xml.get(i+1))  tmp.push(xml.get(i+1))
        g_model.append({ar:tmp})

      }
    }
    XmlRole { name: "I_src"; query: "image/string()"}
    XmlRole { name: "I_size"; query: "size/number()"}
    XmlRole { name: "I_id"; query: "id/number()"}
    XmlRole { name: "I_title"; query: "title/string()"}
    XmlRole { name: "I_desc"; query: "description/string()"}
  }

  XmlListModel{
    id: xml2
    query: "/rss/channel/item"

    onStatusChanged: {
      switch(xml2.status){
      case XmlListModel.Loading:
        loadText.text = "در حال دریافت اطلاعات"
        break
      case XmlListModel.Error:
        if(!firstLoad){

          loadText.text = "خطا! متاسفانه دریافت اطلاعات از شبکه کامل نشد."
          bindic.visible = false
          reLoad.visible = true
        }else{loading.visible = false}
        break
      }
      if(xml2.status == XmlListModel.Ready){
        loading.visible = false
        //loading.visible = false
      //if(g_model.count!=0){g_model.clear()}
      var i;
      var tmp = [];
      for(i=0;i<count;i+=2){
        tmp = [];tmp[0] =xml2.get(i);
        if(xml2.get(i+1))  tmp.push(xml2.get(i+1))
        g_model.append({ar:tmp})

      }
      }
    }
    XmlRole { name: "I_src"; query: "image/string()"}
    XmlRole { name: "I_size"; query: "size/number()"}
    XmlRole { name: "I_id"; query: "id/number()"}
    XmlRole { name: "I_title"; query: "title/string()"}
    XmlRole { name: "I_desc"; query: "description/string()"}
  }
  Flickable{
    id: flick
    anchors.fill: parent
    contentWidth: width
    contentHeight: column.height
    anchors.topMargin: bridge.getGlobal("padding")
    anchors.bottomMargin: bridge.getGlobal("padding")
    anchors.leftMargin: Math.floor(bridge.getGlobal("padding"))
    anchors.rightMargin: Math.floor(bridge.getGlobal("padding"))
    Column {
      width: parent.width
      id:column
      spacing: bridge.getGlobal("padding")
      Repeater {
        model: g_model
        delegate:Row{
          spacing: bridge.getGlobal("padding")
          Repeater {
            model: ar
            delegate:
                Rectangle {
              id: wrect
              border.color: "#6f6f6f"
              width: name.width+5
              height: childrenRect.height+bridge.getGlobal("padding")

              Image {BusyIndicator{id:iloading; anchors.centerIn: parent}
                id: name
                source: I_src
                anchors.top: wrect.top
                anchors.left: wrect.left
                Layout.minimumWidth: iloading.width
                Layout.minimumHeight: iloading.height
                anchors.topMargin: bridge.getGlobal("padding")/2
                anchors.leftMargin: (bridge.getGlobal("padding")-5)/2
                width: (flick.width/2) - bridge.getGlobal("padding")-5
                height: (sourceSize.height / (sourceSize.width/width))-5
                onStatusChanged: {
                  if(name.status == Image.Ready)
                    iloading.visible = false
                }
                MouseArea {
                  onClicked: {
                    bridge.setValue("id", I_id)
                    if(bridge.isExists(I_id)){
                      root.topPage.present(Qt.resolvedUrl("../myComic/comicView.qml"))
                    }else{
                      root.topPage.present(Qt.resolvedUrl("newsView.qml"));
                    }
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
                text: "<b>مشاهده جزئیات...</b>"
                color: "#d91312"
                font.family: mainFont.name
                font.pixelSize: 20 * A.dp
                anchors.margins: bridge.getGlobal("padding")
                anchors.top: tBorder.bottom
                anchors.right: bookIcon.left
                MouseArea {
                  onClicked: {
                    bridge.setValue("id", I_id)
                    if(bridge.isExists(I_id)){
                      root.topPage.present(Qt.resolvedUrl("../myComic/comicView.qml"))
                    }else{

                      root.topPage.present(Qt.resolvedUrl("newsView.qml"));
                    }
                  }
                  anchors.fill: parent
                }
              }

            }
          }
        }
      }
      RaisedButton {
        text: "بیشتر..."
        visible: (g_model.count>0)
        onClicked: {
          root.page ++;
          loading.visible = true
          loadText.text = "در حال دریافت اطلاعات"
          xml2.source = bridge.server()+"?view=android&paged="+root.page
        }

        width: parent.width
      }

    }
  }
  Column{
    spacing: bridge.getGlobal("padding")
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
