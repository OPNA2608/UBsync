cmake_minimum_required (VERSION 3.11)

project (lomiri-cloudsync-app VERSION 0.8.1 LANGUAGES CXX)

set (CMAKE_CXX_STANDARD 11)
set (CMAKE_CXX_EXTENSIONS OFF)
set (CMAKE_CXX_STANDARD_REQUIRED TRUE)

include (GNUInstallDirs)

option (CLICK_MODE "TODO: Describe" OFF)

find_package(Intltool REQUIRED)

find_package(PkgConfig REQUIRED)

find_package (Qt5 COMPONENTS
    Core
    DBus
    Network
    Qml
    Sql
    Xml
    REQUIRED
)

pkg_check_modules (ACCOUNTS accounts-qt5 REQUIRED)
pkg_check_modules (SIGNON libsignon-qt5 REQUIRED)

set (CMAKE_AUTOMOC ON)

if (CLICK_MODE)
    set (QT_IMPORTS_DIR ${CMAKE_INSTALL_LIBDIR})
elseif (DEFINED QT_IMPORTS_DIR)
    message (STATUS "Qt imports dir already set. Installing QML plugins to ${QT_IMPORTS_DIR}")
elseif (EXISTS "/etc/debian_version")
    set (QT_IMPORTS_DIR ${CMAKE_INSTALL_LIBDIR}/qt5/qml)
else()
    get_target_property (QMAKE_EXECUTABLE Qt5::qmake LOCATION)
    execute_process (
        COMMAND ${QMAKE_EXECUTABLE} -query QT_INSTALL_QML
        OUTPUT_VARIABLE QT_IMPORTS_DIR OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    file(TO_CMAKE_PATH "${QT_IMPORTS_DIR}" QT_IMPORTS_DIR)
endif()

if (CLICK_MODE)
    find_program (DPKG_ARCH_EXECUTABLE dpkg-architecture REQUIRED)
else()
    pkg_check_modules (QWEBDAV_PC qwebdav-qt5 REQUIRED)
endif()

if (CLICK_MODE)
    set (CMAKE_INSTALL_DATADIR .)
    set (OWNCLOUD_LIBDIR "${CMAKE_INSTALL_LIBDIR}")
    set (OWNCLOUD_BINDIR "${OWNCLOUD_LIBDIR}/bin")
endif()

configure_file (config.hpp.in ${CMAKE_CURRENT_BINARY_DIR}/config.hpp @ONLY)

set (GETTEXT_PACKAGE "lomiri-cloudsync-app")
add_subdirectory (po)

set (QWEBDAV_INCLUDE_DIRS "")
set (QWEBDAV_LIBRARIES "")
if (CLICK_MODE)
    add_subdirectory (qwebdavlib)
    set (QWEBDAV_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/qwebdavlib")
    set (QWEBDAV_LIBRARIES qwebdav)
else()
    set (QWEBDAV_INCLUDE_DIRS ${QWEBDAV_PC_INCLUDE_DIRS})
    set (QWEBDAV_LIBRARIES ${QWEBDAV_PC_LIBRARIES})

    add_subdirectory (accounts)
endif()

add_subdirectory (Cloudsync-ui)
add_subdirectory (OwncloudSync)
add_subdirectory (OwncloudSyncd)

if (CLICK_MODE)
    # This figures out the target architecture for use in the manifest file.
    if(DEFINED ENV{ARCH})
        set(CLICK_ARCH "$ENV{ARCH}")
    else()
        execute_process(
            COMMAND dpkg-architecture -qDEB_HOST_ARCH
            OUTPUT_VARIABLE CLICK_ARCH
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    endif()

    # Which of the bundled prebuilt files we need to include
    execute_process (
        COMMAND ${DPKG_ARCH_EXECUTABLE} -q DEB_BUILD_MULTIARCH
        RESULT_VARIABLE DPKG_ARCH_RESULT
        OUTPUT_VARIABLE OWNCLOUD_VENDOR_ARCH
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    if (NOT DPKG_ARCH_RESULT EQUAL 0)
        message (FATAL_ERROR "Failed to determine architecture triplet")
    endif()

    set (OWNCLOUD_VENDOR_DIR "${CMAKE_SOURCE_DIR}/lib/${OWNCLOUD_VENDOR_ARCH}")
    if (NOT IS_DIRECTORY "${OWNCLOUD_VENDOR_DIR}")
        message (FATAL_ERROR "Failed to determine correct owncloud prebuilt directory, tried: ${OWNCLOUD_VENDOR_DIR}")
    endif()

    file (GLOB OWNCLOUD_CSYNC_LIBS
        "${OWNCLOUD_VENDOR_DIR}/lib/libowncloud_csync.so*"
    )
    file (GLOB OWNCLOUD_SYNC_LIBS
        "${OWNCLOUD_VENDOR_DIR}/lib/libowncloudsync.so*"
    )
    file (GLOB OWNCLOUD_QT5KEYCHAIN_LIBS
        "${OWNCLOUD_VENDOR_DIR}/lib/libqt5keychain.so*"
    )
    install (FILES
        ${OWNCLOUD_CSYNC_LIBS}
        ${OWNCLOUD_SYNC_LIBS}
        ${OWNCLOUD_QT5KEYCHAIN_LIBS}
        DESTINATION ${OWNCLOUD_LIBDIR}
    )

    install (FILES
        ${OWNCLOUD_VENDOR_DIR}/bin/owncloudcmd
        ${OWNCLOUD_VENDOR_DIR}/bin/sync-exclude.lst
        DESTINATION ${OWNCLOUD_BINDIR}
    )

    configure_file (manifest.json.in ${CMAKE_CURRENT_BINARY_DIR}/manifest.json @ONLY)
    install (FILES ${CMAKE_CURRENT_BINARY_DIR}/manifest.json
        DESTINATION ${CMAKE_INSTALL_PREFIX}
    )
endif()
