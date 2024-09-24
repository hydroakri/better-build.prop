#!/system/bin/sh
sleep 100

for cpu in /sys/devices/system/cpu/cpu*/; do
    echo schedutil > "$cpu/cpufreq/scaling_governor"
done
echo simple_ondemand > /sys/kernel/gpu/gpu_governor

hour=$(date +'%H')
while :; do
    if [ $hour -eq 04 ]; then
        cmd package bg-dexopt-job
        cmd package compile -m everything -a
        break
    fi

    settings delete global battery_saver_constants
    settings put global battery_saver_constants "advertise_is_enabled=true,enable_datasaver=false,enable_night_mode=false,disable_launch_boost=true,disable_vibration=false,disable_animation=false,disable_soundtrigger=false,defer_full_backup=false,defer_keyvalue_backup=false,enable_firewall=true,location_mode=4,enable_brightness_adjustment=true,adjust_brightness_factor=0.8,force_all_apps_standby=true,force_background_check=true,disable_optional_sensors=true,disable_aod=false,enable_quick_doze=true"
    # device_idle_constants is only aviliable under Android 11
    settings delete global device_idle_constants
    settings put global device_idle_constants "inactive_to=30000,sensing_to=0,locating_to=0,location_accuracy=20.0,motion_inactive_to=0,idle_after_inactive_to=0,idle_pending_to=300000,max_idle_pending_to=600000,idle_pending_factor=2.0,idle_to=3600000,max_idle_to=21600000,idle_factor=2.0,min_time_to_alarm=3600000,max_temp_app_whitelist_duration=300000,mms_temp_app_whitelist_duration=60000,sms_temp_app_whitelist_duration=20000"

    # # specific App settings
    # am set-bg-restriction-level --user 0 com.tencent.mm
    # am set-bg-restriction-level --user 0 com.tencent.mobileqq
    # cmd appops set com.tencent.mm WAKE_LOCK ignore
    # cmd appops set com.tencent.mobileqq RUN_ANY_IN_BACKGROUND ignore
    # dumpsys deviceidle whitelist -com.tencent.mm
    # dumpsys deviceidle whitelist -com.tencent.mobileqq

    device_config put device_idle flex_time_short 0
    device_config put device_idle light_after_inactive_to 30000 #
    device_config put device_idle light_idle_to 30000 #
    device_config put device_idle light_idle_to_initial_flex 0
    device_config put device_idle light_max_idle_to_flex 0
    device_config put device_idle light_idle_factor 2 #
    device_config put device_idle light_idle_increase_linearly true
    device_config put device_idle light_idle_linear_increase_factor_ms 300000
    device_config put device_idle light_idle_flex_linear_increase_factor_ms 60000
    device_config put device_idle light_max_idle_to 900000 #
    device_config put device_idle light_idle_maintenance_min_budget 30000 #
    device_config put device_idle light_idle_maintenance_max_budget 60000 #
    device_config put device_idle min_light_maintenance_time 5000 #
    device_config put device_idle min_deep_maintenance_time 30000 #
    device_config put device_idle inactive_to 0 #
    device_config put device_idle sensing_to 0 #
    device_config put device_idle locating_to 0 #
    device_config put device_idle location_accuracy 20.0m
    device_config put device_idle motion_inactive_to 0 #
    device_config put device_idle motion_inactive_to_flex 0 #
    device_config put device_idle idle_after_inactive_to 900000 #
    device_config put device_idle idle_pending_to 60000 #
    device_config put device_idle max_idle_pending_to 120000 #
    device_config put device_idle idle_pending_factor 2 #
    device_config put device_idle quick_doze_delay_to +10s0ms
    device_config put device_idle idle_to 1800000 #
    device_config put device_idle max_idle_to 21600000 #
    device_config put device_idle idle_factor 2 #
    device_config put device_idle min_time_to_alarm +30m0s0ms
    device_config put device_idle max_temp_app_allowlist_duration_ms +20s0ms
    device_config put device_idle mms_temp_app_allowlist_duration_ms +20s0ms
    device_config put device_idle sms_temp_app_allowlist_duration_ms +20s0ms
    device_config put device_idle notification_allowlist_duration_ms +20s0ms
    device_config put device_idle wait_for_unlock true #
    device_config put device_idle use_window_alarms true
    device_config put device_idle use_mode_manager false

    device_config put activity_manager_native_boot use_freezer true
    device_config put activity_manager_native_boot freeze_debounce_timeout 5000
    device_config set_sync_disabled_for_tests persistent

    dumpsys deviceidle enable
    dumpsys deviceidle force-idle
    sleep 3600
done
