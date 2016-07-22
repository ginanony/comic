TEMPLATE = app
ZLIBP = $${PWD}/zlib-1.2.8
QUAZIPP = $${PWD}/quazip
unix {
    LIBS += -L$${ZLIBP} -lz
}
android {
    LIBS += -L/opt/android-ndk-r10d/prebuilt/linux-x86/lib/python2.7/lib-dynload -lz
}
QT += qml quick sql xmlpatterns qml-private  core-private
INCLUDEPATH += /usr/include/c++/{gcc_version}/
SOURCES += main.cpp \
    automator.cpp \
    fileio.cpp \
    db.cpp \
    bridge.cpp \
    downloader.cpp \
    path.cpp \
    $${QUAZIPP}/*.cpp \
    $${QUAZIPP}/*.c

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
# QML_IMPORT_PATH += ../..

include(../../quickandroid.pri)

android {
    QT += androidextras
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources
}

# Default rules for deployment.
include(deployment.pri)
DISTFILES += \
    android-sources/AndroidManifest.xml \
    android-sources/src/quickandroid/example/ExampleService.java \
    README.md \
    newsView.qml

HEADERS += \
    automator.h \
    ../../README.md \
    fileio.h \
    db.h \
    bridge.h \
    downloader.h \
    path.h \
    plat.h \
    $${QUAZIPP}/*.h
HEADERS += qzipreader_p.h
HEADERS += qzipwriter_p.h

SOURCES += qqmlxmllistmodel.cpp
HEADERS += qqmlxmllistmodel_p.h
