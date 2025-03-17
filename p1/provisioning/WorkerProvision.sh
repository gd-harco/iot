#!/bin/bash

echo "Testing internet connection..."
curl -s https://get.k3s.io > /dev/null
if [ $? -ne 0 ]; then
    echo "Failed to access https://get.k3s.io. Check internet connection."
    exit 1
fi

i=1
while [ $i -le 5 ]
do
	echo "testing $i"
	if test -f "/vagrant/token.txt"; then
		echo "Token found"
		break;
	fi
	sleep 5;
	i=$(( $i + 1 ))
done

if test $i -eq 5; then
	echo "token not found during the time. exiting..."
	exit 1;
fi

echo "exporting token as env variable"
export K3S_TOKEN=$(cat /vagrant/token.txt)
echo "K3S_TOKEN=$K3S_TOKEN"

echo "Running K3s installation..."
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$K3S_TOKEN sh -
if [ $? -ne 0 ]; then
    echo "k3s installation failed. Exiting..."
    exit 1
fi

echo "done"
