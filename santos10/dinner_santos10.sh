#!/bin/bash
cd ~/android/system
. build/envsetup.sh
breakfast santos10wifi
brunch santos10wifi
echo "santos10wifi" | mail -s "santos10wifi build done!" $BUILD_DONE_EMAIL
cat ~/android/system/build/core/version_defaults.mk | grep --color "PLATFORM_SECURITY_PATCH :="

breakfast santos103g
brunch santos103g
echo "santos103g" | mail -s "santos103g build done!" $BUILD_DONE_EMAIL
cat ~/android/system/build/core/version_defaults.mk | grep --color "PLATFORM_SECURITY_PATCH :="

breakfast santos10lte
brunch santos10lte
echo "santos10lte" | mail -s "santos10lte build done!" $BUILD_DONE_EMAIL
cat ~/android/system/build/core/version_defaults.mk | grep --color "PLATFORM_SECURITY_PATCH :="

cat ~/android/system/out/target/product/santos10wifi/obj/KERNEL_OBJ/include/config/kernel.release 
cat ~/android/system/out/target/product/santos103g/obj/KERNEL_OBJ/include/config/kernel.release 
cat ~/android/system/out/target/product/santos10lte/obj/KERNEL_OBJ/include/config/kernel.release 
caja ~/android/system/out/target/product