cmake_minimum_required(VERSION 3.16)
project(qmlcutieplugin VERSION 1.0 LANGUAGES C CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

find_package(PkgConfig REQUIRED)
find_package(QT NAMES Qt6 REQUIRED COMPONENTS Core)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Gui Qml Quick WaylandClient)
pkg_check_modules(ATMOSPHERE atmosphere REQUIRED IMPORTED_TARGET)
pkg_check_modules(WAYLAND_CLIENT wayland-client REQUIRED IMPORTED_TARGET)

qt_standard_project_setup()

set(plugin_SOURCES
    src/plugin.cpp src/plugin.h
    src/iconprovider.cpp src/iconprovider.h
    src/backgroundblur.cpp src/backgroundblur.h)

qt6_add_qml_module(qmlcutieplugin
    URI Cutie
    VERSION ${PROJECT_VERSION}
    PLUGIN_TARGET qmlcutieplugin
    NO_GENERATE_PLUGIN_SOURCE
    SOURCES
        ${plugin_SOURCES}
)

qt6_generate_wayland_protocol_client_sources(qmlcutieplugin
    FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/src/protocols/ext-background-effect-v1.xml
)

target_include_directories(qmlcutieplugin PUBLIC
    src
)

target_link_libraries(qmlcutieplugin PUBLIC
    Qt::Core
    Qt::Gui
    Qt::GuiPrivate
    Qt::Qml
    Qt::Quick
    Qt::WaylandClient
    PkgConfig::ATMOSPHERE
    PkgConfig::WAYLAND_CLIENT
)

install(TARGETS qmlcutieplugin
    RUNTIME DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt${QT_VERSION_MAJOR}/qml/Cutie"
    BUNDLE DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt${QT_VERSION_MAJOR}/qml/Cutie"
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt${QT_VERSION_MAJOR}/qml/Cutie"
)

install(DIRECTORY src/qml/Cutie DESTINATION "${CMAKE_INSTALL_LIBDIR}/qt${QT_VERSION_MAJOR}/qml")
