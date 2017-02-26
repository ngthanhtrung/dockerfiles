#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
	set -- archiva "$@"
fi

if [ "$1" = 'archiva' -a "$(id -u)" = '0' ]; then
	for dir in \
		data \
		repositories \
	; do
		chown -R archiva:archiva "/var/lib/archiva/${dir}"
	done

	set -- gosu archiva "$@"
fi

exec "$@"
