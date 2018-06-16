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
DEVPATH=""

# device
OPTIONS=(1 "gtaxllte"
         2 "gtaxlwifi"
         3 "santos10wifi"
         4 "kminilte")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "Choose device" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            TITLE="gtaxllte"
            DEVPATH="/mnt/Android/gtaxl"
            ;;
        2)
            TITLE="gtaxlwifi"
            DEVPATH="/mnt/Android/gtaxl"
            ;;
        3)
            TITLE="santos10wifi"
            DEVPATH="/mnt/Android/santos10"
            ;;
        4)
            TITLE="kminilte"
            DEVPATH="/mnt/Android/kminilte"
            ;;
        *)
            echo "Canceled"
            exit
esac

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

# start
dialog --clear \
       --backtitle "$BACKTITLE" \
       --title "Sure" \
       --yesno "Start $TITLE?" 7 60 \
       2>&1 >/dev/tty
YESNO=$?
clear
case $YESNO in
    0)
        echo "Running..."
        ;;
    *)
        echo "Canceled"
        exit
        ;;
esac

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
    cd $1
    repo sync --force-sync
    if [ $2 == "kminilte" ]
    then
        cd $1/device/samsung/smdk3470-common/patch
        ./apply.sh
    fi
}

repo_build () {
    cd $1
    . build/envsetup.sh
    breakfast $2
    brunch $2
}

repo_clear () {
    cd $1
    make clobber
}

clear
case $CHOICE in
    1)
        echo $TITLE: "rebuild"
        repo_clear $DEVPATH $TITLE
        repo_sync $DEVPATH $TITLE
        repo_build $DEVPATH $TITLE
        print_status $DEVPATH $TITLE
        move_zips $DEVPATH $TITLE
        ;;
    2)
        echo $TITLE: "build"
        repo_sync $DEVPATH $TITLE
        repo_build $DEVPATH $TITLE
        print_status $DEVPATH $TITLE
        move_zips $DEVPATH $TITLE
        ;;
    3)
        echo $TITLE: "compile"
        repo_build $DEVPATH $TITLE
        print_status $DEVPATH $TITLE
        move_zips $DEVPATH $TITLE
        ;;
    4)
        echo $TITLE: "sync"
        repo_sync $DEVPATH $TITLE
        print_status $DEVPATH $TITLE
        ;;
    *)
        echo "Canceled"
        exit
esac

read -p "Press any key..."
