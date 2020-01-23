#
# Geant4 DAMIC simulation docker container
# base on root (6.12) build over an ubuntu (16.04)
#
FROM rootproject/root-ubuntu16:latest

LABEL author="nuria.castello.mor@gmail.com" \
    version="1.0" \
    description="Docker image for GEANT4 DAMICM development"

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
#       -DCMAKE_BUILD_TYPE=Debug \
       -Wno-dev \
#       -DGEANT4_INSTALL_DATADIR=/data/geant4-10.4.1/data \
#       -DGEANT4_USE_FREETYPE=ON \
    && make -j`grep -c processor /proc/cpuinfo` \
    && make install \
    && echo '. /usr/local/bin/geant4.sh' >> ~damicmuser/.bashrc \
    && /bin/bash -c ". /usr/local/bin/geant4.sh" \
#    && echo "source /usr/local/bin/geant4.sh" >> ~damicmuser/.bashrc \
    && chown damicmuser:damicmuser ~damicmuser/.bashrc \
    && chown -R damicmuser:damicmuser /opt/geant4.10

RUN mkdir /home/damicmuser/scripts && chown -R damicmuser:damicmuser /home/damicmuser/scripts \
    && mkdir /home/damicmuser/G4104Source && chown -R damicmuser:damicmuser /home/damicmuser/G4104Source \
    && mkdir /home/damicmuser/G4104Run && chown -R damicmuser:damicmuser /home/damicmuser/G4104Run

RUN echo 'export PATH=${PATH}:/home/damicmuser/G4104Run/build' >>  ~damicmuser/.bashrc  \
    && chown damicmuser:damicmuser ~damicmuser/.bashrc 

#COPY my_scripts/compile_DAMICMG4_in_docker.sh /home/damicmuser/scripts

#### setting vim preferences
#COPY settingvim/vim /home/damicmuser/.vim
#COPY settingvim/vimrc /home/damicmuser/.vimrc
#RUN chown -R damicmuser:damicmuser /home/damicmuser/.vim \
#	&& chown damicmuser:damicmuser /home/damicmuser/.vimrc

USER damicmuser
WORKDIR /home/damicmuser
ENV HOME=/home/damicmuser
RUN touch /home/damicmuser/.pythonrc
ENV PYTHONSTARTUP=/home/damicmuser/.pythonrc
ENV PATH=${PATH}:/home/damicmuser/.local/bin

ENTRYPOINT ["/bin/bash"]

