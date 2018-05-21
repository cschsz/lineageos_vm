#!/bin/bash
cd ~/android/lineage
. build/envsetup.sh

breakfast espresso3g
brunch espresso3g
echo "espresso3g" | mail -s "espresso3g build done!" $BUILD_DONE_EMAIL
cat ~/android/lineage/build/core/version_defaults.mk | grep --color "PLATFORM_SECURITY_PATCH :="

cat ~/android/lineage/out/target/product/espresso3g/obj/KERNEL_OBJ/include/config/kernel.release 
caja ~/android/lineage/out/target/product/espresso3g
