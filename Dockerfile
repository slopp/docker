FROM rocker/hadleyverse
MAINTAINER Sean Lopp <sean@rstudio.com>

RUN set -x \
    && apt-get update \
    && apt-get install -y gdebi-core \
    && wget https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-server-pro-1.0.34-amd64.deb \
    && gdebi -n rstudio-server-pro-1.0.34-amd64.deb


RUN adduser --disabled-password --gecos '' sean \
  && echo 'sean:passwd' | chpasswd

RUN adduser --disabled-password --gecos '' user1 \
  && echo 'user1:passwd' | chpasswd

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

COPY setup.R /setup.R
RUN Rscript setup.R

COPY spark_install.R /spark_install.R
RUN Rscript spark_install.R
RUN cp -r /root/.cache/spark /opt/spark
RUN echo "options(spark.install.dir = '/opt/spark/spark-2.0.0-bin-hadoop2.7')" >> /usr/lib/R/etc/Rprofile.site

RUN echo "SPARK_HOME=/opt/spark/spark-2.0.0-bin-hadoop2.7" >> /usr/lib/R/etc/Renviron.site

COPY profiles /etc/rstudio/profiles

EXPOSE 8787

CMD ["/docker-entrypoint.sh"]




