#include "bridge.h"
#include <qmap.h>
#include <plat.h>
#include <qjsonobject.h>
#include <QJsonDocument>
#include <QJsonValue>
#include <downloader.h>

void Bridge::setValue(QString name, QVariant value){
  map[name] = value;
}

QVariant Bridge::getValue(QString name){
  if (map.contains(name))
    return map[name];
  else
    return false;
}
QVariant Bridge::getGlobal(QString name){
  return globVar[name];
}
void Bridge::rmValue(QString name){
  if(map.contains(name)){
      map.remove(name);
    }
}
void Bridge::nextDownload(){
  foreach(QPointer<Downloader> dl , this->list){
      if(dl.data()->status == Downloader::Downloading)
        return;
      if(dl.data()->status != Downloader::Downloading && dl.data()->status != Downloader::Completed){
          dl.data()->startDownload();
          return;
        }
    }
}

QString Bridge::platform(){
  switch (_PLAT) {
    case 0:
      return "android";
      break;
    case 1:
      return "linux";
      break;
    case 2:
      return "windows";
      break;
    default:
      return "unknown";
      break;
    }
}
void Bridge::setRoot(QObject *root){
  this->root = root;
  foreach(QPointer<Downloader> dl , this->list){
      dl.data()->setRoot(root);
    }
}
void Bridge::dcdl(QString PID){
  try{
    list[PID].data()->dc();
  }catch(QException e){}
}
void Bridge::cdl(QString PID, QObject *root){
  try{
    list[PID].data()->setRoot(root);
    list[PID].data()->con();
  }catch(QException e){}

}
bool Bridge::isdling(QString PID){
  foreach(QPointer<Downloader> dl , this->list){
      if(PID == dl.data()->PID){
          return dl.data()->status == Downloader::Downloading ||
              dl.data()->status == Downloader::Completed ||
              dl.data()->status == Downloader::Queueed;
        }
    }
  return false;
}
bool Bridge::cancel(QString PID){
  bool re;
  foreach(QPointer<Downloader> dl , this->list){
      if(PID == dl.data()->PID){
          re = dl.data()->cancelDownload();
          dl.clear();
          return re;
        }
    }
  return false;
}
void Bridge::completed(Downloader *obj, QString path){
  if(obj->status == Downloader::Completed){
      QZipReader qz(path);
      QString npath = this->path.getAbsPath(obj->data["I_id"].toString());
      qz.extractAll(npath);
      this->setPerm(npath);
      obj->data["I_path"]    =    npath;
      QByteArray ba;
      ba.append(obj->data["image"].toString());

      QFile src(this->path.pathAppend(npath,"src.jpg"));
      src.open(QFile::WriteOnly);
      src.write(QByteArray::fromBase64(ba));
      src.close();
      obj->data.remove("image");
      obj->data["I_src"]     =    this->path.pathAppend(npath,"src.jpg");
      QJsonDocument jdata(obj->data);
      this->db.insert(obj->data["I_id"].toString(),jdata.toJson());
      //this->db.search("0");
    }
  nextDownload();
}

void Bridge::AddComic(QString url, QString PID, QObject *root,
                      QString id,
                      QString title,
                      QString samary,
                      QString size,
                      QString page,
                      QString image){
  Downloader *dl;
  dl =  new Downloader(PID, root);
  dl->data["I_samary"]  =   samary;
  dl->data["I_size"]    =     size;
  dl->data["I_title"]   =    title;
  dl->data["I_page"]    =     page;
  dl->data["I_id"]      =       id;
  dl->data["image"]     =    image;
  list[PID] = dl;
  list[PID].data()->qdownload(url);
  list[PID].data()->connect(dl,SIGNAL(completed(Downloader*, QString)),
                            this,SLOT(completed(Downloader*, QString)));
  foreach(QPointer<Downloader> dl , this->list){
      if(dl.data()->status == Downloader::Downloading)
        return;
    }
  this->nextDownload();

  //this->download(url,PID,root);

}

bool Bridge::isExists(QString id){
  return this->db.check(id);
}

void Bridge::setPerm(QString path){
  QDir dir(path);
  QString newPath;
  QFileInfo fi;
  QFile f;
  foreach(QString c,dir.entryList()){
      if(c == "." || c ==  "..")
        continue;
      newPath = this->path.pathAppend(path,c);
      fi.setFile(newPath);
      if(fi.isDir()){
          this->setPerm(newPath);
        }else{
          f.setFileName(newPath);
          f.setPermissions(QFile::ReadOwner | QFile::WriteOwner | QFile::ReadGroup | QFile::WriteGroup | QFile::ReadOther | QFile::WriteOther);
        }
    }

}
QString Bridge::getList(int from, int to){
  return this->db.list(from,to);
}
QString Bridge::getRList(int from, int to){
  return this->db.Rlist(from,to);
}
QString Bridge::getComicInfo(QString id,QString key){
  QJsonDocument js = QJsonDocument::fromJson( this->db.getComicInfo(id).toUtf8());
  QJsonObject sett2 = js.object();
  return sett2.value(QString(key)).toString();
}
QString Bridge::getComic(QString id){
  return this->db.getComic(id);
}
bool Bridge::setPage(QString id, int page){
  return this->db.setPage(id,page);
}

int Bridge::getPage(QString id){
  return this->db.getPage(id);
}

QString Bridge::server(){
  //return "http://parazitt.ir/comics";
  if(_PLAT == 0){
      return "http://parazitt.ir/comics";
    }
  return "http://127.0.0.1/blog2";
}
QString Bridge::json(){
  return "[{\"a\": \"b\",\"b\": \"c\"}, {\"a\": \"f\",\"b\": \"g\"} ]";
}
