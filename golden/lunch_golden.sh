#!/bin/bash
cd ~/android/carbon
repo sync --force-sync
cd ~/android/carbon/device/samsung/golden/patches
./clearpatches.sh
./patch.sh
cd ~/android/carbon
. build/envsetup.sh

breakfast golden
brunch golden
echo "golden" | mail -s "golden build done!" $BUILD_DONE_EMAIL
cat ~/android/carbon/build/core/version_defaults.mk | grep --color "PLATFORM_SECURITY_PATCH :="

cat ~/android/carbon/out/target/product/golden/obj/KERNEL_OBJ/include/config/kernel.release 
caja ~/android/carbon/out/target/product/golden
