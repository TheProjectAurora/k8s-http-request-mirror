#!/usr/bin/env sh

set -xe

echo $(echo ALPINE_VERSION: && /bin/cat /etc/alpine-release) 

export PYTHONUNBUFFERED=TRUE
cd /app
gunicorn --bind 0.0.0.0:5000 --enable-stdio-inheritance --error-logfile "-"  k8sci.wsgi:app
