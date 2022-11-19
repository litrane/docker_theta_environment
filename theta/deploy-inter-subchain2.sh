#!/bin/bash

host_string=(" -p 22 pzl97@apt107.apt.emulab.net" " -p 22 pzl97@apt098.apt.emulab.net" " -p 22 pzl97@apt083.apt.emulab.net" " -p 22 pzl97@apt086.apt.emulab.net")
# host_string=(" root@10.10.1.9" " root@10.10.1.10" " root@10.10.1.11" " root@10.10.1.12" )
# host_string=(" -p 2209 root@127.0.0.1" " -p 2210 root@127.0.0.1" " -p 2211 root@127.0.0.1" " -p 2212 root@127.0.0.1"  )

name="deploy-theta4"

if [ "$1" == "connect" ]; then 
  tmux new-session -s $name -d
fi 

for i in $( seq 0 `expr ${#host_string[@]} - 1 ` )

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
  tmux send -t $tmux_name "nohup ./theta-eth-rpc-adaptor start --config=./ano_thetasub_eth_rpc_adaptor  > output 2>&1 &  " Enter
  tmux send -t $tmux_name "./thetasubchainlab4 start --config=./allsubchains/DSN_360888/node${val}/ --password=qwe |& tee ~/node${val}.log" Enter
elif [ "$1" == "update" ]; then
  #tmux send -t $tmux_name "cd theta_experiment_file" Enter
  tmux send -t $tmux_name "git clean -xfd" Enter
  tmux send -t $tmux_name "git pull" Enter
elif [ "$1" == "clean" ]; then
  tmux send -t $tmux_name "cd ~" Enter
  tmux send -t $tmux_name "rm -rf docker_experiment_environent" Enter
elif [ "$1" == "locate" ]; then
  tmux send -t $tmux_name "cd ~/docker_theta_environment/theta" Enter
elif [ "$1" == "stop" ]; then
  tmux send-keys -t $tmux_name C-c
fi


  echo "start node${val}!"
  

done

