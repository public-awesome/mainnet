#!/bin/bash

GENESIS_TIME=2021-10-29T17:00:00Z
START_TIME=$(TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" ${GENESIS_TIME:0:19} +%s)
ONE_YEAR=$((3600 * 24 * 365))

vesting_start_time=$(($START_TIME + $ONE_YEAR))
vesting_end_time=$(($vesting_start_time + $ONE_YEAR))

starsd add-genesis-account stars1xuuv5vucu9h74svhma4ykfvjzu4j0rxrsn0yfk 199000000000000ustars
starsd add-genesis-account stars1mxynx2ay7kxuu6vsu8ruy7pwgmsvz93atfj7nu 1000000000000ustars

starsd add-genesis-account stars15zx6hhjcnnnwt3nlf49gae3dd5n4vkjxef6gq2 40000000000000ustars \
    --vesting-amount 40000000000000ustars \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time
starsd add-genesis-account stars1s4ckh9405q0a3jhkwx9wkf9hsjh66nmuu53dwe 30000000000000ustars \
    --vesting-amount 30000000000000ustars \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time
starsd add-genesis-account stars1g457jcltvqdpt50ysq8fe2e7hwtnmnlmc2mkht 30000000000000ustars \
    --vesting-amount 30000000000000ustars \
    --vesting-start-time $vesting_start_time \
    --vesting-end-time $vesting_end_time
