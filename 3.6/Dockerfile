FROM python:3.6-stretch

WORKDIR /app
EXPOSE 80
RUN adduser www-data www-data
RUN chown www-data:www-data /app

# Upgrade pip
RUN pip install --upgrade pip
RUN pip install uwsgi

# Install less
RUN echo "deb http://deb.debian.org/debian/ stretch main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://deb.debian.org/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org/debian-security/ stretch/updates main contrib non-free" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -qqy node-less

# Install JDK
RUN  apt-get install -qqy openjdk-8-jdk
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Configure uwsgi
ENV UWSGI_CHEAPER 2
ENV UWSGI_PROCESSES 16
ENV UWSGI_PY_AUTORELOAD 1

# Installing cython before, because needed to compile pyjnius in next step
RUN pip install cython==0.26.1

# Copy requirements to root and install
COPY flask-requirements.txt /app
COPY django-requirements.txt /app
RUN pip install -r flask-requirements.txt
RUN pip install -r django-requirements.txt

CMD /usr/local/bin/uwsgi --ini /app/uwsgi.ini \
  --die-on-term \
  --chdir="/app" \
  --module="%(app)" \
  --master \
  --callable=app \
  --ignore-sigpipe \
  --ignore-write-errors \
  --disable-write-exception \
  --socket-timeout=30 \
  --threaded-logger \
  --log-master \
  --log-format='{"context": "uwsgi", "severity": "DEBUG", "timestamp": "%(epoch)", "message": "[uWSGI] %(status) [%(msecs)ms] %(method) %(uri) "}' \
  --offload-threads=4 \
  --http=80 \
  --thunder-lock \
  --uid=www-data \
  --gid=www-data \