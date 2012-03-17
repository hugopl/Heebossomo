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
    debian/rules \
    debian/README \
    debian/copyright \
    debian/control \
    debian/compat \
    debian/changelog \
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
    RESOURCES += harmattan.qrc
}
!contains(MEEGO_EDITION,harmattan) {
    RESOURCES += desktop.qrc
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
