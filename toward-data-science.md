# Building a docker container that has everything (and more) required for Data Science projects (and expecially Kaggle)

I had big problems using data science python stacks such:
- trouble with installing tensorflow under Windows (as for now works only with Python 3.6 -- and I had 3.7). Even after using Python 3.6 I got errors.
- missing libraries
- more memory and/or CPU needed
- kaggle docker image din not run for me...
- etc.

So I found these on the internet:
## References:
* https://towardsdatascience.com/docker-for-data-science-9c0ce73e8263
* http://www.science.smith.edu/dftwiki/index.php/Tutorial:_Docker_Anaconda_Python_--_4

## My setup
### 1st Option - pull the image
```bash
docker login
docker pull evheniy/docker-data-science
```
Output should look something as below:
```
Using default tag: latest
latest: Pulling fromevheniy/docker-data-science
cc1a78bfd46b: Pull complete 
314b82d3c9fe: Pull complete 
adebea299011: Pull complete 
f7baff790e81: Pull complete 
Digest: sha256:e07b9ca98ac1eeb1179dbf0e0bbcebd87701f8654878d6d8ce164d71746964d1
Status: Downloaded newer image for evheniy/docker-data-science:latest

```
### 2nd Option - build image locally starting with given Dockerfile

```bash
# Dockerfile
# We will use Ubuntu for our image
FROM ubuntu:latest

# Updating Ubuntu packages
RUN apt-get update && yes|apt-get upgrade
RUN apt-get install -y emacs

# Adding wget and bzip2
RUN apt-get install -y wget bzip2

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
RUN wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
RUN bash Anaconda3-5.0.1-Linux-x86_64.sh -b
RUN rm Anaconda3-5.0.1-Linux-x86_64.sh

# Set path to conda
#ENV PATH /root/anaconda3/bin:$PATH
ENV PATH /home/ubuntu/anaconda3/bin:$PATH

# Updating Anaconda packages
RUN conda update conda
RUN conda update anaconda
RUN conda update --all

# Configuring access to Jupyter
RUN mkdir /home/ubuntu/notebooks
RUN jupyter notebook --generate-config --allow-root
RUN echo "c.NotebookApp.password = u'sha1:6a3f528eec40:6e896b6e4828f525a6e20e5411cd1c8075d68619'" >> /home/ubuntu/.jupyter/jupyter_notebook_config.py

# Jupyter listens port: 8888
EXPOSE 8888

# Run Jupyter notebook as Docker main process
CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/home/ubuntu/notebooks", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
```
> Notes 
> - I made a small modification, i.e. using `--ip=0.0.0.0` instead of the original one that did not work for me. See original line below.
```bash
CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/home/ubuntu/notebooks", "--ip='*'", "--port=8888", "--no-browser"]
```
> * I also got warnings about building a non-windows image on a windows host. If one intents to put this docker image on a public server, maybe the permissions should be re-checked.