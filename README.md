## GitLab_CICD_Instructor (Shell-Executor)

 1. Above all, please ensure there is already a machine(Linux
    preferred), where ***Docker and git are installed***.
 2. Get your own project runnable, with ***dockerfile inside***. And the dockerfile covers two steps: *maven build* and *jar encapsulation*, an example can refer to: [Dockerfile-Springboot-Maven-Example](https://github.com/saLeox/GitLab_CICD_Instructor/blob/main/Dockerfile).
 3. Make GitLab as your ***Code Repository***.
 4. [***Install GitLab Runner***](https://docs.gitlab.com/runner/install/linux-manually.html) on your CI/CD machine, and the whole process will be performed in following way:
![](https://raw.githubusercontent.com/saLeox/photoHub/main/20210423172908.png)
 
 5. Get the ***Runner Token*** info from the access:

		 Project -> Setting -> CI/CD -> Runner -> Expand. 
	You have better close the ***shared runner*** as the same time.
	 ![](https://raw.githubusercontent.com/saLeox/photoHub/main/1619171272.jpg)

<div align=left><img src="https://raw.githubusercontent.com/saLeox/photoHub/main/20210423175046.png" width="50%"/></div>

 6. Register the runner via the ***interactive commond***.
	```
	sudo gitlab-runner register
	```
	![](https://raw.githubusercontent.com/saLeox/photoHub/main/20210423175745.png)
Two key points here: *tags* & *executor*:

> 	***Tags***: Specify the purpose the current runner, corresponding to the tags for each stage defined in the .gitlab-ci.yml.  The CICD job will be distributed to specific runner, only when there is a ***match***.
> 
> ***Executor***: Enable Docker commands for your CI/CD jobs. [Shell executor](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html#use-the-shell-executor) is used for EC2 instance, while  [The Docker executor with the Docker image (Docker-in-Docker)](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html#use-the-docker-executor-with-the-docker-image-docker-in-docker) is suitable in the context of Kubernate or other Docker orchestration tools.

 7. ***Write .gitlab-ci.yml*** to configure your CI/CD Job.
Ideal process of CICD should look like below:![](https://raw.githubusercontent.com/saLeox/photoHub/main/20210423181206.png)

	[***A simple example***](https://github.com/saLeox/GitLab_CICD_Instructor/blob/main/gitlab-ci.yml) is provided here. Including two steps: Buid && Deploy.

	***Build***: Make sure you already login your DockerHub account before Push.
	
	***Deploy***: Remember to stop and remove the old version containers you want to deploy, them also remove their images.

 8. ***Run the Pipeline*** and wait for the result.
 ![](https://raw.githubusercontent.com/saLeox/photoHub/main/20210423182602.png)
