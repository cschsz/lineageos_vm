#!/bin/bash
if [ $USE_NINJA != "false" ]
then
    echo "Wrong settings detected!"
    read -p "Press any key..."
fi

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=5
BACKTITLE="LineageOS"
TITLE="Compiling"
ZIPPATH="/mnt/Android/_builds"

# device
DEVICES=$(dialog --backtitle "$BACKTITLE" \
              --title "$TITLE" \
              --checklist "Choose device(s)" 20 75 5 \
                          "gtaxllte" "Samsung Galaxy Tab A LTE" off \
                          "gtaxlwifi" "Samsung Galaxy Tab A Wifi" off \
                          "santos10wifi" "Samsung Galaxy Tab 3" off \
                          "kminilte" "Samsung Galaxy S5 mini" off \
                          2>&1 >/dev/tty)
clear

# type
OPTIONS=(1 "rebuild"
         2 "build"
         3 "compile"
         4 "sync")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "Choose type" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

echo $CHOICE

# functions
move_zips () {
    mv $1/out/target/product/$2/*.zip* $ZIPPATH
}

print_status () {
    #echo $2 | mail -s "$2 build done!" $BUILD_DONE_EMAIL
    echo "============================================"
    cat $1/build/core/version_defaults.mk | grep "PLATFORM_SECURITY_PATCH :="
    cat $1/out/target/product/$2/obj/KERNEL_OBJ/include/config/kernel.release
    ls -lh $1/out/target/product/$2/kernel
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
        "kminilte" )
            DEVPATH="/mnt/Android/kminilte"
            ;;
        * )
            echo "Canceled [$DEVICES]"
            exit
            ;;
    esac

    case $CHOICE in
        1)
            echo $DEVICES: "rebuild"
            repo_clear $DEVPATH $DEVICES
            repo_sync $DEVPATH $DEVICES
            repo_build $DEVPATH $DEVICES
            print_status $DEVPATH $DEVICES
            move_zips $DEVPATH $DEVICES
            ;;
        2)
            echo $DEVICES: "build"
            repo_sync $DEVPATH $DEVICES
            repo_build $DEVPATH $DEVICES
            print_status $DEVPATH $DEVICES
            move_zips $DEVPATH $DEVICES
            ;;
        3)
            echo $DEVICES: "compile"
            repo_build $DEVPATH $DEVICES
            print_status $DEVPATH $DEVICES
            move_zips $DEVPATH $DEVICES
            ;;
        4)
            echo $DEVICES: "sync"
            repo_sync $DEVPATH $DEVICES
            print_status $DEVPATH $DEVICES
            ;;
        *)
            echo "Canceled [$CHOICE]"
            exit
            ;;
    esac
done
