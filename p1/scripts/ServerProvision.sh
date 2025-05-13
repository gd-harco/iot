#!/bin/bash

curl -sfL https://get.k3s.io | sh -
if [ $? -ne 0 ]; then
    echo "k3s installation failed. Exiting..."
    exit 1
fi

# put token in token.txt in /vagrant
sudo cat /var/lib/rancher/k3s/server/token > /vagrant/token.txt
sudo chmod o+r /vagrant/token.txt

sudo chmod 644 /etc/rancher/k3s/k3s.yaml
