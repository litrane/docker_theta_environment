#!/bin/bash

host_string=(" -p 22 pzl97@apt137.apt.emulab.net" " -p 22 pzl97@apt161.apt.emulab.net" " -p 22 pzl97@apt144.apt.emulab.net" " -p 22 pzl97@apt157.apt.emulab.net")
# host_string=(" root@10.10.1.1" " root@10.10.1.2" " root@10.10.1.3" " root@10.10.1.4" )
# host_string=(" -p 2201 root@127.0.0.1" " -p 2202 root@127.0.0.1" " -p 2203 root@127.0.0.1" " -p 2204 root@127.0.0.1"  )
name="deploy-theta1"

if [ "$1" == "connect" ]; then 
  tmux new-session -s $name -d
fi 

for i in $( seq 0  `expr ${#host_string[@]} - 1` )

do
  val=`expr $i + 1`
  tmux_name="$name:$i"
  #tmux neww -a -n "$client" -t $name
  if [ "$1" == "connect" ]; then 
  tmux new-window -n "$i" -t "$name" -d
  tmux send -t $tmux_name "ssh ${host_string[i]}" Enter
elif [ "$1" == "init" ]; then
  tmux send -t $tmux_name "git clone -b lab34 https://github.com/litrane/docker_theta_environment.git" Enter
  tmux send -t $tmux_name "cd docker_theta_environment" Enter
  #tmux send -t $tmux_name "nohup ./earthd start --home=./workspace/earth/validator${i} > output 2>&1 & " Enter
elif [ "$1" == "start" ]; then
  tmux send -t $tmux_name "cd theta" Enter
  tmux send -t $tmux_name "nohup ./theta-eth-rpc-adaptor start --config=./eth_rpc_adaptor  > output 2>&1 &  " Enter
  tmux send -t $tmux_name "./theta start --config=./lab34/node${val}/ --password=qwertyuiop " Enter
elif [ "$1" == "update" ]; then
  #tmux send -t $tmux_name "cd theta_experiment_file" Enter
  tmux send -t $tmux_name "git clean -xfd" Enter
  tmux send -t $tmux_name "git pull" Enter
elif [ "$1" == "clean" ]; then
  tmux send -t $tmux_name "cd ~" Enter
  tmux send -t $tmux_name "rm -rf docker_theta_environment" Enter
elif [ "$1" == "stop" ]; then
  tmux send-keys -t $tmux_name C-c
elif [ "$1" == "lsof" ]; then
  tmux send -t $tmux_name "lsof -i:16888" Enter
elif [ "$1" == "locate" ]; then
  tmux send -t $tmux_name "cd ~/docker_theta_environment/theta" Enter
elif [ "$1" == "reset" ]; then
  tmux send -t $tmux_name "rm -rf ./lab34/node${val}/db" Enter
  tmux send -t $tmux_name "cp -rf ./db_bak ./lab34/node${val}/db" Enter
elif [ "$1" == "copy" ]; then
  tmux send -t $tmux_name "cp -rf ./lab34/node${val}/db ./db_bak " Enter
fi

  echo "start node${val}!"
  

done

