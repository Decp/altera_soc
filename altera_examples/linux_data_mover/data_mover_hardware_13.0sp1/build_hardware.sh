#!/bin/sh

EXPECTED_QUARTUS_VERSION="Version 13.0.1 Build 232"
TOP_QSYS_SYSTEM_NAME="soc_system"
QUARTUS_QPF="${TOP_QSYS_SYSTEM_NAME}.qpf"
QUARTUS_OUTPUT_DIR="output_files"
QSYS_HEADERS_DIR="qsys_headers"

BUILD_LOG_DIR="build_logs"

# Make sure the CWD is the directory that this script is located in.
pushd "$(dirname $0)" > /dev/null

# Load some helper functions.
. ./build_funcs.shinc

#
#******************************************************************************
# Validate the current Quartus is the version we tested on.
#******************************************************************************
#
VALIDATE_QUARTUS_VERSION "${EXPECTED_QUARTUS_VERSION}"

#
#******************************************************************************
# Check for required source files.
#******************************************************************************
#
FILE_MUST_EXIST "./${QUARTUS_QPF}"
FILE_MUST_EXIST "./${TOP_QSYS_SYSTEM_NAME}.qsys"

#
#******************************************************************************
# Check for a clean project directory, no previous build residue.
#******************************************************************************
#
DIR_MUST_NOT_EXIST "./${QUARTUS_OUTPUT_DIR}"
DIR_MUST_NOT_EXIST "./${QSYS_HEADERS_DIR}"
DIR_MUST_NOT_EXIST "./${TOP_QSYS_SYSTEM_NAME}"

#
#******************************************************************************
# Generate Qsys System
#******************************************************************************
#
PINFO ""
PINFO "Generating Qsys system..."

RUN_CMD \
ip-generate \
	--project-directory="./" \
	--output-directory="./${TOP_QSYS_SYSTEM_NAME}/synthesis/" \
	--file-set=QUARTUS_SYNTH \
	--report-file=sopcinfo:"./${TOP_QSYS_SYSTEM_NAME}.sopcinfo" \
	--report-file=html:"./${TOP_QSYS_SYSTEM_NAME}.html" \
	--report-file=qip:"./${TOP_QSYS_SYSTEM_NAME}/synthesis/${TOP_QSYS_SYSTEM_NAME}.qip" \
	--report-file=cmp:"./${TOP_QSYS_SYSTEM_NAME}.cmp" \
	--report-file=svd \
	--system-info=DEVICE_FAMILY="Cyclone V" \
	--system-info=DEVICE=5CSXFC6D6F31C8ES \
	--system-info=DEVICE_SPEEDGRADE=8_H6 \
	--component-file="./${TOP_QSYS_SYSTEM_NAME}.qsys" \
	--language=VERILOG

FILE_MUST_EXIST "./${TOP_QSYS_SYSTEM_NAME}/synthesis/${TOP_QSYS_SYSTEM_NAME}.qip" \
FILE_MUST_EXIST "./${TOP_QSYS_SYSTEM_NAME}/synthesis/${TOP_QSYS_SYSTEM_NAME}.v" \

#
#******************************************************************************
# Patch Qsys Top Level HDL File
#******************************************************************************
#
PINFO ""
PINFO "Patching Qsys top level HDL file..."

RUN_CMD \
./patch_qsys_top_hdl.sh "./${TOP_QSYS_SYSTEM_NAME}/synthesis/${TOP_QSYS_SYSTEM_NAME}.v"

#
#******************************************************************************
# Make HPS HMC pin assignments
#******************************************************************************
#
PINFO ""
PINFO "Setting HPS HMC pin assignments..."

PIN_ASSIGNMENTS_SCRIPT_FILE="${TOP_QSYS_SYSTEM_NAME}/synthesis/submodules/hps_sdram_p0_pin_assignments.tcl"

FILE_MUST_EXIST "./${PIN_ASSIGNMENTS_SCRIPT_FILE}"

RUN_CMD \
quartus_map "./${QUARTUS_QPF}"

RUN_CMD \
quartus_sta -t "./${PIN_ASSIGNMENTS_SCRIPT_FILE}" "./${QUARTUS_QPF}"

#
#******************************************************************************
# Compile Quartus Project
#******************************************************************************
#
PINFO ""
PINFO "Compiling Quartus project..."

RUN_CMD \
quartus_sh --flow compile "./${QUARTUS_QPF}"

FILE_MUST_EXIST "./${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.sof"
FILE_MUST_EXIST "./${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.map.rpt"
FILE_MUST_EXIST "./${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.fit.rpt"
FILE_MUST_EXIST "./${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.asm.rpt"
FILE_MUST_EXIST "./${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.sta.rpt"
FILE_MUST_EXIST "./${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.eda.rpt"
FILE_MUST_EXIST "./${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.flow.rpt"

PINFO_STDIN <<EOF

NOTE: critical warnings are expected from the *.fit.rpt and *.sta.rpt
files.  There are two fit warnings regarding \"No exact pin location
assignments\".  And there are four sta warnings regarding the
preliminary timing model status in the 13.0sp1 tools.
EOF

CHECK_FOR_CRITICAL_WARNINGS "./${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.map.rpt"
CHECK_FOR_CRITICAL_WARNINGS "./${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.fit.rpt"
CHECK_FOR_CRITICAL_WARNINGS "./${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.asm.rpt"
CHECK_FOR_CRITICAL_WARNINGS "./${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.sta.rpt"
CHECK_FOR_CRITICAL_WARNINGS "./${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.eda.rpt"
CHECK_FOR_CRITICAL_WARNINGS "./${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.flow.rpt"

#
#******************************************************************************
# Create RBF file
#******************************************************************************
#
PINFO ""
PINFO "Creating RBF programming file..."

QUARTUS_SOF="${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.sof"
QUARTUS_RBF="${QUARTUS_OUTPUT_DIR}/${TOP_QSYS_SYSTEM_NAME}.rbf"

FILE_MUST_EXIST "./${QUARTUS_SOF}"

RUN_CMD \
quartus_cpf -c -o bitstream_compression=on "./${QUARTUS_SOF}" "./${QUARTUS_RBF}"

FILE_MUST_EXIST "./${QUARTUS_RBF}"

#
#******************************************************************************
# Create Qsys system header files
#******************************************************************************
#
PINFO ""
PINFO "Creating Qsys system header files..."

SOPCINFO_FILE="${TOP_QSYS_SYSTEM_NAME}.sopcinfo"

FILE_MUST_EXIST "./${SOPCINFO_FILE}"

MAKE_DIRECTORY "./${QSYS_HEADERS_DIR}"

RUN_CMD \
sopc-create-header-files "./${SOPCINFO_FILE}" --output-dir "./${QSYS_HEADERS_DIR}"

FILE_MUST_EXIST "./${QSYS_HEADERS_DIR}/${TOP_QSYS_SYSTEM_NAME}.h"

#
#******************************************************************************
# Build Complete
#******************************************************************************
#
PINFO_STDIN <<EOF

Build flow completed successfully...

File \"./${QUARTUS_RBF}\" created successfully.

You can move this FPGA configuration file onto your SoC FPGA linux
target and program it into the FPGA with the following command:

cat $(basename "./${QUARTUS_RBF}") > /dev/fgpa0

or

dd if=$(basename "./${QUARTUS_RBF}") of=/dev/fpga0 bs=1M

To check the FPGA status:

cat /sys/class/fpga/fpag0/status

EOF

exit 0

