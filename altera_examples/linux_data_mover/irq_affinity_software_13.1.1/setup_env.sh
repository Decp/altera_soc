#!/bin/bash

. "$(dirname $0)/check_env.shinc"

#
# Make sure that the current shell environment was not already configured by
# this script.
#
CHECK_SETUP_ENV_SH_WAS_RUN

#
# Make sure that the SoC EDS environment is visible so that we can leverage the
# tools and resources provided by it.
#
CHECK_SOCEDS_DEST_ROOT


#
# Create a convenience variable to reference the linux-socfpga source tree path
# which is required to build linux modules.  This should point into the build
# output directory for the kernel that you are running on your SoC target.
#
# The kernel module in this example will require this path to build against the
# proper kernel configuration.
#
# You can set this variable within this file directly or you can set it up
# prior to running this script.
#
#export LINUX_SOCFPGA_SRC_TREE_PATH="<path-to-linux-build-output-source-dir>"

CHECK_LINUX_SOCFPGA_SRC_TREE_PATH

#
# Create a convenience variable to reference the Qsys header directory that is
# created in the hardware project directory for the hardware target we plan to
# to build this example software for.  Some of the software in this example
# will reference the Qsys headers that were generated with the hardware build.
#
# You can set this variable within this file directly or you can set it up
# prior to running this script.
#
#export QSYS_HEADERS="<path-to-qsys-header-directory>"

CHECK_QSYS_HEADERS

#
# setup the cross compiling environment requirements
#
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm
export SETUP_ENV_SH_WAS_RUN=1

echo ""
echo "These convenience variables are now available:"
declare -p LINUX_SOCFPGA_SRC_TREE_PATH QSYS_HEADERS CROSS_COMPILE ARCH
echo ""

exec bash

