#!/bin/bash

TEST_PARAMETER=${SETUP_ENV_SH_WAS_RUN:?please run setup_env.sh before running this script}

THE_DIRNAME="$(dirname ${0})"
OUTPUT_DIR="${THE_DIRNAME}/build_output"

function BUILD_APPLICATION() {
	echo ""
	echo "INFO: building ${1} application..."
	echo ""
	"${THE_DIRNAME}/${1}/build_script.sh" || {
		echo "" >&2
		echo "ERROR: while building ${1} application..." >&2
		echo "" >&2
		exit 1
	}
	[ -f "${THE_DIRNAME}/${1}/${1}" ] || {
		echo "" >&2
		echo "ERROR: expected output file cannot be located..." >&2
		echo "ERROR: \"${THE_DIRNAME}/${1}/${1}\"" >&2
		echo "" >&2
		exit 1
	}
	cp "${THE_DIRNAME}/${1}/${1}" "${OUTPUT_DIR}/"
}

function BUILD_MODULE() {
	echo ""
	echo "INFO: making ${1} module..."
	echo ""
	pushd "${THE_DIRNAME}/${1}" > /dev/null
	make || {
		echo "" >&2
		echo "ERROR: while making ${1} module..." >&2
		echo "" >&2
		exit 1
	}
	popd > /dev/null
	[ -f "${THE_DIRNAME}/${1}/${1}.ko" ] || {
		echo "" >&2
		echo "ERROR: expected output file cannot be located..." >&2
		echo "ERROR: \"${THE_DIRNAME}/${1}/${1}.ko\"" >&2
		echo "" >&2
		exit 1
	}
	cp "${THE_DIRNAME}/${1}/${1}.ko" "${OUTPUT_DIR}/"
}

[ -d "${OUTPUT_DIR}" ] && {
	echo "" >&2
	echo "ERROR: output directory \"${OUTPUT_DIR}\" already exists..." >&2
	echo "ERROR: cannot continue..." >&2
	echo "" >&2
	exit 1
}

mkdir "${OUTPUT_DIR}"

BUILD_APPLICATION max_jitter
BUILD_APPLICATION mem_thrash
BUILD_APPLICATION max_irq_jitter_app
BUILD_MODULE irq_module

echo ""
echo "INFO: All examples have been built successfully..."
echo ""

exit 0

