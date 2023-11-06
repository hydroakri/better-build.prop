#!/system/bin/sh
while :; do
    cmd package bg-dexopt-job
    cmd package compile -m everything -a
    sleep 1d
done
