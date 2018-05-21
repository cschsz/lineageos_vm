#!/bin/bash
cd ~/android/system
. build/envsetup.sh

breakfast gtaxllte
brunch gtaxllte
echo "gtaxllte" | mail -s "gtaxllte build done!" $BUILD_DONE_EMAIL
cat ~/android/system/build/core/version_defaults.mk | grep --color "PLATFORM_SECURITY_PATCH :="

. build/envsetup.sh
breakfast gtaxlwifi
brunch gtaxlwifi
echo "gtaxlwifi" | mail -s "gtaxlwifi build done!" $BUILD_DONE_EMAIL
cat ~/android/system/build/core/version_defaults.mk | grep --color "PLATFORM_SECURITY_PATCH :="

cat ~/android/system/out/target/product/gtaxllte/obj/KERNEL_OBJ/include/config/kernel.release 
cat ~/android/system/out/target/product/gtaxlwifi/obj/KERNEL_OBJ/include/config/kernel.release 
caja ~/android/system/out/target/product
