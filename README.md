## CM1 Docker image
This is George Bryan's **CM1 Numerical Model, Release 20.3  (cm1r20.3)  25 June 2021**  based on a Centos 7 (Linux) image. The container opens with  **CM1** already built and installed. But the source and all necessary packages are also included so it can be rebuilt as necessary.

Since the output data can become very sizable and would be lost if the container is stopped, it should be diverted to a location on your local file system. This is optional but highly recommended. The alternative is to copy the data to your system after it's been written. However, you'd then have two copies of the data until the container was stopped and its volume purged with the Docker prune command.

If you run this container on a Windows 10 system, the second option may be your only choice, unless some clever person can answer the dilemma described below in the **Windows Caveat** discussion. 

Having said that, I run it on Windows myself, but within a WSL Linux shell. [WSL is a free virtualization subsystem](https://docs.microsoft.com/en-us/windows/wsl/install-win10)  built-in to Windows 10.

### Building the container
If you pulled this container directly from **hub.docker.com** then you can skip this step and go to the section: **Starting the container**.

If you are starting from my github repo, all that you will have in your local folder is the Dockerfile and this readme file, so you will need to build the container first. To do so, enter the command:
```
docker build -t cm1 .
```
This will take several minutes, so this is a good time to enjoy a tasty refreshment.

### Starting the container 
This is how you start the container with an output folder synced to a local directory on your system. **Do not** create the output folder yourself prior to running this command. The command will create it for you, and with the correct owner and folder permissions.
```
docker run -id --name <desired_name> -v <host_output_dir>:/cm1/output cm1 (or enjaysea/cm1)
```
For example, if you want your output folder to be **/home/weather/output** and want to name the container **cm1** the command would be:
```
docker run -id --name cm1 -v /home/weather/output:/cm1/output cm1
```
You can specify a location relative to your starting directory by using the **$(pwd)** variable if using Mac or Linux. Be sure to add quotes around this variable if your current directory has any spaces in it. For instance, if you want the output directory to be **/home/weather center/output** and you're issuing the command from **/home/weather center**, the command would be:
```
docker run -id --name cm1 -v "$(pwd)"/output:/cm1/output cm1
```
After the command successfully completes, the ID of the container is displayed on the command line. You don't need to take note of it because you can see the ID plus any other information about the container by using the command
```
docker ps

CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
850c51b72bb7   cm1       "/bin/bash"   11 seconds ago   Up 10 seconds             cm1
```
Once the container is started using this method it stays running on your machine until you either explicitly stop it or you reboot your system.

### Windows caveat
This volume mapping only works (well) on a Mac or Linux shell. When I've tried it on Windows, the output folder mapping is created, however the corresponding folder within the container is owned by root, which prevents the **CM1** data from being written. I've worked through about a dozen proposed solutions for this undesirable effect, but none of them worked. 

Do you have a solution?  [Email me](mailto:nick@centanni.com) and clue me in!

### Using the container
Now that the container has been created and is available on your system, it's time to log into the container's shell and start working.
```
docker exec -it cm1 /bin/bash
```
This command will leave you on a command line within the container. You're now running a Centos 7 image with **CM1** pre-installed.

### Running CM1

To direct the data output to your mapped output folder you must be in that directory before you start the program:
```
cd output
```
If you run **CM1** from this directory then all the output will be stored here, and will also be available on the mapped output folder on your local disk. 

You will need, at a minimum, the **namelist.input** file in this directory before running **CM1** or it will complain that it's missing, and exit.
```
cp /cm1/run/namelist.input /cm1/output
```
Make any changes you'd like to **namelist.input**. I always change the **output_format** to **2** and the **output_filetype** to **1** so the output is stored in a single **netcdf** format file compatible with both **VIsit** and **Vapor**. After learning how to use **CM1** you'll undoubtedly have a certain set of changes to the file that you'll know well.
 
You may also find that other files from the run directory are needed depending on what you're doing. If so just copy them over before starting, for example:
```
cp ../run/LANDUSE.TBL . 
```
The executable is in the run directory, so to start the program type:
```
../run/cm1
```
You should see a flurry of output scrolling down your screen. That's good. That means it's running ok. Type **CTRL-C** to exit.

If you'd like to speed things up you can make use of your computer's available CPU cores by indicating the number of cores you'd like to devote to the task after the **-n** in the following launch command (the example uses 2 cores):
```
mpirun -n 2 ../run/cm1
```

Once everything checks out, you can search up one of the many fine tutorials out there which teach you how to use **CM1**.  There is also a wealth of information provided by the author contained in the various README files in the /cm1 directory.

### Rebuilding CM1
To rebuild the system you can go into the **/cm1/src** directory, make any changes you need, then rebuild with 
```
make
```
Keep in mind that the Makefile creates the executable as **cm1.exe**. You can run it with that name, or change it back to just **cm1** which is what this Dockerfile does after it builds the system.
