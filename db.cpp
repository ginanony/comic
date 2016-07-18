#include "db.h"
#include "qdebug.h"
#include <QSqlRecord>
#include <QSqlResult>
#include <QSqlError>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
Db::Db()
{
  this->db = QSqlDatabase::addDatabase("QSQLITE");
  this->db.setDatabaseName("database.sqlite");
  if(!this->db.open()){
      qDebug() << "cannot open data base!!!";
    }
  this->result = QSqlQuery(this->db);
  this->init();
}
void Db::init(){
  this->query("CREATE TABLE IF NOT EXISTS \"comics\" (\
              \"ID\" INTEGER PRIMARY KEY AUTOINCREMENT,\"Json\" TEXT);");
  this->query("CREATE TABLE IF NOT EXISTS \"pagenav\" (\
              \"ID\" INTEGER PRIMARY KEY, \"page\" INTEGER);");
}
//QString Db::search(QString key){
//  QJsonArray res;
//  this->result.setForwardOnly(true);
//  this->result.exec("SELECT Json FROM comics");
//  this->result.first();
//  do{
//      //res << this->result.value("Json").toString();
//      res.append(
//            QJsonDocument::fromJson(
//              this->result.value("Json").toString().toUtf8()
//              ).object());
//    }while(this->result.next());
//  QJsonDocument doc(res);
//  return doc.toJson();
//}
QString Db::list(int from, int to){
  QJsonArray res;
  this->result.setForwardOnly(true);
  this->result.exec("SELECT Json FROM comics LIMIT "+QString::number(from)+", "+QString::number(to));
  if(!this->result.first())
    return "";
  do{

      //res << this->result.value("Json").toString();
      res.append(
            QJsonDocument::fromJson(
              this->result.value("Json").toString().toUtf8()
              ).object());
    }while(this->result.next());
  QJsonDocument doc(res);
  return doc.toJson();
}
QString Db::Rlist(int from, int to){
  QJsonArray res;
  this->result.setForwardOnly(true);
  this->result.exec("SELECT comics.* FROM comics inner JOIN pagenav ON comics.ID = pagenav.ID WHERE pagenav.page > 0 LIMIT "+QString::number(from)+", "+QString::number(to));
  if(!this->result.first())
    return "";
  do{
      res.append(
            QJsonDocument::fromJson(
              this->result.value("Json").toString().toUtf8()
              ).object());
    }while(this->result.next());
  QJsonDocument doc(res);
  return doc.toJson();
}
QString Db::getComicInfo(QString id){
  this->result.setForwardOnly(true);
  this->result.exec("SELECT Json FROM comics WHERE ID = "+id);
  if(!this->result.first())
    return "";

  return this->result.value("Json").toString();
}
QString Db::getComic(QString id){
  QJsonArray res;
  this->result.setForwardOnly(true);
  this->result.exec("SELECT Json FROM comics WHERE ID = "+id);
  if(!this->result.first())
    return "";
  res.append(
        QJsonDocument::fromJson(
          this->result.value("Json").toString().toUtf8()
          ).object());
  QJsonDocument doc(res);
  return doc.toJson();
}
bool Db::check(QString id){
  QString gid;
  this->result.prepare("SELECT ID FROM comics WHERE ID = :id");
  this->result.bindValue(":id",id);
  if(this->result.exec()){
      this->result.first();
      gid = this->result.value("ID").toString().toUtf8();
    }
  if(gid == id)
    return true;
  return false;
}

bool Db::insert(QString id, QString data){
  this->result.prepare("INSERT INTO comics (ID, Json)VALUES(:id, :data);");
  this->result.bindValue(":id",id);
  this->result.bindValue(":data",data);
  return this->result.exec();
}
bool Db::setPage(QString id, int page){
  this->result.prepare("INSERT OR IGNORE INTO pagenav (ID, page) VALUES (:id , :page)");
  this->result.bindValue(":id",id);
  this->result.bindValue(":page",page);
  bool res = this->result.exec();
  this->result.prepare("UPDATE pagenav SET page = :page WHERE ID = :id");
  this->result.bindValue(":id",id);
  this->result.bindValue(":page",page);
  bool res2 = this->result.exec();
  return res || res2;
}
int Db::getPage(QString id){
  this->result.setForwardOnly(true);
  this->result.exec("SELECT page FROM pagenav WHERE ID = "+id);
  this->result.first();
  return this->result.value("page").toInt();
}

bool Db::query(QString qstr){
  return this->result.exec(qstr);
}
bool Db::query(QString qstr, QString key){
  this->result.prepare(qstr);
  this->result.bindValue(0,key);
  return this->result.exec();
}
