# TCL File Generated by Component Editor 13.0sp1
# Fri Jul 05 22:31:51 EDT 2013
# DO NOT MODIFY


# 
# issue_dma_descriptor "issue_dma_descriptor" v1.0
# RSF 2013.07.05.22:31:51
# 
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module issue_dma_descriptor
# 
set_module_property DESCRIPTION ""
set_module_property NAME issue_dma_descriptor
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR RSF
set_module_property DISPLAY_NAME issue_dma_descriptor
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL issue_dma_descriptor
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file issue_dma_descriptor.v VERILOG PATH issue_dma_descriptor.v TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point csr
# 
add_interface csr avalon end
set_interface_property csr addressUnits WORDS
set_interface_property csr associatedClock clock
set_interface_property csr associatedReset reset
set_interface_property csr bitsPerSymbol 8
set_interface_property csr burstOnBurstBoundariesOnly false
set_interface_property csr burstcountUnits WORDS
set_interface_property csr explicitAddressSpan 0
set_interface_property csr holdTime 0
set_interface_property csr linewrapBursts false
set_interface_property csr maximumPendingReadTransactions 0
set_interface_property csr readLatency 0
set_interface_property csr readWaitTime 1
set_interface_property csr setupTime 0
set_interface_property csr timingUnits Cycles
set_interface_property csr writeWaitTime 0
set_interface_property csr ENABLED true
set_interface_property csr EXPORT_OF ""
set_interface_property csr PORT_NAME_MAP ""
set_interface_property csr SVD_ADDRESS_GROUP ""

add_interface_port csr avs_csr_read read Input 1
add_interface_port csr avs_csr_write write Input 1
add_interface_port csr avs_csr_address address Input 3
add_interface_port csr avs_csr_byteenable byteenable Input 4
add_interface_port csr avs_csr_writedata writedata Input 32
add_interface_port csr avs_csr_readdata readdata Output 32
set_interface_assignment csr embeddedsw.configuration.isFlash 0
set_interface_assignment csr embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment csr embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment csr embeddedsw.configuration.isPrintableDevice 0


# 
# connection point dma_req
# 
add_interface dma_req avalon_streaming start
set_interface_property dma_req associatedClock clock
set_interface_property dma_req associatedReset reset
set_interface_property dma_req dataBitsPerSymbol 128
set_interface_property dma_req errorDescriptor ""
set_interface_property dma_req firstSymbolInHighOrderBits true
set_interface_property dma_req maxChannel 0
set_interface_property dma_req readyLatency 0
set_interface_property dma_req ENABLED true
set_interface_property dma_req EXPORT_OF ""
set_interface_property dma_req PORT_NAME_MAP ""
set_interface_property dma_req SVD_ADDRESS_GROUP ""

add_interface_port dma_req aso_dma_req_data data Output 128
add_interface_port dma_req aso_dma_req_valid valid Output 1
add_interface_port dma_req aso_dma_req_ready ready Input 1

