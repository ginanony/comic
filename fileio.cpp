#include <QtNetwork>
#include <qdebug.h>
#include "fileio.h"


bool FileIO::write(const QString& source, const QString& data)
{
  if (source.isEmpty())
    return false;

  QFile file(source);
  if (!file.open(QFile::WriteOnly | QFile::Truncate))
    return false;

  QTextStream out(&file);
  out << data;
  file.close();
  return true;
}
QString FileIO::json(){
  return "[{\"a\": \"b\",\"b\": \"c\"}, {\"a\": \"f\",\"b\": \"g\"} ]";
}
