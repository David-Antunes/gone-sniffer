package main

import (
	"encoding/gob"
	"fmt"
	"net"
	"os"
	"os/signal"

	"github.com/David-Antunes/gone-proxy/xdp"
	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
)

func main() {
	addrs := make(map[string]int)

  
	if len(os.Args) == 1 {
		fmt.Println("missing socket id")
		return
	}
	if len(os.Args) > 2 {
		fmt.Println("too many arguments")
		return
	}

	// Establish connection with the sniffer socket
	conn, err := net.Dial("unix", os.Args[1])

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

			if _, ok := addrs[ip.SrcIP.String()]; ok {
				addrs[ip.SrcIP.String()] += 1
			} else {
				addrs[ip.SrcIP.String()] = 1
			}
		}
	}

}
