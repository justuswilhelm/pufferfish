#!/bin/bash
# $1: Notification Type (Service or Host)
# $2: Service/Host Name
# $3: State (OK, WARNING, CRITICAL, DOWN, etc.)
# $4: Address (IP or hostname)
# $5: Additional Info

MESSAGE="Alert: $1 $2 is $3 - $5"
osascript -e "display notification \"$MESSAGE\" with title \"Nagios Notification\""
