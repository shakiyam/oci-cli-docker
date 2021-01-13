FROM python:3-slim-buster
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends sudo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN chmod u+s /usr/sbin/useradd \
  && chmod u+s /usr/sbin/groupadd
# hadolint ignore=DL3013
RUN pip install oci oci-cli
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
