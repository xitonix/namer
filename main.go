package main

import (
	"fmt"
	"time"

	"github.com/brianvoe/gofakeit/v5"
)

func main() {
	gofakeit.Seed(time.Now().UnixNano())
	fmt.Println(gofakeit.Name())
}
