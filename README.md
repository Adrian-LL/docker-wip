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

## 2. Installing Jupyter - TBU
```ps
docker run --rm -p 10000:8888 -e JUPYTER_ENABLE_LAB=yes -v "$PWD":/home/jovyan/work jupyter/datascience-notebook
```
See previous note about IP address, you have to run the browser with this IP address instead of `localhost` or `127.0.0.1`.
