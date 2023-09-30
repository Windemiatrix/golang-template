package main

import (
	"log"
	"os"

	"github.com/Windemiatrix/golang-template/internal/config"
)

func main() {
	if err := run(); err != nil {
		log.Fatal(err)
	}
	os.Exit(0)
}

func run() error {
	// read config from env
	_ = config.Read()

	return nil
}
