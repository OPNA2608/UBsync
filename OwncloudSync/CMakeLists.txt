set (TARGET CloudsyncOwncloud)

list (APPEND ${TARGET}_SRCS
    backend.cpp
    daemoncontroller.cpp
    owncloudsync.cpp
    servicecontrol.cpp
    webdavfolderlistmodel.cpp
)

add_library (${TARGET} MODULE ${${TARGET}_SRCS})

target_include_directories (${TARGET} PRIVATE
    ${CMAKE_BINARY_DIR} # config.hpp

    ${QWEBDAV_INCLUDE_DIRS}
)

target_link_libraries (${TARGET} PUBLIC
    ${QWEBDAV_LIBRARIES}
    Qt5::DBus
    Qt5::Qml
)

install (TARGETS ${TARGET}
    LIBRARY DESTINATION ${QT_IMPORTS_DIR}/${TARGET}
)

install (FILES qmldir
    DESTINATION ${QT_IMPORTS_DIR}/${TARGET}
)
