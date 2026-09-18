MSPM_DIR = etc/mspm
BINDIR = usr/bin

install: 
	mkdir -p ${DESTDIR}/${MSPM_DIR}
	install -Dm755 mspm ${DESTDIR}/${BINDIR}/mspm
	install -Dm644 installed ${DESTDIR}/${MSPM_DIR}
	install -Dm644 repos.conf ${DESTDIR}/${MSPM_DIR}
uninstall:
	rm -rf ${DESTDIR}/${MSPM_DIR}
	rm -f ${DESTDIR}/${BINDIR}/mspm	
