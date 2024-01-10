FROM container-registry.oracle.com/os/oraclelinux:9-slim AS builder
# hadolint ignore=DL3041
RUN microdnf -y install gcc python3.11 python3.11-devel python3.11-pip  \
  && microdnf clean all \
  && rm -rf /var/cache
COPY requirements.txt /requirements.txt
# hadolint ignore=DL3013
RUN python3.11 -m pip install --no-cache-dir --upgrade pip \
  && python3.11 -m pip install --no-cache-dir -r /requirements.txt

FROM container-registry.oracle.com/os/oraclelinux:9-slim
# hadolint ignore=DL3041
RUN microdnf -y install jq python3.11 \
  && microdnf clean all \
  && rm -rf /var/cache \
  && chmod u+s /usr/sbin/useradd \
  && chmod u+s /usr/sbin/groupadd
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/lib64/python3.11/site-packages /usr/local/lib64/python3.11/site-packages
COPY --from=builder /usr/local/bin/oci /usr/local/bin/oci
