#include "downloader.h"
#include <QtNetwork>
#include <QFile>
#include "path.h"
// init
Downloader::Downloader(QString PID, QObject *root)
{
  this->CAB = false;
  this->status = Queueed;
  this->PID = PID;
  this->root = root;
  this->surl = "";
  this->filePath = "";
  this->connects = true;
}

void Downloader::downloadFile(const QString& href)
{
  url = href;
  QFileInfo fileInfo(url.path());
  QString fileName = fileInfo.fileName();
  Path path;
  fileName = path.getGname(fileName);
  this->filePath = fileName;
    file = new QFile(fileName);
  if (!file->open(QIODevice::WriteOnly)) {
      this->status = Downloader::Failed;
      this->error = "Cannot create file";
      qDebug() << "Cannot create file";
      return;
    }
  httpRequestAborted = false;
  this->status = Downloader::Downloading;
  startRequest(url);
}
void Downloader::qdownload(const QString &href){
  this->surl = href;
  this->status = Downloader::Queueed;
}
void Downloader::startDownload(){
  this->downloadFile(this->surl);
}
bool Downloader::cancelDownload()
{

  if(!this->CAB)
    return false;
  if(this->status == Downloader::Downloading){
  httpRequestAborted = true;
  }
  reply->abort();
  this->status = Downloader::Aborted;
  return true;
}
void Downloader::httpReadyRead()
{
  // this slot gets called every time the QNetworkReply has new data.
  // We read all of its new data and write it into the file.
  // That way we use less RAM than when reading it at the finished()
  // signal of the QNetworkReply
  if (file)
    file->write(reply->readAll());
}
void Downloader::updateDataReadProgress(qint64 bytesRead, qint64 totalBytes)
{
  if (httpRequestAborted)
    return;
  this->CAB = true;
  qDebug() << "Download " << bytesRead << " of " << totalBytes << "Bytes" << this->connects;
  if(this->connects)
    QMetaObject::invokeMethod(root,
                              "updateProgress",
                              QGenericReturnArgument(),
                              Q_ARG(QVariant, bytesRead),
                              Q_ARG(QVariant, totalBytes));

}

void Downloader::setDlState(){

  emit completed(this,this->filePath);
  if(this->connects)
    this->setFinish();
  //this->qparent->nextDownload();
}
void Downloader::setFinish(){
  QMetaObject::invokeMethod(root,
                            "finishDownload",
                            QGenericReturnArgument(),
                            Q_ARG(QVariant, (this->status == Downloader::Completed)?true:false));
}

void Downloader::httpFinished()
{
  this->status = Downloader::Completed;
  if (httpRequestAborted) {
      if (file) {
          file->close();
          file->remove();
          delete file;
          file = 0;
        }
      reply->deleteLater();
      this->status = Downloader::Aborted;
      return;
    }
  file->flush();
  file->close();
  QVariant redirectionTarget = reply->attribute(QNetworkRequest::RedirectionTargetAttribute);
  if (reply->error()) {
      file->remove();
      status = Downloader::Failed;
      this->error = reply->errorString();
      qDebug() << reply->errorString();
    } else if (!redirectionTarget.isNull()) {
      QUrl newUrl = url.resolved(redirectionTarget.toUrl());
      this->status = Downloader::Downloading;
      url = newUrl;
      reply->deleteLater();
      file->open(QIODevice::WriteOnly);
      file->resize(0);
      startRequest(url);
      return;
    }
  this->setDlState();
  reply->deleteLater();
  reply = 0;
  delete file;
  file = 0;
}
void Downloader::startRequest(QUrl url)
{
  this->status = Downloader::Downloading;
    reply = qnam.get(QNetworkRequest(url));
    connect(reply, SIGNAL(finished()),
            this, SLOT(httpFinished()));
    connect(reply, SIGNAL(readyRead()),
            this, SLOT(httpReadyRead()));
    connect(reply, SIGNAL(downloadProgress(qint64,qint64)),
            this, SLOT(updateDataReadProgress(qint64,qint64)));
}

void Downloader::dc(){
  this->connects = false;
  qDebug() << "disconnected " << this->PID << this->connects;
}
void Downloader::con(){
  qDebug() << "connected " << this->PID;
  this->connects = true;
  if(this->status != Downloader::Downloading || this->status != Downloader::Queueed){
    this->setFinish();
    }
}
void Downloader::setRoot(QObject *root){
  this->root = root;
}
