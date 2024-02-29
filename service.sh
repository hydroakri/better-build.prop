#!/system/bin/sh
hour=$(date +'%H')
while :; do
    if [ $hour -eq 04 ]; then
        cmd package bg-dexopt-job
        cmd package compile -m everything -a
        break
    fi
    sleep 3600
done
