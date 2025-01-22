TEMPLATE = aux
TARGET = accounts

include($$PWD/../common-install.pri)

application_files.path = $${INSTALL_DATA}/accounts/applications
application_files.files = *.application
INSTALLS += application_files

service_files.path = $${INSTALL_DATA}/accounts/services/lomiri
service_files.files = *.service
INSTALLS += service_files

DISTFILES += \
    $${application_files.files} \
    $${service_files.files}
