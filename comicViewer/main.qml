import QtQuick 2.0
import QtQuick.Layouts 1.1
import "../"
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import "../theme"
Page {
  property bool inited: false
  Component.onCompleted: {
    if(bridge.isHelper("Comic"))
      helper.visible = true
    if(!bridge.fexists(bridge.getComicInfo(bridge.getValue("id"),"I_path")+"/pages.json"))
      dialog2.open()

    bridge.setValue("page", bridge.getPage(bridge.getValue("id")));
    if(bridge.getValue("continue") == "YES"){
      tabView.currentIndex = bridge.getValue("page");
      bridge.setValue("continue",false)
    }else if(bridge.getValue("continue") == "NO"){
      bridge.setValue("continue",false)
    }else{
    if(bridge.getValue("page")>0)
      dialog.open()
    }
    inited = true
  }
  Dialog {
      id: dialog2
      anchors.centerIn: parent
      title: "کمیک حذف شود"
      Text {
        width: parent.width
        wrapMode: Text.WordWrap
          text: "احتمالا فایل های کمیک از روی حافظه شما پاک شده آیا می خواهید کمیک حذف شود؟"
      }
      z: 20
      rejectButtonText: "بماند"
      acceptButtonText: "حذف شود"
      onAccepted: {
        bridge.removeComic(bridge.getValue("id"));
        back();
      }

  }
  Dialog {
      id: dialog
      anchors.centerIn: parent
      title: "خواندن از ادامه"
      Text {
        width: parent.width
        wrapMode: Text.WordWrap
          text: "آیا می خواهید داستان از آخرین صفحه ای که می خواندید شروع شود؟"
      }
      z: 20
      rejectButtonText: "شروع از ابتدا"
      acceptButtonText: "ادامه"
      onAccepted: {
        //if(bridge.getValue("page")< tabView.count)
          tabView.currentIndex = bridge.getValue("page");
      }
  }
  Rectangle{
    id: helper
    anchors.fill: parent
    color: Qt.rgba(0.20,0.20,0.20,0.70)
    z: 100
    visible: false
    Image {
      id: helpTab
      source: "qrc:///images/swipeleft.png"
      anchors.top: parent.top
      anchors.topMargin: (parent.height - height)/4
      anchors.left: parent.left
    }
    Text {
      id: helpTabText
      text: "<b>
برای خواندن به ترتیب داستان <br>
انگشت خود را به سمت چپ بکشید
</b>"
      anchors.margins: bridge.getGlobal("padding")
      verticalAlignment: Text.AlignJustify
      color: "#FFFFFF"
      font.family: mainFont.name
      font.pixelSize: A.dp * 21
      anchors.top: helpTab.top
      anchors.left: helpTab.right
      width: parent.width - helpTab.width - bridge.getGlobal("padding")
      wrapMode: Text.WordWrap
    }
    Image {
      id: helpRswipe
      source: "qrc:///images/swiperight.png"
      anchors.top: (helpTab.bottom>helpTabText.bottom)?helpTab.bottom:helpTabText.bottom
      anchors.topMargin: bridge.getGlobal("padding")*2
      anchors.right: parent.right
    }
    Text {
      id: helpRswipeText
      text: "<b>
یا برای خواندن برعکس داستان <br>
انگشت خود را به سمت راست بکشید
</b>"
      anchors.margins: bridge.getGlobal("padding")
      color: "#FFFFFF"
      font.family: mainFont.name
      horizontalAlignment: Text.AlignRight
      font.pixelSize: A.dp * 21
      anchors.top: helpRswipe.top
      anchors.right: helpRswipe.left
      width: parent.width - helpRswipe.width - bridge.getGlobal("padding")
      wrapMode: Text.WordWrap
    }
    FontLoader{
      id: mainFont
      source: "qrc:///fonts/BNazanin.ttf"
    }

    Image {
      id: helpPull
      source: "qrc:///images/dlbtab.png"
      anchors.top: (helpRswipe.height>helpRswipeText.height)?helpRswipe.bottom:helpRswipeText.bottom
      anchors.topMargin: bridge.getGlobal("padding")*4
      anchors.left: parent.left
    }
    Text {
      id: helpPullText
      text: "<b>
برای خروج از این حالت دوبار ضربه بزنید سپس: <br>
۱. با کشیدن انگشت روی صفحه بین صفحات داستان حرکت کنید<br>
۲. برای انتخاب بخشی از داستان روی آن بخش دوبار ضربه بزنید
</b>"
      anchors.margins: bridge.getGlobal("padding")
      verticalAlignment: Text.AlignJustify
      color: "#FFFFFF"
      font.family: mainFont.name
      font.pixelSize: A.dp * 21
      anchors.top: helpPull.top
      anchors.topMargin: (helpPull.height>height)?(helpPull.height - height) /2:0
      anchors.left: helpPull.right

      width: parent.width - helpPull.width - bridge.getGlobal("padding")
      wrapMode: Text.WordWrap
    }
    MouseArea{
      anchors.fill: parent
      onClicked: {
        parent.visible = false
        bridge.viewedHelper("Comic")
      }
    }
  }
  id: root
  function makeStruct(names) {
    names = names.split(' ');
    var count = names.length;
    function constructor() {
      for (var i = 0; i < count; i++) {
        this[names[i]] = arguments[i];
      }
    }
    return constructor;
  }
  function getPoints(points){
    var p;
    var lines = points.split(";")
    var point = Array();
    for(var i = 0;i<lines.length;i++){
      p = lines[i].split(",");
      point[i] = root.makeStruct("x y w h hd");
      point[i].x =  p[0];
      point[i].y =  p[1];
      point[i].w =  p[2]-p[0];
      point[i].h =  p[3]-p[1];
      point[i].hd= point[i].h;
    }
    return point
  }
  property bool drag: false
  JSONListModel {
    id: json
    source: "file://"+bridge.getComicInfo(bridge.getValue("id"),"I_path")+"/pages.json"
    query: "$[*]"
  }
  TabView {

    id: tabView
    onCurrentIndexChanged: {
      if(inited)
        bridge.setPage(bridge.getValue("id"),tabView.currentIndex);
    }

    interactive: root.drag
    anchors.fill: parent
    model: VisualDataModel {
      id: vdm
      model: json.model
      delegate: Comic {
        signal send
        onSend: {
        }

        id: name
        isource: "file://"+bridge.getComicInfo(bridge.getValue("id"),"I_path")+"/"+src
        zoom: getPoints(points)
        width: tabView.width
        height: tabView.height
        MouseArea {
          anchors.fill: parent
          onClicked: {
            init();
          }
          SwipeArea {
            anchors.fill: parent
            onDoubleClicked: {
              if(!root.drag){
                reinit(true)
                root.drag = true
              }else{
                findPoint(mouse.x,mouse.y)
                root.drag = false
              }

            }
            onClicked: {
              init();
            }

            onSwipe: {
              if(root.drag)
                return
              switch (direction) {
              case "left":
                if(nagivate(false) && tabView.count>tabView.currentIndex-1){
                  reinit(true)
                  if(tabView.currentIndex<tabView.count-1)
                    tabView.currentIndex++;
                }
                break
              case "right":
                if(nagivate(true) && tabView.currentIndex>0){
                  reinit(true)
                  bridge.setValue("Last",1)
                  if(tabView.currentIndex>0)
                  tabView.currentIndex--;
                }
                break
              }
            }
          }
        }
      }
    }
  }
}


