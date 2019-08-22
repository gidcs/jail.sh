#!/bin/bash

_app="jail.sh"

function error {
    >&2 echo "[ERR] $*"
}

function usage {
    echo "Usage:"
    echo "  ${_app} [-h] [[-d DIRECTORY] [FILES ...]]"
}

if [ "$#" -eq "0" ]; then
    usage
    exit 0
fi

while getopts ":hd:" opt; do
    case ${opt} in
        d )
            _chroot_dir=$OPTARG
            ;;
        h )
            usage
            exit -1
            ;;
        \? )
            error "Invalid Option: -$OPTARG"
            exit -1
            ;;
        : )
            error "Invalid Option: -$OPTARG requires an argument"
            exit -1
            ;;
    esac
done

shift $(( OPTIND - 1 ))

mkdir ${_chroot_dir}

for i in $( ldd $@ | grep -v dynamic | cut -d " " -f 3 | sed 's/://' | sort | uniq );
do
    cp --parents $i ${_chroot_dir}
done

# ARCH amd64
if [ -f /lib64/ld-linux-x86-64.so.2 ]; then
   cp --parents /lib64/ld-linux-x86-64.so.2 ${_chroot_dir}
fi

# ARCH i386
if [ -f  /lib/ld-linux.so.2 ]; then
   cp --parents /lib/ld-linux.so.2 ${_chroot_dir}
fi

echo "Chroot jail is ready. To access it execute: chroot ${_chroot_dir}"
