# Docker installations - mainly for Jupyter & Data Science
## Content
### [1. Docker setup in Windows 10 with docker-machine (i.e. *not* Docker for Windows)](./docker-machine.md)
### [2. Creating a powerful docker machine for Data Science + Jupyter docker container](./jupyter-stacks.md)
### [3. Another (more powerfull and all-inclusive) container for data Science](./toward-data-science.md)


### Files in this folder
* `commands.txt` - clipboard file used for useful commands (in my setup)
* `jupyter-docker-stacks.pdf` - PDF file downloaded from jupyter stacks official page
* `README.md` - this file 
* `docker-machine.md` - docker-machine setup (1)
* `jupyter-stacks.md` - (2)
* `toward-data-science.md` - (3)
* `Dockerfile` - the Dockerfile from (3)

### Useful Links - some are specific to my setup, but all are worth a reading
* Yes, you can docker in Windows 7 (https://stefanscherer.github.io/yes-you-can-docker-on-windows-7/)
* Details about docker-machine for wmware workstation (https://github.com/pecigonzalo/docker-machine-vmwareworkstation)
* Chocolatey repository links: 
  * (https://chocolatey.org/packages/docker) - ignore the "deprecated"
  * (https://chocolatey.org/packages/docker-machine)
  * (https://chocolatey.org/packages/docker-machine-vmwareworkstation)
  * (https://chocolatey.org/packages/docker-compose) - `docker-compose` may be needed
  * (https://chocolatey.org/packages/docker-toolbox) - this is `docker-toolbox` for VirtualBox setups. *Please don't mix too many packages*
* Read the docs about jupyter stacks (made by the jupyter team) - (https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html)
* Select the stack from Docker Hub - (https://hub.docker.com/u/jupyter)
* Evheniy Bystov image from towardsdatascience (https://towardsdatascience.com/docker-for-data-science-9c0ce73e8263)
* A nice tutorial for using Docker and Anaconda (http://www.science.smith.edu/dftwiki/index.php/Tutorial:_Docker_Anaconda_Python_--_4)
#### Not included in my setup, but very useful
* Torus : A Toolkit For Docker-First Data Science - (https://medium.com/manifold-ai/torus-a-toolkit-for-docker-first-data-science-bddcb4c97b52). This was not included in my setup
