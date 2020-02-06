FROM tensorflow/tensorflow:1.15.2-py3

# The installation of R was taken from multiple sources:
# - https://github.com/openanalytics/r-base/blob/master/Dockerfile
# - https://stackoverflow.com/questions/54239485/add-a-particular-version-of-r-to-a-docker-container
# - https://cran.r-project.org/bin/linux/ubuntu/README.html
# - https://github.com/noisebrain/Dockerfiles/blob/0668df74b27f514dab19a7afae6715328de72980/Rstudio-server-aib/rstudio-server-aib.dockerfile
# - https://linuxize.com/post/how-to-install-r-on-ubuntu-18-04/

# This is here to force R to use a specific mirror (and not ask where we are during installation)
ENV DEBIAN_FRONTEND noninteractive
ENV CRAN_URL https://cloud.r-project.org/

# This is here to force a specific version of R to be installed
ENV R_BASE_VERSION 3.6.1

# This is for installing R
RUN	apt-get -y install \
	apt-transport-https software-properties-common && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \ 
	add-apt-repository -y 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'  && \
	apt-get -y update && \
        apt install -y --no-install-recommends --no-install-suggests \
	            r-base=${R_BASE_VERSION}* \
	            r-base-dev=${R_BASE_VERSION}* \
	            r-recommended=${R_BASE_VERSION}* 

# This is for installing devtools
RUN	apt-get -y install \
# These are for being able to install devtools dependencies
	libxml2-dev libssl-dev libcurl4-openssl-dev && \ 
# This installs devtools and its dependencies: ideally, should fix version of devtools (but then need to assemble dependency list on our own)
	R -e "install.packages('devtools', dependencies=TRUE, repos='http://cran.rstudio.com/')"

# This is for installing GSL
RUN	apt-get -y install \
		libgsl-dev

RUN	R -e "install.packages('RcppCNPy', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
	R -e "install.packages('idr', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
	R -e "BiocManager::install('MAST', ask=FALSE)" && \
	R -e "BiocManager::install('DESeq2', ask=FALSE)" && \
	R -e "BiocManager::install('biomaRt', ask=FALSE)" && \
	R -e "BiocManager::install('scran', ask=FALSE)" && \
	R -e "BiocManager::install('scRNAseq', ask=FALSE)" && \
	R -e "BiocManager::install('SIMLR', ask=FALSE)" && \
	R -e "BiocManager::install('zinbwave', ask=FALSE)"

RUN	pip install rpy2 pandas matplotlib sklearn IPython

# Step 05: add git repositories
RUN	apt-get -y install git

RUN	mkdir -p /scVI && \
	cd /scVI && \
	git clone https://github.com/gvrocha/scVI-reproducibility.git &&\
	git clone https://github.com/gvrocha/scVI-container.git

# Step 06: more R packages
# copula requires gmp which requires GMP C library and Rmpfr which requires mpfr.h, see:
# https://stackoverflow.com/questions/22277440/in-r-using-ubuntu-try-to-install-a-lib-depending-on-gmp-c-lib-it-wont-find-g/26451979
# https://stackoverflow.com/questions/28868789/error-when-trying-to-install-rmpfr-in-r-related-to-the-header-file-mpfr-h
RUN	apt-get -y install libgmp3-dev libmpfr-dev && \
	R -e "install.packages('ADGofTest', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
	R -e "install.packages('gsl', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
	R -e "install.packages('pspline', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
	R -e "install.packages('copula', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
	R -e "BiocManager::install('scone', ask=FALSE)"

# Step 07: scripts for dowloading, organizing and preprocessing data:
ENV	OUTDIR	/base/scVI-data

RUN	apt-get -y install wget && \
	mkdir -p ${OUTDIR}/reorganized/originals && \
	unzip /scVI/scVI-reproducibility/additional/data.zip PBMC/*   -d ${OUTDIR}/reorganized/originals && \
	unzip /scVI/scVI-reproducibility/additional/data.zip RETINA/* -d ${OUTDIR}/reorganized/originals && \
	unzip /scVI/scVI-reproducibility/additional/data.zip HEMATO/* -d ${OUTDIR}/reorganized/originals && \
	mkdir -p ${OUTDIR}/reorganized/originals/CORTEX && \
	wget -v -O ${OUTDIR}/reorganized/originals/CORTEX/expression_mRNA_17-Aug-2014.txt https://storage.googleapis.com/linnarsson-lab-www-blobs/blobs/cortex/expression_mRNA_17-Aug-2014.txt

