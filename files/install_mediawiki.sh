#!/usr/bin/bash

VERSION="$1"
VERSION_SHORT=$(echo "$VERSION" | sed -E 's/([0-9]+\.[0-9]+)+\.[0-9]+/\1/g')

if [[ -e "/var/lib/mediawiki/version" ]]; then
    CURRENT=$(cat /var/lib/mediawiki/version)
    if [[ "$VERSION" == "$CURRENT" ]]; then
        exit 0
    fi

    UPGRADING="true"
fi

if [[ -e /var/lib/mediawiki ]]; then
    wget -O '/tmp/mediawiki.tar.gz' "https://releases.wikimedia.org/mediawiki/$VERSION_SHORT/mediawiki-$VERSION.tar.gz"
    tar xvf /tmp/mediawiki.tar.gz
    mkdir /var/lib/mediawiki
    mv mediawiki-*/* /var/lib/mediawiki
    rm /tmp/mediawiki.tar.gz
fi

if [[ -z $UPGRADING ]]; then
    # TODO
    echo "Not implemented"
    exit 1
fi
