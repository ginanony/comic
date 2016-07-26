#include "path.h"
#include <qmap.h>
#include <QStandardPaths>
#include <QDir>
#include <qdebug.h>
#include "plat.h"
#ifdef __ANDROID__
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#include <jni.h>
#endif
QString Path::getExternalStorageDirectory(){
  if(_PLAT == 0){
  QAndroidJniObject mediaDir = QAndroidJniObject::callStaticObjectMethod(
        "android/os/Environment",
        "getExternalStorageDirectory",
        "()Ljava/io/File;");
  QAndroidJniObject mediaPath = mediaDir.callObjectMethod(
        "getAbsolutePath",
        "()Ljava/lang/String;" );
  QString dataAbsPath = mediaPath.toString()+"";
//  QAndroidJniEnvironment env;
//  if (env->ExceptionCheck()) {
//          // Handle exception here.
//          env->ExceptionClear();
//  }
  return dataAbsPath;
    }else{
      return QStandardPaths::writableLocation(QStandardPaths::DataLocation);
    }
}
QString Path::pathAppend(const QString& path1, const QString& path2)
{
    return QDir::cleanPath(path1 + QDir::separator() + path2);
}
void Path::touchDir(QString& path){
  QDir dir(path);
  if (!dir.exists()) {
      dir.mkpath(".");
  }
}
QString Path::getAbsPath(QString name){
  QString path = this->pathAppend(this->getExternalStorageDirectory(), "comics");
  this->touchDir(path);
  path = this->pathAppend(path,name);
  this->touchDir(path);
  return path;
}

QString Path::getGname(QString& fileName){
  if (fileName.isEmpty())
    fileName = "index.html";
  QString path = this->pathAppend(this->getExternalStorageDirectory(),"comics");
  this->touchDir(path);
  fileName = this->pathAppend(path, fileName);
  if (QFile::exists(fileName)) {
      QFile::remove(fileName);
    }
  return fileName;
}
bool Path::fexists(QString path){
  QFile file(path);
  return file.exists();
}
