intltool_update_potfile(
    KEYWORDS "_" "_:1,2" "N_" "N_:1,2" "tr" "tr:1,2"
    GETTEXT_PACKAGE ${GETTEXT_PACKAGE}
    COPYRIGHT_HOLDER "UBports Developers"
    FILE_GLOBS "${CMAKE_SOURCE_DIR}/*.desktop.in" "${CMAKE_SOURCE_DIR}/*.qml"
    FILTER "tests/*"
)

intltool_install_translations(
    ALL
    GETTEXT_PACKAGE ${GETTEXT_PACKAGE}
)

