version: '3'

###
# Demo Fin Server from deployed DockerHub container images
###
services:

  ###
  # Font End NodeJS Application Server
  ###
  server:
    image: ucdlib/fin-server:1.0.3
    env_file:
      - ENV
    volumes:
#      - ./conf:/etc/fin # Frames now in image
      - ./conf/default-services.js:/etc/fin/default-services.js
#      - ./backups:/fcrepo-backups
    ports:
      - PORT:3001
    depends_on:
      - fcrepo
      - redis
      - elasticsearch

  ###
  # Fedora Repository
  ###
  fcrepo:
    image: ucdlib/fin-fcrepo:v1.0.0
    env_file:
      - ENV
    volumes:
      - fedora-data:/var/lib/jetty/fedora-data
#      - ./backups:/var/lib/jetty/fcrepo-backups

###
  # Session, admin store
  ###
  redis:
    image: redis:3.2
    volumes:
      - redis-data:/data
    depends_on:
      - fcrepo

  ###
  # UC DAMS Client UI
  ###
  ucd-lib-client:
    image: ucdlib/fin-ucd-lib-client:0.1.0
    env_file:
      - ENV
    depends_on:
      - elasticsearch

  ###
  # Search
  ###
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:5.4.1
    environment:
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - es-data:/usr/share/elasticsearch/data
      - ./conf/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml
    depends_on:
      - fcrepo

  ###
  # Trusted Proxy for Services
  ###
  trustedproxy:
    image: ucdlib/fin-trusted-proxy:1.0.0
    env_file:
      - ENV
    depends_on:
      - fcrepo

  ###
  # IIIF Service
  ###
  loris:
    image: ucdlib/fin-loris-service:v0.0.2
    env_file:
      - ENV
    depends_on:
      - fcrepo
    volumes:
      - loris-cache:/var/cache/loris
      - ./conf/loris/loris2.conf:/opt/loris/etc/loris2.conf
      - ./conf/loris/start.py:/opt/loris/loris/start.py

  ###
  # ES Indexer
  ###
  essync:
    image: ucdlib/fin-essync-service:0.1.0
    env_file:
      - ENV
    depends_on:
      - server

  ###
  # CAS AuthenticationService
  ###
  cas:
    image: ucdlib/fin-cas-service:0.0.1
    env_file:
      - ENV
    depends_on:
      - server


###
# Docker data volumes
###
volumes:
  fedora-data:
    driver: local
  es-data:
    driver: local
  redis-data:
    driver: local
  loris-cache:
    driver: local
