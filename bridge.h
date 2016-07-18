#ifndef BRIDGE_H
#define BRIDGE_H
#include <QObject>
#include <qmap.h>
#include <QtCore>
#include <path.h>
#include <fileio.h>
#include <db.h>
#include "qzipreader_p.h"

#include <downloader.h>

class Bridge : public QObject
{
  Q_OBJECT

public slots:
  void setValue(QString name, QVariant value);
  QVariant getValue(QString name);
  QVariant getGlobal(QString name);
  void rmValue(QString name);
  QString platform();
  QString server();
  QString json();
  void setRoot(QObject *root);
  void dcdl(QString PID);
  void cdl(QString PID, QObject *root);
  bool isdling(QString PID);
  bool cancel(QString PID);
  void AddComic(QString url,
                QString PID,
                QObject *root,
                QString id,
                QString title,
                QString samary,
                QString size,
                QString page,
                QString image);
  void completed(Downloader *obj, QString path);
  bool isExists(QString id);
  void setPerm(QString path);
  QString getList(int from, int to);
  QString getRList(int from, int to);
  QString getComicInfo(QString id,QString key);
  QString getComic(QString id);
  void nextDownload();
  bool setPage(QString id, int page);
  int getPage(QString id);
public:
  Bridge(){
    globVar["padding"] = 10;
    globVar["countItem"] = 12;
    globVar["maxlen"] = 125;
  }
  Path path;
  FileIO io;
  Db db;
private:
  QObject *root;
  QMap<QString, QVariant> map;
  QMap<QString, QVariant> globVar;
  QMap<QString, QPointer<Downloader> > list;
};

#endif // BRIDGE_H
