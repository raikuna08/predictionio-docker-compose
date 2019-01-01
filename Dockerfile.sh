export PIO_VERSION=0.12.1
export SPARK_VERSION=2.1.3
export HADOOP_VERSION=2.7
export JDBC_PGSQL_VERSION=42.1.4
 1
export PIO_HOME=/opt/pio
export PATH=${PIO_HOME}/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

apt-get update \
    && apt-get install -y --auto-remove --no-install-recommends curl openjdk-8-jdk libgfortran3 python-pip git wget nano ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

cd /tmp && \
	curl -L https://github.com/apache/predictionio/archive/v${PIO_VERSION}.tar.gz -o pio.tar.gz \
    && mkdir pio \
    && tar -xzf pio.tar.gz -C pio \
    && cd pio/predictionio-${PIO_VERSION} \
	&& ./make-distribution.sh -Dscala.version=2.11.12 -Dspark.version=${SPARK_VERSION}

mkdir ${PIO_HOME} && \
	tar -zxf /tmp/pio/predictionio-${PIO_VERSION}/PredictionIO-${PIO_VERSION}.tar.gz --strip-components=1 -C ${PIO_HOME} && \
	mkdir ${PIO_HOME}/vendors

wget http://apache.mirror.iphh.net/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -O /tmp/spark.tar.gz && \
    tar -xvzf /tmp/spark.tar.gz -C ${PIO_HOME}/vendors

cd ${PIO_HOME}/vendors && curl -O https://jdbc.postgresql.org/download/postgresql-${JDBC_PGSQL_VERSION}.jar

update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1 && \
    update-alternatives  --set python /usr/bin/python3.6 && \
    apt update && \
    apt install python3-pip -y && \
    hash -r

pip3 install --upgrade pip && \
    hash -r && \
	pip3 install -U setuptools && \
	pip3 install wheel predictionio

rm -rf /tmp/* && \
	rm -rf /etc/service/{cron,syslog-forwarder,syslog-ng,sshd}

#COPY files/pio_event_service /etc/service/pio_event/run
#COPY files/pio_query_service /etc/service/pio_query/run
#COPY universal-recommender /root/ur
#COPY files/import_likes_data.sh /root/ur/examples/import_likes_data.sh
