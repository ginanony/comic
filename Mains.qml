import QtQuick 2.0
import QtQuick.Layouts 1.1
import QuickAndroid 0.1
import "./news"
import "./myComic"
import "./reading"
import "./button"
Page {
  objectName: "ComponentPage";
  id:root
  property var splash
  property bool inited: false
  function init(){
    if(inited)
      return
    inited = true
    splash.visible = false
    tools.visible = true
    if(bridge.isHelper("Home"))
      helper.visible = true
  }
  Timer {
    id: timer
    interval: 900
    onTriggered: {
      init()
    }
  }

  onHeightChanged: {
    if(height>0)
      init()
    else
      timer.start()
  }
  actionBar: ActionBar {
    iconSource: A.drawable("ic_menu",Constants.white100)
    showIcon: false
    ufont: mainFont.name
    id: tools
    actionButtonEnabled: false
    title: "<b>کتاب های مصور</b>"
    nav: nav.nav
    visible: false
    onVisibleChanged: {
    }

    onEnabledChanged: {
      tabView.refresh()
    }

  }
  FontLoader{
    id: mainFont
    source: "qrc:///fonts/BNazanin.ttf"
  }
  Rectangle{
    id: helper
    anchors.fill: parent
    color: Qt.rgba(0.20,0.20,0.20,0.70)
    z: 100
    visible: false
    Image {
      id: helpTab
      source: "qrc:///images/tab.png"
      anchors.top: parent.top
      anchors.left: parent.left
    }
    Text {
      id: helpTabText
      text: "<b>
برای مشاهده بخش های مختلف<br>
نرم افزار از منو استفاده کنید<br>
(روی آیکن بالا ضربه بزنید)
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
      id: helpPull
      source: "qrc:///images/pull.png"
      anchors.top: parent.top
      anchors.topMargin: (parent.height - height) /2
      anchors.left: parent.left
    }
    Text {
      id: helpPullText
      text: "<b>
یا سمت چپ صفحه را به داخل بکشید
</b>"
      anchors.margins: bridge.getGlobal("padding")
      verticalAlignment: Text.AlignJustify
      color: "#FFFFFF"
      font.family: mainFont.name
      font.pixelSize: A.dp * 21
      anchors.top: helpPull.top
      anchors.topMargin: (helpPull.height - height) /2
      anchors.left: helpPull.right

      width: parent.width - helpPull.width - bridge.getGlobal("padding")
      wrapMode: Text.WordWrap
    }
    MouseArea{
      anchors.fill: parent
      onClicked: {
        parent.visible = false
        bridge.viewedHelper("Home")
      }
    }
  }

  TabBar {
    id: tabs
    ufont: mainFont.name
    currentIndex: 2
    backgroundColor: "#FFFFFF"
    indicatorColor: "#d91314"
    width: parent.width
    tabs: colorModel2
    anchors.top: parent.top

  }
  property var colorModel2: [
    { title: "<b>کمیک های جدید</b>" },
    { title: "<b>خوانده شده ها</b>" },
    { title: "<b>کمیک ها</b>" }
  ]
  TabView {
    anchors.top: tabs.bottom
    id: tabView
    tabBar:tabs
    currentIndex: 2
    onCurrentIndexChanged: {
      refresh()
    }
    function refresh() {
      if(currentIndex == 2)
        mycomic.refresh()
      else if(currentIndex == 1)
        reading.refresh()
    }
    width: parent.width
    model: VisualItemModel {
      News {   id: news;   width: tabView.width; height: tabView.height; topPage: root}

      Reading {id:reading; width: tabView.width; height: tabView.height; topPage: root}

      Mycomic {id:mycomic; width: tabView.width; height: tabView.height; topPage: root}

    }
    height: parent.height - tabs.height
  }
  Mymenu{
    id: nav
    topPage: root
    anchors.fill: parent
  }
}
