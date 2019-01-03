FROM phusion/baseimage:0.11

RUN apt-get update \
    && apt-get install -y --auto-remove --no-install-recommends curl openjdk-8-jdk libgfortran3 python-pip git wget nano ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PIO_VERSION 0.12.1
ENV SPARK_VERSION 2.1.3
ENV HADOOP_VERSION 2.7
ENV JDBC_PGSQL_VERSION 42.2.5

ENV PIO_HOME /opt/pio
ENV PATH=${PIO_HOME}/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN cd /tmp && \
	curl -L https://github.com/apache/predictionio/archive/v${PIO_VERSION}.tar.gz -o pio.tar.gz \
    && mkdir pio \
    && tar -xzf pio.tar.gz -C pio \
    && cd pio/predictionio-${PIO_VERSION} \
	&& ./make-distribution.sh -Dscala.version=2.11.12 -Dspark.version=${SPARK_VERSION}

RUN mkdir ${PIO_HOME} && \
	tar -zxf /tmp/pio/predictionio-${PIO_VERSION}/PredictionIO-${PIO_VERSION}.tar.gz --strip-components=1 -C ${PIO_HOME} && \
	mkdir ${PIO_HOME}/vendors

RUN wget http://apache.mirror.iphh.net/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -O /tmp/spark.tar.gz && \
    tar -xvzf /tmp/spark.tar.gz -C ${PIO_HOME}/vendors

RUN cd ${PIO_HOME}/vendors && curl -O https://jdbc.postgresql.org/download/postgresql-${JDBC_PGSQL_VERSION}.jar

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1 && \
    update-alternatives  --set python /usr/bin/python3.6 && \
    apt update && \
    apt install python3-pip -y && \
    hash -r

RUN pip3 install --upgrade pip && \
    hash -r && \
	pip3 install -U setuptools && \
	pip3 install wheel predictionio

RUN rm -rf /tmp/* && \
	rm -rf /etc/service/{cron,syslog-forwarder,syslog-ng,sshd}

COPY files/pio_event_service /etc/service/pio_event/run
COPY files/pio_query_service /etc/service/pio_query/run
COPY universal-recommender /root/ur
