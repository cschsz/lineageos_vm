#!/bin/bash
cd ~/android/system
repo sync --force-sync
cd ~/android/system/device/samsung/smdk3470-common/patch
./apply.sh
cd ~/android/system
. build/envsetup.sh

breakfast kminilte
brunch kminilte
echo "kminilte" | mail -s "kminilte build done!" $BUILD_DONE_EMAIL
cat ~/android/system/build/core/version_defaults.mk | grep --color "PLATFORM_SECURITY_PATCH :="

cat ~/android/system/out/target/product/kminilte/obj/KERNEL_OBJ/include/config/kernel.release 
caja ~/android/system/out/target/product/kminilte
