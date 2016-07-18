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
      title: "<b>دریافت کمیک</b>"
      showTitle: true
      onActionButtonClicked: back();
      z: 10
      nav:nav.nav
  }
News {
anchors.fill: parent
topPage: root
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
