#!/bin/bash

gone-cli node -- docker run --rm -d --network gone_net --name client --hostname client nicolaka/netshoot sleep 100000
gone-cli node -- docker run --rm -d --network gone_net --name server --hostname server nicolaka/netshoot iperf3 -s

gone-cli bridge bridge1

gone-cli connect -b 10G node client bridge1
gone-cli connect -b 10G node server bridge1

gone-cli sniff -n client
gone-cli sniff -n server

gone-cli unpause -a

go build main.go
./main /tmp/client.sniff > /dev/null &
pid=$!
echo $pid

./main /tmp/server.sniff > /dev/null &
pid2=$!
echo $pid2

docker exec -t client iperf3 -c server | tee overhead-2.iperf3 

kill -9 $pid
kill -9 $pid2


