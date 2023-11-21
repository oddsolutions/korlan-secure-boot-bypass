# Export gpio pin and create a symlink to mic mute GPIO value
MIC_MUTE_STATE_DIR=/data/chrome/tmp/mic_mute_state
MIC_MUTE_GPIO=413
echo ${MIC_MUTE_GPIO} > /sys/class/gpio/export
echo in > /sys/class/gpio/gpio${MIC_MUTE_GPIO}/direction
echo disable > /sys/class/gpio/gpio${MIC_MUTE_GPIO}/pull
ln -s /sys/class/gpio/gpio${MIC_MUTE_GPIO}/value ${MIC_MUTE_STATE_DIR}
