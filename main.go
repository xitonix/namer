package main

import (
	"flag"
	"fmt"
	"time"

	"github.com/brianvoe/gofakeit/v5"
)

// Version build flags
var (
	version    string
	commit     string
	runtimeVer string
	built      string
)

func main() {
	showVersion := flag.Bool("v", false, "Shows the version")
	flag.Parse()
	if *showVersion {
		fmt.Printf("namer %s (%s) runtime: %s on %s\n", version, commit, runtimeVer, built)
		return
	}
	gofakeit.Seed(time.Now().UnixNano())
	fmt.Println(gofakeit.Name())
}
