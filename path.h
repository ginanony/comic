#ifndef PATH_H
#define PATH_H

#include <QObject>

class Path : public QObject
{
  Q_OBJECT
public:
  Path(){}

signals:

public slots:
  QString getExternalStorageDirectory();
  QString pathAppend(const QString& path1, const QString& path2);
  void touchDir(QString& path);
  QString getGname(QString& fileName);
  QString getAbsPath(QString name);
  bool exists(QString path);
};
#ifndef __ANDROID__
class QAndroidJniObject{
 public:
    QAndroidJniObject callObjectMethod(const char *methodName,const char *methodName2){ methodName++; methodName2++; return QAndroidJniObject();}
    static QAndroidJniObject callStaticObjectMethod(const char *className, const char *methodName, const char *methodName2){className++;methodName++; methodName2++;return QAndroidJniObject();}
    QString toString(){return "";}
};
#endif

#endif // PATH_H
