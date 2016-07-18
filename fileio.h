#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QQuickItem>
#include <qdebug.h>
#include <QMetaObject>
#include <QNetworkAccessManager>
#include <QUrl>




class FileIO : public QObject
{
  Q_OBJECT

public slots:
  // file manager
  bool write(const QString& source, const QString& data);


  // connected to qml o_0


  /*QVariant appInfo(QString name);*/

  QString json();
private:
public:
  QObject *root;

  FileIO() {}
};





#endif // FILEIO_H
