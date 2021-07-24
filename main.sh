USERNAME=${1:-"qiangzibro"}
NUMBER_COMPUTERS=${2:-5}
SERVER_IPS=("10.22.148.86" "10.22.78.13")
N_SERVERS=${#SERVER_IPS[@]}

make clean
if test "$(uname)" = "Darwin";then
	gsed "s|seq.*$|seq 1 $N_SERVERS"'`|g' setup.sh
elif test "$(expr substr $(uname -s) 1 5)" = "Linux";then
	ssed "s|seq.*$|seq 1 $N_SERVERS"'`|g' setup.sh
fi

# generate config file
for j in `seq 1 $N_SERVERS`
do
	i=0
	while [[ $i -lt $NUMBER_COMPUTERS ]]
	do
		if [ $j = 0 ];then
			HOST="l${i}"
		elif [ $j = 1 ];then
			HOST="l${i}_"
		fi
		IP=${SERVER_IPS[j]}
		cat <<- EOF >> ${USERNAME}.config
		Host $HOST
		HostName $IP
		Port 610${i}
		User $USERNAME

		EOF
		i=$(expr $i + 1)
	done
done 


# generate frp software
for j in `seq 1 $N_SERVERS`
do

	IP=${SERVER_IPS[j]}
	i=0
	while [[ $i -lt $NUMBER_COMPUTERS ]]
	# for i in {0..5}
	do
		frp_dir=frp_m${i}
		frp_system=${frp_dir}/systemd/
		cp -r frp $frp_dir

		cp setup.sh ${frp_dir}


		cat <<- EOF > ${frp_dir}/frpc${j}.ini
		[common]
		server_addr = ${IP}
		server_port = 7000
		token = 1234567

		[sshM${i}${j}]
		type = tcp
		local_ip = 127.0.0.1
		local_port = 22
		remote_port = 610${i}

		[RDPM${i}${j}]
		type = tcp
		local_ip = 127.0.0.1
		local_port = 3389
		remote_port = 349${i}

		[httpM${i}${j}]
		type = tcp
		local_ip = 127.0.0.1
		local_port = 1100${i}
		remote_port = 1100${i}

		EOF

		cat <<- EOF > ${frp_system}/frpc${j}.service
		[Unit]
		Description=Frp Client Service
		After=network.target

		[Service]
		Type=simple
		User=root
		Restart=on-failure
		RestartSec=5s
		ExecStart=/usr/local/frp/frpc -c /usr/local/frp/frpc${j}.ini
		ExecReload=/usr/local/frp/frpc reload -c /usr/local/frp/frpc${j}.ini

		[Install]
		WantedBy=multi-user.target
		EOF

	i=$(expr $i + 1)
	done
done
