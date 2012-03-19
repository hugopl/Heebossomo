# -*- makefile -*-

TEMPLATE = app
TARGET = heebossomo
QT += declarative network
OBJECTS_DIR = obj

# Input
HEADERS += src/cpp/gameview.h \
    src/cpp/gamemapset.h\
    src/cpp/gamemap.h \
    src/cpp/opponent.h
SOURCES += \
    src/cpp/gameview.cpp \
    src/cpp/heebo.cpp \
    src/cpp/gamemapset.cpp \
    src/cpp/gamemap.cpp \
    src/cpp/opponent.cpp

OTHER_FILES += \
    src/qml/AboutPage.qml \
    src/qml/Block.qml \
    src/qml/FullPage.qml \
    src/qml/FullPageText.qml \
    src/qml/HelpPage.qml \
    src/qml/JewelDialog.qml \
    src/qml/JewelPage.qml \
    src/qml/Jewel.qml \
    src/qml/MainPage.qml \
    src/qml/main.qml \
    src/qml/MenuButton.qml \
    src/qml/ScrollBar.qml \
    src/qml/ToolBar.qml \
    src/js/constants.js \
    src/js/jewels.js \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog

RESOURCES += common.qrc
contains(MEEGO_EDITION,harmattan) {
    DEFINES += HARMATTAN
}

target.path = /opt/heebossomo/bin
desktopfile.files = heebossomo_harmattan.desktop
desktopfile.path = /usr/share/applications
icon.files = heebossomo80.png
icon.path = /usr/share/icons/hicolor/80x80/apps
INSTALLS += icon desktopfile
INSTALLS += target

# enable booster
CONFIG += qdeclarative-boostable
QMAKE_CXXFLAGS += -fPIC -fvisibility=hidden -fvisibility-inlines-hidden
QMAKE_LFLAGS += -pie -rdynamic
