FROM docker.elastic.co/elasticsearch/elasticsearch:7.17.6@sha256:af43249cab60c8069a7868517b5c9d0f6481c6a1ac00e8ec3fa3ae614fb99e63
EXPOSE 9200 9300
RUN export ES_HOME="/var/lib/elasticsearch" 

ENV ES_HOME="/var/lib/elasticsearch" \
    ES_PATH_CONF="/var/lib/elasticsearch/config"
WORKDIR ${ES_HOME}

CMD ["sh", "-c", "${ES_HOME}/bin/elasticsearch"]