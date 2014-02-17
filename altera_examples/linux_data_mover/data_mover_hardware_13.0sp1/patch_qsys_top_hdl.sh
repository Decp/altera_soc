#!/bin/sh

[ "$#" -eq "1" ] || {
	echo "USAGE: ${0} <hdl file>"
	exit 1
}

[ -f "${1}" ] || {

	echo "ERROR: file does not exist \"${1}\""
	exit 1
}

#
# This patch is required to get proper coherency on transactions that we pass
# thru the ACP port of the Cortex A9.
#
# This script adjusts some signal settings for the AXI slave interface on the
# FPGA2HPS bridge.  Qsys currently does not provide a mechanism to set these
# ports to the required state.
#
# The AxUSER and AxCACHE signals are adjusted by this script.
#
# The AxPROT signals are properly passed thru the Qsys fabric based on the
# secure/non-secure settings of the Avalon masters, so this script does not
# touch the AxPROT signals.
#
sed -i.orig \
-e "/\.f2h_AWUSER/ s/\(.*\)hps_0_f2h_axi_slave_agent_altera_axi_master_awuser\(.*\)/\1 5'h1 \2 \/\/ RSF hps_0_f2h_axi_slave_agent_altera_axi_master_awuser/" \
-e "/\.f2h_ARUSER/ s/\(.*\)hps_0_f2h_axi_slave_agent_altera_axi_master_aruser\(.*\)/\1 5'h1 \2 \/\/ RSF hps_0_f2h_axi_slave_agent_altera_axi_master_aruser/" \
-e "/issue_dma_descriptor_1_csr_translator/,/f2h_pb_0_m0_translator_avalon_universal_master_0_agent/ s/\(.*CACHE_VALUE.*\)0\(.*\)/\1 15 \2 \/\/ RSF/" \
${1}

