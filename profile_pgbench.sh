#!/bin/bash

setsid ./profile_perf_L1.sh L1-dcache-load-misses 10 $1 perf_savepoint_L1-lm.out 6 >./logfile0 2>&1 < /dev/null &

 sleep 1
/usr/local/pgsql/bin/pgbench -f script_savepoint postgres  -s 20 -T 5

echo L1-lm

setsid ./profile_perf_L1.sh l2_rqsts.miss 5 $1 perf_savepoint_L2-all.out 6 >./logfile2 2>&1 < /dev/null &

 sleep 1
/usr/local/pgsql/bin/pgbench -f script_savepoint postgres  -s 20 -T 5

echo L2-all

setsid ./profile_perf_L1.sh LLC-store-misses 1 $1 perf_savepoint_L3-lm.out 6 >./logfile3 2>&1 < /dev/null &

 sleep 1
/usr/local/pgsql/bin/pgbench -f script_savepoint postgres  -s 20 -T 5

echo L3-lm

setsid ./profile_perf_L1.sh LLC-load-misses 1 $1 perf_savepoint_L3-sm.out 6 >./logfile4 2>&1 < /dev/null &

 sleep 1
/usr/local/pgsql/bin/pgbench -f script_savepoint postgres  -s 20 -T 5

echo L3-sm


perf script -i perf_savepoint_L1-lm.out --header --fields comm,pid,tid,time,event,ip,sym,dso | ../FlameGraph/stackcollapse-perf.pl -> perf_savepoint_L1-lm.perf_out
echo script1
perf script -i perf_savepoint_L2-all.out --header --fields comm,pid,tid,time,event,ip,sym,dso | ../FlameGraph/stackcollapse-perf.pl -> perf_savepoint_L2-all.perf_out
echo script3
perf script -i perf_savepoint_L3-lm.out --header --fields comm,pid,tid,time,event,ip,sym,dso | ../FlameGraph/stackcollapse-perf.pl -> perf_savepoint_L3-lm.perf_out
echo script4
perf script -i perf_savepoint_L3-sm.out --header --fields comm,pid,tid,time,event,ip,sym,dso | ../FlameGraph/stackcollapse-perf.pl -> perf_savepoint_L3-sm.perf_out
echo script5
../FlameGraph/flamegraph.pl perf_savepoint_L1-lm.perf_out > perf_L1-lm.svg
../FlameGraph/flamegraph.pl perf_savepoint_L2-all.perf_out > perf_L2-all.svg
../FlameGraph/flamegraph.pl perf_savepoint_L3-lm.perf_out > perf_L3-lm.svg
../FlameGraph/flamegraph.pl perf_savepoint_L3-sm.perf_out > perf_L3-sm.svg

rm perf_savepoint*

echo done