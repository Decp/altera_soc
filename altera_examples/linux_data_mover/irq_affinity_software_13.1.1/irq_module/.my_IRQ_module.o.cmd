cmd_/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.o := arm-linux-gnueabihf-gcc -Wp,-MD,/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/.my_IRQ_module.o.d  -nostdinc -isystem /tools/soceds/13.1/162/linux32/ds-5/sw/gcc/bin/../lib/gcc/arm-linux-gnueabihf/4.7.3/include -I/tools/rocketboards.org/linux-socfpga/arch/arm/include -Iarch/arm/include/generated  -I/tools/rocketboards.org/linux-socfpga/include -Iinclude -I/tools/rocketboards.org/linux-socfpga/arch/arm/include/uapi -Iarch/arm/include/generated/uapi -I/tools/rocketboards.org/linux-socfpga/include/uapi -Iinclude/generated/uapi -include /tools/rocketboards.org/linux-socfpga/include/linux/kconfig.h   -I/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module -D__KERNEL__ -mlittle-endian -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -fno-dwarf2-cfi-asm -fno-omit-frame-pointer -mapcs -mno-sched-prolog -mabi=aapcs-linux -mno-thumb-interwork -funwind-tables -marm -D__LINUX_ARM_ARCH__=7 -march=armv7-a -msoft-float -Uarm -Wframe-larger-than=1024 -fno-stack-protector -Wno-unused-but-set-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -g -pg -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DCC_HAVE_ASM_GOTO   -I/data/rfrazer/work/projects/soc_irq_amp/no-backup/data_mover_hardware/qsys_headers   -I/tools/soceds/13.1/162/linux32/ip/altera/hps/altera_hps/hwlib/include  -DMODULE  -D"KBUILD_STR(s)=\#s" -D"KBUILD_BASENAME=KBUILD_STR(my_IRQ_module)"  -D"KBUILD_MODNAME=KBUILD_STR(my_IRQ_module)" -c -o /data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.o /data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.c

source_/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.o := /data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.c

deps_/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.o := \
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
    $(wildcard include/config/module/unload.h) \
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
  /tools/rocketboards.org/linux-socfpga/include/linux/platform_device.h \
    $(wildcard include/config/suspend.h) \
    $(wildcard include/config/hibernate/callbacks.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/device.h \
    $(wildcard include/config/debug/devres.h) \
    $(wildcard include/config/acpi.h) \
    $(wildcard include/config/pinctrl.h) \
    $(wildcard include/config/devtmpfs.h) \
    $(wildcard include/config/sysfs/deprecated.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/ioport.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/klist.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/pinctrl/devinfo.h \
    $(wildcard include/config/pm.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/pm.h \
    $(wildcard include/config/vt/console/sleep.h) \
    $(wildcard include/config/pm/runtime.h) \
    $(wildcard include/config/pm/clk.h) \
    $(wildcard include/config/pm/generic/domains.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/ratelimit.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/device.h \
    $(wildcard include/config/dmabounce.h) \
    $(wildcard include/config/iommu/api.h) \
    $(wildcard include/config/arm/dma/use/iommu.h) \
    $(wildcard include/config/arch/omap.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/pm_wakeup.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/mod_devicetable.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/uuid.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/uuid.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/slab.h \
    $(wildcard include/config/slab/debug.h) \
    $(wildcard include/config/kmemcheck.h) \
    $(wildcard include/config/failslab.h) \
    $(wildcard include/config/slob.h) \
    $(wildcard include/config/slab.h) \
    $(wildcard include/config/slub.h) \
    $(wildcard include/config/debug/slab.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/slub_def.h \
    $(wildcard include/config/slub/stats.h) \
    $(wildcard include/config/memcg/kmem.h) \
    $(wildcard include/config/slub/debug.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/kmemleak.h \
    $(wildcard include/config/debug/kmemleak.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/fs.h \
    $(wildcard include/config/fs/posix/acl.h) \
    $(wildcard include/config/security.h) \
    $(wildcard include/config/quota.h) \
    $(wildcard include/config/fsnotify.h) \
    $(wildcard include/config/ima.h) \
    $(wildcard include/config/epoll.h) \
    $(wildcard include/config/debug/writecount.h) \
    $(wildcard include/config/file/locking.h) \
    $(wildcard include/config/auditsyscall.h) \
    $(wildcard include/config/block.h) \
    $(wildcard include/config/fs/xip.h) \
    $(wildcard include/config/migration.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/kdev_t.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/kdev_t.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/dcache.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/rculist.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/rculist_bl.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/list_bl.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/bit_spinlock.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/lockref.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/path.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/llist.h \
    $(wildcard include/config/arch/have/nmi/safe/cmpxchg.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/radix-tree.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/pid.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/capability.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/capability.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/semaphore.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/fiemap.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/shrinker.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/migrate_mode.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/percpu-rwsem.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/blk_types.h \
    $(wildcard include/config/blk/cgroup.h) \
    $(wildcard include/config/blk/dev/integrity.h) \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/fs.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/limits.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/ioctl.h \
  arch/arm/include/generated/asm/ioctl.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/ioctl.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/ioctl.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/quota.h \
    $(wildcard include/config/quota/netlink/interface.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/percpu_counter.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/dqblk_xfs.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/dqblk_v1.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/dqblk_v2.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/dqblk_qtree.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/projid.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/quota.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/nfs_fs_i.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/fcntl.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/fcntl.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/uapi/asm/fcntl.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/fcntl.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/err.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/miscdevice.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/major.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/mm.h \
    $(wildcard include/config/x86.h) \
    $(wildcard include/config/ppc.h) \
    $(wildcard include/config/parisc.h) \
    $(wildcard include/config/metag.h) \
    $(wildcard include/config/stack/growsup.h) \
    $(wildcard include/config/transparent/hugepage.h) \
    $(wildcard include/config/ksm.h) \
    $(wildcard include/config/debug/vm/rb.h) \
    $(wildcard include/config/arch/uses/numa/prot/none.h) \
    $(wildcard include/config/proc/fs.h) \
    $(wildcard include/config/debug/pagealloc.h) \
    $(wildcard include/config/hibernation.h) \
    $(wildcard include/config/hugetlbfs.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/debug_locks.h \
    $(wildcard include/config/debug/locking/api/selftests.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/mm_types.h \
    $(wildcard include/config/split/ptlock/cpus.h) \
    $(wildcard include/config/have/cmpxchg/double.h) \
    $(wildcard include/config/have/aligned/struct/page.h) \
    $(wildcard include/config/want/page/debug/flags.h) \
    $(wildcard include/config/aio.h) \
    $(wildcard include/config/mm/owner.h) \
    $(wildcard include/config/mmu/notifier.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/auxvec.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/auxvec.h \
  arch/arm/include/generated/asm/auxvec.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/auxvec.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/page-debug-flags.h \
    $(wildcard include/config/page/poisoning.h) \
    $(wildcard include/config/page/guard.h) \
    $(wildcard include/config/page/debug/something/else.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/uprobes.h \
    $(wildcard include/config/arch/supports/uprobes.h) \
    $(wildcard include/config/uprobes.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/mmu.h \
    $(wildcard include/config/cpu/has/asid.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/range.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/pgtable.h \
    $(wildcard include/config/highpte.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/proc-fns.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/glue-proc.h \
    $(wildcard include/config/cpu/arm7tdmi.h) \
    $(wildcard include/config/cpu/arm720t.h) \
    $(wildcard include/config/cpu/arm740t.h) \
    $(wildcard include/config/cpu/arm9tdmi.h) \
    $(wildcard include/config/cpu/arm920t.h) \
    $(wildcard include/config/cpu/arm922t.h) \
    $(wildcard include/config/cpu/arm925t.h) \
    $(wildcard include/config/cpu/arm926t.h) \
    $(wildcard include/config/cpu/arm940t.h) \
    $(wildcard include/config/cpu/arm946e.h) \
    $(wildcard include/config/cpu/arm1020.h) \
    $(wildcard include/config/cpu/arm1020e.h) \
    $(wildcard include/config/cpu/arm1022.h) \
    $(wildcard include/config/cpu/arm1026.h) \
    $(wildcard include/config/cpu/mohawk.h) \
    $(wildcard include/config/cpu/feroceon.h) \
    $(wildcard include/config/cpu/v6k.h) \
    $(wildcard include/config/cpu/v7.h) \
    $(wildcard include/config/cpu/pj4b.h) \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/pgtable-nopud.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/pgtable-hwdef.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/pgtable-2level-hwdef.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/tlbflush.h \
    $(wildcard include/config/smp/on/up.h) \
    $(wildcard include/config/cpu/tlb/v4wt.h) \
    $(wildcard include/config/cpu/tlb/fa.h) \
    $(wildcard include/config/cpu/tlb/v4wbi.h) \
    $(wildcard include/config/cpu/tlb/feroceon.h) \
    $(wildcard include/config/cpu/tlb/v4wb.h) \
    $(wildcard include/config/cpu/tlb/v6.h) \
    $(wildcard include/config/cpu/tlb/v7.h) \
    $(wildcard include/config/arm/errata/720789.h) \
    $(wildcard include/config/arm/errata/798181.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/sched.h \
    $(wildcard include/config/sched/debug.h) \
    $(wildcard include/config/no/hz/common.h) \
    $(wildcard include/config/lockup/detector.h) \
    $(wildcard include/config/core/dump/default/elf/headers.h) \
    $(wildcard include/config/sched/autogroup.h) \
    $(wildcard include/config/virt/cpu/accounting/native.h) \
    $(wildcard include/config/bsd/process/acct.h) \
    $(wildcard include/config/taskstats.h) \
    $(wildcard include/config/audit.h) \
    $(wildcard include/config/cgroups.h) \
    $(wildcard include/config/inotify/user.h) \
    $(wildcard include/config/fanotify.h) \
    $(wildcard include/config/posix/mqueue.h) \
    $(wildcard include/config/keys.h) \
    $(wildcard include/config/perf/events.h) \
    $(wildcard include/config/schedstats.h) \
    $(wildcard include/config/task/delay/acct.h) \
    $(wildcard include/config/fair/group/sched.h) \
    $(wildcard include/config/rt/group/sched.h) \
    $(wildcard include/config/cgroup/sched.h) \
    $(wildcard include/config/blk/dev/io/trace.h) \
    $(wildcard include/config/rcu/boost.h) \
    $(wildcard include/config/compat/brk.h) \
    $(wildcard include/config/cc/stackprotector.h) \
    $(wildcard include/config/virt/cpu/accounting/gen.h) \
    $(wildcard include/config/sysvipc.h) \
    $(wildcard include/config/detect/hung/task.h) \
    $(wildcard include/config/rt/mutexes.h) \
    $(wildcard include/config/task/xacct.h) \
    $(wildcard include/config/cpusets.h) \
    $(wildcard include/config/futex.h) \
    $(wildcard include/config/fault/injection.h) \
    $(wildcard include/config/latencytop.h) \
    $(wildcard include/config/function/graph/tracer.h) \
    $(wildcard include/config/bcache.h) \
    $(wildcard include/config/have/unstable/sched/clock.h) \
    $(wildcard include/config/irq/time/accounting.h) \
    $(wildcard include/config/no/hz/full.h) \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/sched.h \
  arch/arm/include/generated/asm/cputime.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/cputime.h \
    $(wildcard include/config/virt/cpu/accounting.h) \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/cputime_nsecs.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/sem.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/sem.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/ipc.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/ipc.h \
  arch/arm/include/generated/asm/ipcbuf.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/ipcbuf.h \
  arch/arm/include/generated/asm/sembuf.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/sembuf.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/signal.h \
    $(wildcard include/config/old/sigaction.h) \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/signal.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/signal.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/uapi/asm/signal.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/signal-defs.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/uapi/asm/sigcontext.h \
  arch/arm/include/generated/asm/siginfo.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/siginfo.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/siginfo.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/proportions.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/seccomp.h \
    $(wildcard include/config/seccomp.h) \
    $(wildcard include/config/seccomp/filter.h) \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/seccomp.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/rtmutex.h \
    $(wildcard include/config/debug/rt/mutexes.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/plist.h \
    $(wildcard include/config/debug/pi/list.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/resource.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/resource.h \
  arch/arm/include/generated/asm/resource.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/resource.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/asm-generic/resource.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/hrtimer.h \
    $(wildcard include/config/high/res/timers.h) \
    $(wildcard include/config/timerfd.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/timerqueue.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/task_io_accounting.h \
    $(wildcard include/config/task/io/accounting.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/latencytop.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/cred.h \
    $(wildcard include/config/debug/credentials.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/key.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/selinux.h \
    $(wildcard include/config/security/selinux.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/cputype.h \
    $(wildcard include/config/cpu/cp15.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/pgtable-2level.h \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/pgtable.h \
    $(wildcard include/config/have/arch/soft/dirty.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/page-flags.h \
    $(wildcard include/config/pageflags/extended.h) \
    $(wildcard include/config/arch/uses/pg/uncached.h) \
    $(wildcard include/config/memory/failure.h) \
    $(wildcard include/config/swap.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/huge_mm.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/vmstat.h \
    $(wildcard include/config/vm/event/counters.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/vm_event_item.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/interrupt.h \
    $(wildcard include/config/generic/hardirqs.h) \
    $(wildcard include/config/irq/forced/threading.h) \
    $(wildcard include/config/generic/irq/probe.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/irqreturn.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/irqnr.h \
  /tools/rocketboards.org/linux-socfpga/include/uapi/linux/irqnr.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/hardirq.h \
  /tools/rocketboards.org/linux-socfpga/include/linux/ftrace_irq.h \
    $(wildcard include/config/ftrace/nmi/enter.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/vtime.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/hardirq.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/irq.h \
    $(wildcard include/config/sparse/irq.h) \
    $(wildcard include/config/multi/irq/handler.h) \
  /tools/rocketboards.org/linux-socfpga/include/linux/irq_cpustat.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/uaccess.h \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/unified.h \
    $(wildcard include/config/arm/asm/unified.h) \
  /tools/rocketboards.org/linux-socfpga/arch/arm/include/asm/io.h \
    $(wildcard include/config/need/mach/io/h.h) \
    $(wildcard include/config/pci.h) \
    $(wildcard include/config/pcmcia/soc/common.h) \
    $(wildcard include/config/isa.h) \
    $(wildcard include/config/pccard.h) \
  /tools/rocketboards.org/linux-socfpga/include/asm-generic/pci_iomap.h \
    $(wildcard include/config/no/generic/pci/ioport/map.h) \
    $(wildcard include/config/generic/pci/iomap.h) \
  /tools/soceds/13.1/162/linux32/ip/altera/hps/altera_hps/hwlib/include/socal/hps.h \
  /tools/soceds/13.1/162/linux32/ip/altera/hps/altera_hps/hwlib/include/socal/alt_rstmgr.h \
    $(wildcard include/config/io.h) \
  /tools/soceds/13.1/162/linux32/ip/altera/hps/altera_hps/hwlib/include/socal/alt_fpgamgr.h \
  /tools/soceds/13.1/162/linux32/ip/altera/hps/altera_hps/hwlib/include/alt_mpu_registers.h \
  /data/rfrazer/work/projects/soc_irq_amp/no-backup/data_mover_hardware/qsys_headers/hps_0.h \
  /data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/mod_altera_avalon_timer_regs.h \

/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.o: $(deps_/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.o)

$(deps_/data/rfrazer/work/projects/soc_irq_amp/linux_stuff/my_IRQ_module/my_IRQ_module.o):
