# check-packages.py
""" Given a packages file, verify structure and content """
import sys
import os
import re
from typing import List
from enum import Enum


class RecordType(Enum):
    CANON_SOURCE = 1
    DESC = 2
    DETECT_COMMAND = 3

class DuplicatePackage(RuntimeError):
    ...
class BadRecordType(RuntimeError):
    ...
class DispatchTokenError(RuntimeError):
    ...
class BadPackageError(RuntimeError):
    ...


def xlat_record_type(text: str) -> RecordType:
    if text == "canon-source":
        return RecordType.CANON_SOURCE
    if text == "desc":
        return RecordType.DESC
    if text == "detect-command":
        return RecordType.DETECT_COMMAND
    raise BadRecordType(f"{text} is not a valid RecordType")


class Package:
    """What's a package?"""

    def __init__(self, name: str = None):
        self.name: str = name
        self.canon_source: str = None
        self.detect_command: str = None
        self.desc: str = None

def validate_package(package:Package) -> None:
    """ Apply business rules to Package """
    if not package.name:
        raise BadPackageError("No name in package")
    if not re.search( r"^[a-zA-Z][a-zA-Z0-9_-]+$", package.name):
        raise BadPackageError(f"Package name {package.name} doesn't match char pattern requirements")
    if not package.canon_source:
        raise BadPackageError(f"Package {package.name} has no canon-source spec")
    if not package.detect_command:
        raise BadPackageError(f"Package {package.name} has no detect-command spec")


class Packages:
    """ADG of Package"""

    def __init__(self):
        self.packages:Dict[str,Package] = {}

    def add(self, package: Package):
        if package.name in self.packages:
            raise DuplicatePackage(f"package {package.name} is already in Packages collection")
        self.packages[package.name]=package
        return self.packages[package.name]

    def get(self,package_name:str) -> Package:
        return self.packages[package_name]

    def items(self):
        return self.packages.items()

class Tokens:
    """Tokenized line from packages"""

    def __init__(self):
        self.name: str = None
        self.record_type: RecordType = None
        self.info: str = None


def main(argv: List[str]) -> int:
    """main"""
    filename = argv[1]
    packages=Packages()

    def parse_line(line: str) -> Tokens:
        tokens: Tokens = Tokens()
        tokens.name, _, remain = line.partition(" ")
        record_type, _, tokens.info = remain.partition(" ")
        tokens.record_type = xlat_record_type(record_type)
        return tokens

    def dispatch_token(tokens: Tokens) -> None:
        try:
            package = Package(tokens.name)
            packages.add(package)
        except DuplicatePackage:
            package = packages.get(tokens.name)
        if tokens.record_type==RecordType.CANON_SOURCE:
            package.canon_source=tokens.info
        elif tokens.record_type==RecordType.DESC:
            package.desc=tokens.info
        elif tokens.record_type==RecordType.DETECT_COMMAND:
            package.detect_command=tokens.info
        else:
            raise DispatchTokenError(f"Unable to parse token")


    with open(filename, encoding='utf-8') as infile:
        for line in infile:
            line = line.strip()
            if not line:
                continue
            if line.startswith("#"):
                continue
            dispatch_token(parse_line(line))
    for package_name, package in packages.items():
        validate_package(package)

    print(f"{filename} check: OK")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
