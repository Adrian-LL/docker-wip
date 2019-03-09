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

Based on those, a better data science image can be built (as the skeleton `Dockerfile` was already provided).


## 1st Option - pull the image made by Evheniy
Please note that my image is a little different. I added some additional modules and software.

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
## 2nd Option - build image locally starting with given Dockerfile
### 2nd Option variant - just do `docker pull aludosan/toward-data-science`. 
(This will pull the image created with the `Dockerfile` below. It's pretty big, aroung 11 GiB.)

The `Dockerfile` is pretty simple and easy to understand. See more at the links above in References.

The configuration below runs as `root`, so it's easy to install additional Ubuntu or Python packages during work.

> NOTE: Packages can be added and/or removed based on needs during the session, using the Jupyter terminal. But keep in mind that in this way they will not be persistent.

### TO DO:
* ~~fiddle a little with terminal in Jupyter.~~ (actually one has to run `bash` instead of `sh` - still have to see where to launch it from....)
* ~~install jupyterlab~~ It is installed. Should be launched from command line, or in the brouwser change the last part of URL after launching from `/tree?` (that is standard Jupyter) to `/lab?`. Use the 2nd variant of command line below.

### Install additional programs in Ubuntu and Python libraries 
I updated the `Dockerfile` with more libraries for Data Science (these were not included initially).

Some of them cannot be installed with `conda`, so I made a mix from `conda` and `pip`.

#### For example, for Python I needed (in no particular order):
* `keras`
* `xgboost`
* `catboost`
* `lightgbm`
* `osa`
* etc.

#### Also for Linux (Ubuntu)
* `texlive-xetex` (here I got into some missing packages and had to use `apt-get update --fix-missing`)
* `htop`
* `screenfetch` (just for fun, not actually needed)

Please note that `tzdata` package is hidden in there, and its installation is non-interactive, so one have to use `ENV DEBIAN_FRONTEND=noninteractive` followed by `RUN apt-get install -y tzdata `. This will default to UTC zone.


```bash
# Dockerfile
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
```
> Notes 
> - I made a small modification, i.e. using `--ip=0.0.0.0` instead of the original one that did not work for me. See original line below.
```bash
CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/home/ubuntu/notebooks", "--ip='*'", "--port=8888", "--no-browser"]
```
> * I also got warnings about building a non-windows image on a windows host. If one intents to put this docker image on a public server, maybe the permissions should be re-checked.

#### Build
Assuming you are in the same folder with `Dockerfile`. Otherwise use the `docker build` command options.
```bash
docker build -t toward-data-science .
```

#### Run
Runs the stack with a local folder mounted under `/home/ubuntu/notebooks`.

```bash
docker run --name toward-data-science -p 8888:8888 --env="DISPLAY" -v "$PWD/notebooks:/home/ubuntu/notebooks" -d toward-data-science
```
* This assumes that a folder `notebook` exists in the working directory.
* The command line options and ports can be modified. Read docker command reference. See also the previous `.md` file.
* If run with `docker-machine` the actual IP of the virtual machine should be used (from `docker machine env` command). Otherwise it will run on `localhost`. Also `--env="DISPLAY"` may be dropped in this case.

My actual command:
```bash
 docker run  -it -p 10000:8888  -v "/Users:/home/ubuntu/notebooks"  -d toward-data-science
```
This also works:
```bash
docker run  -it -p 10000:8888 -e JUPYTER_ENABLE_LAB=yes -v "/Users:/home/ubuntu/notebooks"  -d toward-data-science
```

The local directory should be previously mounted in the VM. Stefan setup uses `C:\Users` as default.
