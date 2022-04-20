# rocket.chat docker compose

```yml

version: '2'

services:

rocketchat:

image: rocketchat/rocket.chat:latest

command: >

bash -c

"for i in `seq 1 30`; do

node main.js &&

s=$$? && break || s=$$?;

echo \\"Tried $$i times. Waiting 5 secs...\\";

sleep 5;

done; (exit $$s)"

restart: unless-stopped

volumes:

- ./uploads:/app/uploads

environment:

- PORT=3000

- ROOT_URL=http://10.10.11.108:3000

- MONGO_URL=mongodb://rocketchatUser:123@10.10.11.107:27017/rocketchat?authSource=serviceUser&replicaSet=rs01

- MONGO_OPLOG_URL=mongodb://rocketchatUser:123@10.10.11.107:27017/local?authSource=serviceUser&replicaSet=rs01

- USE_NATIVE_OPLOG=true

# - MAIL_URL=smtp://smtp.email

ports:

- 3000:3000

labels:

- "traefik.backend=rocketchat"

- "traefik.frontend.rule=Host: rocketchat.l-its.de"

- traefik.http.routers.my-container.rule=Host(`l-its.de`)

# hubot, the popular chatbot (add the bot user first and change the password before starting this image)

hubot:

image: rocketchat/hubot-rocketchat:latest

restart: unless-stopped

environment:

- ROCKETCHAT_URL=rocketchat:3000

- ROCKETCHAT_ROOM=GENERAL

- ROCKETCHAT_USER=bot

- ROCKETCHAT_PASSWORD=botpassword

- BOT_NAME=Bot

# you can add more scripts as you'd like here, they need to be installable by npm

- EXTERNAL_SCRIPTS=hubot-help,hubot-seen,hubot-links,hubot-diagnostics

depends_on:

- rocketchat

labels:

- "traefik.enable=false"

volumes:

- ./scripts:/home/hubot/scripts

# this is used to expose the hubot port for notifications on the host on port 3001, e.g. for hubot-jenkins-notifier

ports:

- 3001:8080

traefik:

image: traefik:latest

restart: unless-stopped

command: >

traefik

--docker

--acme=false

#--acme.domains='l-its.de'

#--acme.email='mcwertgaming@l-its.de'

#--acme.entrypoint=https

#--acme.storagefile=acme.json

--defaultentrypoints=http

--defaultentrypoints=https

--entryPoints='Name:http Address::80 Redirect.EntryPoint:https'

--entryPoints='Name:https Address::443'

ports:

- 80:80

- 443:443

volumes:

- /var/run/docker.sock:/var/run/docker.sock

```
