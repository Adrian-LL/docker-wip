# docker-wip for Jupyter + Docker
>Work In Progress for Docker

>I intend to put here the steps I used for my docker setup in Windows 10 *without* using Docker for Windows (i.e. without using Hyper-V).

> Using `docker-machine`
## 1. Installed according Stefan Scherer's article (here: https://stefanscherer.github.io/yes-you-can-docker-on-windows-7/)
My setup:
* Windows 10 Pro
* Vmware Workstation 15
* NOT using Hyper-V (installed, but not enabled via bcedit)

### Commands used:
> NOTE - all the commands are execute inside `Powershell` with administrative access
```ps
choco install -y docker
choco install -y docker-machine
choco install -y docker-machine-vmwareworkstation
```
The next one was not in the article above, but is needed for more advanced setups:
```ps
choco install -y docker-compose
```

By default the machines will be created in a folder `.docker` in user profile home

 * `$env:USERPROFILE` if in Powershell, 
 * `%USERPROFILE%` if in cmd.

### Move folder to another disk / location
To move on another disk create a junction first for `.docker` folder.
Put whatever path you need. 

I used and external SSD. The junction survives.

```ps
docker-machine rm -f default
rm $env:USERPROFILE\.docker
mkdir D:\docker
cmd /c mklink /J $env:USERPROFILE\.docker D:\docker

```
> NOTE(S)
> * For some reason the windows `ssh` (based on open-ssh) does not really work , but `docker-machine` has a native ssh option, i.e. `--native-ssh`, so use it (you may have an error such as `Waiting for SSH to be available...` or `cannot establish SSH session(...)` or something like these.
>
> * More shells (or in this case Powershell windows) may be needed. In that case be sure to run `docker-machine env | iex` in each new terminal window.

```ps
docker-machine --native-ssh create -d vmwareworkstation default
docker-machine env | iex

```

## IP Address of the Virtual Machine
> NOTE - because with this setup the docker engine run in a VM in vmware, the IP address of the machine is important.
```ps
docker-machine ip
```
### SSH into VM
See the above remark about Windows ssh not working.

`default` is the name of the machine built above.
```bash
docker-machine --native-ssh ssh default
```

### Daily starting (and stopping) routine:
See below. If you have multiple docker machines use the name of the respective machine. 
Without parameters it will assume `default`.

```bash
docker-machine --native-ssh start
# after starting:
docker-machine env | iex
# when finishing work
docker-machine stop
```

## 2. Installing and Running a Jupyter Stack - See the next document

## 3. Useful docker commands
```docker
docker build -t friendlyhello .  # Create image using this directory's Dockerfile
docker run -p 4000:80 friendlyhello  # Run "friendlyname" mapping port 4000 to 80
docker run -d -p 4000:80 friendlyhello         # Same thing, but in detached mode
docker container ls                                # List all running containers
docker container ls -a             # List all containers, even those not running
docker container stop <hash>           # Gracefully stop the specified container
docker container kill <hash>         # Force shutdown of the specified container
docker container rm <hash>        # Remove specified container from this machine
docker container rm $(docker container ls -a -q)         # Remove all containers
docker image ls -a                             # List all images on this machine
docker image rm <image id>            # Remove specified image from this machine
docker image rm $(docker image ls -a -q)   # Remove all images from this machine
docker login             # Log in this CLI session using your Docker credentials
docker tag <image> username/repository:tag  # Tag <image> for upload to registry
docker push username/repository:tag            # Upload tagged image to registry
docker run username/repository:tag                   # Run image from a registry
```