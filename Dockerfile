FROM ubuntu:16.04

ENV NSPAWN_BOOTSTRAP_IMAGE_SIZE=10GB

# install apt + npm dependencies
RUN apt-get update && \
  apt-get install --yes \
    locales \
    build-essential \
    software-properties-common \
    apt-transport-https \
    curl \
    wget \
    git \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    gfortran -y && \
  ln -s /bin/gzip /usr/bin/gzip && \
  wget -P /tmp/ "https://repo.continuum.io/miniconda/Miniconda2-4.7.10-Linux-x86_64.sh" && \
  bash "/tmp/Miniconda2-4.7.10-Linux-x86_64.sh" -b -p /usr/local/anacapa/miniconda

ENV PATH "/usr/local/anacapa/miniconda/bin:${PATH}"

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get install -y nodejs && \
  npm i dat -g

RUN locale-gen en_US.UTF-8

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# install python modules
RUN pip install --upgrade pip && \
  pip install biopython==1.76 cutadapt && \
  conda config --add channels r && \
  conda config --add channels defaults && \
  conda config --add channels conda-forge && \
  conda config --add channels bioconda

RUN conda update --all -c defaults

RUN conda install -c bioconda obitools

RUN conda install -c bioconda bowtie2

RUN conda install -c bioconda cogent

RUN conda install -c bioconda blast

RUN conda install -c conda-forge libiconv

RUN conda install -c anaconda pandas

RUN conda install -c bioconda fastx_toolkit

RUN apt-get install --yes zlib1g-dev libgit2-dev

RUN conda install -c conda-forge r=3.4.1

# copy local installation_script files
COPY anacapa_installation_scripts /usr/local/anacapa_installation_scripts

ENV PATH "/usr/local/anacapa_installation_scripts/miniconda/lib/R/bin:${PATH}"

RUN Rscript --vanilla /usr/local/anacapa_installation_scripts/install-deps.R

RUN Rscript --vanilla /usr/local/anacapa_installation_scripts/install-deps-bioconductor.R

RUN ln -s /bin/tar /bin/gtar && \
  Rscript --vanilla /usr/local/anacapa_installation_scripts/install-deps-dada2.R

RUN wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.11.0+-x64-linux.tar.gz && \
  tar -xvzf ncbi-blast-2.11.0+-x64-linux.tar.gz && \
  rm ncbi-blast-2.11.0+-x64-linux.tar.gz

RUN conda install ecopcr

#RUN git clone https://git.metabarcoding.org/obitools/ecopcr && \
#  cd /ecopcr/src && \
#  make

RUN git clone https://github.com/JungbluthLab/Anacapa && \
  chmod +x /Anacapa/Anacapa_db/muscle

RUN wget https://zenodo.org/record/2602180/files/anacapa.tar.gz?download=1 && \
  tar -xvzf anacapa.tar.gz\?download\=1 && \
  mv /anacapa/Anacapa_db/CO1 /Anacapa/Example_data/CO1_custom_run && \
  rm anacapa.tar.gz\?download\=1

RUN echo "AAAAB"

RUN git clone https://github.com/JungbluthLab/CRUX_Creating-Reference-libraries-Using-eXisting-tools

# WORKDIR "/Anacapa/Anacapa_db"

WORKDIR "/CRUX_Creating-Reference-libraries-Using-eXisting-tools/crux_db"
