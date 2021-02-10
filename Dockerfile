FROM alpine:latest

ARG USER=notroot
ARG GROUP=notroot
ARG UID=1000
ARG GID=1000

COPY requirements.txt /tmp/requirements.txt
COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN set -xe && \
    echo $(echo BUILD_TIME_ALPINE_VERSION: && /bin/cat /etc/alpine-release) && \
    apk upgrade --no-cache && \
    apk add --no-cache \
        python3 \
        py3-pip && \
    pip install -r /tmp/requirements.txt && \
    addgroup -g ${GID} -S ${GROUP} && \
    adduser -u ${UID} -S -D ${USER} ${GROUP} && \
    chmod a+x /usr/bin/entrypoint.sh && \
    mkdir /app && chown ${USER} /app


COPY --chown=${USER} k8sci/ /app/k8sci/
WORKDIR /app
USER ${USER}

ENTRYPOINT /usr/bin/entrypoint.sh