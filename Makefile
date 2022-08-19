# Makefile for shellkit-meta

.PHONY: check-packages
python=$(shell python3.9 -c 'import sys; print(sys.executable)')

check-packages: packages
	${python} bin/check_packages.py $${PWD}/packages

black:
	${python} -m black bin/*py

lint:
	${python} -m pylint bin/*.py

