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
  actionBar: ActionBar {
    iconSource: A.drawable("ic_menu",Constants.white100)
    showIcon: false
    ufont: mainFont.name
    id: tools
    actionButtonEnabled: false
    title: "<b>کتاب های مصور</b>"
    nav: nav.nav
    Component.onCompleted: {
      bridge.setValue("tools", tools)
    }
  }
  FontLoader{
    id: mainFont
    source: "qrc:///fonts/BNazanin.ttf"
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
