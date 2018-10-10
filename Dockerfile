#
# Geant4 DAMIC simulation docker container
# base on root (6.12) build over an ubuntu (16.04)
#
FROM rootproject/root-ubuntu16:latest

LABEL author="nuria.castello.mor@gmail.com" \
    version="1.0" \
    description="Docker image for GEANT4 DAMIC simulation"

USER 0

# uid (-u) and group IDs (-g) are fixed to 1000 to be used for development
# purposes
RUN useradd -u 1000 -md /home/damicmuser -ms /bin/bash -G builder,sudo damicmuser \
#    && usermod -a -G builder damicmuser
    && echo "damicmuser:docker" | chpasswd \
    && echo "damicmuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Correct base image to include ROOT python module
ENV PYTHONPATH="${PYTHONPATH}:/usr/local/lib/root"
# Include ROOT libraries
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib/root"

RUN apt-get update && apt-get -y install \
        cmake build-essential \
	    qt4-dev-tools \
        libxerces-c-dev \
        libgl1-mesa-dev \
        libxmu-dev \
        libmotif-dev \
        libexpat1-dev \
        libboost-all-dev \
        xfonts-75dpi \
        xfonts-100dpi \
        imagemagick \
        wget \
        vim \
        tk \
        ipython \
        python-numpy \
        python-scipy \
        python-matplotlib \
        libboost-python-dev \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Download, extract and install DAWN
RUN mkdir /opt/DAWN  \
    && cd /opt/DAWN \
    && wget http://geant4.kek.jp/~tanaka/src/dawn_3_90b.tgz \
    && cd /opt/DAWN \
    && tar -xzf dawn_3_90b.tgz \
    && rm dawn_3_90b.tgz \
    && cd /opt/DAWN/dawn_3_90b \
    && DAWN_PS_PREVIEWER="NONE" \
    && make clean \
    && make guiclean \
    && make \
    && make install \
    && chown -R damicmuser:damicmuser /opt/DAWN \
    && mkdir /opt/DAVID \
    && cd /opt/DAVID \
    && wget http://geant4.kek.jp/~tanaka/src/david_1_36a.taz \
    && tar xzf david_1_36a.taz\
    && rm david_1_36a.taz \
    && cd /opt/DAVID/david_1_36a \
    && make -f Makefile.GNU_g++ \
    && make -f Makefile.GNU_g++ install \
    && chown -R damicmuser:damicmuser /opt/DAVID

# BUILD THE GDML MODULE NEEDS THE XERCESC PARSER PRE-INSTALLED
RUN mkdir -p /opt/XercesC \
    && cd /opt/XercesC \
    && wget http://www-us.apache.org/dist//xerces/c/3/sources/xerces-c-3.2.2.tar.gz \
    && tar -xzf xerces-c-3.2.2.tar.gz\
    && cd xerces-c-3.2.2 \
    && mkdir /opt/XercesC/xerces-c-3.2.2/build && cd /opt/XercesC/xerces-c-3.2.2/build \
    && cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/XercesC/xerces-c-3.2.2/bin /opt/XercesC/xerces-c-3.2.2 \
    && make -j`grep -c processor /proc/cpuinfo` \
    && make install \
    && chown -R damicmuser:damicmuser /opt/XercesC


# Download, extract and install GEANT4
RUN mkdir -p /opt/geant4.10 \
    && cd /opt/geant4.10 \
    && wget http://github.com/Geant4/geant4/archive/v10.4.1.tar.gz \
    && tar -xzf v10.4.1.tar.gz && rm v10.4.1.tar.gz \
    && mkdir /opt/geant4-10-build && cd /opt/geant4-10-build \
    && cmake /opt/geant4.10/geant4-10.4.1 \
       -DGEANT4_BUILD_MULTITHREADED=ON \
       -DGEANT4_USE_QT=ON \
       -DGEANT4_USE_XM=ON \
       -DGEANT4_INSTALL_DATA=ON \
       -DGEANT4_INSTALL_DATA_TIMEOUT=3000 \
       -DGEANT4_USE_QT=ON \
       -DGEANT4_USE_SYSTEM_EXPAT=ON \
       -DGEANT4_USE_OPENGL_X11=ON  \
       -DGEANT4_USE_RAYTRACER_X11=ON \
       -DGEANT4_USE_GDML=ON \
       -Wno-dev \
#       -DGEANT4_INSTALL_DATADIR=/data/geant4-10.4.1/data \
#       -DGEANT4_USE_FREETYPE=ON \
    && make -j`grep -c processor /proc/cpuinfo` \
    && make install \
    && echo '. /usr/local/bin/geant4.sh' >> ~damicmuser/.bashrc \
    && /bin/bash -c ". /usr/local/bin/geant4.sh" \
    && chown damicmuser:damicmuser ~damicmuser/.bashrc \
    && chown -R damicmuser:damicmuser /opt/geant4.10

# Boot and damicm source container with GEANT4 started
WORKDIR /home/damicmuser/G4104Sim

#
USER damicmuser

ENV HOME /home/damicmuser
ENV DAMICM_SIM_ROOT /home/damicmuser/G4104Sim/DamicG4
ENV DAMICM_RUN_DIR $DAMICM_SIM_ROOT/build


ENTRYPOINT ["/bin/bash"]

