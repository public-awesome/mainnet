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

	sdk "github.com/cosmos/cosmos-sdk/types"
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
	denom := "ustars"
	total := sdk.NewCoin(denom, sdk.ZeroInt())
	totalVesting := sdk.NewCoin(denom, sdk.ZeroInt())

	for {
		record, err := r.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal(err)
		}
		amount, ok := sdk.NewIntFromString(record[1])
		if !ok {
			panic(fmt.Sprintf("invalid amount %s", record[1]))
		}
		initialAmount := sdk.NewCoin(denom, amount)
		accountBalance := initialAmount.Add(sdk.NewInt64Coin(denom, 1_000_000))

		address := record[0]
		total = total.Add(accountBalance)
		totalVesting = totalVesting.Add(initialAmount)
		cmd := exec.Command("starsd",
			"add-genesis-account", address, accountBalance.String(),
			"--vesting-amount", initialAmount.String(),
			"--vesting-start-time", strconv.FormatInt(start.Unix(), 10),
			"--vesting-end-time", strconv.FormatInt(end.Unix(), 10),
			"--home", "tmp/stargaze",
		)
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		err = cmd.Run()
		if err != nil {
			log.Fatal(err)
		}
	}
	fmt.Println("total", total.Amount.Quo(sdk.NewInt(1_000_000)).String())
	fmt.Println("total vesting", totalVesting.Amount.Quo(sdk.NewInt(1_000_000)).String())
	fmt.Println("diff", total.Sub(totalVesting).Amount.Quo(sdk.NewInt(1_000_000)).String())
}
