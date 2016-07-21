#ifndef DB_H
#define DB_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>

class Db : public QObject
{
  Q_OBJECT

public slots:
  void init();
  //QString search(QString key);
  QString list(int from = 0, int to = 10);
  QString Rlist(int from = 0, int to = 10);
  QString getComic(QString id);
  QString getComicInfo(QString id);
  bool removeComic(QString id);
  bool check(QString id);
  bool insert(QString id, QString data);
  bool setPage(QString id, int page);
  int getPage(QString id);
  bool query(QString qstr);
  bool query(QString qstr, QString key);
private:
  QSqlDatabase db;
  QSqlQuery result;
public:
  Db();
};

#endif // DB_H
