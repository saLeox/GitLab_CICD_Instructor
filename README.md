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

<div align=center><img src="https://raw.githubusercontent.com/saLeox/photoHub/main/20210423175046.png" width="40%"/></div>

 6. Register the runner via the ***interactive commond***.
	```
	sudo gitlab-runner register
	```
	![](https://raw.githubusercontent.com/saLeox/photoHub/main/20210423175745.png)
Two key points here: *tags* & *executor*:

> 	***Tags***: Specify the purpose the current runner, corresponding to the tags for each stage defined in the .gitlab-ci.yml.  The CICD job will be distributed to specific runner, only when there is a ***match***.
> 
> ***Executor***: Enable Docker commands for your CI/CD jobs. [Shell executor](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html#use-the-shell-executor) is used for EC2 instance, while  [The Docker executor with the Docker image (Docker-in-Docker)](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html#use-the-docker-executor-with-the-docker-image-docker-in-docker) is suitable in the context of Kubernate or other Docker orchestration tools.

Execute the command to ***start runner***

	    sudo gitlab-runner start ##start
	    sudo gitlab-runner stop ##stop
	    sudo gitlab-runner restart  ##restart
	    sudo gitlab-runner --debug run ##debug


7. ***Write .gitlab-ci.yml*** to configure your CI/CD Job.

	Ideal process of CICD should look like below:![](https://raw.githubusercontent.com/saLeox/photoHub/main/20210423181206.png)

	[***A simple example***](https://github.com/saLeox/GitLab_CICD_Instructor/blob/main/gitlab-ci.yml) is provided here. Including two steps: Buid && Deploy.

	***Build***: Make sure you already login your DockerHub account before Push.
	
	***Deploy***: Remember to stop and remove the old version containers you want to deploy, them also remove their images.


 8. ***Run the Pipeline*** and wait for the result.

	 After that, don't forget to check whether the application is running or not.
 ![](https://raw.githubusercontent.com/saLeox/photoHub/main/20210423182602.png)
 
 
 9. ***Best practice for Optimization*** 
 
	 The first time to perform the CI/CD job will be slow since there is a need to pull the maven images and pull the maven dependency resources.

	 - [ ] Have better ***use the local installed Docker*** instead of
	       Docker image pulled from Docker, since the maven repo and images
	       can be stored in fixed place, so that will be reused in next
	       time.

	 - [ ] If import any image in gitlab-ci.yml, some settings should be
	       appended at the end of ***/etc/gitlab-runner/config.toml***.

		```
	    [runners.docker]
	      ...
	    volumes = ["/cache", "/root/maven/.m2/:/root/.m2"]
	    pull_policy = ["if-not-present"]
		```

		 *The **first config** aims to store the maven repo in fixed place by using volumn, so that it doesn't matter even the maven image will change from time to time.
		 The **second config** changes the docker pull policy, enable to reuse existing images. Can refer to the official statement as below:*

		> The always pull policy will ensure that the image is always pulled. When always is used, the Runner will try to pull the image even if a local copy is available. If the image is not found, then the build will fail.

	 - [ ] Before deployment, you can delete all the old version images, but
	       please ***exclude the latest one*** that generated just now. Otherwise,
	       need to pull from dockerhub again. Detail showed in the code as following:
	       
		``` 
		if [ "$(docker images -a | grep $IMAGE_PREFIX | grep -v $CI_COMMIT_SHORT_SHA)" ]
		``` 

	 - [ ] Optimize the ***docker images building*** process:
		 - [ ] Import ***lightweight basic image***, such as Alpine, of which lots of language or framework build on the top.
		 - [ ] Make the core of ***image as small as possible***, for example, use class file rather than java file.
		 - [ ] Combine the continous ***RUN***  commands by "&&".
		 - [ ] Apply ***multi-stages building*** strategy, make full use of ***cahce***, since it can help save effor, if there are same interlayers from the begining, no matter in image build, pull, or push process. At the same time, you can also only ***extract the needed stuff*** from previous layer.  
			 **SpringBoot multi layer build in docker tutorial is [provided](https://www.baeldung.com/docker-layers-spring-boot) inside.*
			 
			In practice, you can should notice:
			<div align=left><img src="https://raw.githubusercontent.com/saLeox/photoHub/main/20210425150805.png" width="60%"/></div>

			<div align=left><img src="https://raw.githubusercontent.com/saLeox/photoHub/main/20210425151329.png" width="60%"/></div>

***This is the end, cheer up forks!***
