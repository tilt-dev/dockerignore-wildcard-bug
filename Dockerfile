FROM busybox
WORKDIR /src
ADD . .
RUN find .
