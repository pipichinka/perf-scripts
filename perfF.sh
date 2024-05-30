#!/bin/bash

perf record -F 997 -a -g --pid=$1 --all-user --call-graph=fp -o $2 sleep $3