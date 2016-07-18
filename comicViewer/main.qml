import QtQuick 2.0
import QtQuick.Layouts 1.1
import "../"
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import "../theme"
Page {
  property bool inited: false
  Component.onCompleted: {
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


