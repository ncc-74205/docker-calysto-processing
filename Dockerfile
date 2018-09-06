FROM jupyter/scipy-notebook

USER $NB_UID
RUN mkdir /home/$NB_USER/tmp

# Install Calysto Processing
RUN	pip install --upgrade calysto_processing --user && \
	python3 -m calysto_processing install --user

# Download and extract Processing
RUN cd /tmp && \
    wget http://download.processing.org/processing-3.4-linux64.tgz && \
    tar zxvf processing-3.4-linux64.tgz -C /home/$NB_USER/

# Ensure processing-java command can be used from anywhere
ENV PATH="/home/$NB_USER/processing-3.4:${PATH}"

USER $NB_UID
