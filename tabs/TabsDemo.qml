import QtQuick 2.0
import QtQuick.Layouts 1.1
import QuickAndroid 0.1

Page {
    actionBar: ActionBar {
        title: "Tabs Demonstration"
        onActionButtonClicked: back();
        height: material.unitHeight + tabs.height


    }
    MouseArea {
      anchors.fill: parent
      onClicked: {
        console.log("fuck")
        tabView.currentIndex = 2
      }
    }
    property var colorModel: [
        { title: "Blue" },
        { title: "Green" },
        { title: "Yellow" }
    ]

    TabView {
        id: tabView
        enabled: false
        anchors.fill: parent

        model: VisualDataModel {
            model: colorModel
            delegate: Rectangle {
                width: tabView.width
                height: tabView.height
                color: modelData.title
                MouseArea {
                  anchors.fill: parent
                  onClicked: {
                    console.log("fuck")
                    tabView.currentIndex = 2
                  }
                }
            }
        }
    }

}

