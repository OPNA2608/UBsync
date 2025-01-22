TEMPLATE = aux
TARGET = UBsync-ui

include($$PWD/../common-install.pri)

RESOURCES += UBsync-ui.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  UBsync.apparmor \
               UBsync.accounts

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               UBsync.png \
               UBsync.svg \
               UBsync.desktop

click {
    ubsync_dir = /UBsync-ui
    desktop_path = $${ubsync_dir}
    desktop_icon = UBsync-ui/UBsync.png
    icon_path = $${ubsync_dir}
} else {
    ubsync_dir = $${INSTALL_DATA}/UBsync-ui
    desktop_path = $${INSTALL_DATA}/applications
    desktop_icon = UBsync
    icon_path = $${INSTALL_DATA}/pixmaps
}

#specify where the qml/js files are installed to
qml_files.path = $${ubsync_dir}
qml_files.files += *.qml #$${QML_FILES}

#specify where the ui qml/js files are installed to
ui_files.path = $${ubsync_dir}/ui
ui_files.files += ui/*.qml ui/*.js

asset_files.path = $${qml_files.path}
asset_files.files += UBsync.svg

#specify where the component qml/js files are installed to
component_files.path = $${ubsync_dir}/components
component_files.files += components/*.qml

#specify where the icon file is installed to
icon_file.path = $${icon_path}
icon_file.files = UBsync.png

#install the desktop file, a translated version is
#automatically created in the build directory
desktop_file.path = $${desktop_path}
desktop_file.files = $$OUT_PWD/UBsync.desktop
desktop_file.CONFIG += no_check_exist

click {
    #specify where the config files are installed to
    config_files.path = $${ubsync_dir}
    config_files.files += $${CONF_FILES}
    INSTALLS += config_files

    owncloud_files.path = /lib/
    owncloud_files.files += aarch64-linux-gnu/bin/*
    owncloud_files.files += aarch64-linux-gnu/lib/*
    owncloud_files.files += arm-linux-gnueabihf/bin/*
    owncloud_files.files += arm-linux-gnueabihf/lib/*
    INSTALLS += owncloud_files
}

INSTALLS += \
    qml_files \
    asset_files \
    icon_file \
    desktop_file \
    ui_files \
    component_files

DISTFILES += \
    ui/AboutPage.qml \
    ui/HelpPage.qml \
    ui/AccountsPage.qml \
    ui/EditAccount \
    ui/EditTarget \
    ui/webdav.js \
    ui/WebdavFileBrowser.qml \
    ui/LocalFileBrowser.qml \
    components/PopupStatusBox.qml \
    ui/SyncServicePage.qml \
    ui/TargetsPage.qml \
    ui/MenuPage.qml \
    ui/RequestAccountPage.qml \
    components/FileBrowser.qml \
