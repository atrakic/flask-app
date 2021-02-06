FROM tiangolo/uwsgi-nginx-flask:python3.7

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR /app

ADD requirements.txt /app/

RUN /bin/bash -c "pip3 install --no-cache-dir -r requirements.txt"

ADD /app/ /app/

EXPOSE 8080
CMD ["gunicorn", "-b", "0.0.0.0:8080", "wsgi", "-k", "gevent"]
