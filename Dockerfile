FROM alpine

RUN apk add --no-cache bash

COPY bin/wait-for /usr/local/bin/wait-for
COPY bin/wait-forever /usr/local/bin/wait-forever

RUN chmod +x \
    /usr/local/bin/wait-for \
    /usr/local/bin/wait-forever

ENTRYPOINT ["wait-for"]
