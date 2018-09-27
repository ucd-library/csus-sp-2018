#!/usr/bin/env bash
printf "Enter your 2-char identifier to configure, create, and deploy server"
printf "\n\nAvailable options:\n\tcl (Chas)\t|\tjr (James) \n\tns (Nima)\t|\teh (Ehsan) \n\ter (Eli)\t|\tdm (Derek) \n\tts (Test)\t|\tps (Production)\n"

read identifer

printf "Are you running this instance locally on your own machine or on the UC Davis Server? \nAvailable Options [U|L]:\n"

read env

printf "Please enter your email address\n"

read email

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

if [ ${env} = "U" ]; then
    printf "You have chosen to create an instance on UC Davis Server. Using assigned settings.\n"
    FIN_URL="http://p$PORT.csus.casil.ucdavis.edu"

elif [ ${env} = "L" ]; then
    printf "You have chosen to create an instance locally."

    PORT=3000
    FIN_URL="http://localhost:3000"

 else
    printf "Error Instance Identifier Not Valid. Aborting"
    exit 1

fi


export FIN_URL=$FIN_URL
export USERNAME=$USERNAME
export PORT=$PORT

sudo sysctl -w vm.max_map_count=262144


docker-compose -f fin-example.yml up -d

printf "Running at $FIN_URL\n"

USER=$USERNAME
EMAIL=$EMAIL


docker-compose -f fin-example.yml exec basic-auth node service/cli create-user -u ${USER} -p laxlax -e $EMAIL
docker-compose -f fin-example.yml exec server node app/cli admin add-admin -u ${USER}@local
source ./fin-example.env; fin jwt encode --admin --save=true $JWT_SECRET $JWT_ISSUER ${USER}@local
fin config set host $FIN_URL

#docker exec --privileged ${USERNAME}_server npm install -g nodemon
#docker exec --privileged ${USERNAME}_basic_auth npm install -g nodemon
#docker exec --privileged ${USERNAME}_ucd_library_client npm install -g nodemon

fin http put -H prefer:return=minimal -H "Content-Type:text/turtle" -@ server.ttl -P h /
fin http get -P b /
## Now import the data
sudo ./import.sh
