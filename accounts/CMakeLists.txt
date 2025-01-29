install (FILES com.lomiri.cloudsync.application
    DESTINATION "${CMAKE_INSTALL_DATADIR}/accounts/applications"
)

install (FILES
    com.lomiri.cloudsync.nextcloud.service
    com.lomiri.cloudsync.owncloud.service
    DESTINATION "${CMAKE_INSTALL_DATADIR}/accounts/services/lomiri"
)
