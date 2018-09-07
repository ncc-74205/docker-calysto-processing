FROM jupyter/scipy-notebook

USER $NB_UID
RUN mkdir /home/$NB_USER/tmp

# Install Calysto Processing
RUN	pip install --upgrade calysto_processing --user && \
	python3 -m calysto_processing install --user

# Download and extract Processing
user root
RUN cd /tmp && \
    wget http://download.processing.org/processing-3.4-linux64.tgz && \
    tar zxvf processing-3.4-linux64.tgz -C /usr/local/

USER $NB_UID

# Ensure processing-java command can be used from anywhere
ENV PATH="/usr/local/processing-3.4:${PATH}"

RUN mkdir /home/$NB_USER/processing
RUN mkdir /home/$NB_USER/java
RUN mkdir /home/$NB_USER/octave
RUN mkdir /home/$NB_USER/cpp

ADD --chown=1000:100 getstarted-processing.ipynb /home/$NB_USER/processing
ADD --chown=1000:100 getstarted-java.ipynb /home/$NB_USER/java
ADD --chown=1000:100 getstarted-octave.ipynb /home/$NB_USER/octave
ADD --chown=1000:100 getstarted-cpp.ipynb /home/$NB_USER/cpp

# Install JDK >= 9 and Octave
user root

ENV JAVA_HOME=/usr
RUN apt-get update
RUN apt-get install -y --no-install-recommends openjdk-11-jdk-headless octave gnuplot ghostscript
RUN apt-get clean

# Download and extract IJava kernel from SpencerPark

RUN cd /tmp && \
    wget https://github.com/SpencerPark/IJava/releases/download/v1.1.2/ijava-1.1.2.zip && \
    unzip ijava-1.1.2.zip && \
    python install.py --sys-prefix
    
USER $NB_UID

# Install Octave kernel
RUN conda config --add channels conda-forge
RUN conda install octave_kernel

# Install xeus-cling kernel
RUN conda create -n cling
# RUN source activate cling
RUN conda install xeus-cling notebook -c QuantStack -c conda-forge

# Remove unused folders
RUN rm -r /home/$NB_USER/tmp
RUN rm -r /home/$NB_USER/work
