#!/bin/bash

curl -sfL https://get.k3s.io | sh -
if [ $? -ne 0 ]; then
    echo "k3s installation failed. Exiting..."
    exit 1
fi

