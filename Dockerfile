FROM container-registry.oracle.com/os/oraclelinux:9-slim
# hadolint ignore=DL3041
RUN microdnf -y install python3 pip \
  && microdnf clean all \
  && rm -rf /var/cache \
  && chmod u+s /usr/sbin/useradd \
  && chmod u+s /usr/sbin/groupadd
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
COPY requirements.txt /requirements.txt
# hadolint ignore=DL3013
RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir -r /requirements.txt
