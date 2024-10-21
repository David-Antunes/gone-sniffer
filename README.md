# GONE-SNIFFER

Example usage of a sniffer program of a particular network setup in GONE.

This repository contains a simple program to convert the frames coming from GONE to pcap format to stdout.

All you need to do is to run the following command to see the output in tcpdump.

```bash
sudo go run main.go /tmp/<id>.sniff | tcpdump -r -
```

