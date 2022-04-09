#!/usr/bin/env bash

dnf update -y
dnf install cockpit -y
systemctl enable cockpit.socket
