# lets try debian buster.

# debian:buster
FROM debian@sha256:9b61eaedd46400386ecad01e2633e4b62d2ddbab8a95e460f4e0057c612ad085 AS base

FROM base as build
RUN apt-get update && apt-get -y install --no-install-recommends \
	gcc \
	g++ \
	gfortran \
	libopenblas-dev \
	libblas-dev \
	liblapack-dev \
	libatlas-base-dev \
	libhdf5-dev \
	libhdf5-103 \
	pkg-config \
	python3 \
	python3-dev \
	python3-pip \
	python3-setuptools \
	pybind11-dev \
	wget
RUN pip3 install wheel==0.34.2 cython==0.29.14 pybind11==2.5
RUN pip3 wheel numpy==1.18.5 && pip3 install numpy-*.whl
RUN pip3 wheel scipy==1.4.1
RUN pip3 wheel --no-deps h5py==2.10.0
RUN pip3 wheel grpcio==1.27.1

# V1.2 enabling HTTPS querys + installing packages
RUN apt-get update && apt-get -y install --no-install-recommends \
	build-essential \
	python-certifi \
	ca-certificates \
	libssl-dev \
	libffi6 \
	libffi-dev

RUN	pip3 install -U pip
RUN pip3 install -U matplotlib pyOpenSSL six

### Need set or failure validate cert.
ENV SSL_CERT_DIR=/etc/ssl/certs
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# install finish V1.1
RUN pip3 install *.whl
RUN wget https://github.com/lhelontra/tensorflow-on-arm/releases/download/v2.3.0/tensorflow-2.3.0-cp37-none-linux_armv7l.whl
RUN pip3 install tensorflow-*.whl

# V1.3 Enable Jupyter Notebook 
RUN pip3 install -U -q keras matplotlib jupyter six

## Add jupyter to PATH
### /home/pi/.local
ENV PATH="${PATH}:/home/pi/.local/bin"
ENV PATH="${PATH}:root/.local/bin" 
ENV PATH="${PATH}:~/.local/bin" 

# Logging
## pip 20.2.4
RUN pip3 --version && sleep 7s 
## 3.7.3 [python itself no works]
RUN python3 --version && sleep 7s
## Manylinux compatiability
##RUN cat /usr/local/bin/_manylinux.py && sleep 7s
RUN pip3 list  && sleep 12s

# Cleanup
RUN rm *.whl