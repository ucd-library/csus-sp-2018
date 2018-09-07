#!/usr/bin/env bash
printf "Enter your 2-char identifier to configure, create, and deploy server"
printf "\n\nAvailable options:\n\tcl (Chas)\t|\tjr (James) \n\tns (Nima)\t|\teh (Ehsan) \n\ter (Eli)\t|\tdm (Derek) \n\tts (Test)\t|\tps (Production)\n"

read identifer

printf "Are you running this instance locally on your own machine or on the UC Davis Server? \nAvailable Options [U|L]:\n"

read env

if [ ${identifer} = "cl" ]; then
    USERNAME="chas_"
    PORT="4001"

elif [ ${identifer} = "jr" ]; then
    USERNAME="james_"
    PORT="4002"

elif [ ${identifer} = "ns" ]; then
    USERNAME="nima_"
    PORT="4003"

elif [ ${identifer} = "eh" ]; then
    USERNAME="ehsan_"
    PORT="4004"

elif [ ${identifer} = "er" ]; then
    USERNAME="eli_"
    PORT="4005"

elif [ ${identifer} = "dm" ]; then
    USERNAME="derek_"
    PORT="4006"

elif [ ${identifer} = "ts" ]; then
    USERNAME="test_"
    PORT="4007"

elif [ ${identifer} = "ps" ]; then
    USERNAME="production_"
    PORT="4008"

else
    printf "Error: Option Identifier Not Valid. Aborting"
    exit 1
fi

if [ ${env} = "U" ]; then
    printf "You have chosen to create an instance on UC Davis Server. Using assigned settings.\n"
    FIN_URL="http://p$PORT.csus.casil.ucdavis.edu"

elif [ ${env} = "L" ]; then
    printf "You have chosen to create an instance locally. \nWhat port do you want to run it on?\n"
    read LOCALPORT
    FIN_URL="http://localhost:$LOCALPORT"

 else
    printf "Error Instance Identifier Not Valid. Aborting"
    exit 1

fi


export FIN_URL=$FIN_URL
export USERNAME=$USERNAME
export PORT=$PORT


docker-compose -f docker_compose.yml up -d

printf "Running at $FIN_URL"

