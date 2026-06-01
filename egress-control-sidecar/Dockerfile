FROM gogost/gost:3.2.6@sha256:1ae76fcd556aec335ff602a1828c1140c27d6243c7f02a89f41e177baa265faf

RUN apk add --no-cache nftables

ADD entrypoint.sh gost.yaml allowlist.txt /opt/egress-sidecar/
ADD bin/policy /usr/local/bin/policy
