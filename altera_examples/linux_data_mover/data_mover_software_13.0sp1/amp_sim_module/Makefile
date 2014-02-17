ifndef LINUX_SOCFPGA_SRC_TREE_PATH
    $(error LINUX_SOCFPGA_SRC_TREE_PATH is undefined, bad environment, you may need to run setup_env.sh)
endif

KDIR ?= $(LINUX_SOCFPGA_SRC_TREE_PATH)

default:
	$(MAKE) -C $(KDIR) M=$$PWD

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean

help:
	$(MAKE) -C $(KDIR) M=$$PWD help

modules:
	$(MAKE) -C $(KDIR) M=$$PWD modules

modules_install:
	$(MAKE) -C $(KDIR) M=$$PWD modules_install

