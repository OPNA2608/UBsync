set (TARGET UBsync-ui)

set (UBSYNC_DIR "${CMAKE_INSTALL_DATADIR}/${TARGET}")

if (CLICK_MODE)
    set (DESKTOP_DIR "${UBSYNC_DIR}")
    set (DESKTOP_ICON "${TARGET}/UBsync.png")
    set (ICON_DIR "${UBSYNC_DIR}")
else()
    set (DESKTOP_DIR "${CMAKE_INSTALL_DATADIR}/applications")
    set (DESKTOP_ICON "UBsync")
    set (ICON_DIR "${CMAKE_INSTALL_DATADIR}/pixmaps")
endif()

list (APPEND ${TARGET}_DIRS
    components
    ui
)

intltool_merge_translations (
    ${CMAKE_CURRENT_SOURCE_DIR}/UBsync.desktop.in
    ${CMAKE_CURRENT_BINARY_DIR}/UBsync.desktop
    ALL
    UTF8
)

install (FILES ${CMAKE_CURRENT_BINARY_DIR}/UBsync.desktop
    DESTINATION ${DESKTOP_DIR}
)

install (FILES UBsync.png
    DESTINATION ${ICON_DIR}
)

install (FILES
    Main.qml
    UBsync.svg
    DESTINATION ${UBSYNC_DIR}
)

install (DIRECTORY ${${TARGET}_DIRS}
    DESTINATION ${UBSYNC_DIR}
)

if (CLICK_MODE)
    install (FILES
        UBsync.accounts
        UBsync.apparmor
        DESTINATION ${UBSYNC_DIR}
    )
endif()
