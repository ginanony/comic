#include <QtCore>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include "quickandroid.h"
#include "qadrawableprovider.h"
#include "qasystemdispatcher.h"
#include <qjsonobject.h>

#include "automator.h"
#include "bridge.h"
#include "db.h"

#ifdef Q_OS_ANDROID
#include <QtAndroidExtras/QAndroidJniObject>
#include <QtAndroidExtras/QAndroidJniEnvironment>

JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void*) {
    Q_UNUSED(vm);
    qDebug("NativeInterface::JNI_OnLoad()");

    // It must call this function within JNI_OnLoad to enable System Dispatcher
    QASystemDispatcher::registerNatives();

    /* Optional: Register your own service */

    // Call quickandroid.example.ExampleService.start()
    QAndroidJniObject::callStaticMethod<void>("quickandroid/example/ExampleService",
                                              "start",
                                              "()V");

    return JNI_VERSION_1_6;
}
#endif

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Arvid");
        app.setOrganizationDomain("Arvidweb.com");
        app.setApplicationName("Comics");
    QQmlApplicationEngine engine;
    Bridge br;
    /* QuickAndroid Initialization */
    engine.addImportPath("qrc:///"); // Add QuickAndroid into the import path
    /* End of QuickAndroid Initialization */

    // Extra features:
    QADrawableProvider* provider = new QADrawableProvider();
    provider->setBasePath("qrc://res");
    engine.addImageProvider("drawable",provider);
    engine.rootContext()->setContextProperty("bridge", &br);
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));
    QObject* root    = engine.rootObjects()[0];
    br.setRoot(root);
    /* Testing Code. Not needed for regular project */
    Automator* automator = new Automator();
    automator->start();

    return app.exec();
}
