import QtQuick 2.0

Rectangle {
  property string src
  property alias h: image.height
  height: image.height+8

Rectangle {
  color: "#fff"
anchors.fill: parent
  Image {
    id: image
    source: src
    width: parent.width-8
    height: sourceSize.height / (sourceSize.width/width)
  }
}

}
