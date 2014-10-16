#!/bin/sh

#Functions
help () { #Show Help Function
    echo "dangerzone.sh - Usage Instructions...\n"
    echo "dangerzone.sh config - Configure Develpoment Enviornment"
    echo "dangerzone.sh up  - Start Development Enviornment"
}

up() { #Start Development Enviornment

    #Pull Latest Image
    sudo docker pull bkreisel/bazaar-nginx
    if [ ! -e "etc/dangerzone.conf" ]; then
        echo "Yo! no config file."
        echo "Run: dangerzone.sh config"
        exit 1
    fi

    GIT=`cat etc/dangerzone.conf | grep "GIT" | awk '{print $2}'`
    GIT=`eval "echo $GIT"`
    PORT=`cat etc/dangerzone.conf | grep "PORT" | awk '{print $2}'`
    PORT=`eval "echo $PORT"`

    #Check for Pre-existing enviornment
    down

    #Start the engines
    echo "docker run -d -p $PORT:80 --name hermes-nginx -v $GIT:/app"
    sudo docker run -d -p $PORT:80 --name hermes-nginx -v $GIT:/app bkreisel/bazaar-nginx
    echo "Containers online, you are cleared for takeoff"
}

down() {
    prevContain=`sudo docker ps -a | awk '{ print $1" "$(NF) }' | grep 'hermes-nginx' | awk '{ print $(NF)}'`
    prevContainRunning=`sudo docker ps | awk '{ print $1" "$(NF) }' | grep 'hermes-nginx' | awk '{ print $(NF) }'`
    if [  -n "$prevContainID" ]; then
        #check for running container
        if [  -n "$prevContainRunning" ]; then
            echo "running container found"
            sudo docker kill $prevContainRunning
        fi
            echo "previous container found"
            sudo docker rm $prevContain
    fi
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
    printf "GIT $gitLocation\nPORT $railsPort" > etc/dangerzone.conf
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
elif [ "$1" = "down" ]; then
    down
    echo "Containers shipped to a far away port"
fi
