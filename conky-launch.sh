#!/bin/env bash
killall conky
# start for conky-altcoin-monitor
conky -c ~/.config/conky/conf/conky-altcoin-monitor/conky-altcoin-monitor &
# start for conky-bluetooth-monitor
conky -c ~/.config/conky/conf/conky-bluetooth-monitor/conky-bluetooth-monitor &
# start for conky-calendar
conky -c ~/.config/conky/conf/conky-calendar/conky-calendar &
# start for conky-clock
conky -c ~/.config/conky/conf/conky-clock/conky-clock &
# start for conky-computer-metrics
conky -c ~/.config/conky/conf/conky-computer-metrics/conky-computer-metrics &
# start for conky-exploded-view
conky -c ~/.config/conky/conf/conky-exploded-view/conky-exploded-view &
# start for conky-mini-playerctl
conky -c ~/.config/conky/conf/conky-mini-playerctl/conky-mini-playerctl &
# start for conky-weather
conky -c ~/.config/conky/conf/conky-weather/conky-weather &
# start for conky-xfce-workspace-indicator
conky -c ~/.config/conky/conf/conky-xfce-workspace-indicator/conky-xfce-workspace-indicator &
