# FCG: Frp Config Generator
> Note: This repo is in its original developing version, but could be used for your requirments

What to do if you have multi computers waiting for setup proxy? This script generate what you need!

It setups three configurations:
- ssh
- desktop
- http

and generate connect file for you

# Usage
Assume your name's qiangzibro, generate for 10 machines
```bash
bash main.sh 'qiangzibro' 10
```

Then you get `frp_*` and `qiangzibro.config`, move config file to `~/.ssh`
```bash
mv qiangzibro.config ~/.ssh
```

Enjoy! :beer::beer:
