#!/bin/bash

echo "sudo chmod 644 /etc/rancher/k3s/k3s.yaml" >> /home/vagrant/.bashrc

echo "alias k=kubectl" >>/home/vagrant/.bashrc
