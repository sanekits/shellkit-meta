#!/bin/bash
#!/bin/bash
# pick_python.sh

canonpath() {
    builtin type -t realpath.sh &>/dev/null && {
        realpath.sh -f "$@"
        return
    }
    builtin type -t readlink &>/dev/null && {
        command readlink -f "$@"
        return
    }
    # Fallback: Ok for rough work only, does not handle some corner cases:
    ( builtin cd -L -- "$(command dirname -- $0)"; builtin echo "$(command pwd -P)/$(command basename -- $0)" )
}
scriptName="$(canonpath "$0")"
scriptDir=$(command dirname -- "${scriptName}")

die() {
    builtin echo "ERROR($(basename ${scriptName}): $*" >&2
    builtin exit 1
}

stub() {
   builtin echo "  <<< STUB[$*] >>> " >&2
}
main() {
    builtin echo "args:[$*]"
}

[[ -z ${sourceMe} ]] && {
    for cand in python3.{10..7}; do
        $cand -m pip --version &>/dev/null && {
            ${cand} -c 'import sys; print(sys.executable)'
            exit
        }
    done
    die "No usable python3 installation found"
}
command true
