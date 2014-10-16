#!/bin/sh
#Functions
help () { #Show Help Function
    echo "dangerzone.sh - Usage Instructions...\n"
    echo "dangerzone.sh config - Configure Develpoment Enviornment"
    echo "dangerzone.sh up  - Start Development Enviornment"
}

up() { #Start Development Enviornment

    #Pull Latest Image
    docker pull bkreisel/bazaar-nginx

    if [ ! -e "conf/dangerzone.conf" ]; then
        echo "Yo! no config file."
        echo "Run: dangerzone.sh config"
        exit 1
    fi

    GIT=`cat conf/dangerzone.conf | grep "GIT" | awk '{print $2}'`
    GIT=`eval "echo $GIT"`
    PORT=`cat conf/dangerzone.conf | grep "PORT" | awk '{print $2}'`
    PORT=`eval "echo $PORT"`

    #Check for Pre-existing enviornment
    down

    #Start the engines
    echo "docker run -d -p $PORT:80 --name hermes-nginx -v $GIT:/app"
    docker run -d -p $PORT:80 --name hermes-nginx -v $GIT:/app bkreisel/bazaar-nginx
    
    if [ $? -eq 0 ]; then
        printf "\nContainers online, you are cleared for takeoff\n"
    fi
}

down() {
    prevContain=`docker ps -a | awk '{ print $1" "$(NF) }' | grep 'hermes-nginx' | awk '{ print $(NF)}'`
    prevContainRunning=`docker ps | awk '{ print $1" "$(NF) }' | grep 'hermes-nginx' | awk '{ print $(NF) }'`
    echo "$prevContain"
    if [  -n "$prevContain" ]; then
        #check for running container
        if [  -n "$prevContainRunning" ]; then
            echo "running container found"
            docker kill $prevContainRunning
        fi
            echo "previous container found"
            docker rm $prevContain
    fi
}

config() {
    #Check for Pre-Existing
    if [ -e "conf/dangerzone.conf" ]; then
        printf "Configuration File Exists... Delete (y/n)? :"
        read delete
        if [ $delete = "y" ]; then
            rm conf/dangerzone.conf
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
    mkdir conf
    printf "GIT $gitLocation\nPORT $railsPort" > conf/dangerzone.conf
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
elif [ "$1" = "me" ]; then
    up
fi
