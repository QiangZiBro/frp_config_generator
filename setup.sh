#!/bin/bash
set -ex

HOSTNAME=`hostname`
USER=`whoami`
# TODO: this should use relative path
frp_dir="/home/${USER}/frp_m${HOSTNAME: -1}"

if [ -d "/usr/local/frp_m${HOSTNAME: -1}" ];then
	sudo rm -rf "/usr/local/frp_m${HOSTNAME: -1}"
fi
sudo cp -r ${frp_dir} /usr/local

cd /usr/local
sudo rm -rf frp
sudo ln -s "frp_m"${HOSTNAME: -1}  frp

for i in {0..1}
do
	sudo cp /usr/local/frp/systemd/frpc${i}.service /lib/systemd/system/
	sudo systemctl enable frpc${i}.service
	sudo systemctl start frpc${i}.service
	sudo systemctl restart frpc${i}.service

done
