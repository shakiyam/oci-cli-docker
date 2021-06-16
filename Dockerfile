FROM python:3-slim-buster
RUN chmod u+s /usr/sbin/useradd \
  && chmod u+s /usr/sbin/groupadd
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt
