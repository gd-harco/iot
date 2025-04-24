#!/bin/bash

if ! curl -sfL https://get.k3s.io | sh -; then
    echo "k3s installation failed. Exiting..."
    exit 1
fi
