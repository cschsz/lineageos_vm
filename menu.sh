#!/bin/bash
if [ $USE_NINJA != "false" ]
then
    echo "Wrong settings detected!"
    read -p "Press any key..."
fi

LOGFILE="/home/christian/loslog.txt"

BACKTITLE="LineageOS"
TITLE="Compiling"
ZIPPATH="/mnt/Android/_builds"

# device
DEVICES=$(dialog --backtitle "$BACKTITLE" \
              --title "$TITLE" \
              --checklist "Choose device(s)" 20 75 10 \
                          "gtaxllte" "Samsung Galaxy Tab A LTE" off \
                          "gtaxlwifi" "Samsung Galaxy Tab A Wifi" off \
                          "santos10wifi" "Samsung Galaxy Tab 3 Wifi" off \
                          "santos103g" "Samsung Galaxy Tab 3 3G" off \
                          "santos10lte" "Samsung Galaxy Tab 3 LTE" off \
                          "kminilte" "Samsung Galaxy S5 mini" off \
                          "zerofltexx" "Samsung Galaxy S6" off \
                          "golden" "Samsung Galaxy S3 mini" off \
                          "espresso3g" "Samsung Galaxy Tab 2" off \
                          2>&1 >/dev/tty)
clear

# type
OPTIONS=(1 "clean & sync & compile"
         2 "sync & compile"
         3 "clean & compile"
         4 "compile"
         5 "sync"
         6 "clean")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "Choose type" \
                15 40 6 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

echo $CHOICE

# functions
move_zips () {
    echo "--------------------------------------------"
    echo move_zips: $1 $2
    echo "--------------------------------------------"
    mv $1/out/target/product/$2/*.zip* $ZIPPATH
}

print_status () {
    #echo $2 | mail -s "$2 build done!" $BUILD_DONE_EMAIL

    # print
    echo "============================================"
    cat $1/build/core/version_defaults.mk | grep "PLATFORM_SECURITY_PATCH :="
    cat $1/out/target/product/$2/obj/KERNEL_OBJ/include/config/kernel.release
    ls -lh $1/out/target/product/$2/kernel
    # log
    echo "============================================" >> $LOGFILE
    echo $1 $2 >> $LOGFILE
    cat $1/build/core/version_defaults.mk | grep "PLATFORM_SECURITY_PATCH :=" >> $LOGFILE
    cat $1/out/target/product/$2/obj/KERNEL_OBJ/include/config/kernel.release >> $LOGFILE
    ls -lh $1/out/target/product/$2/kernel >> $LOGFILE
}

repo_sync () {
    echo "--------------------------------------------"
    echo repo_sync: $1 $2
    echo "--------------------------------------------"
    cd $1
    repo sync --force-sync
    if [ $2 == "kminilte" ]
    then
        cd $1/device/samsung/smdk3470-common/patch
        ./apply.sh
    fi
    if [ $2 == "golden" ]
    then
        cd $1/device/samsung/golden/patches
        ./clearpatches.sh
        ./patch.sh
    fi
}

repo_build () {
    echo "--------------------------------------------"
    echo repo_build: $1 $2
    echo "--------------------------------------------"
    cd $1
    . build/envsetup.sh
    breakfast $2
    brunch $2
}

repo_clear () {
    echo "--------------------------------------------"
    echo repo_clear: $1 $2
    echo "--------------------------------------------"
    cd $1
    . build/envsetup.sh
    breakfast $2
    make clobber
}

# start
clear
for DEVICES in $DEVICES
do
    case $DEVICES in
        "gtaxllte" )
            DEVPATH="/mnt/Android/gtaxl"
            ;;
        "gtaxlwifi" )
            DEVPATH="/mnt/Android/gtaxl"
            ;;
        "santos10wifi" )
            DEVPATH="/mnt/Android/santos10"
            ;;
        "santos103g" )
            DEVPATH="/mnt/Android/santos10"
            ;;
        "santos10lte" )
            DEVPATH="/mnt/Android/santos10"
            ;;
        "kminilte" )
            DEVPATH="/mnt/Android/kminilte"
            ;;
        "zerofltexx" )
            DEVPATH="/mnt/VMs/zerofltexx"
            ;;
        "golden" )
            DEVPATH="/mnt/Android/golden"
            ;;
        "espresso3g" )
            DEVPATH="/mnt/VMs/espresso"
            ;;
        * )
            echo "Canceled [$DEVICES]"
            exit
            ;;
    esac

    case $CHOICE in
        1)
            echo "============================================"
            echo $DEVICES: "clean & sync & compile"
            repo_clear $DEVPATH $DEVICES
            repo_sync $DEVPATH $DEVICES
            repo_build $DEVPATH $DEVICES
            print_status $DEVPATH $DEVICES
            move_zips $DEVPATH $DEVICES
            ;;
        2)
            echo "============================================"
            echo $DEVICES: "sync & compile"
            repo_sync $DEVPATH $DEVICES
            repo_build $DEVPATH $DEVICES
            print_status $DEVPATH $DEVICES
            move_zips $DEVPATH $DEVICES
            ;;
        3)
            echo "============================================"
            echo $DEVICES: "clean & compile"
            repo_clear $DEVPATH $DEVICES
            repo_build $DEVPATH $DEVICES
            print_status $DEVPATH $DEVICES
            move_zips $DEVPATH $DEVICES
            ;;
        4)
            echo "============================================"
            echo $DEVICES: "compile"
            repo_build $DEVPATH $DEVICES
            print_status $DEVPATH $DEVICES
            move_zips $DEVPATH $DEVICES
            ;;
        5)
            echo "============================================"
            echo $DEVICES: "sync"
            repo_sync $DEVPATH $DEVICES
            print_status $DEVPATH $DEVICES
            ;;
        6)
            echo "============================================"
            echo $DEVICES: "clean"
            repo_clear $DEVPATH $DEVICES
            print_status $DEVPATH $DEVICES
            ;;
        *)
            echo "Canceled [$CHOICE]"
            exit
            ;;
    esac
done

echo "Done!"
read -p "Press any key..."
