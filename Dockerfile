FROM alpine:latest

ARG USER=notroot
ARG GROUP=notroot
ARG UID=1000
ARG GID=1000

COPY requirements.txt /requirements.txt
RUN set -xe && \
    echo $(echo BUILD_TIME_ALPINE_VERSION: && /bin/cat /etc/alpine-release) && \
    apk upgrade --no-cache && \
    apk add --no-cache \
        python3 \
        py3-pip && \
    pip install -r /requirements.txt && \
    addgroup -g ${GID} -S ${GROUP} && \
    adduser -u ${UID} -S -D ${USER} ${GROUP}

COPY --chown=${USER} bin/cache-invalidation.py /cache-invalidation.py
WORKDIR /home/${USER}
USER ${USER}
RUN chmod +x /cache-invalidation.py

ENTRYPOINT echo $(echo ALPINE_VERSION: && /bin/cat /etc/alpine-release) && /usr/bin/python3 /cache-invalidation.py