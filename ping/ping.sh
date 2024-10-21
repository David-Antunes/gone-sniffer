#!/bin/bash

docker build -t ping .

gone-cli node -- docker run --rm -d --network gone_net --name ping-1 --hostname ping-1 --ip 10.1.0.100 ping
gone-cli node -- docker run --rm -d --network gone_net --name ping-2 --hostname ping-2 ping
gone-cli node -- docker run --rm -d --network gone_net --name ping-3 --hostname ping-3 ping
gone-cli node -- docker run --rm -d --network gone_net --name ping-4 --hostname ping-4 ping
gone-cli node -- docker run --rm -d --network gone_net --name ping-5 --hostname ping-5 ping
gone-cli node -- docker run --rm -d --network gone_net --name ping-6 --hostname ping-6 ping
gone-cli node -- docker run --rm -d --network gone_net --name ping-7 --hostname ping-7 ping
gone-cli node -- docker run --rm -d --network gone_net --name ping-8 --hostname ping-8 ping
gone-cli node -- docker run --rm -d --network gone_net --name ping-9 --hostname ping-9 ping
gone-cli node -- docker run --rm -d --network gone_net --name ping-10 --hostname ping-10 ping

gone-cli bridge bridge1
gone-cli bridge bridge2
gone-cli bridge bridge3 
gone-cli bridge bridge4
gone-cli bridge bridge5

gone-cli router router1
gone-cli router router2
gone-cli router router3

gone-cli connect -b 1G node ping-1 bridge1
gone-cli connect -b 1G node ping-2 bridge1

gone-cli connect -b 1G node ping-3 bridge2
gone-cli connect -b 1G node ping-4 bridge2

gone-cli connect -b 1G node ping-5 bridge3
gone-cli connect -b 1G node ping-6 bridge3

gone-cli connect -b 1G node ping-7 bridge4
gone-cli connect -b 1G node ping-8 bridge4

gone-cli connect -b 1G node ping-9 bridge5
gone-cli connect -b 1G node ping-10 bridge5

gone-cli connect -b 1G bridge bridge1 router1
gone-cli connect -b 1G bridge bridge2 router1

gone-cli connect -b 1G bridge bridge3 router2
gone-cli connect -b 1G bridge bridge4 router2

gone-cli connect -b 1G bridge bridge5 router3
gone-cli connect -b 1G router router1 router2

gone-cli connect -b 1G router router2 router3

gone-cli connect -b 1G router router3 router1

gone-cli propagate router3

gone-cli sniff -n ping-1

gone-cli unpause -a

sudo go run main.go
