#!/bin/sh

case "$1" in
'start')
	# Log to indicate (re)start
	boot=`cat /tmp/last_boot_type`
	if [ "$boot" != "-3" ]; then
		for log in `ls /log/*/current 2> /dev/null`; do echo "*** CCGX booted ($boot) ***" | tai64n >> $log; done
	fi

	# remove stale entries
	find -L /data/service -maxdepth 1 -type l -delete

	# let the enabled services auto-start
	rm -f /data/service/*/down /data/service/*/log/down

	svscanboot &
	;;
'stop')
        svc -d /service/*
        svc -d /service/*/log
        killall svscan
        killall supervise
	;;
*)
	echo "Usage: $0 { start | stop }"
	;;
esac
