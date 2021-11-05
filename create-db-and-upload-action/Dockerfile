FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -yqq && \
    apt-get install -y eatmydata

RUN eatmydata apt-get install -y reprepro rclone && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"] 
