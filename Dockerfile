# lets try debian buster.

# debian:buster
FROM debian@sha256:9b61eaedd46400386ecad01e2633e4b62d2ddbab8a95e460f4e0057c612ad085 AS base

# debian:stretch-20200130
#FROM debian@sha256:872b72a2b8487e4b91ae27855c7de1671635d3dc2cc0b89651103e55c74ed34a AS base

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

# RUN pip3 install --upgrade pip

RUN pip3 install *.whl
# fuck it
#RUN wget "https://raw.githubusercontent.com/PINTO0309/Tensorflow-bin/master/tensorflow-2.3.1-cp37-none-linux_armv7l_download.sh"
#RUN chmod +x ./tensorflow-2.3.1-cp37-none-linux_armv7l_download.sh
#RUN ./tensorflow-2.3.1-cp37-none-linux_armv7l_download.sh
#RUN pip3 uninstall tensorflow
#RUN pip3 install ./root/tensorflow-2.3.1-cp37-none-linux_armv7l.whl

RUN wget https://github.com/lhelontra/tensorflow-on-arm/releases/download/v2.3.0/tensorflow-2.3.0-cp37-none-linux_armv7l.whl


#RUN pip3 install -U --user keras_applications==1.0.8 --no-deps
#RUN pip3 install -U --user keras_preprocessing==1.1.0 --no-deps

#RUN pip3 install cython
#RUN apt-get update && apt-get -y install --no-install-recommends \
#	gcc\
#	g++

#
#RUN wget https://storage.googleapis.com/tensorflow/raspberrypi/tensorflow-2.3.0-cp35-none-linux_armv7l.whl
#
#RUN pip3 install --upgrade pip
#RUN pip3 install cython
#RUN pip3 install --upgrade setuptools
#RUN pip3 install gprcio
#RUN apt-get -y install libpcap-dev libpq-dev
#RUN pip3 install grpcio
#RUN apt-get -y install --no-install-recommends python-dev
#RUN python3 -m pip install --upgrade setuptools
#RUN python3 -m pip install --no-cache-dir grpcio==1.16.1
#RUN pip3 install --upgrade setuptools
#RUN pip3 install --upgrade pip
#RUN pip3 install --upgrade wheel

### List Modules
## pip 20.2.4
RUN pip3 --version && sleep 7s 
## 3.7.3 [python itself no works]
RUN python3 --version && sleep 7s
## Manylinux compatiability
##RUN cat /usr/local/bin/_manylinux.py && sleep 7s
RUN pip3 list  && sleep 12s

## just building the grpcio module... its annoying.
#RUN apt-get update && apt-get -y install --no-install-recommends \
#	build-essential\

#RUN python3 -m pip install grpcio

#RUN pip3 install -v --no-cache-dir --global-option="--pyprof" --global-option="--cpp_ext" --global-option="--cuda_ext" ./
#RUN pip3 install --only-binary ":all:" grpcio==1.27.1
#RUN pip3 install grpcio==1.27.1

RUN pip3 install tensorflow-*.whl
#RUN pip3 install tensorflow-2.3.0-cp35-none-linux_armv7l.whl
RUN rm *.whl
