#!/usr/bin/bash

# A script to install MediaWiki. This script takes the same parameters
# as install.php and are passed into it directly.

VERSION="$1"

# Takes a number like "1.29.5" and turns it into "1.29"
VERSION_SHORT=$(echo "$VERSION" | sed -E 's/([0-9]+\.[0-9]+)+\.[0-9]+/\1/g')

# Skip the first argument
shift 1

if [[ ! -e /var/lib/mediawiki ]]; then
    wget -O '/tmp/mediawiki.tar.gz' "https://releases.wikimedia.org/mediawiki/$VERSION_SHORT/mediawiki-$VERSION.tar.gz"
    tar xvf /tmp/mediawiki.tar.gz
    mkdir /var/lib/mediawiki
    mv mediawiki-*/* /var/lib/mediawiki
    rm /tmp/mediawiki.tar.gz

    php /var/lib/mediawiki/maintenance/install.php $@
fi

if [[ -e "/var/lib/mediawiki/version" ]]; then
    CURRENT=$(cat /var/lib/mediawiki/version)
    if [[ "$VERSION" == "$CURRENT" ]]; then
        exit 0
    fi

    # We're preforming an upgrade
    mkdir -p /var/lib/backup
    tar -cvf - /var/lib/mediawiki/ | xz -9 > /var/lib/backup/backup-$(date +%s).tar.xz
fi
