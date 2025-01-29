set (TARGET Cloudsync-ui)

set (UBSYNC_DIR "${CMAKE_INSTALL_DATADIR}/${TARGET}")

if (CLICK_MODE)
    set (DESKTOP_DIR "${UBSYNC_DIR}")
    set (DESKTOP_ICON "${TARGET}/lomiri-cloudsync-app.png")
    set (ICON_DIR "${UBSYNC_DIR}")
else()
    set (DESKTOP_DIR "${CMAKE_INSTALL_DATADIR}/applications")
    set (DESKTOP_ICON "lomiri-cloudsync-app")
    set (ICON_DIR "${CMAKE_INSTALL_DATADIR}/icons/hicolor/256x256/apps")
endif()

list (APPEND ${TARGET}_DIRS
    components
    ui
)

configure_file (lomiri-cloudsync-app.desktop.in.in ${CMAKE_CURRENT_BINARY_DIR}/lomiri-cloudsync-app.desktop.in @ONLY)

intltool_merge_translations (
    ${CMAKE_CURRENT_BINARY_DIR}/lomiri-cloudsync-app.desktop.in
    ${CMAKE_CURRENT_BINARY_DIR}/lomiri-cloudsync-app.desktop
    ALL
    UTF8
)

install (FILES ${CMAKE_CURRENT_BINARY_DIR}/lomiri-cloudsync-app.desktop
    DESTINATION ${DESKTOP_DIR}
)

install (FILES lomiri-cloudsync-app.png
    DESTINATION ${ICON_DIR}
)

install (FILES
    Main.qml
    lomiri-cloudsync-app.svg
    DESTINATION ${UBSYNC_DIR}
)

install (DIRECTORY ${${TARGET}_DIRS}
    DESTINATION ${UBSYNC_DIR}
)

if (CLICK_MODE)
    install (FILES
        lomiri-cloudsync-app.accounts
        lomiri-cloudsync-app.apparmor
        DESTINATION ${UBSYNC_DIR}
    )
endif()
