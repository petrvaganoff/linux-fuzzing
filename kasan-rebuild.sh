#!/bin/bash

set -e

make CC=clang defconfig
make CC=clang kvm_guest.config

./scripts/config -e KASAN -e KASAN_INLINE -e KCOV -e KCOV_ENABLE_COMPARISONS \
    -e KCOV_INSTRUMENT_ALL -e FAULT_INJECTION -e FAULT_INJECTION_DEBUG_FS \
    -e FAULT_INJECTION_USERCOPY -e FAILSLAB -e FAIL_PAGE_ALLOC \
    -e FAIL_MAKE_REQUEST -e FAIL_IO_TIMEOUT -e FAIL_FUTEX -e LOCKDEP \
    --set-val LOCKDEP_BITS 17 --set-val LOCKDEP_CHAINS_BITS 18 \
    --set-val LOCKDEP_STACK_TRACE_BITS 20 --set-val LOCKDEP_STACK_TRACE_HASH_BITS 14 \
    --set-val LOCKDEP_CIRCULAR_QUEUE_BITS 12 -e PROVE_LOCKING -e DEBUG_ATOMIC_SLEEP \
    -e PROVE_RCU -e DEBUG_VM -e FORTIFY_SOURCE -e HARDENED_USERCOPY \
    -e LOCKUP_DETECTOR -e SOFTLOCKUP_DETECTOR -e HARDLOCKUP_DETECTOR \
    -e BOOTPARAM_HARDLOCKUP_PANIC -e DETECT_HUNG_TASK -e WQ_WATCHDOG \
    --set-val DEFAULT_HUNG_TASK_TIMEOUT 140 --set-val RCU_CPU_STALL_TIMEOUT 100 \
    -e DEBUG_KMEMLEAK --set-val DEBUG_KMEMLEAK_AUTO_SCAN n \
    --set-val DEBUG_KMEMLEAK_MEM_POOL_SIZE 16000 -e DEBUG_INFO -e GDB_SCRIPTS \
    --set-val DEBUG_INFO_REDUCED n -e UNWINDER_ORC --set-val RANDOMIZE_BASE n \
    --set-val DEBUG_INFO_COMPRESSED n --set-val DEBUG_INFO_SPLIT n \
    -e DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT --set-val DEBUG_INFO_BTF n -e PVH \
    -e KALLSYMS -e KALLSYMS_ALL -e CMDLINE_BOOL \
    --set-str CMDLINE "earlyprintk=serial net.ifnames=0 sysctl.kernel.hung_task_all_cpu_backtrace=1 ima_policy=tcb nf-conntrack-ftp.ports=20000 nf-conntrack-tftp.ports=20000 nf-conntrack-sip.ports=20000 nf-conntrack-irc.ports=20000 nf-conntrack-sane.ports=20000 binder.debug_mask=0 rcupdate.rcu_expedited=1 no_hash_pointers page_owner=on sysctl.vm.nr_hugepages=4 sysctl.vm.nr_overcommit_hugepages=4 secretmem.enable=1 msr.allow_writes=off root=/dev/sda console=ttyS0 vsyscall=native numa=fake=2 kvm-intel.nested=1 spec_store_bypass_disable=prctl nopcid vivid.n_devs=16 vivid.multiplanar=1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2 netrom.nr_ndevs=16 rose.rose_ndevs=16 dummy_hcd.num=8 smp.csd_lock_timeout=100000 watchdog_thresh=55 workqueue.watchdog_thresh=140 sysctl.net.core.netdev_unregister_timeout_secs=140 panic_on_warn=1" \
    --set-val CMDLINE_OVERRIDE n -e TUN -e MAC80211_HWSIM \
    --set-val IEEE802154_FAKELB n -e IEEE802154_HWSIM -e USB_DUMMY_HCD -e USB_RAW_GADGET \
    -e BT_HCIVHCI -e UBSAN -e UBSAN_SANITIZE_ALL --set-val UBSAN_TRAP n \
    --set-val UBSAN_MISC n -e UBSAN_BOUNDS -e UBSAN_SHIFT --set-val UBSAN_DIV_ZERO n \
    --set-val UBSAN_BOOL n --set-val UBSAN_OBJECT_SIZE n \
    --set-val UBSAN_SIGNED_OVERFLOW n --set-val UBSAN_UNSIGNED_OVERFLOW n \
    --set-val UBSAN_ENUM n --set-val UBSAN_ALIGNMENT n \
    --set-val DEVMEM n --set-val DEVKMEM n --set-val DEVPORT n --set-val UPROBE_EVENTS n \
    --set-val MODULE_FORCE_UNLOAD n -e SECURITY_TOMOYO_INSECURE_BUILTIN_SETTING

make CC=clang olddefconfig

make CC=clang KCFLAGS="-g -fno-omit-frame-pointer" -j$(nproc)
