#!/bin/bash
#
# FILE: run_docker.sh
#
# DESCRIPTION: This script builds the docker image necessary to
#   build the FreeCAD source.
#
# REF: https://wiki.freecad.org/Compile_on_Docker


p_source_dir=~/git/opensource/FreeCAD
p_build_dir=~/git/opensource/FreeCAD-build
p_conf_dir=~/.config/FreeCAD
HOME_DIR=~/

#------------------------------------------------------------------------------
# FUNCTION: usage
#------------------------------------------------------------------------------
usage()
{
    cat >&2 <<EOF

Usage: $(basename $0)

Build a docker container for a local FreeCAD development environment.

General options:
    -h|--help: This message
    -c|--config-dir CONFIG_DIR: the directory where the config artifacts
        are stored on the host machine.
    -b|--build-dir BUILD_DIR: the directory where the build artifacts
        will be stored on the host machine.
    -s|--source-dir SOURCE_DIR: the directory where the source code is
        located on the host machine.

SYNOPSIS:

Build the docker container and drop to a shell in the container
?> $0

EOF
}

#==============================================================================
#
# MAIN PROGRAM SECTION.
#
#==============================================================================
options=$(getopt --alternative --name $(basename $0) --options "hc:b:s:" --longoptions help,config-dir:,build-dir:,source-dir: -- $0 "$@")
if [ $? -ne 0 ]; then
    usage 
    exit 1
fi
eval set -- "$options"
while true; do
    case "$1" in
    -c|--config-dir) shift; p_conf_dir=$1 ;;
    -b|--build-dir)  shift; p_build_dir=$1 ;;
    -s|--source-dir) shift; p_source_dir=$1 ;;
    -h|--help)       usage; exit 0 ;;
    --) shift; break ;;
    esac
    shift
done

if [ ! -d "${p_conf_dir}" ]; then
  usage
  echo "Invalid '--config-dir'. No such file or directory" >&2
  exit 1
fi

if [ ! -d "${p_build_dir}" ]; then
  usage
  echo "Invalid '--build-dir'. No such file or directory" >&2
  exit 1
fi

if [ ! -d "${p_source_dir}" ]; then
  usage
  echo "Invalid '--source-dir'. No such file or directory" >&2
  exit 1
fi

echo "Building docker container ..."

docker build -t local/freecad-docker:latest .

if [ ! -d "${p_source_dir}" ]; then
    mkdir -p "${p_source_dir}"
    pushd "${p_source_dir}"
    git clone https://github.com/FreeCAD/FreeCAD.git -d "${p_source_dir}"
    exit 1
fi
if [ ! -d "${p_build_dir}" ]; then
    mkdir -p "${p_build_dir}"
fi

echo "Enabling local X connections ..."
xhost +local:

echo "Building from ${p_source_dir} ..."
docker run -it --rm \
    -v ${p_source_dir}:/mnt/source \
    -v ${p_build_dir}:/mnt/build \
    -v ${HOME_DIR}:/mnt/files \
    -v ${p_conf_dir}:/root/.local/FreeCAD \
    -e "DISPLAY" \
    -e "QT_X11_NO_MITSHM=1" \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    local/freecad-docker:latest
