# FROM node:13-alpine
FROM ubuntu:18.04

LABEL version="1.0.0"
LABEL repository="https://github.com/sma11black/hexo-action"
LABEL homepage="https://sma11black.github.io"
LABEL maintainer="sma11black <smallblack@outlook.com>"

COPY entrypoint.sh /entrypoint.sh

# RUN apk add --no-cache git openssh > /dev/null ; \
#     chmod +x /entrypoint.sh

RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils git openssh-client \
    && apt install -y nodejs npm \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]