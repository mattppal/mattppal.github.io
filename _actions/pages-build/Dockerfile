FROM ubuntu:latest

COPY entrypoint.sh /entrypoint.sh

RUN apt-get update && apt-get install -y curl

ENTRYPOINT ["/entrypoint.sh"]
