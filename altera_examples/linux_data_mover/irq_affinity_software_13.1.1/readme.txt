This example directory contains the following application examples:

	mem_thrash
	max_jitter
	max_irq_jitter_app

And the following module example:

	irq_module

This example assumes that you have the Altera SoC EDS development tools
installed on your host workstation and that you have a linux source tree
available from a linux kernel build for your Altera SoC FPGA target and that you
have a Qsys headers directory available from a proper hardware build of the
hardware example that accompanies this software example.  You must configure two
environment variables to create a sufficient environment for building this
example:

export LINUX_SOCFPGA_SRC_TREE_PATH="<path-to-linux-build-output-source-dir>"
export QSYS_HEADERS="<path-to-qsys-header-directory>"

Once you have those environment variables properly declared you can run the
"./setup_env.sh" script and then you can either run the "./build_everything.sh"
script to build all of the applications and modules that are part of this
example, or you can manually build any of the applications or modules in this 
example.  Each application example contains a build script that can be used to
build the application example and each module example contains a make file that
can be used to build the module example.

Here is the manifest of the contents of this example:

build_everything.sh  - a script to build all application and module examples
check_env.shinc      - include file for setup_env.sh
irq_module           - module example directory
max_irq_jitter_app   - application example directory
max_jitter           - application example directory
mem_thrash           - application example directory
readme.txt           - this readme file
setup_env.sh         - environment setup script

./irq_module:        - module example directory
irq_module.c         - module source file
Kbuild               - Kbuild file for local module build
Makefile             - Makefile for local module project
mod_altera_avalon_timer_regs.h - modified header for Altera Avalon Timer peripheral

./max_irq_jitter_app: - application example directory
build_script.sh       - application build script
main.c                - application source file

./max_jitter:        - application example directory
build_script.sh      - application build script
main.c               - application source file

./mem_thrash:        - application example directory
build_script.sh      - application build script
main.c               - application source file

