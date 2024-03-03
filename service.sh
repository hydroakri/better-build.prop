#!/system/bin/sh
hour=$(date +'%H')
while :; do
    if [ $hour -eq 04 ]; then
        device_config put activity_manager_native_boot use_freezer true
        device_config put activity_manager_native_boot freeze_debounce_timeout 5000
        cmd package bg-dexopt-job
        cmd package compile -m everything -a
        break
    fi
    sleep 3600
done
