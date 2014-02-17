# Setup Device
set_global_assignment -name FAMILY "Cyclone V"
set_global_assignment -name DEVICE 5CSXFC6C6U23C8ES

# Setup Bank Voltages
set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 3A
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 3B
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 4A
set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 5A
set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 5B
set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 6A
set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 6B
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 7A
set_global_assignment -name IOBANK_VCCIO 1.8V -section_id 7B
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 7C
set_global_assignment -name IOBANK_VCCIO 1.8V -section_id 7D
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 8A

# Setup Pin Voltages
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TX_CTL
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_MDC
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_MDIO
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to RGMII1_RESETn
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RXD0
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RXD1
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RXD2
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RXD3
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RX_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RX_CTL
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TXD0
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TXD1
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TXD2
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TXD3
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TX_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_DQ0
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_DQ1
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_DQ2
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_DQ3
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_SS0
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_SS1
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_CMD
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_D0
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_D1
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_D2
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_D3
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_STP
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_CS
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D0
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D1
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D2
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D3
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D4
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D5
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D6
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D7
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_DIR
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_NXT
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_RESET_N
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_CAN0_RX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_CAN0_TX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_CAN1_RX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_CAN1_TX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_I2C0_SCL
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_I2C0_SDA
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_UART0_RX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_UART0_TX
set_instance_assignment -name IO_STANDARD "1.8 V" -to HPS_GPIO28
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SW3
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SPIS1_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SPIS1_MISO
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SPIS1_MOSI
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SPIS1_SS0
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SW1
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SW2
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to I2C1_SCL
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to I2C1_SDA
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to LED1
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to LED2
set_instance_assignment -name IO_STANDARD "1.8 V" -to LED3

# HPS DDR
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_D
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to HPS_DDR_D
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_D

set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_RZQ0 


set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to HPS_DDR_DQS_P
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to HPS_DDR_DQS_P
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_DQS_P

set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to HPS_DDR_DQS_N
set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to HPS_DDR_DQS_N
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_DQS_N

set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to HPS_DDR_CK_P 
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_CK_P
set_instance_assignment -name D5_DELAY 2 -to HPS_DDR_CK_P

set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to HPS_DDR_CK_N
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_CK_N
set_instance_assignment -name D5_DELAY 2 -to HPS_DDR_CK_N 

set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_A
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_A

set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_BAS
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_BAS

set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_CAS_N 
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_CAS_N

set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_CKE
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_CKE
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_CS0_N -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_CS0_N -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_RAS_N -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_RAS_N -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_WE_N -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_WE_N -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to NC_ODT1 -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to NC_ODT1 -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_RESET_N -tag __hps_sdram_p0
set_instance_assignment -name BOARD_MODEL_FAR_PULLUP_R OPEN -to HPS_DDR_RESET_N -tag __hps_sdram_p0
set_instance_assignment -name BOARD_MODEL_NEAR_PULLUP_R OPEN -to HPS_DDR_RESET_N -tag __hps_sdram_p0
set_instance_assignment -name BOARD_MODEL_FAR_PULLDOWN_R OPEN -to HPS_DDR_RESET_N -tag __hps_sdram_p0
set_instance_assignment -name BOARD_MODEL_NEAR_PULLDOWN_R OPEN -to HPS_DDR_RESET_N -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_RESET_N -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_DQM[0] -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_DQM[0] -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_DQM[1] -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_DQM[1] -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_DQM[2] -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_DQM[2] -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_DQM[3] -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_DQM[3] -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_DQM[4] -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_DQM[4] -tag __hps_sdram_p0
