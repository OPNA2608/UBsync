QT += core sql network dbus xml
QT -= gui

TARGET = OwncloudSyncd
CONFIG += console
CONFIG -= app_bundle

include($$PWD/../common-install.pri)

click:load(ubuntu-click)

TEMPLATE = app

SOURCES += main.cpp \
    owncloudsyncd.cpp

HEADERS += \
    owncloudsyncd.h

click {
    INCLUDEPATH += /usr/include/accounts-qt5
    INCLUDEPATH += /usr/include/signon-qt5

    LIBS += -laccounts-qt5
    LIBS += -lsignon-qt5

    target.path = $${UBUNTU_CLICK_BINARY_PATH}

    arch_triplet = $$system(dpkg-architecture -qDEB_HOST_MULTIARCH)
    click_lib_path = /opt/click.ubuntu.com/ubsync/current/lib/$${arch_triplet}
    click_bin_path = $${click_lib_path}/bin
    DEFINES += \
        CLICK_LIB_PATH=\\\"$${click_lib_path}\\\" \
        CLICK_BIN_PATH=\\\"$${click_bin_path}\\\"
} else {
    CONFIG += link_pkgconfig
    PKGCONFIG += \
        accounts-qt5 \
        libsignon-qt5 \
        qwebdav-qt5

    target.path = $${INSTALL_BINS}
}

INSTALLS+=target
