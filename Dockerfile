FROM erdc/proteus:latest

MAINTAINER ProteusDevelopers <proteus@groups.google.com>

USER root

RUN pip3 install jupyterhub==0.7.2

USER $NB_USER
