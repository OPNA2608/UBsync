set (TARGET OwncloudSyncd)

list (APPEND ${TARGET}_SRCS
    main.cpp
    owncloudsyncd.cpp
)

add_executable (${TARGET} ${${TARGET}_SRCS})

target_include_directories (${TARGET} PRIVATE
    ${CMAKE_BINARY_DIR} # config.hpp

    ${ACCOUNTS_INCLUDE_DIRS}
    ${SIGNON_INCLUDE_DIRS}
    ${QWEBDAV_INCLUDE_DIRS}
)

target_link_libraries (${TARGET} PUBLIC
    ${ACCOUNTS_LIBRARIES}
    ${SIGNON_LIBRARIES}
    ${QWEBDAV_LIBRARIES}
    Qt5::Core
    Qt5::DBus
    Qt5::Sql
)

install (TARGETS ${TARGET}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
