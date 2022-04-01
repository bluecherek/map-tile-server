FROM ubuntu:21.04

LABEL name="map tile server" vendor="oss"

# Instructions
#https://switch2osm.org/serving-tiles/manually-building-a-tile-server-ubuntu-21/

# Data
#https://download.geofabrik.de/

# Old container
#https://hub.docker.com/r/overv/openstreetmap-tile-server/

RUN apt -y update; apt -y upgrade

RUN apt install -y software-properties-common 

RUN add-apt-repository ppa:kakrueger/openstreetmap

RUN apt install -y sudo screen locate libapache2-mod-tile renderd git tar unzip wget bzip2 apache2 lua5.1 mapnik-utils python3-mapnik python3-psycopg2 python3-yaml gdal-bin npm fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted ttf-unifont

# Database creation steps
#/etc/init.d/postgresql
#sudo -u postgres -i
#createuser _renderd
#createdb -E UTF8 -O _renderd gis
#psql
#\c gis
#CREATE EXTENSION postgis;
#CREATE EXTENSION hstore;
#ALTER TABLE geometry_columns OWNER TO _renderd;
#ALTER TABLE spatial_ref_sys OWNER TO _renderd;
#\q
#exit

# Stylesheet config
#mkdir ~/src
#cd ~/src
#git clone https://github.com/gravitystorm/openstreetmap-carto.git
#cd openstreetmap-carto
#carto project.mml > mapnik.xml

# Loading data
#mkdir ~/data
#cd ~/data
#wget https://download.geofabrik.de/asia/azerbaijan-latest.osm.pbf
#chmod o+rx ~
#sudo -u _renderd osm2pgsql -d gis --create --slim  -G --hstore --tag-transform-script ~/src/openstreetmap-carto/openstreetmap-carto.lua -C 2500 --number-processes 1 -S ~/src/openstreetmap-carto/openstreetmap-carto.style ~/data/azerbaijan-latest.osm.pbf



#USER
CMD ["/bin/bash"]