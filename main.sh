USERNAME=qiangzibro
SERVER_IPS=("10.22.148.86" "10.22.78.13")

if [ -f "config" ]; then
	rm config
fi

for j in {0..1}
do

	IP=${SERVER_IPS[j]}

	for i in {0..5}
	do

		if [ $j = 0 ];then
			HOST="l${i}"
		elif [ $j = 1 ];then
			HOST="l${i}_"
		fi

		frp_dir=frp_m${i}
		frp_system=${frp_dir}/systemd/
		[[ -d $frp_dir ]] && rm -rf $frp_dir
		cp -r frp $frp_dir

		cp setup.sh ${frp_dir}


		cat <<- EOF >> config
		Host $HOST
		HostName $IP
		Port 610${i}
		User $USERNAME

		EOF

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

	done
done
