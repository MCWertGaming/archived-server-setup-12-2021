#!/usr/bin/env bash


MC_VERSION=1.18.1
PAPER_BUILD=$(curl -s https://papermc.io/api/v2/projects/paper/versions/1.18.1 | tail -c 5 | cut -c1-3)
GRIEF_VERSION=16.18-RC1
LUCKPERMS_REL_PATH=$(curl -s https://ci.lucko.me/job/LuckPerms/lastStableBuild/api/json\?pretty=true | grep bukkit/loader | cut -d : -f 2,3 | tr -d \")

# prepare
rm -rf build/
mkdir build/
mkdir build/plugins

# download paper
wget -q https://papermc.io/api/v2/projects/paper/versions/$MC_VERSION/builds/$PAPER_BUILD/downloads/paper-$MC_VERSION-$PAPER_BUILD.jar -O build/paper.jar

# download plugins
wget -q https://github.com/TechFortress/GriefPrevention/releases/download/$GRIEF_VERSION/GriefPrevention.jar -O build/plugins/grief_prevention.jar

wget -q https://ci.lucko.me/job/LuckPerms/lastSuccessfulBuild/artifact/$LUCKPERMS_REL_PATH -O build/plugins/luckperms.jar

wget -q $(curl -s https://api.github.com/repos/jrbudda/Vivecraft_Spigot_Extensions/releases | grep Vivecraft_Spigot_Extensions.1.18 | cut -d : -f 2,3 | tr -d \" | tail -n 1) -O build/plugins/vivecraft.zip
unzip build/plugins/vivecraft.zip -d build/plugins/
rm build/plugins/vivecraft.zip

wget -q $(curl -s https://api.github.com/repos/EssentialsX/Essentials/releases | grep EssentialsX- | cut -d : -f 2,3 | tr -d \" | tail -n 1) -O build/plugins/essentialsx.jar

wget -q $(curl -s https://api.github.com/repos/EssentialsX/Essentials/releases | grep EssentialsXDiscord- | cut -d : -f 2,3 | tr -d \" | tail -n 1) -O build/plugins/essentialsx_discord.jar

wget -q $(curl -s https://api.github.com/repos/PlayPro/CoreProtect/releases | grep CoreProtect- | cut -d : -f 2,3 | tr -d \" | tail -n 1) -O build/plugins/coreprotect.jar

wget -q https://github.com/rutgerkok/BlockLocker/releases/latest/download/BlockLocker.jar -O build/plugins/blocklocker.jar
