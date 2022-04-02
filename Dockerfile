FROM ubuntu:21.04

LABEL name="map tile server" vendor="oss"

# Instructions
#https://switch2osm.org/serving-tiles/manually-building-a-tile-server-ubuntu-21/

# Data
#https://download.geofabrik.de/

# Old container
#https://hub.docker.com/r/overv/openstreetmap-tile-server/

RUN apt -y update; \
    apt -y upgrade; \
    apt install -y software-properties-common; \
    add-apt-repository ppa:kakrueger/openstreetmap; \
    apt install -y sudo screen locate libapache2-mod-tile renderd git tar unzip wget bzip2 apache2 lua5.1 mapnik-utils python3-mapnik python3-psycopg2 python3-yaml gdal-bin npm fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted ttf-unifont

# Database creation steps
RUN /etc/init.d/postgresql start; \
    sudo -u postgres -H -- createuser _renderd; \
    sudo -u postgres -H -- createdb -E UTF8 -O _renderd gis; \
    sudo -u postgres -H -- psql -d gis -c "CREATE EXTENSION postgis; CREATE EXTENSION hstore; ALTER TABLE geometry_columns OWNER TO _renderd; ALTER TABLE spatial_ref_sys OWNER TO _renderd;"

# Stylesheet config
WORKDIR /build/src/openstreetmap-carto
RUN mkdir -p /build/src; \
    chmod 770 /build; \
    git clone https://github.com/gravitystorm/openstreetmap-carto.git; \
    npm install -g carto; \
    carto project.mml > mapnik.xml; \
    chgrp -R _renderd /build 

# Loading data
WORKDIR /build/data
RUN mkdir -p /build/data; \
    wget https://download.geofabrik.de/asia/azerbaijan-latest.osm.pbf -P /build/data; \
    chmod -R o+rx /build/data; \
    sudo -u _renderd osm2pgsql -d gis --create --slim  -G --hstore --tag-transform-script /build/src/openstreetmap-carto/openstreetmap-carto.lua -C 2500 --number-processes 1 -S /build/src/openstreetmap-carto/openstreetmap-carto.style /build/data/azerbaijan-latest.osm.pbf

# Creating indexes
#WORKDIR /build/src/openstreetmap-carto
#RUN sudo -u _renderd -H -- psql -d gis -f indexes.sql

# Shapefile download
#WORKDIR /build/src/openstreetmap-carto
#RUN mkdir /build/src/openstreetmap-carto/data; \
#    chown _renderd /build/src/openstreetmap-carto/data; \
#    sudo -u _renderd scripts/get-external-data.py

# Configure renderd
#COPY renderd.conf /etc/renderd.conf

# Configure Apache (or nginx???)

# Create start.sh
#launch postgresql
#launch renderd
#launch Apache

#USER
CMD ["/bin/bash"]