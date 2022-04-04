FROM ubuntu:20.04

# Initial system
RUN apt-get -y update \
    && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install \
    sudo wget unzip zip xvfb ghostscript imagemagick \
    bc dc file libfontconfig1 libfreetype6 libgl1-mesa-dev \
    libgl1-mesa-dri libglu1-mesa-dev libgomp1 libice6 libxt6 \
    libxcursor1 libxft2 libxinerama1 libxrandr2 libxrender1 \
    libopenblas-base language-pack-en \
    openjdk-8-jre \
    python3-pip \
    && \
    apt-get clean

# Install the MCR
RUN wget -nv https://ssd.mathworks.com/supportfiles/downloads/R2019b/Release/6/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2019b_Update_6_glnxa64.zip \
     -O /opt/mcr_installer.zip && \
     unzip /opt/mcr_installer.zip -d /opt/mcr_installer && \
    /opt/mcr_installer/install -mode silent -agreeToLicense yes && \
    rm -r /opt/mcr_installer /opt/mcr_installer.zip

# Install FSL. Env vars first
ENV FSLDIR="/opt/fsl" \
    PATH="/opt/fsl/bin:$PATH" \
    FSLOUTPUTTYPE="NIFTI_GZ" \
    FSLMULTIFILEQUIT="TRUE" \
    FSLTCLSH="/opt/fsl/bin/fsltclsh" \
    FSLWISH="/opt/fsl/bin/fslwish" \
    FSLLOCKDIR="" \
    FSLMACHINELIST="" \
    FSLREMOTECALL=""

# Main download. See https://fsl.fmrib.ox.ac.uk/fsldownloads/manifest.csv
RUN wget -nv -O /opt/fsl.tar.gz https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.5.1-centos7_64.tar.gz && \
    cd /opt && \
    tar -zxf fsl.tar.gz && \
    rm /opt/fsl.tar.gz

# FSL python installer. A clue that we forgot this is an imglob error at runtime
RUN ${FSLDIR}/etc/fslconf/fslpython_install.sh

# Python3 setup
RUN pip3 install pandas fpdf

# Copy the pipeline code
COPY src /opt/gf-fmri/src
COPY matlab /opt/gf-fmri/matlab
COPY README.md /opt/gf-fmri/README.md
COPY ImageMagick-policy.xml /etc/ImageMagick-6/policy.xml

# Matlab env
ENV MATLAB_SHELL=/bin/bash
ENV MATLAB_RUNTIME=/usr/local/MATLAB/MATLAB_Runtime/v97

# Add pipeline to system path
ENV PATH /opt/gf-fmri/src:/opt/gf-fmri/matlab/bin:${PATH}

# Matlab executable must be run at build to extract the CTF archive
RUN run_matlab_entrypoint.sh ${MATLAB_RUNTIME} quit

# Entrypoint
ENTRYPOINT ["gf-fmri.sh"]
