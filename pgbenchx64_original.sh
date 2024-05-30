#!/bin/bash

setsid ./perfF.sh  $2 perf-simple_simple-update.out 121 >./logfile0 2>&1 < /dev/null &

 sleep 1
$1 -T 120 --builtin=simple-update --protocol=simple postgres

echo simple_simple-update
sleep 2

setsid ./perfF.sh  $2 perf-prepared_simple-update.out 121 >./logfile1 2>&1 < /dev/null &

 sleep 1
$1 -T 120 --builtin=simple-update --protocol=prepared postgres

echo prepared_simple-update
sleep 2

setsid ./perfF.sh  $2 perf-simple_select-only.out 121 >./logfile1 2>&1 < /dev/null &

 sleep 1
$1 -T 120 --builtin=select-only --protocol=simple postgres

echo simple_select-only
sleep 2

setsid ./perfF.sh  $2 perf-prepared_select-only.out 121 >./logfile1 2>&1 < /dev/null &

 sleep 1
$1 -T 120 --builtin=select-only --protocol=prepared postgres

echo prepared_select-only
sleep 2


perf script -i perf-simple_simple-update.out --header --fields comm,pid,tid,time,event,ip,sym,dso > perf-simple_simple-update.out_raw
../FlameGraph/stackcollapse-perf.pl < perf-simple_simple-update.out_raw -> perf-simple_simple-update.collapse
echo script1
perf script -i perf-prepared_simple-update.out --header --fields comm,pid,tid,time,event,ip,sym,dso > perf-prepared_simple-update.out_raw
../FlameGraph/stackcollapse-perf.pl < perf-prepared_simple-update.out_raw -> perf-prepared_simple-update.collapse
echo script2
perf script -i perf-simple_select-only.out --header --fields comm,pid,tid,time,event,ip,sym,dso > perf-simple_select-only.out_raw
../FlameGraph/stackcollapse-perf.pl < perf-simple_select-only.out_raw -> perf-simple_select-only.collapse
echo script3
perf script -i perf-prepared_select-only.out --header --fields comm,pid,tid,time,event,ip,sym,dso > perf-prepared_select-only.out_raw
../FlameGraph/stackcollapse-perf.pl < perf-prepared_select-only.out_raw -> perf-prepared_select-only.collapse
echo script4


../FlameGraph/flamegraph.pl perf-simple_simple-update.collapse > perf-simple_simple-update.svg
../FlameGraph/flamegraph.pl perf-prepared_simple-update.collapse > perf-prepared_simple-update.svg
../FlameGraph/flamegraph.pl perf-simple_select-only.collapse > perf-simple_select-only.svg
../FlameGraph/flamegraph.pl perf-prepared_select-only.collapse > perf-prepared_select-only.svg