#!/bin/bash

perf record --event=$1 --count=$2 -a -g --pid=$3 --all-user --call-graph=fp -o $4 sleep $5
