import QtQuick 2.3
import QtQuick.Window 2.2
/**
  * Isuses:
  * 1: centeral problem
  *
**/
Rectangle {
  id: window
  property real cf: 1
  property real fcf: 1
  property var wsize: {"width": 0,"height":0}
  property string isource
  property bool resizing: false
  property var zoom: [{x:0,y:0,w:1280,h:1968},
    {x:24,y:667,w:1248,h:336},
    {x:19,y:1051,w:632,h:1005},
    {x:674,y:1054,w:597,h:1005}
  ]
  property int current: -2;
  property int px: 0
  property int py: 0
  visible: true
  /*anchors.fill: parent*/
  function reinit(){
    if(window.resizing) return;
    var i; var x; var y; var w; var h;



    window.current = 0
    window.cf =  window.width /image.width
    if(image.height*window.cf>window.height){
      // if image height more than window height
      window.cf =  window.height /image.height
      // reduse image width
      w = image.width *window.cf
      h = image.height * window.cf
      // image align to center
      x = (window.width - w)/2
      y = 0
    }else{
      // fixing image height
      h = image.height *window.cf
      w = image.width *window.cf
      // image vertical align to center
      x = 0
      y = (window.height - h)/2
    }
    // rebulid all x,y points
    for(i = 0; i<window.zoom.length;i++){
      window.zoom[i].x *= window.cf
      window.zoom[i].y *= window.cf
    }
    utdhAnimation.to = 0
    utdyAnimation.to = window.height
    rtlwAnimation.to = 0
    rtlxAnimation.to = window.width
    dtuhAnimation.to = 0
    dtuyAnimation.to = 0
    ltrwAnimation.to = 0
    ltrxAnimation.to = 0
    xAnimation.to = x
    yAnimation.to = y
    wAnimation.to = w
    hAnimation.to = h
    animateHead.start();
    window.current = -1
    window.cf = window.fcf
  }

  function init() {
    rtlg.width = 0;
    // on_load >> image size to window size
    if(window.current<-1 && window.width && image.width){
      var i;

      utdg.height =  0
      utdg.y = window.height
      rtlg.width = 0
      rtlg.x = window.x
      dtug.height = 0
      dtug.y = 0
      ltrg.width = 0
      ltrg.x = 0

      window.current = 0
      window.wsize.width = image.width
      window.wsize.hieght= image.height
      window.cf =  window.width /image.sourceSize.width
      if(image.sourceSize.height*window.cf>window.height){
        // if image height more than window height
        window.cf =  window.height /image.sourceSize.height
        // reduse image width
        image.width = image.sourceSize.width *window.cf
        // image align to center
        image.x = (window.width - image.width)/2
      }else{
        // fixing image height
        image.height = image.sourceSize.height *window.cf
        // image vertical align to center
        image.y = (window.height - image.height)/2
      }
      // rebulid all x,y points
      for(i = 0; i<window.zoom.length;i++){
        window.zoom[i].x *= window.cf
        window.zoom[i].y *= window.cf
      }
      window.current = -1
      window.fcf = window.cf;
    }
  }
  function findPoint(x,y){
    var i;
     for(i = 0; i<window.zoom.length;i++)
       if(window.zoom[i].x < x-image.x)
         if((window.zoom[i].w*window.cf)+ window.zoom[i].x >  x-image.x)
           if(window.zoom[i].y  < y-image.y)
             if((window.zoom[i].h*window.cf)+ window.zoom[i].y >  y-image.y){
               window.current = i-1;
               nagivate(false)
             }

  }

  function nagivate(prev) {
    var i;
    var f;
    window.init()
    if(bridge.getValue("Last") == 1){
      window.current = window.zoom.length
      bridge.setValue("Last",0)
    }

    if(window.resizing) return;
    if(prev){

      if(window.current>0){
        window.current--;
      }else{return true;}
    }else{
      if(window.current<window.zoom.length-1){
        window.current++;
      }else{return true;}
    }
    var fullWidth;
    if((window.zoom[window.current].w*window.wsize.hieght/window.wsize.width) > window.zoom[window.current].h){
      f = (window.wsize.width/window.zoom[window.current].w )/window.cf;
      fullWidth = true
    }else{
      f = (window.wsize.hieght/window.zoom[window.current].h )/window.cf;
      fullWidth = false;
    }
    window.cf *= f;
    var h = image.height* f;
    var w = image.width * f;
    var x = -(window.zoom[window.current].x*f);
    var y = -(window.zoom[window.current].y*f)
    var gy = 0;
    var gh = 0;
    var gw = 0;
    var gx = 0;
    if(!fullWidth){
                    //var nx = (window.wsize.width - (window.zoom[window.current].w*f)) /2
      gy = window.height
      gh = 0

      gx = (window.zoom[window.current].w*(window.height / window.zoom[window.current].h))
      gw = window.width - gx
      gx += gw/2
      px = gw /= 2
      x += gw
    //                console.log(nx)
    //                if(image.x<0){
    //                  //x += nx
    //                }else {
    //                  //x -= nx
    //                }
    }else{
                    //var ny = (window.wsize.height -  (window.zoom[window.current].h*f)) /2
      gy = (window.zoom[window.current].h*(window.width / window.zoom[window.current].w))
      gh = window.height - gy
      gy += gh / 2
      py = gh /= 2;
      gx = window.width
      gw = 0
      y += gh
    //                console.log(ny)
    //                if(y<0){
    //                  y += ny
    //                }else {
    //                  y -= ny
    //                }
    }
    for(i = 0; i<window.zoom.length;i++){
      window.zoom[i].x *= f
      window.zoom[i].y *= f
      window.zoom[i]._w *= f
      window.zoom[i]._h *= f
      window.zoom[i].hd*= f
    }
    xAnimation.to = x
    yAnimation.to = y
    wAnimation.to = w
    hAnimation.to = h
    utdhAnimation.to = gh
    utdyAnimation.to = gy
    rtlwAnimation.to = gw
    rtlxAnimation.to = gx
    dtuhAnimation.to = gh
    ltrwAnimation.to = gw
    animateHead.start();

    //    var pw =  window.zoom[window.current].w - window.zoom[window.current].x;
    //    var ph =  window.zoom[window.current].h - window.zoom[window.current].y;
    //    var f = (window.wsize.width/pw )/window.cf;
    //    //console.log(window.zoom[window.current].h * f , window.wsize.hieght)
    //    if(window.zoom[window.current].h * f > window.wsize.hieght)
    //      console.log(f = (window.wsize.hieght/ph )/window.cf);
    //    window.cf *= f;
    //    var h = image.height* f;
    //    var w = image.width * f;
    //    var x = -(window.zoom[window.current].x*f);
    //    //                    var nx = (window.wsize.width - w) /2
    //    //                    console.log(nx)
    //    //                    if(image.x<0){
    //    //                      x += nx
    //    //                    }else {
    //    //                      x -= nx
    //    //                    }
    //    var y = -(window.zoom[window.current].y*f)
    //    //                var ny = (window.wsize.height - y) /2
    //    //                console.log(ny)
    //    //                if(y<0){
    //    //                  y += ny
    //    //                }else {
    //    //                  y -= ny
    //    //                }
    //    for(i = 0; i<window.zoom.length;i++){
    //      window.zoom[i].x *= f
    //      window.zoom[i].y *= f
    //    }
    return false;
    /*console.log("width:", w, ",\theight:",h,
                  ",\nx:",x, ",\ty:",y,
                  ",\nscale to:",f))*/
  }
  ParallelAnimation {
    onStarted: {
      window.resizing = true;
    }
    onStopped: {
      window.resizing = false;
    }
    id: animateHead;
    NumberAnimation {
      id: xAnimation
      target: image;
      properties: "x";
      duration: 500;
    }
    NumberAnimation {
      id: yAnimation
      target: image;
      properties: "y";
      duration: 500;
    }
    NumberAnimation {
      id: wAnimation
      target: image;
      properties: "width";
      duration: 500;
    }
    NumberAnimation {
      id: hAnimation
      target: image;
      properties: "height";
      duration: 500;
    }
    NumberAnimation {
      id: utdhAnimation
      target: utdg;
      properties: "height";
      duration: 500;
    }
    NumberAnimation {
      id: utdyAnimation
      target: utdg;
      properties: "y";
      duration: 500;
    }
    NumberAnimation {
      id: rtlwAnimation
      target: rtlg;
      properties: "width";
      duration: 500;
    }
    NumberAnimation {
      id: rtlxAnimation
      target: rtlg;
      properties: "x";
      duration: 500;
    }





    NumberAnimation {
      id: dtuhAnimation
      target: dtug;
      properties: "height";
      duration: 500;
    }
    NumberAnimation {
      id: dtuyAnimation
      target: dtug;
      properties: "y";
      duration: 500;
    }
    NumberAnimation {
      id: ltrwAnimation
      target: ltrg;
      properties: "width";
      duration: 500;
    }
    NumberAnimation {
      id: ltrxAnimation
      target: ltrg;
      properties: "x";
      duration: 500;
    }
  }
  Image {
    id: image
    property var df;
    //        source: "qrc:/pic/01.jpg"
    source: isource
    width: parent.width
    height: parent.height
    fillMode: Image.PreserveAspectFit
  }
  Image {
    source: "qrc:///images/utdg.png"
    id: utdg
    width: parent.width
    height: 0
    y: parent.height
  }

  Image {

    source: "qrc:///images/rtlg.png"
    id: rtlg
    width: 0
    height: parent.height
    x: parent.x
  }
  Image {
    source: "qrc:///images/dtug.png"
    id: dtug
    width: parent.width
    height: 0
    y: 0
  }

  Image {

    source: "qrc:///images/ltrg.png"
    id: ltrg
    width: 0
    height: parent.height
    x: 0
  }
}
