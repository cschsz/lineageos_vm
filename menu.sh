#!/bin/bash
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=5
BACKTITLE="LineageOS"
TITLE="Compiling"
MPATH=""

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
            MPATH="/mnt/VMsA/gtaxl"
            ;;
        2)
            TITLE="gtaxlwifi"
            MPATH="/mnt/VMsA/gtaxl"
            ;;
        3)
            TITLE="santos10wifi"
            MPATH="/mnt/VMsA/santos10"
            ;;
        4)
            TITLE="kminilte"
            MPATH="/mnt/VMsA/kminilte"
            ;;
        *)
            echo "Canceled"
            exit
esac

# type
OPTIONS=(1 "full build with make clean"
         2 "full build with repo sync"
         3 "just compile"
         4 "just sync")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "Choose type" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

# sure
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
print_status () {
    #echo $2 | mail -s "$2 build done!" $BUILD_DONE_EMAIL
    echo "============================================"
    cat $1/build/core/version_defaults.mk | grep "PLATFORM_SECURITY_PATCH :="
    cat $1/out/target/product/$2/obj/KERNEL_OBJ/include/config/kernel.release
}

repo_sync () {
    cd $1
    repo sync --force-sync
    if [ $2 == "kminilte" ]
    then
        echo cd $1/device/samsung/smdk3470-common/patch
        echo ./apply.sh
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
    echo make clean
}

clear
case $CHOICE in
    1)
        echo $TITLE: "full build with make clean"
        repo_clear $MPATH $TITLE
        repo_sync $MPATH $TITLE
        repo_build $MPATH $TITLE            
        print_status $MPATH $TITLE
        ;;
    2)
        echo $TITLE: "full build with repo sync"
        repo_sync $MPATH $TITLE
        repo_build $MPATH $TITLE            
        print_status $MPATH $TITLE
        ;;
    3)
        echo $TITLE: "just compile"
        repo_build $MPATH $TITLE
        print_status $MPATH $TITLE
        ;;
    4)
        echo $TITLE: "just sync"
        repo_sync $MPATH $TITLE
        print_status $MPATH $TITLE
        ;;
    *)
        echo "Canceled"
        exit
esac
