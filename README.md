# docker-wip
Work In Progress for Docker
I intend to put here the steps for my docker setup in Windows 10 *without* using Docker for Windows (i.e. without using Hyper-V)
## 1. Installed according Stefan Scherer's recs (here: https://stefanscherer.github.io/yes-you-can-docker-on-windows-7/)
* Windows 10 Pro
* Vmware Workstation 15
* NOT using Hyper-V (installed, but not enabled via bcedit)
```ps
choco install -y docker
choco install -y docker-machine
choco install -y docker-machine-vmwareworkstation
```
The next one was not in the article above:
```ps
choco install -y docker-compose
```
> NOTE - all inside Powershell with administrative access

Put whatever path you need. I used and external SSD.

```ps
docker-machine rm -f default
rm $env:USERPROFILE\.docker
mkdir D:\docker
cmd /c mklink /J $env:USERPROFILE\.docker D:\docker

```
> NOTE - the first command will not finish, so after the machine is started, hit `ctrl+c` and run the second command.
> One will need usually more than one PS window, so be sure to run `docker-machine env | iex` in each new windows.

```ps
docker-machine --native-ssh create -d vmwareworkstation default
docker-machine env | iex

```

> NOTE - because with this setup the docker engine run in a VM in vmware, the IP address of the machine is important.
```ps
docker-machine ip
```

## 2. Installing Jupyter - TBU (https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html)
**Example 2:** This command pulls the jupyter/datascience-notebook image tagged 9b06df75e445 from Docker Hub if it is not already present on the local host. It then starts an ephemeral container running a Jupyter Notebook server and exposes the server on host port 10000. The command mounts the current working directory on the host as /home/jovyan/work in the container. The server logs appear in the terminal. Visiting http://<hostname>:10000/?token=<token> in a browser loads JupyterLab, where hostname is the name of the computer running docker and token is the secret token printed in the console. Docker destroys the container after notebook server exit, but any files written to ~/work in the container remain intact on the host.:

```ps
docker run --rm -p 10000:8888 -e JUPYTER_ENABLE_LAB=yes -v "$PWD":/home/jovyan/work jupyter/datascience-notebook
```
### Remarks
1. See previous note about IP address, you have to run the browser with this IP address instead of `localhost` or `127.0.0.1`.
2. Because runninh in a VMware VM, the path to local drives is actually something like below (according to https://github.com/docker/for-win/issues/1669)

hostPath:
```ps
"C:\\temp\\soccerdb-pv"
```
~~should be (note `host_mnt`) ~~
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

