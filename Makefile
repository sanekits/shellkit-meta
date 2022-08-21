# Makefile for shellkit-meta

.PHONY: check-packages lint black install publish
python=$(shell bin/pick_python.sh)

check-packages: packages
	${python} bin/check_packages.py $${PWD}/packages

black:
	${python} -m pip install black
	${python} -m black bin/*py

lint:
	${python} -m pip install pylint
	${python} -m pylint bin/*.py

install: ${HOME}/.config/shellkit-meta/packages

publish:
	@echo The 'packages' file is the distributed artifact.  But
	@echo the distribution happens in shellkit-pm, not here.  That
	@echo project depends on shellkit-meta at publish time.

${HOME}/.config/shellkit-meta/packages: packages bin/check_packages.py Makefile
	test -f ${HOME}/.config/shellkit-meta/packages && cp ${HOME}/.config/shellkit-meta/packages ${HOME}/.config/shellkit-meta/packages-bak.$$$$ || :
	mkdir -p ${HOME}/.config/shellkit-meta
	cp packages ${HOME}/.config/shellkit-meta/packages
