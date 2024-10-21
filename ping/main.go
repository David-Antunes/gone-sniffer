package main

import (
	"encoding/gob"
	"fmt"
	"net"
	"os"
	"os/signal"
	"time"

	"github.com/David-Antunes/gone-proxy/xdp"
	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
)

func main() {
	addrs := make(map[string]int)

	// Establish connection with the sniffer socket
	conn, err := net.Dial("unix", "/tmp/ping-1.sniff")

	if err != nil {
		panic(err)
	}
	// Convert connection to a gob decoder to simplify data parsing
	dec := gob.NewDecoder(conn)

	// Setup routine to handle CTRL+C interruption
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	go func() {
		<-c
		fmt.Println("Counters:")
		for key, value := range addrs {
			fmt.Println(key, value)
		}
		os.Exit(0)
	}()
	// Print statistics
	go func() {
		for {

			time.Sleep(10 * time.Second)
			for key, value := range addrs {
				fmt.Println(key, value)
			}
			fmt.Println()
		}
	}()

	fmt.Println("Started Sniffing...")
	for {
		var frame *xdp.Frame

		err := dec.Decode(&frame)
		if err != nil {
			panic(err)
		}

		packet := gopacket.NewPacket(frame.FramePointer, layers.LinkTypeEthernet, gopacket.NoCopy)

		if ipLayer := packet.Layer(layers.LayerTypeIPv4); ipLayer != nil {
			ip := ipLayer.(*layers.IPv4)

			// Setup assumes that the first container has a defined ip
			// If you want to not have a defined ip you just have to
			// run the docker inspect command and discover the important
			// ip address.
			if ip.SrcIP.String() == "10.1.0.100" {
				continue
			}
			if _, ok := addrs[ip.SrcIP.String()]; ok {
				addrs[ip.SrcIP.String()] += 1
			} else {
				addrs[ip.SrcIP.String()] = 1
			}
		}
	}

}
