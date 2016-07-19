#ifndef DOWNLOADER_H
#define DOWNLOADER_H

#include <QObject>
#include <QMetaObject>
#include <QNetworkAccessManager>
#include <QUrl>
#include <QFile>
#include <qdebug.h>
#include <QJsonObject>

class Downloader : public QObject
{
  Q_OBJECT
public slots:
  void downloadFile(const QString& href);
  void qdownload(const QString& href);
  void startDownload();
  bool cancelDownload();
  void httpReadyRead();
  void updateDataReadProgress(qint64 bytesRead, qint64 totalBytes);
  void setDlState();
  void setFinish();
  void setRoot(QObject *root);
  void httpFinished();
  void startRequest(QUrl url);
  void dc();
  void con();
signals:
  void completed(Downloader *obj, QString path);
public:
  enum {
      Queueed = 0,
      Downloading = 1,
      Aborted = 2,
      Failed = 3,
      Completed = 10
  };
  Downloader(QString PID,QObject *root);
  QString PID;
  QString filePath;
  int status;
  QString error;
  QJsonObject data;
  bool connects;
private:
  QObject *root;
  QString surl;
  QUrl url;
  QNetworkAccessManager qnam;
  QNetworkReply *reply;
  QFile *file;
  bool httpRequestAborted;
  bool CAB;
  bool fualt;
};

#endif // DOWNLOADER_H
