set (TARGET qwebdav)

list (APPEND ${TARGET}_SRCS
    qwebdav.cpp
    qwebdavitem.cpp
    qwebdavdirparser.cpp
    qnaturalsort.cpp
)

add_library (${TARGET} ${${TARGET}_SRCS})

target_include_directories (${TARGET} PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries (${TARGET} PUBLIC
    Qt5::Core
    Qt5::Network
    Qt5::Xml
)

get_target_property (${TARGET}_TYPE ${TARGET} TYPE)
if (${${TARGET}_TYPE} STREQUAL SHARED_LIBRARY)
    install (TARGETS ${TARGET}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )
endif()
