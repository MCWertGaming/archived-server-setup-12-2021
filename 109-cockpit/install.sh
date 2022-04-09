#!/usr/bin/env bash

dnf -y update
dnf -y install cockpit
systemctl enable --now cockpit-socket
