# Ping

Simple ping setup where a network of 10 pings are made.

The objective of this experiment is to show the capabilities of the sniffing feature in GONE.

The experiment will sniff packets from the ping-1 container and count the number of messages received from all the other containers.

To run this experiment all you need to do is to execute the `ping.sh` script.

```bash
./ping.sh
```

After that you execute the program at the parent folder of the repository as follows:

```bash
cd ..
sudo go run main.go /tmp/link1.sniff | tcpdump -r -
```

