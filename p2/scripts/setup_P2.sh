#!/bin/bash

echo "Launching Vagrant"

vagrant up

echo "Setting up host file"

echo "Updating /etc/hosts file..."
declare -i app_nb=1
while [ $app_nb != 4 ]
do
	if ! grep -q "192.168.56.110 app$app_nb.com" /etc/hosts; then
		echo "Adding entry to /etc/hosts"
		echo "192.168.56.110 app$app_nb.com" | sudo tee -a /etc/hosts
	else
		:
		echo "Entry already exists in /etc/hosts, skipping..."
	fi
	app_nb+=1
done
