package main

import (
	"encoding/csv"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"strconv"
	"time"
)

func main() {
	date, err := time.Parse(time.RFC3339Nano, "2021-10-29T17:00:00Z")
	if err != nil {
		panic(err)
	}
	fmt.Println("genesis time", date)

	start := date.AddDate(1, 0, 0)
	end := start.AddDate(1, 0, 0)

	csv_file, _ := os.Open("stargaze-1/accounts/accounts.csv")
	r := csv.NewReader(csv_file)
	for {
		record, err := r.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal(err)
		}
		cmd := exec.Command("starsd",
			"add-genesis-account", record[0], record[1],
			"--vesting-amount", record[1],
			"--vesting-start-time", strconv.Itoa(int(start.Unix())),
			"--vesting-end-time", strconv.Itoa(int(end.Unix())),
			"--home", "tmp/stargaze",
		)
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		err = cmd.Run()
		if err != nil {
			log.Fatal(err)
		}
	}
}
