# Installing and Running a Jupyter Stack - TBU 

> NOTE - This is my setup, so running a docker with docker-machine under VMware Workstation. With Docker for Windows some things will slightly change (and easier to use)

## 1. Read the docs...(https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html)

## 2. Get the desired stack from here, e.g. https://hub.docker.com/r/jupyter/datascience-notebook
## 3. Install it
```ps
docker pull jupyter/datascience-notebook
```
> NOTE - `jupyter\tensorflow-notebook` or (`jupyter\scipy-notebook` if tensorflow is not needed...) is better if one works with Python only. It is a little nimbler.
> However, a container with more memory and cores is definitely needed. I got errors even with 4 GB RAM and 4 cores,

Otherwise just do `docker run` command, if the stack is not found locally the `latest` image will be downloaded.

### Again, RTFM

**Example 2:** 
* This command pulls the `jupyter/datascience-notebook` image tagged `9b06df75e445` from Docker Hub if it is not already present on the local host. 
* It then starts an *ephemeral* container running a Jupyter Notebook server and exposes the server on host port 10000. 
* The command mounts the current working directory on the host as `/home/jovyan/work` in the container. 
* The server logs appear in the terminal. 
* Visiting http://<hostname>:10000/?token=<token> in a browser loads JupyterLab, where hostname is the name of the computer running docker and token is the secret token printed in the console. Docker destroys the container after notebook server exit, but any files written to `~/work` in the container remain intact on the host.:

```ps
docker run --rm -p 10000:8888 -e JUPYTER_ENABLE_LAB=yes -v "$PWD":/home/jovyan/work jupyter/datascience-notebook
```
If you want to run the image from docker and give `jovyan` sudo rights.
```ps
docker run --rm -p 10000:8888 -e JUPYTER_ENABLE_LAB=yes -e GRANT_SUDO=yes --user root -v "$PWD":/home/jovyan/work jupyter/datascience-notebook
```

### Remarks
1. See previous note about IP address, you have to run the browser with this IP address instead of `localhost` or `127.0.0.1`. Running with `localhost` works only if Docker for Windows (via Hyper-V) is installed. See below.
2. Because we are running the docker machine in a VMware VM, the path to local drives is actually something like below (according to https://github.com/docker/for-win/issues/1669)

hostPath:
```ps
"C:\\temp\\soccerdb-pv"
```
~~should be (note `host_mnt`)~~

Actualy this is valid only if the mount point already exists. (i.e. `host_mnt/c/... etc`). 
Otherwise it will create the mount point inside the VM, but will not be linked with the actual host machine.

```ps
"/host_mnt/c/temp/soccerdb-pv"
```
~~WIP - still after mounting the path is not writeable.~~

It seems that the VM is automatically mounting `C:\users` with 2 mounting points, that is `\c` and `\Users`.

I tried fiddling with vmware `.vmx` file but what I managed was only to change `C:\users` with `D:\Users` - works for the moment, but I don't understand what's happening.

See the line `sharedFolder.maxNum = "1"`. 

Originally it was `sharedFolder.maxNum = "2"`, after I changed `C:` with `D:` it changed to `1`...

I tried to add from the graphical interface of vmware workstation, but my changes in vmx file did not reflected in the VM.

```bash
sharedFolder0.present = "TRUE"
sharedFolder0.enabled = "TRUE"
sharedFolder0.readAccess = "TRUE"
sharedFolder0.writeAccess = "TRUE"
sharedFolder0.hostPath = "D:\Users\"
sharedFolder0.guestName = "Users"
sharedFolder0.expiration = "never"
sharedFolder.maxNum = "1"
floppy0.present = "FALSE"
tools.upgrade.policy = "useGlobal"
```
So my command was something like below:

```ps
docker run --rm -p 10000:8888 -e JUPYTER_ENABLE_LAB=yes -v /Users:/home/jovyan/work jupyter/datascience-notebook
```
or
```ps
docker run --rm -p 10000:8888 -e JUPYTER_ENABLE_LAB=yes -v /Users:/home/jovyan/work jupyter/tensorflow-notebook
```
> Note that `/Users` in the commands above point to `D:\Users` or whatever was configured in `/vmx` file. For example, if in configuration you put `D:\Users\Adrian\Documents` in `.vmx` (and the mounting is successful) you cannot move above this folder. Inside docker you will have the contents of `Documents` under `work`.

## Command line for creation of another machine with different resources
As told above, for intensive processing more memory and more cores are needed.

According to https://github.com/pecigonzalo/docker-machine-vmwareworkstation

Environment variables and default values:

```
CLI option	    Environment variable	    Default
--vmwareworkstation-boot2docker-url	WORKSTATION_BOOT2DOCKER_URL	Latest boot2docker url
--vmwareworkstation-cpu-count	WORKSTATION_CPU_COUNT	1
--vmwareworkstation-disk-size	WORKSTATION_DISK_SIZE	20000
--vmwareworkstation-memory-size	WORKSTATION_MEMORY_SIZE	1024
--vmwareworkstation-ssh-user	WORKSTATION_SSH_USER	docker
--vmwareworkstation-ssh-password	WORKSTATION_SSH_PASSWORD	tcuser
```

For example, creating a machine named `dev` with 2 CPUs and 4096 MB of memory. 
> NOTE - do not forget `--native-ssh`

```bash
docker-machine --native-ssh create --driver=vmwareworkstation --vmwareworkstation-cpu-count 2 --vmwareworkstation-memory-size 4096 dev
```
