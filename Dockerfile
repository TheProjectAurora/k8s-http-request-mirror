FROM alpine:latest

ARG USER=nonroot
ARG GROUP=nonroot
ARG UID=1000
ARG GID=1000

COPY requirements.txt /tmp/requirements.txt
RUN set -xe && \
    echo $(echo BUILD_TIME_ALPINE_VERSION: && /bin/cat /etc/alpine-release) && \
    apk upgrade --no-cache && \
    apk add --no-cache \
        python3 \
        py3-pip && \
    pip install -r /tmp/requirements.txt && \
    addgroup -g ${GID} -S ${GROUP} && \
    adduser -u ${UID} -S -D ${USER} ${GROUP}
COPY --chown=${USER} k8sci/ /app/k8sci/
WORKDIR /app
USER ${USER}
ENV PYTHONUNBUFFERED=TRUE

ENTRYPOINT echo $(echo ALPINE_VERSION: && /bin/cat /etc/alpine-release) && \
           gunicorn --bind 0.0.0.0:5000 --enable-stdio-inheritance --error-logfile "-"  k8sci.wsgi:app