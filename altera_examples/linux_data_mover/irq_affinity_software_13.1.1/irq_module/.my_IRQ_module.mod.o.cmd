cmd_/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.mod.o := arm-linux-gnueabihf-gcc -Wp,-MD,/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/.my_IRQ_module.mod.o.d  -nostdinc -isystem /tools/soceds/13.1/162/linux32/ds-5/sw/gcc/bin/../lib/gcc/arm-linux-gnueabihf/4.7.3/include -I/tools/rocketboards.org/linux-socfpga/arch/arm/include -Iarch/arm/include/generated  -I/tools/rocketboards.org/linux-socfpga/include -Iinclude -I/tools/rocketboards.org/linux-socfpga/arch/arm/include/uapi -Iarch/arm/include/generated/uapi -I/tools/rocketboards.org/linux-socfpga/include/uapi -Iinclude/generated/uapi -include /tools/rocketboards.org/linux-socfpga/include/linux/kconfig.h   -I/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module -D__KERNEL__ -mlittle-endian -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -fno-dwarf2-cfi-asm -fno-omit-frame-pointer -mapcs -mno-sched-prolog -mabi=aapcs-linux -mno-thumb-interwork -funwind-tables -marm -D__LINUX_ARM_ARCH__=7 -march=armv7-a -msoft-float -Uarm -Wframe-larger-than=1024 -fno-stack-protector -Wno-unused-but-set-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -g -pg -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DCC_HAVE_ASM_GOTO   -I/data/rfrazer/work/projects/soc_irq_amp/no-backup/data_mover_hardware/qsys_headers   -I/tools/soceds/13.1/162/linux32/ip/altera/hps/altera_hps/hwlib/include  -D"KBUILD_STR(s)=\#s" -D"KBUILD_BASENAME=KBUILD_STR(my_IRQ_module.mod)"  -D"KBUILD_MODNAME=KBUILD_STR(my_IRQ_module)" -DMODULE  -c -o /data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.mod.o /data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.mod.c

source_/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.mod.o := /data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.mod.c

deps_/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.mod.o := \
    $(wildcard include/config/module/unload.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/module.h \
    $(wildcard include/config/sysfs.h) \
    $(wildcard include/config/modules.h) \
    $(wildcard include/config/unused/symbols.h) \
    $(wildcard include/config/module/sig.h) \
    $(wildcard include/config/generic/bug.h) \
    $(wildcard include/config/kallsyms.h) \
    $(wildcard include/config/smp.h) \
    $(wildcard include/config/tracepoints.h) \
    $(wildcard include/config/tracing.h) \
    $(wildcard include/config/event/tracing.h) \
    $(wildcard include/config/ftrace/mcount/record.h) \
    $(wildcard include/config/constructors.h) \
    $(wildcard include/config/debug/set/module/ronx.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/list.h \
    $(wildcard include/config/debug/list.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/types.h \
    $(wildcard include/config/uid16.h) \
    $(wildcard include/config/lbdaf.h) \
    $(wildcard include/config/arch/dma/addr/t/64bit.h) \
    $(wildcard include/config/phys/addr/t/64bit.h) \
    $(wildcard include/config/64bit.h) \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/types.h \
  arch/arm/include/generated/asm/types.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/types.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/int-ll64.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/int-ll64.h \
  arch/arm/include/generated/asm/bitsperlong.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/bitsperlong.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/bitsperlong.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/posix_types.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/stddef.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/stddef.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/compiler.h \
    $(wildcard include/config/sparse/rcu/pointer.h) \
    $(wildcard include/config/trace/branch/profiling.h) \
    $(wildcard include/config/profile/all/branches.h) \
    $(wildcard include/config/enable/must/check.h) \
    $(wildcard include/config/enable/warn/deprecated.h) \
    $(wildcard include/config/kprobes.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/compiler-gcc.h \
    $(wildcard include/config/arch/supports/optimized/inlining.h) \
    $(wildcard include/config/optimize/inlining.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/compiler-gcc4.h \
    $(wildcard include/config/arch/use/builtin/bswap.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/uapi/asm/posix_types.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/posix_types.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/poison.h \
    $(wildcard include/config/illegal/pointer/value.h) \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/const.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/stat.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/uapi/asm/stat.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/stat.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/time.h \
    $(wildcard include/config/arch/uses/gettimeoffset.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/cache.h \
    $(wildcard include/config/arch/has/cache/line/size.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/kernel.h \
    $(wildcard include/config/preempt/voluntary.h) \
    $(wildcard include/config/debug/atomic/sleep.h) \
    $(wildcard include/config/prove/locking.h) \
    $(wildcard include/config/ring/buffer.h) \
  /tools/soceds/13.1/162/linux32/ds-5/sw/gcc/bin/../lib/gcc/arm-linux-gnueabihf/4.7.3/include/stdarg.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/linkage.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/stringify.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/export.h \
    $(wildcard include/config/have/underscore/symbol/prefix.h) \
    $(wildcard include/config/modversions.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/linkage.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/bitops.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/bitops.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/irqflags.h \
    $(wildcard include/config/trace/irqflags.h) \
    $(wildcard include/config/irqsoff/tracer.h) \
    $(wildcard include/config/preempt/tracer.h) \
    $(wildcard include/config/trace/irqflags/support.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/typecheck.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/irqflags.h \
    $(wildcard include/config/cpu/v7m.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/ptrace.h \
    $(wildcard include/config/arm/thumb.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/uapi/asm/ptrace.h \
    $(wildcard include/config/cpu/endian/be8.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/hwcap.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/uapi/asm/hwcap.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/bitops/non-atomic.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/bitops/fls64.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/bitops/sched.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/bitops/hweight.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/bitops/arch_hweight.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/bitops/const_hweight.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/bitops/lock.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/bitops/le.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/uapi/asm/byteorder.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/byteorder/little_endian.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/byteorder/little_endian.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/swab.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/swab.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/swab.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/uapi/asm/swab.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/byteorder/generic.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/bitops/ext2-atomic-setbit.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/log2.h \
    $(wildcard include/config/arch/has/ilog2/u32.h) \
    $(wildcard include/config/arch/has/ilog2/u64.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/printk.h \
    $(wildcard include/config/early/printk.h) \
    $(wildcard include/config/printk.h) \
    $(wildcard include/config/dynamic/debug.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/init.h \
    $(wildcard include/config/broken/rodata.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/kern_levels.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/dynamic_debug.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/string.h \
    $(wildcard include/config/binary/printf.h) \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/string.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/string.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/errno.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/errno.h \
  arch/arm/include/generated/asm/errno.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/errno.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/errno-base.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/kernel.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/sysinfo.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/cache.h \
    $(wildcard include/config/arm/l1/cache/shift.h) \
    $(wildcard include/config/aeabi.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/seqlock.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/spinlock.h \
    $(wildcard include/config/debug/spinlock.h) \
    $(wildcard include/config/generic/lockbreak.h) \
    $(wildcard include/config/preempt.h) \
    $(wildcard include/config/debug/lock/alloc.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/preempt.h \
    $(wildcard include/config/debug/preempt.h) \
    $(wildcard include/config/context/tracking.h) \
    $(wildcard include/config/preempt/count.h) \
    $(wildcard include/config/preempt/notifiers.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/thread_info.h \
    $(wildcard include/config/compat.h) \
    $(wildcard include/config/debug/stack/usage.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/bug.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/bug.h \
    $(wildcard include/config/bug.h) \
    $(wildcard include/config/thumb2/kernel.h) \
    $(wildcard include/config/debug/bugverbose.h) \
    $(wildcard include/config/arm/lpae.h) \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/bug.h \
    $(wildcard include/config/generic/bug/relative/pointers.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/thread_info.h \
    $(wildcard include/config/crunch.h) \
    $(wildcard include/config/arm/thumbee.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/fpstate.h \
    $(wildcard include/config/vfpv3.h) \
    $(wildcard include/config/iwmmxt.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/domain.h \
    $(wildcard include/config/io/36.h) \
    $(wildcard include/config/cpu/use/domains.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/barrier.h \
    $(wildcard include/config/cpu/32v6k.h) \
    $(wildcard include/config/cpu/xsc3.h) \
    $(wildcard include/config/cpu/fa526.h) \
    $(wildcard include/config/arch/has/barriers.h) \
    $(wildcard include/config/arm/dma/mem/bufferable.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/outercache.h \
    $(wildcard include/config/outer/cache/sync.h) \
    $(wildcard include/config/outer/cache.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/bottom_half.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/spinlock_types.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/spinlock_types.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/lockdep.h \
    $(wildcard include/config/lockdep.h) \
    $(wildcard include/config/lock/stat.h) \
    $(wildcard include/config/prove/rcu.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/rwlock_types.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/spinlock.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/processor.h \
    $(wildcard include/config/have/hw/breakpoint.h) \
    $(wildcard include/config/mmu.h) \
    $(wildcard include/config/arm/errata/754327.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/hw_breakpoint.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/rwlock.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/spinlock_api_smp.h \
    $(wildcard include/config/inline/spin/lock.h) \
    $(wildcard include/config/inline/spin/lock/bh.h) \
    $(wildcard include/config/inline/spin/lock/irq.h) \
    $(wildcard include/config/inline/spin/lock/irqsave.h) \
    $(wildcard include/config/inline/spin/trylock.h) \
    $(wildcard include/config/inline/spin/trylock/bh.h) \
    $(wildcard include/config/uninline/spin/unlock.h) \
    $(wildcard include/config/inline/spin/unlock/bh.h) \
    $(wildcard include/config/inline/spin/unlock/irq.h) \
    $(wildcard include/config/inline/spin/unlock/irqrestore.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/rwlock_api_smp.h \
    $(wildcard include/config/inline/read/lock.h) \
    $(wildcard include/config/inline/write/lock.h) \
    $(wildcard include/config/inline/read/lock/bh.h) \
    $(wildcard include/config/inline/write/lock/bh.h) \
    $(wildcard include/config/inline/read/lock/irq.h) \
    $(wildcard include/config/inline/write/lock/irq.h) \
    $(wildcard include/config/inline/read/lock/irqsave.h) \
    $(wildcard include/config/inline/write/lock/irqsave.h) \
    $(wildcard include/config/inline/read/trylock.h) \
    $(wildcard include/config/inline/write/trylock.h) \
    $(wildcard include/config/inline/read/unlock.h) \
    $(wildcard include/config/inline/write/unlock.h) \
    $(wildcard include/config/inline/read/unlock/bh.h) \
    $(wildcard include/config/inline/write/unlock/bh.h) \
    $(wildcard include/config/inline/read/unlock/irq.h) \
    $(wildcard include/config/inline/write/unlock/irq.h) \
    $(wildcard include/config/inline/read/unlock/irqrestore.h) \
    $(wildcard include/config/inline/write/unlock/irqrestore.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/atomic.h \
    $(wildcard include/config/arch/has/atomic/or.h) \
    $(wildcard include/config/generic/atomic64.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/atomic.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/cmpxchg.h \
    $(wildcard include/config/cpu/sa1100.h) \
    $(wildcard include/config/cpu/sa110.h) \
    $(wildcard include/config/cpu/v6.h) \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/cmpxchg-local.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/atomic-long.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/math64.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/div64.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/compiler.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/time.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/uidgid.h \
    $(wildcard include/config/uidgid/strict/type/checks.h) \
    $(wildcard include/config/user/ns.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/highuid.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/kmod.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/gfp.h \
    $(wildcard include/config/numa.h) \
    $(wildcard include/config/highmem.h) \
    $(wildcard include/config/zone/dma.h) \
    $(wildcard include/config/zone/dma32.h) \
    $(wildcard include/config/pm/sleep.h) \
    $(wildcard include/config/cma.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/mmzone.h \
    $(wildcard include/config/force/max/zoneorder.h) \
    $(wildcard include/config/memory/isolation.h) \
    $(wildcard include/config/memcg.h) \
    $(wildcard include/config/compaction.h) \
    $(wildcard include/config/memory/hotplug.h) \
    $(wildcard include/config/sparsemem.h) \
    $(wildcard include/config/have/memblock/node/map.h) \
    $(wildcard include/config/discontigmem.h) \
    $(wildcard include/config/flat/node/mem/map.h) \
    $(wildcard include/config/no/bootmem.h) \
    $(wildcard include/config/numa/balancing.h) \
    $(wildcard include/config/have/memory/present.h) \
    $(wildcard include/config/have/memoryless/nodes.h) \
    $(wildcard include/config/need/node/memmap/size.h) \
    $(wildcard include/config/need/multiple/nodes.h) \
    $(wildcard include/config/have/arch/early/pfn/to/nid.h) \
    $(wildcard include/config/flatmem.h) \
    $(wildcard include/config/sparsemem/extreme.h) \
    $(wildcard include/config/have/arch/pfn/valid.h) \
    $(wildcard include/config/nodes/span/other/nodes.h) \
    $(wildcard include/config/holes/in/zone.h) \
    $(wildcard include/config/arch/has/holes/memorymodel.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/wait.h \
  arch/arm/include/generated/asm/current.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/current.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/wait.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/threads.h \
    $(wildcard include/config/nr/cpus.h) \
    $(wildcard include/config/base/small.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/numa.h \
    $(wildcard include/config/nodes/shift.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/nodemask.h \
    $(wildcard include/config/movable/node.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/bitmap.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/pageblock-flags.h \
    $(wildcard include/config/hugetlb/page.h) \
    $(wildcard include/config/hugetlb/page/size/variable.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/page-flags-layout.h \
    $(wildcard include/config/sparsemem/vmemmap.h) \
  include/generated/bounds.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/page.h \
    $(wildcard include/config/cpu/copy/v4wt.h) \
    $(wildcard include/config/cpu/copy/v4wb.h) \
    $(wildcard include/config/cpu/copy/feroceon.h) \
    $(wildcard include/config/cpu/copy/fa.h) \
    $(wildcard include/config/cpu/xscale.h) \
    $(wildcard include/config/cpu/copy/v6.h) \
    $(wildcard include/config/kuser/helpers.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/glue.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/pgtable-2level-types.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/memory.h \
    $(wildcard include/config/need/mach/memory/h.h) \
    $(wildcard include/config/page/offset.h) \
    $(wildcard include/config/dram/size.h) \
    $(wildcard include/config/dram/base.h) \
    $(wildcard include/config/have/tcm.h) \
    $(wildcard include/config/arm/patch/phys/virt.h) \
    $(wildcard include/config/phys/offset.h) \
    $(wildcard include/config/virt/to/bus.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/sizes.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/memory_model.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/getorder.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/memory_hotplug.h \
    $(wildcard include/config/memory/hotremove.h) \
    $(wildcard include/config/have/arch/nodedata/extension.h) \
    $(wildcard include/config/have/bootmem/info/node.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/notifier.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/mutex.h \
    $(wildcard include/config/debug/mutexes.h) \
    $(wildcard include/config/mutex/spin/on/owner.h) \
    $(wildcard include/config/have/arch/mutex/cpu/relax.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/rwsem.h \
    $(wildcard include/config/rwsem/generic/spinlock.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/rwsem-spinlock.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/srcu.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/rcupdate.h \
    $(wildcard include/config/rcu/torture/test.h) \
    $(wildcard include/config/tree/rcu.h) \
    $(wildcard include/config/tree/preempt/rcu.h) \
    $(wildcard include/config/rcu/trace.h) \
    $(wildcard include/config/preempt/rcu.h) \
    $(wildcard include/config/rcu/user/qs.h) \
    $(wildcard include/config/tiny/rcu.h) \
    $(wildcard include/config/debug/objects/rcu/head.h) \
    $(wildcard include/config/hotplug/cpu.h) \
    $(wildcard include/config/rcu/nocb/cpu.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/cpumask.h \
    $(wildcard include/config/cpumask/offstack.h) \
    $(wildcard include/config/debug/per/cpu/maps.h) \
    $(wildcard include/config/disable/obsolete/cpumask/functions.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/completion.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/debugobjects.h \
    $(wildcard include/config/debug/objects.h) \
    $(wildcard include/config/debug/objects/free.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/rcutree.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/workqueue.h \
    $(wildcard include/config/debug/objects/work.h) \
    $(wildcard include/config/freezer.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/timer.h \
    $(wildcard include/config/timer/stats.h) \
    $(wildcard include/config/debug/objects/timers.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/ktime.h \
    $(wildcard include/config/ktime/scalar.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/jiffies.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/timex.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/timex.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/param.h \
  arch/arm/include/generated/asm/param.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/param.h \
    $(wildcard include/config/hz.h) \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/param.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/timex.h \
    $(wildcard include/config/arch/multiplatform.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/topology.h \
    $(wildcard include/config/sched/smt.h) \
    $(wildcard include/config/sched/mc.h) \
    $(wildcard include/config/sched/book.h) \
    $(wildcard include/config/use/percpu/numa/node/id.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/smp.h \
    $(wildcard include/config/use/generic/smp/helpers.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/smp.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/percpu.h \
    $(wildcard include/config/need/per/cpu/embed/first/chunk.h) \
    $(wildcard include/config/need/per/cpu/page/first/chunk.h) \
    $(wildcard include/config/have/setup/per/cpu/area.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/pfn.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/percpu.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/percpu.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/percpu-defs.h \
    $(wildcard include/config/debug/force/weak/per/cpu.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/topology.h \
    $(wildcard include/config/arm/cpu/topology.h) \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/topology.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/mmdebug.h \
    $(wildcard include/config/debug/vm.h) \
    $(wildcard include/config/debug/virtual.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/sysctl.h \
    $(wildcard include/config/sysctl.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/rbtree.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/sysctl.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/elf.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/elf.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/user.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/elf.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/elf-em.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/kobject.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/sysfs.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/kobject_ns.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/kref.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/moduleparam.h \
    $(wildcard include/config/alpha.h) \
    $(wildcard include/config/ia64.h) \
    $(wildcard include/config/ppc64.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/tracepoint.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/static_key.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/jump_label.h \
    $(wildcard include/config/jump/label.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/module.h \
    $(wildcard include/config/arm/unwind.h) \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/module.h \
    $(wildcard include/config/have/mod/arch/specific.h) \
    $(wildcard include/config/modules/use/elf/rel.h) \
    $(wildcard include/config/modules/use/elf/rela.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/vermagic.h \
  include/generated/utsrelease.h \

/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.mod.o: $(deps_/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.mod.o)

$(deps_/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.mod.o):
