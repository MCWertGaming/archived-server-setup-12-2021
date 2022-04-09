#!/usr/bin/env bash

# prepare pacman
pacman-key --init
pacman-key --populate archlinux
echo "#Server = https://nexus.lcl.leven.dev/repository/arch-proxy/\$repo/os/\$arch
Server = https://mirror.mikrogravitation.org/archlinux/\$repo/os/\$arch
Server = https://de.arch.mirror.kescher.at/\$repo/os/\$arch
Server = https://mirrors.niyawe.de/archlinux/\$repo/os/\$arch
Server = https://archlinux.thaller.ws/\$repo/os/\$arch
Server = https://mirror.dogado.de/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
# trust root cert
echo "-----BEGIN CERTIFICATE-----
MIIBnzCCAUWgAwIBAgIQMHrgJwVSnPX2NWIMugjiBDAKBggqhkjOPQQDAjAuMREw
DwYDVQQKEwhsZXZlbmxhYjEZMBcGA1UEAxMQbGV2ZW5sYWIgUm9vdCBDQTAeFw0y
MjAyMDIxOTQ1MDhaFw0zMjAxMzExOTQ1MDhaMC4xETAPBgNVBAoTCGxldmVubGFi
MRkwFwYDVQQDExBsZXZlbmxhYiBSb290IENBMFkwEwYHKoZIzj0CAQYIKoZIzj0D
AQcDQgAEiRW80tOxM1HGS5nzO4sXIngrl80SSnXM1/p+8dIp5xI7Vyet5znjp9h0
WdHVjZgh5tSOs0bW/sLsy01QCJ1oo6NFMEMwDgYDVR0PAQH/BAQDAgEGMBIGA1Ud
EwEB/wQIMAYBAf8CAQEwHQYDVR0OBBYEFGXKZMGXQI/fXewUy1ermk1evH8ZMAoG
CCqGSM49BAMCA0gAMEUCIB9KsTM7SlJyGzuEDsz/5i2ueqpq0UlDq5uJUwRWAv7l
AiEAz4le4W7rv69Jmma6OIS6MrJ3YKqsFAlESQmLvuE3IY8=
-----END CERTIFICATE-----" > root.cert
trust anchor root.cert
rm root.cert
# update keyring
pacman -Sy archlinux-keyring
# install docker
pacman -Syu --needed --noconfirm docker docker-compose
systemctl enable docker --now
# create systemd service
echo "[Unit]
Description=docker-compose service
Requires=docker.service
After=docker.service

[Service]
WorkingDirectory=/opt/compose
ExecStartPre=-/usr/bin/docker compose down
ExecStartPre=-/usr/bin/docker compose rm
ExecStartPre=-/usr/bin/docker compose pull
ExecStart=/usr/bin/docker compose up --remove-orphans
ExecStop=/usr/bin/docker compose down

[Install]
WantedBy=multi-user.target" > /usr/lib/systemd/system/docker-compose.service
# prepare compose
mkdir /opt/compose/
cd /opt/compose/

# TODO: clone compose from git
# TODO: copy and enable compose service from git
# cp docker-compose /usr/lib/systemd/system/
