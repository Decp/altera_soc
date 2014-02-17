#!/bin/bash

pushd "$(dirname $0)" > /dev/null

HWLIBS_HEADERS="${SOCEDS_DEST_ROOT:?bad environment, you may need to run setup_env.sh}/ip/altera/hps/altera_hps/hwlib/include"

CMD="arm-linux-gnueabihf-gcc \
-g \
-O3 \
-Werror \
-Wall \
-I"${HWLIBS_HEADERS}" \
-pthread \
-o max_jitter \
main.c \
"

echo "${CMD}"
${CMD}

