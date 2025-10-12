FROM alpine:3.20

ARG PB_VERSION=0.29.2
WORKDIR /pb

# install unzip & curl
RUN apk add --no-cache curl unzip

# download linux binary
RUN curl -L -o pb.zip \
  https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip \
  && unzip pb.zip && rm pb.zip && chmod +x pocketbase

# data dir (will be mounted as a Railway Volume)
RUN mkdir -p /pb/pb_data
# copy schema migrations into the image
COPY pb_migrations/ /pb/pb_migrations/


#CMD ["/bin/sh","-lc","./pocketbase superuser upsert admin@test.com 'MyPass123' || true; exec ./pocketbase serve --http=0.0.0.0:${PORT:-8080}"]

CMD ["/bin/sh","-lc","./pocketbase migrate up || true; ./pocketbase superuser upsert admin@test.com 'MyPass123' || true; exec ./pocketbase serve --http=0.0.0.0:${PORT:-8080}"]
