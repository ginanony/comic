import QtQuick 2.0
import QuickAndroid 0.1
import QuickAndroid.Styles 0.1
import "../theme"
import ".."
Page {

    actionBar: ActionBar {
        id: actionBar
        upEnabled: true
        title: qsTr("DropDownMenu Demo")
        showTitle: true

        onActionButtonClicked: back();
        z: 10
        nav: nav
        menuBar : Button {
            id: menuButton
            iconSource : A.drawable("ic_menu",Constants.black87)
            iconSourceSize: Qt.size(A.px(24),A.px(24));
            onClicked:  {
                dropDownMenu.open();
            }
        }
    }

    DropDownMenu {
        id: dropDownMenu
        anchorView: menuButton
        anchorPoint: Constants.rightTop
        model: VisualDataModel {
            model: ListModel {
                ListElement { title: "Share" }
                ListElement { title: "Copy" }
                ListElement { title: "Delete"}
            }

            delegate: ListItem {
                title: model.title
                showDivider: false
                onClicked: {
                    dropDownMenu.close();
                    label.text = model.title;
                }
            }

        }
    }

    Text {
        id: label
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color : Constants.black87
        font.pixelSize: ThemeManager.currentTheme.largeText.textSize
    }
    NavigationDrawer {
        id: nav
        Rectangle {
            anchors.fill: parent
            color: "white"

            // Список с пунктами меню
            ListView {
                anchors.fill: parent

                delegate: Item {
                    height: dp(48)
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: dp(5)
                        color: "whitesmoke"

                        Text {
                            text: fragment
                            anchors.fill: parent
                            font.pixelSize: dp(20)

                            renderType: Text.NativeRendering
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        MouseArea {
                            anchors.fill: parent

                            // По нажатию на пункт меню заменяем компонент в Loader
                            onClicked: {
                                loader.loadFragment(index)
                            }
                        }
                    }
                }

                model: navModel
            }
        }
    }
}
