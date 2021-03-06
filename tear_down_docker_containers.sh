#!/usr/bin/env bash
printf "Enter your 2-char identifier to stop and remove containers"
printf "\n\nAvailable options:\n\tcl (Chas)\t|\tjr (James) \n\tns (Nima)\t|\teh (Ehsan) \n\ter (Eli)\t|\tdm (Derek) \n\tts (Test)\t|\tps (Production)\n"

read identifer

if [ ${identifer} = "cl" ]; then
    USERNAME="chas"
    PORT="4001"

elif [ ${identifer} = "jr" ]; then
    USERNAME="james"
    PORT="4002"

elif [ ${identifer} = "ns" ]; then
    USERNAME="nima"
    PORT="4003"

elif [ ${identifer} = "eh" ]; then
    USERNAME="ehsan"
    PORT="4004"

elif [ ${identifer} = "er" ]; then
    USERNAME="eli"
    PORT="4005"

elif [ ${identifer} = "dm" ]; then
    USERNAME="derek"
    PORT="4006"

elif [ ${identifer} = "ts" ]; then
    USERNAME="test"
    PORT="4007"

elif [ ${identifer} = "ps" ]; then
    USERNAME="production"
    PORT="4008"

else
    printf "Error: Option Identifier Not Valid. Aborting"
    exit 1
fi

export FIN_URL=$FIN_URL
export USERNAME=$USERNAME
export PORT=$PORT

docker-compose -f fin-example.yml down

