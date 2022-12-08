## CM1 Docker image
To build a cm1r20 image, with the source code built:

1) Copy the file Dockerfile_r20 to Dockerfile
2) Run the script ~/bin/cm1_refresh_r20

To build a cm1r21 image, just the environment, with the source directory mapped to
the local folder f:/cm1r21.0:

1) Copy the file Dockerfile_r21 to Dockerfile
2) Run the script cm1_refresh_r21
3) From inside the container, go to /base/common for data
4) Go to /base/cm1/src to rebuild
4) Run /base/cm1/run/cm1.exe


