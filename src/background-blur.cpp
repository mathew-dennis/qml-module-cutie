#include <QGuiApplication>
#include <QPointer>
#include <QQuickWindow>
#include <QtWaylandClient/QWaylandClientExtension>
#include <qpa/qplatformnativeinterface.h>
#include <wayland-client-protocol.h>
#include <map>
#include <memory>

#include "qwayland-ext-background-effect-v1.h"

class BlurEffect : public QtWayland::ext_background_effect_surface_v1 {
    public:
	using QtWayland::ext_background_effect_surface_v1::
		ext_background_effect_surface_v1;
	~BlurEffect() override { destroy(); }
};

// Blurs what is behind every transparent Qt Quick window when the compositor
// supports ext-background-effect-v1. Otherwise windows just stay transparent.
class BlurManager : public QWaylandClientExtensionTemplate<BlurManager>,
		    public QtWayland::ext_background_effect_manager_v1 {
    public:
	BlurManager() : QWaylandClientExtensionTemplate<BlurManager>(1)
	{
		qApp->installEventFilter(this);
	}

    protected:
	void ext_background_effect_manager_v1_capabilities(uint32_t flags) override
	{
		m_blur = flags & capability_blur;
		for (QWindow *window : QGuiApplication::allWindows())
			apply(window);
	}

	bool eventFilter(QObject *object, QEvent *event) override
	{
		if (event->type() == QEvent::PlatformSurface &&
		    object->isWindowType()) {
			auto *window = static_cast<QWindow *>(object);
			auto type = static_cast<QPlatformSurfaceEvent *>(event)
					    ->surfaceEventType();
			if (type == QPlatformSurfaceEvent::SurfaceCreated)
				apply(window);
			else
				m_effects.erase(window);
		}
		return false;
	}

    private:
	void apply(QWindow *window)
	{
		m_effects.erase(window);
		auto *quick = qobject_cast<QQuickWindow *>(window);
		if (!m_blur || !quick || quick->color().alpha() == 255 ||
		    !window->handle())
			return;

		auto *native = QGuiApplication::platformNativeInterface();
		auto *surface = static_cast<::wl_surface *>(
			native->nativeResourceForWindow("surface", window));
		auto *compositor = static_cast<::wl_compositor *>(
			native->nativeResourceForIntegration("compositor"));
		if (!surface || !compositor)
			return;

		// A NULL region means "no effect", so cover the whole surface.
		::wl_region *region = wl_compositor_create_region(compositor);
		wl_region_add(region, 0, 0, INT32_MAX, INT32_MAX);
		auto effect = std::make_unique<BlurEffect>(
			get_background_effect(surface));
		effect->set_blur_region(region);
		wl_region_destroy(region);
		m_effects[window] = std::move(effect);
		window->requestUpdate();
	}

	bool m_blur = false;
	std::map<QWindow *, std::unique_ptr<BlurEffect>> m_effects;
};

void initBackgroundBlur()
{
	static QPointer<BlurManager> blur;
	if (!blur && qGuiApp &&
	    QGuiApplication::platformName().startsWith(QLatin1String("wayland"))) {
		blur = new BlurManager;
		blur->setParent(qGuiApp);
	}
}
