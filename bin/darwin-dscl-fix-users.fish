#!/usr/bin/env fish
# SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Fix nix-darwin managed user paths

# macOS moves user's home directories around after installing updates
# Then, `darwin-rebuild switch` fails with the following error:
# error: config contains the wrong home directory for nagios-nsca, aborting activation
# nix-darwin does not support changing the home directory of existing users.
#
# Please set:
#
#     users.users.nagios-nsca.home = "/private/var/lib/nagios-nsca";
#
# or remove it from your configuration.

for user in nagios lithium-ca nagios-nsca
    if sudo dscl . -change /Users/$user NFSHomeDirectory {/private,}/var/lib/$user
        echo "Fixed $user"
    else
        echo "Already fixed $user"
    end
end
