FROM python:3-slim-buster
# hadolint ignore=DL3008
RUN chmod u+s /usr/sbin/useradd \
  && chmod u+s /usr/sbin/groupadd
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
