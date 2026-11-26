#include "plugin.h"
#include "backgroundblur.h"

void CutiePlugin::registerTypes(const char *uri)
{
	qmlRegisterSingletonType<AtmosphereModel>(uri, 1, 0, "Atmosphere",
						  &AtmosphereModel::provider);
	qmlRegisterType<BackgroundBlur>(uri, 1, 0, "BackgroundBlur");
}

void CutiePlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
	Q_UNUSED(uri);
	// Ensure CutieWindow gets an RGBA surface even if it starts opaque
	// before Wayland blur capabilities arrive.
	QQuickWindow::setDefaultAlphaBuffer(true);
	QIcon::setThemeName(
		qEnvironmentVariable("CUTIE_ICON_THEME", "cutie"));
	engine->addImageProvider("icon", &iconProvider);
}
