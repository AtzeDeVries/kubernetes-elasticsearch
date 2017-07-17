FROM openjdk:8-jre
MAINTAINER atze.devries@naturalis.nl

EXPOSE 9200 9300

ENV VERSION 5.5.0

# Install Elasticsearch.
RUN apt update && apt install -y sudo uuid-runtime && \
    ( curl -Lskj https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$VERSION.tar.gz | \
    gunzip -c - | tar xf - ) && \
    mv /elasticsearch-$VERSION /elasticsearch && \
    rm -rf $(find /elasticsearch | egrep "(\.(exe|bat)$)")


# Set environment
ENV DISCOVERY_SERVICE elasticsearch-discovery

# Volume for Elasticsearch data
VOLUME ["/data"]

# Copy configuration
COPY config /elasticsearch/config

# Copy run script
COPY run.sh /

#ADD config /elasticsearch/config

# Set environment variables defaults
ENV ES_JAVA_OPTS "-Xms512m -Xmx512m"
ENV CLUSTER_NAME elasticsearch-default
ENV NODE_MASTER true
ENV NODE_DATA true
ENV NODE_INGEST true
ENV HTTP_ENABLE true
ENV NETWORK_HOST _site_
ENV HTTP_CORS_ENABLE true
ENV HTTP_CORS_ALLOW_ORIGIN *
ENV NUMBER_OF_MASTERS 1
ENV NUMBER_OF_SHARDS 1
ENV NUMBER_OF_REPLICAS 0
ENV MAX_LOCAL_STORAGE_NODES 1
ENV DISCOVERY_SERVICE elasticsearch-discovery
CMD ["/run.sh"]
