function updateProgress(current, max){
  prog.indeterminate = false
  prog.maximumValue = max;
  prog.value = current;

  stat.text = foo(current) + " of " + foo(max);
}
function finishDownload(secc){
  if(secc){
    prog.visible = false;
    stat.visible = false
    viewer.backgroundColor = "#FE4523"
    dlbtn.visible = false
    canbtn.visible = false
    viewer.visible = true
  }else{
    stat.text = "<span style=\"color:#FF0000; font-weight:bold;\">خطا در دریافت کمیک!</span>"
    stat.textFormat= Text.RichText
    canbtn.visible = false
    dlbtn.enabled = true
  }
}
function foo(value){
  if(value<4096){
    return value+"Bytes";
  }else if(value<1024*1024){
    return Math.round((value/1024*100))/100+"KB"
  }else if(value<1024*1024*1024){
    return Math.round((value/1024/1024*100))/100+"MB"
  }
}
