#!/bin/bash
audioDevices=$(system_profiler -json SPAudioDataType | /usr/local/bin/jq ".SPAudioDataType[0]._items[]._name")

while IFS= read -r line ; do
    # getting address of audio devices that are also bluetooth devices
    bluetoothAudioDevice=$(system_profiler -json SPBluetoothDataType | /usr/local/bin/jq -r '.SPBluetoothDataType[0].devices_list[].'"$line"'.device_address' | grep -v null)
    echo "[$(bluetoothAudioDevice)] :attempting to disable bluetooth" >> ~/bluetooth.log
    if [ ! -z "$bluetoothAudioDevice" ]; then
        /usr/local/bin/blueutil --disconnect $bluetoothAudioDevice --wait-disconnect $bluetoothAudioDevice
    fi
done <<< "$audioDevices"

# Uncomment to debug
# echo "[$(date)] :attempting to disable bluetooth" >> ~/bluetooth.log