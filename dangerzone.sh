#!/bin/sh

#Functions
help () { #Show Help Function
    echo "dangerzone.sh - Usage Instructions...\n"
    echo "dangerzone.sh config - Configure Develpoment Enviornment"
    echo "dangerzone.sh up  - Start Development Enviornment"
}

up() { #Start Development Enviornment
    if [ ! -e "etc/dangerzone.conf" ]; then
        echo "Yo! no config file."
        echo "Run: dangerzone.sh config"
        exit 1
    fi

    GIT=`cat etc/dangerzone.conf | grep "GIT"`
    PORT=`cat etc/dangerzone.conf | grep "PORT"`
    echo"$GIT\n$PORT"
}

config() {
    #Check for Pre-Existing
    if [ -e "etc/dangerzone.conf" ]; then
        printf "Configuration File Exists... Delete (y/n)? :"
        read delete
        if [ $delete = "y" ]; then
            rm etc/dangerzone.conf
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
    printf "GIT $gitlocation\nPORT $railsPort" > etc/dangerzone.conf
    echo "Configuration Complete!"
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
elif [ "$1" = "up" ]; then
    up
elif [ "$1" = "help" ]; then
    help
fi
