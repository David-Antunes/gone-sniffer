#!/bin/bash

gone-cli node -- docker run --rm -d --network gone_net --name client --hostname client nicolaka/netshoot sleep 100000
gone-cli node -- docker run --rm -d --network gone_net --name server --hostname server nicolaka/netshoot iperf3 -s

gone-cli bridge bridge1

gone-cli connect -b 10G -n client bridge1
gone-cli connect -b 10G -n server bridge1

gone-cli sniff -n client

gone-cli unpause -a

docker exec -t client iperf3 -c server | tee baseline.iperf3 



