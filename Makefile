# Makefile for shellkit-meta

.PHONY: check-packages
python=$(shell python3.9 -c 'import sys; print(sys.executable)')

check-packages: packages
	bin/check-packages.sh

black:
	${python} -m black bin/*py

lint:
	${python} -m pylint bin/*.py

