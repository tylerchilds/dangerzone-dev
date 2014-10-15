#!/bin/sh


#Functions

help () { #Show Help Function
    echo "dangerzone.sh - Usage Instructions...\n"
    echo "dangerzone.sh config - Configure Develpoment Enviornment"
    echo "dangerzone.sh up  - Start Development Enviornment"
}

up() { #Start Development Enviornment
    echo ""
}

config() {
    #Check for Pre-Existing
    if [ -e "dangerzone.conf" ]; then
        printf "Configuration File Exists... Delete (y/n)? :"
        read delete
        if [ $delete = "y" ]; then
            rm dangerzone.conf
        else
            echo "Nevermind then....exiting"
            exit 1
        fi
    fi
    echo "Please Enter your git repository location:"
    read gitLocation
    echo "Gratzi...."

    printf "Please enter your desired port for the rails app:"
    read railsPort
    echo "Merci...."

    printf "GIT $gitlocation\nPORT $railsPort" > dangerzone.conf
}



#Do Work
if [ $# -eq 0 ]; then
    echo "No Arguments Supplied ..."
    help
    exit 1
fi

if [ $# -gt 1 ];then
    echo "Whoa there cowboy... (Too Many Arguments)"
    help
    exit 1
fi

if [ "$1" = "config" ]; then
    config
fi
