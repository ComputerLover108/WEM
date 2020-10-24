#!/bin/sh
apt install docker.io
usermod -aG docker ${USER}
