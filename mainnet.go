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
		vestingAmount := sdk.NewCoin(denom, amount)
		accountBalance := vestingAmount.Add(sdk.NewInt64Coin(denom, 1_000_000))

		address := record[0]
		total = total.Add(accountBalance)
		totalVesting = totalVesting.Add(vestingAmount)
		cmd := exec.Command("starsd",
			"add-genesis-account", address, accountBalance.String(),
			"--vesting-amount", vestingAmount.String(),
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
	// 50M stars
	valAllocation := sdk.NewInt(50_000_000_000_000)
	if total.Amount.Sub(sdk.NewInt(100_000_000_000_000)).GT(valAllocation) {
		panic("failed allocation check")
	}
	fmt.Println("---partial---")
	fmt.Println("partial total", total.Amount.Quo(sdk.NewInt(1_000_000)).String())
	fmt.Println("total vesting", totalVesting.Amount.Quo(sdk.NewInt(1_000_000)).String())
	fmt.Println("diff", total.Sub(totalVesting).Amount.Quo(sdk.NewInt(1_000_000)).String())

	accs := []struct {
		address string
		amount  sdk.Coin
	}{
		{
			"stars13nh557xzyfdm6csyp0xslu939l753sdlgdc2q0",
			sdk.NewInt64Coin(denom, 200_000_000_000_000),
		},
		{
			"stars1xqz6xujjyz0r9uzn7srasle5uynmpa0zkjr5l8",
			sdk.NewInt64Coin(denom, 402_013_846_966_397),
		},
		{
			"stars1yu27wfrxffktuuj0za407tfs3eahjpeqctk65g",
			sdk.NewInt64Coin(denom, 1_000_000_000_000),
		},
	}
	for _, a := range accs {
		cmd := exec.Command("starsd",
			"add-genesis-account", a.address, a.amount.String(),
			"--home", "tmp/stargaze",
		)
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		err = cmd.Run()
		if err != nil {
			log.Fatal(err)
		}
		total = total.Add(a.amount)
	}
	fmt.Println("--Supply--")
	fmt.Println("total vesting", totalVesting.Amount.Quo(sdk.NewInt(1_000_000)).String())
	fmt.Println("total", total.Amount.Quo(sdk.NewInt(1_000_000)).String())

}
