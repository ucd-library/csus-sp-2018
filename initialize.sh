#! /bin/bash

user=admin
email=admin@example.org
dc='docker-compose -f fin-example.yml -p fin'

${dc} exec basic-auth node service/cli create-user -u $user -p laxlax -e $email

${dc} exec server node app/cli admin add-admin -u ${user}@local

# Mint a token
source fin-example.env; fin jwt encode --admin --save=true $JWT_SECRET $JWT_ISSUER ${user}@local

fin http put -H prefer:return=minimal -H "Content-Type:text/turtle" -@ server.ttl -P h /
fin http get -P b /
