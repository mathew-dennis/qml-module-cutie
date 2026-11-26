#include "backgroundblur.h"

#include <QEvent>
#include <QGuiApplication>
#include <QPlatformSurfaceEvent>
#include <qpa/qplatformnativeinterface.h>
#include <wayland-client.h>

// Large enough to cover any window without resending regions on resize; the
// compositor clips the blur region to the surface size per the protocol spec.
static const int MAX_EXTENT = 100000;

BackgroundBlur::BackgroundBlur()
	: QWaylandClientExtensionTemplate<BackgroundBlur>(1)
{
	connect(this, &QWaylandClientExtension::activeChanged, this, [this]() {
		if (!isActive() && (m_capabilities & capability_blur)) {
			m_capabilities = 0;
			if (m_enabled)
				emit blurredChanged();
		}
		sync();
	});
}

BackgroundBlur::~BackgroundBlur()
{
	if (m_window)
		m_window->removeEventFilter(this);
	clearEffect();
	if (isInitialized())
		destroy();
}

void BackgroundBlur::setWindow(QWindow *window)
{
	if (m_window == window)
		return;
	if (m_window) {
		m_window->removeEventFilter(this);
		clearEffect();
	}
	m_window = window;
	if (m_window)
		m_window->installEventFilter(this);
	emit windowChanged();
	sync();
}

void BackgroundBlur::setEnabled(bool enabled)
{
	if (m_enabled == enabled)
		return;
	const bool was = isBlurred();
	m_enabled = enabled;
	emit enabledChanged();
	if (was != isBlurred())
		emit blurredChanged();
	sync();
}

void BackgroundBlur::ext_background_effect_manager_v1_capabilities(
	uint32_t flags)
{
	const bool was = isBlurred();
	m_capabilities = flags;
	if (was != isBlurred())
		emit blurredChanged();
	sync();
}

bool BackgroundBlur::eventFilter(QObject *watched, QEvent *event)
{
	if (watched == m_window) {
		if (event->type() == QEvent::PlatformSurface) {
			auto *e = static_cast<QPlatformSurfaceEvent *>(event);
			if (e->surfaceEventType() ==
			    QPlatformSurfaceEvent::SurfaceAboutToBeDestroyed)
				clearEffect();
			else
				sync();
		} else if (event->type() == QEvent::Expose) {
			sync();
		}
	}
	return QObject::eventFilter(watched, event);
}

void BackgroundBlur::clearEffect()
{
	if (m_effect) {
		ext_background_effect_surface_v1_destroy(m_effect);
		m_effect = nullptr;
	}
	m_surface = nullptr;
}

void BackgroundBlur::sync()
{
	if (!m_window || !m_window->handle() || !isBlurred()) {
		const bool hadEffect = m_effect != nullptr;
		clearEffect();
		if (hadEffect && m_window && m_window->isExposed())
			m_window->requestUpdate();
		return;
	}

	QPlatformNativeInterface *native =
		QGuiApplication::platformNativeInterface();
	if (!native)
		return;

	auto *surface = static_cast<struct ::wl_surface *>(
		native->nativeResourceForWindow("surface", m_window));
	auto *compositor = static_cast<struct ::wl_compositor *>(
		native->nativeResourceForIntegration("compositor"));
	if (!surface || !compositor) {
		clearEffect();
		return;
	}

	if (m_surface == surface && m_effect)
		return;

	clearEffect();
	m_surface = surface;
	m_effect = get_background_effect(surface);

	struct ::wl_region *region = wl_compositor_create_region(compositor);
	wl_region_add(region, 0, 0, MAX_EXTENT, MAX_EXTENT);
	ext_background_effect_surface_v1_set_blur_region(m_effect, region);
	wl_region_destroy(region);

	m_window->requestUpdate();
}
