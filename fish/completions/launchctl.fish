# SPDX-FileCopyrightText: 2026 Justus Perlwitz
# SPDX-License-Identifier: GPL-3.0-or-later
# Completions for macOS launchctl command
# Supported subcommands:

# kickstart
# print

# output for `launchctl print gui/501`:
# gui/501 = {
# 	type = login
# 	handle = 100017
# 	active count = 425
# 	service count = 424
# 	active service count = 230
# 	creator = loginwindow[536]
# 	creator euid = 0
# 	session = Aqua
# 	endpoint destination = com.apple.xpc.launchd.domain.user.501
# 	auxiliary bootstrapper = com.apple.xpc.otherbsd (complete)
# 	security context = {
# 		uid = 501
# 		asid = 100017
# 	}
#
# 	bringup time = 64 ms
# 	death port = 0x14503
#
# 	environment = {
# 		SSH_AUTH_SOCK => /private/tmp/com.apple.launchd.tcPrbRORRV/Listeners
# 	}
#
# 	services = {
# 		     887      - 	net.jwpconsulting.postgresql
# 		     866      - 	com.apple.syncdefaultsd
# 	}
#
# 	unmanaged processes = {
# […]
# 	}
#
# 	endpoints = {
# […]
# 	}
#
# 	externally-hosted endpoints = {
# […]
# 	}
#
# 	task-special ports = {
# […]
# 	}
#
# 	disabled services = {
# […]
# 		"com.apple.rcd" => disabled
# 	}
#
# 	properties = gui | gui login
# }

# output for `launchctl print system`:
# system = {
# 	type = system
# 	handle = 0
# 	active count = 1089
# 	service count = 431
# 	active service count = 216
# 	maximum allowed shutdown time = 65 s
# 	service stats = {
# 		com.apple.launchd.service-stats-default (4096 records)
# 	}
# 	trial factor reloads = 1
# 	trial factors = {
# 	}
# 	creator = launchd[1]
# 	creator euid = 0
# 	auxiliary bootstrapper = com.apple.xpc.smd (complete)
# 	security context = {
# 		uid unset
# 		asid = 0
# 	}
#
# 	bringup time = 70 ms
# 	death port = 0x1b03
# 	subdomains = {
# 		pid/85352
# […]
# 	}
#
# 	services = {
# 		       0      - 	com.apple.rpmuxd
# 		       0      - 	com.apple.lskdd
# 		     876      - 	com.apple.kernelmanager_helper
# 		     539      - 	com.apple.runningboardd
# […]
# 	}
#
# 	unmanaged processes = {
# […]
# 	}
#
# 	endpoints = {
# 		       0    M   D   com.apple.fpsd.arcadeservice
# 		       0    M   D   com.apple.dt.RemotePairingDataVaultHelper
# 		 0x1b123    M   A   com.apple.backgroundtaskmanagement.sfl
# […]
# 	}
#
# 	task-special ports = {
# 			  0x1d03 4       bootstrap  com.apple.xpc.launchd.domain.system
# 			  0x2303 9          access  com.apple.taskgated
# 	}
# 	attractive services = {
# 		com.apple.MessagesBlastDoorService
# 		com.apple.IDSBlastDoorService
# 	}
#
# 	disabled services = {
# 		"net.jwpconsulting.nagios" => enabled
# 		"com.apple.ftpd" => disabled
# […]
# 	}
#
# 	properties = uncorked | audit check done | bootcache hack
# }

# Autocomplete launchctl print <target>
# where <target> = <domain-target> | <service-target>
# 1. domain targets:
# <domain-target> = system | user/<uid> | gui/<uid>
# where <uid> is a user id
# 2. system service targets:
# <service-target> = system/<service-name>
# where <service-name> comes from `launchctl print system`
# 3. user service targets:
# <service-target> = user/<uid>/<service-name>
# where <service-name> comes from `launchctl print user/<uid>`
# 4. gui service targets:
# <service-target> = gui/<uid>/<service-name>
# where <service-name> comes from `launchctl print gui/<uid>`
# 5. not implemented
# - <domain-target> = login/<asid> | login/<asid>/<service-name>
# - <domain-target> = pid/<pid> | pid/<pid>/<service-name

set -l commands print kickstart kill

# Launchctl only takes filenames in some locations
complete -c launchctl -f

function __launchctl_services_for_domain -a domain -a description
    # Look for this block and print out the third column with extra info
    # 	services = {
    # 		       0      - 	com.apple.rpmuxd
    # 		       0      - 	com.apple.lskdd
    # 		     876      - 	com.apple.kernelmanager_helper
    # 		     539      - 	com.apple.runningboardd
    # […]
    # 	}
    # becomes
    # gui/501/com.apple.rpmuxd\tUser service\n
    # TODO consider using disabled services for kickstart. print lists
    # running processes like Firefox that I'm not keen on restarting
    launchctl print $domain | awk -v domain=$domain '
    /^\t*services/,/^\t*}/ {
        if (length($3) > 1) printf("%s/%s\t%s\n", domain, $3, description);
    }
    '
end

function __launchctl_all_service_completions -a uid
    __launchctl_services_for_domain system "System service"
    __launchctl_services_for_domain "user/$uid" "User service"
    __launchctl_services_for_domain "gui/$uid" "GUI service"
end

# Top-level subcommand completions
complete -c launchctl -n "not __fish_seen_subcommand_from $comands" \
    -a "$commands"

# Completions for `launchctl print <target>`
function __launchctl_print_completions -a uid
    printf "system\tSystem domain\n"
    printf "user/%s\tUser domain\n" $uid
    printf "gui/%s\tGUI domain\n" $uid
    __launchctl_all_service_completions $uid
end
complete -c launchctl -n '__fish_seen_subcommand_from print' \
    -f -a '(__launchctl_print_completions (id -u))'
complete -c launchctl -n '__fish_seen_subcommand_from print' \
    -a print -d 'Prints information about the specified service or domain.'

# Completions for `launchctl kickstart <service-target>`
complete -c launchctl -n '__fish_seen_subcommand_from kickstart' \
    -f -a '(__launchctl_all_service_completions (id -u))'
complete -c launchctl -n '__fish_seen_subcommand_from kickstart' \
    -a kickstart -d 'Instructs launchd to run the specified service immediately, regardless of its configured launch conditions.'
complete -c launchctl -n '__fish_seen_subcommand_from kickstart' \
    -s k -d "Terminates the service if it is already running."
complete -c launchctl -n '__fish_seen_subcommand_from kickstart' \
    -s p -d "Prints the PID of the service that was started."
complete -c launchctl -n '__fish_seen_subcommand_from kickstart' \
    -s s -d "Starts the service suspended so that a debugger may attach."

# Kill
# Missing: signal numbers
complete -c launchctl -n '__fish_seen_subcommand_from kill' \
    -a kill -d 'Sends the specified signal to the specified service if it is running.'
