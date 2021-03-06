# Dockerfile
# Updated 2020-09-02
#
# We will use Ubuntu for our image
FROM ubuntu:latest

# Updating Ubuntu packages
RUN apt-get update && yes|apt-get upgrade
RUN apt-get install -y emacs

# Adding wget and bzip2
# Adding also htop (useful) and screenfetch (just for fun)
RUN apt-get install -y wget bzip2 htop screenfetch

# Adding texlive (useful for conversion of .ipynb files to PDF or other formats)
# RUN apt-get install -y texlive-xetex (this may be needed to be uncommented and run twice)
RUN apt-get update --fix-missing
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt-get install -y tzdata 
RUN apt-get install -y texlive-xetex


# Add sudo
RUN apt-get -y install sudo

# Add user ubuntu with no password, add to sudo group
RUN adduser --disabled-password --gecos '' ubuntu
RUN adduser ubuntu sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER ubuntu
WORKDIR /home/ubuntu/
RUN chmod a+rwx /home/ubuntu/
#RUN echo `pwd`

# Anaconda installing
# Latest one in 2020-09-02 - `Anaconda3-2020.07-Linux-x86_64.sh`
# Includes Python 3.8.3
RUN wget https://repo.continuum.io/archive/Anaconda3-2020.07-Linux-x86_64.sh
RUN bash Anaconda3-2020.07-Linux-x86_64.sh
RUN rm Anaconda3-2020.07-Linux-x86_64.sh

# Set path to conda
#ENV PATH /root/anaconda3/bin:$PATH
ENV PATH /home/ubuntu/anaconda3/bin:$PATH

# Updating Anaconda packages
RUN conda update conda
RUN conda update anaconda
RUN conda update --all

# Installing additional libraries
RUN conda install tensorflow keras lightgbm

# Additional libraries with pip
RUN pip install osa xgboost catboost

# Configuring access to Jupyter
RUN mkdir /home/ubuntu/notebooks
RUN jupyter notebook --generate-config --allow-root
RUN echo "c.NotebookApp.password = u'sha1:6a3f528eec40:6e896b6e4828f525a6e20e5411cd1c8075d68619'" >> /home/ubuntu/.jupyter/jupyter_notebook_config.py

# Jupyter listens port: 8888
EXPOSE 8888

# Run Jupyter notebook as Docker main process
CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/home/ubuntu/notebooks", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
