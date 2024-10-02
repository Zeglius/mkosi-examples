FROM alpine@sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d
RUN echo -e '#!/bin/sh\necho hello $1\n' > /bin/hello && chmod +x /bin/hello
ENTRYPOINT ["/bin/hello"]