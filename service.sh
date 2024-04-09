#!/system/bin/sh
sleep 100
for cpu in /sys/devices/system/cpu/cpu*/; do
    echo conservative > "$cpu/cpufreq/scaling_governor"
done
echo simple_ondemand > /sys/kernel/gpu/gpu_governor
hour=$(date +'%H')
while :; do
    if [ $hour -eq 04 ]; then
        # device_config put activity_manager_native_boot use_freezer true
        device_config put activity_manager_native_boot freeze_debounce_timeout 5000
        cmd package bg-dexopt-job
        cmd package compile -m everything -a
        break
    fi
    sleep 3600
done
