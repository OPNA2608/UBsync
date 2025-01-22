!click {
    INSTALL_PREFIX = $$[QT_INSTALL_PREFIX]
    !isEmpty(PREFIX) {
        INSTALL_PREFIX = $${PREFIX}
    }
    INSTALL_BINS = $$[QT_INSTALL_BINS]
    !isEmpty(BINDIR) {
        INSTALL_BINS = $${BINDIR}
    }
    INSTALL_LIBS = $$[QT_INSTALL_LIBS]
    !isEmpty(LIBDIR) {
        INSTALL_LIBS = $${LIBDIR}
    }
    INSTALL_HEADERS = $$[QT_INSTALL_HEADERS]
    !isEmpty(HEADERDIR) {
        INSTALL_HEADERS = $${HEADERDIR}
    }
    INSTALL_DATA = $$[QT_INSTALL_DATA]
    !isEmpty(DATADIR) {
        INSTALL_DATA = $${DATADIR}
    }
    INSTALL_QML = $$[QT_INSTALL_QML]
    !isEmpty(QMLDIR) {
        INSTALL_QML = $${QMLDIR}
    }
}
