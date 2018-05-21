FROM python:3.6-stretch

EXPOSE 80
RUN adduser www-data www-data
RUN mkdir /app && chown www-data:www-data /app

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
COPY ./flask-requirements.txt /app
COPY ./django-requirements.txt /app
WORKDIR /app
RUN pip install -r flask-requirements.txt
RUN pip install -r django-requirements.txt

# Copy config files and scripts
COPY ./before_script.sh /root
COPY ./entrypoint.sh /root
COPY ./uwsgi.ini /root

# Otherwise the python code reloader won't work
RUN chown -R www-data:www-data /root

CMD /root/entrypoint.sh
