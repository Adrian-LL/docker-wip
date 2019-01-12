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
