#!/bin/bash

set -e

bzImage='arch/x86/boot/bzImage'
qemuImage='/home/petr/w/k/syzkaller/bullseye.img'

qemu-system-x86_64 \
  -m 2G \
  -smp 2 \
  -kernel $bzImage \
  -append 'console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0 nokaslr' \
  -drive file=$qemuImage,format=raw \
  -net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
  -net nic,model=e1000 \
  -enable-kvm \
  -nographic \
  -pidfile vm.pid

# ctrl + A, X - exit  from QEMU
