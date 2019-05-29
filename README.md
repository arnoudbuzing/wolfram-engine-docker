# Wolfram Engine for Docker

## Summary

The Wolfram Engine for Docker allows you to run the Wolfram Language in an interactive REPL (Read-Evaluate-Print-Loop). 

The first part of the instructions below show how you can use the Dockerfile (from https://github.com/arnoudbuzing/wolfram-engine-docker) to create a Docker image configured to run the Wolfram Engine conveniently on your machine. It downloads and installs the official Wolfram Engine (for Linux) from Wolfram Research. After the image is created you will need to run it once to activate it with your Wolfram ID and password that you used to sign up for your Free Wolfram Engine for Developer license. This creates a password file which you can copy to your host machine and use for subsequent launches of the Wolfram Engine.

The second part of the instructions show how you can get a prebuilt Wolfram Engine docker image directly from https://hub.docker.com/r/arnoudbuzing/wolframengine and run it locally on your machine.

The Wolfram Engine gives you full access to the Wolfram Language. See:

* https://www.wolfram.com/language, for an overview of the Wolfram Language
* https://www.wolfram.com/language/fast-introduction-for-programmers/en/, for a getting started tutorial
* https://reference.wolfram.com, for full reference documentation of the Wolfram Language

Please note that the Free Wolfram Engine for Developer is licensed software, subject to the Terms of Use listed here:
* http://www.wolfram.com/legal/terms/wolfram-engine.html

To use the Wolfram Engine you will need to sign up for a (free) developer license, which can be obtained here:
* https://www.wolfram.com/developer-license

The developer license requires the creation of a Wolfram ID and acceptance of the Terms of Use.

## Creating a Wolfram Engine docker image, using the Dockerfile

### 1. Clone this repository

Open  a shell and change to a directory that you normally use for GitHub repositories. Then clone the following repository.

Using ssh:

```
git clone git@github.com:arnoudbuzing/wolfram-engine-docker.git
```

Or using https:

```
git clone https://github.com/arnoudbuzing/wolfram-engine-docker.git
```

### 2. Run the Dockerfile to build the Wolfram Engine image

Change the directory to the repo directory:

```
cd wolfram-engine-docker
```

Build the docker image. You should replace `yourname` with your name and increment the version if you make additional custom changes to the Dockerfile:

```
docker build -t yourname/wolframengine:1.0 .
```

At this point Docker will configure a base Ubuntu image with various packages required by the Wolfram Engine. It will also download a copy of the Wolfram Engine from the Wolfram Research web site, and install it. This whole process may take 5-10 minutes to complete.

## Using the prebuilt Wolfram Engine docker image

Instead of building the Wolfram Engine using the Dockerfile you can also download a prebuilt Wolfram Engine docker image directly from https://hub.docker.com/r/arnoudbuzing/wolframengine. In a command line issue the following command:

```
> docker pull arnoudbuzing/wolframengine
```

## Activating and running the Wolfram Engine

The following steps are required whether you built the Wolfram Engine docker image yourself or using the prebuilt Wolfram Engine docker image from Docker Hub.

### 1. Run the Docker image to activate the Wolfram Engine

Visit https://wolfram.com/developer-license first to get a license for the Free Wolfram Engine for Developers. You will be asked to sign up for a Wolfram ID and to accept the terms of use.

To activate the Wolfram Engine you need to start the docker image you just created. Again, replace `yourname` with your name and type your own Wolfram ID instead of `yourwolframid@example.com` and type your own password as well at the password prompt

After the Wolfram Engine activates, type `$PasswordFile` at the `In[1]` prompt and hit enter. The output will show you the location of the password file. Next, at the `In[2]` prompt, type `$PasswordFile // FilePrint` to print the content of the password file. Next, at the `In[3]` prompt type Quit and hit enter to quit the Wolfram Engine.

```
> docker run -it yourname/wolframengine:1.0
The Wolfram Engine requires one-time activation on this computer.

Visit https://wolfram.com/developer-license to get your free license.

Wolfram ID: yourwolframid@example.com
Password:
Wolfram Engine activated. See https://www.wolfram.com/wolframscript/ for more information.
Wolfram Language 12.0.0 Engine for Linux x86 (64-bit)
Copyright 1988-2019 Wolfram Research, Inc.

In[1]:= $PasswordFile

Out[1]= /root/.WolframEngine/Licensing/mathpass

In[2]:= $PasswordFile // FilePrint
1e1d781ed0a3    6520-03713-97466        4304-2718-2K5ATR        5095-179-696:2,0,8,8:80001:20190627

In[3]:= Quit
```

Because Docker images start 'clean' every time, this password information is lost when you restart and run the image again. For this reason we need to copy the password information to the host machine, where it can be stored persistently.

### 4. Copy the password file to the host machine

On the host machine, create a `Licensing` directory which will hold the password file:

```
mkdir Licensing
```

With a text editor, create a file called `mathpass` and copy and paste the password (the output from `In[2]` above) into it. Save the file. You should now have a file called `mathpass` in the `Licensing` directory and this `mathpass` file contains a single line with four fields. These four fields, for informational purposes, represent the machine name, a unique machine identifier, your activation key and the password.

### 5. Run the Wolfram Engine using the password file

To launch the Wolfram Engine with the password file from the host machine, use the `-v` option to make the `./Licensing` directory available to the docker image under `/root/.WolframEngine/Licensing`. In the command below replace `yourname` with your name. If everything works correctly, you should now be able to launch this Docker image over and over and you can use this as a starting point to customize things for your development project.

```
> docker run -it -v ./Licensing:/root/.WolframEngine/Licensing yourname/wolframengine:1.0
Wolfram Language 12.0.0 Engine for Linux x86 (64-bit)
Copyright 1988-2019 Wolfram Research, Inc.

In[1]:= $MachineName

Out[1]= 861d2b5cd33f

In[2]:= $Version

Out[2]= 12.0.0 for Linux x86 (64-bit) (May 19, 2019)
```

Note that the password for the Free Wolfram Engine for Developer has an expiration date. When the actual date is close to the expiration date, the Wolfram Engine will automatically re-activate itself. However, you will need to copy the newer password from the `$PasswordFile` again to the hostmachine `mathpass` file (basically repeating step 3 and 4 above).

Also note that activating a Wolfram Engine docker image uses up one of the two activation keys that were assigned to you when you signed up for the Free Wolfram Engine for Developer license.

