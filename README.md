## CM1 Docker image
To build a cm1r21.0 image

If you have CM1 on your local disk, then:

1) Edit the file cm1_create_local and make these two changes:
--> Replace '/mnt/f/cm1r21.0' with the location of your CM1 directory
--> Replace '/mnt/f/cm1' with the location on disk to your data directory
The data directory is where CM1 will look for the namelist.input file and where it will write the output files
2) Run cm1_refresh_local

Otherwise if you'd like an image that includes the source inside it rather than referring to an external location:

1) Edit the file cm1_create_local and make these two changes:
--> Replace '/mnt/f/cm1' with the location on disk to your data directory
The data directory is where CM1 will look for the namelist.input file and where it will write the output files
2) Run cm1_refresh_complete

Both of these procedures will drop you into the container when successfully completed.

3) From inside the container, the data will be in /base/common

The container will already have a fully built CM1 at /base/cm1/run/cm1. However, if you need to rebuild it:
1) Go to /base/cm1/src
2) Change the Makefile or any of the Fortran code, if desired
3) Run 'make'
4) The executable should now exist: /base/cm1/run/cm1.exe
5) Rename it to /base/cm1/run/cm1 to avoid having to add the .exe extension when running it



