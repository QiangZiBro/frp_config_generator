# FCG: Frp Config Generator
> Note: This repo is in its original developing version, but could be used for your requirments

What to do if you have multi computers waiting for setup proxy? This script generate what you need!

It setups three configurations:
- ssh
- desktop
- http

and generate connect file for you

# Usage

Clone 

```bash
git clone https://github.com/QiangZiBro/frp_config_generator
cd frp_config_generator
```

Assume your name's `qiangzibro`, generate for 10 machines
```bash
bash main.sh 'qiangzibro' 10
```
Then upload generated directories to different machines, for my name fashion, each machine can be connected using `ssh l${i}`, where`0<=i<=N`, so

```bash
for i in {0..10}
do
rsync -au frp_m$i l${i}:~ &
done
wait
```
Then enter each machine you want to setup, such as for `M1`, we can do 
```bash
ssh l1
cd ~/frp_m1
bash setup.sh
```
Finally, move config file to `~/.ssh`
```bash
mv qiangzibro.config ~/.ssh/config
```

Enjoy! :beer::beer:

# TODO
- [x] Include the `frps.ini` file for server