#pragma once

#include <QPointer>
#include <QWindow>
#include <QtWaylandClient/QWaylandClientExtensionTemplate>

#include "qwayland-ext-background-effect-v1.h"

struct wl_surface;

class BackgroundBlur
	: public QWaylandClientExtensionTemplate<BackgroundBlur>,
	  public QtWayland::ext_background_effect_manager_v1 {
	Q_OBJECT
	Q_PROPERTY(QWindow *window READ window WRITE setWindow NOTIFY
			   windowChanged)
	Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY
			   enabledChanged)
	Q_PROPERTY(bool blurred READ isBlurred NOTIFY blurredChanged)
    public:
	BackgroundBlur();
	~BackgroundBlur() override;

	QWindow *window() const
	{
		return m_window;
	}
	void setWindow(QWindow *window);

	bool enabled() const
	{
		return m_enabled;
	}
	void setEnabled(bool enabled);

	bool isBlurred() const
	{
		return m_enabled && isActive() &&
		       (m_capabilities & capability_blur);
	}

    signals:
	void windowChanged();
	void enabledChanged();
	void blurredChanged();

    protected:
	void
	ext_background_effect_manager_v1_capabilities(uint32_t flags) override;
	bool eventFilter(QObject *watched, QEvent *event) override;

    private:
	void sync();
	void clearEffect();

	QPointer<QWindow> m_window;
	bool m_enabled = false;
	uint32_t m_capabilities = 0;
	struct ::wl_surface *m_surface = nullptr;
	struct ::ext_background_effect_surface_v1 *m_effect = nullptr;
};
