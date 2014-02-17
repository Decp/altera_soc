This example directory contains the following application examples:

	amp_sim_data_copy
	data_mover_app
	mem_thrash
	smp_data_copy
	max_jitter

And the following module examples:

	amp_sim_module
	data_mover_module

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

amp_sim_data_copy    - application example directory
amp_sim_module       - module example directory
build_everything.sh  - a script to build all application and module examples
check_env.shinc      - include file for setup_env.sh
data_mover_app       - application example directory
data_mover_module    - module example directory
max_jitter           - application example directory
mem_thrash           - application example directory
readme.txt           - this readme file
setup_env.sh         - environment setup script
smp_data_copy        - application example directory

./amp_sim_data_copy: - application example directory
build_script.sh      - application build script
main.c               - application source file

./amp_sim_module:    - module example directory
amp_sim_module.c     - module source file
Kbuild               - module Kbuild description
Makefile             - module make file

./data_mover_app:    - application example directory
build_script.sh      - application build script
main.c               - application source file

./data_mover_module: - module example directory
data_mover_module.c  - module source file
Kbuild               - module Kbuild description
Makefile             - module make file

./max_jitter:        - application example directory
build_script.sh      - application build script
main.c               - application source file

./mem_thrash:        - application example directory
build_script.sh      - application build script
main.c               - application source file

./smp_data_copy:     - application example directory
build_script.sh      - application build script
main.c               - application source file

