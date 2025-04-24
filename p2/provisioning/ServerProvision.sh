#!/bin/bash

export INSTALL_K3S_EXEC="server --node-external-ip=$1 --bind-address=$1 --flannel-iface=eth1"
if ! curl -sfL https://get.k3s.io | sh -; then
    echo "k3s installation failed. Exiting..."
    exit 1
fi
