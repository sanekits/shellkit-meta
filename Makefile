# Makefile for shellkit-meta

.PHONY: check-packages lint black install
python=$(shell python3.9 -c 'import sys; print(sys.executable)')

check-packages: packages
	${python} bin/check_packages.py $${PWD}/packages

black:
	${python} -m black bin/*py

lint:
	${python} -m pylint bin/*.py

install: ${HOME}/.config/shellkit-meta/packages


${HOME}/.config/shellkit-meta/packages: packages bin/check_packages.py Makefile
	test -f ${HOME}/.config/shellkit-meta/packages && cp ${HOME}/.config/shellkit-meta/packages ${HOME}/.config/shellkit-meta/packages-bak.$$$$ || :
	mkdir -p ${HOME}/.config/shellkit-meta
	cp packages ${HOME}/.config/shellkit-meta/packages
