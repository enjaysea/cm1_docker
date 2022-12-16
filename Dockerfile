FROM ubuntu:20.04
MAINTAINER nick@centanni.com

#scl file hostname m4 openssh-clients openssh-server net-tools epel-release

#gcc
#gcc-gfortran
#gcc-c++
#glibc.i686
#libgcc.i686 
#libpng-devel
#zlib 
#zlib-devel
#libgfortran 
#netcdf-openmpi-devel.x86_64
#netcdf-fortran-openmpi-devel.x86_64
#netcdf-fortran-openmpi.x86_64
#openmpi.x86_64 openmpi-devel.x86_64

RUN apt update 
RUN apt install -y curl build-essential gfortran

RUN curl -o ./miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN chmod +x ./miniconda.sh
RUN ./miniconda.sh -b -p /opt/conda
ENV PATH .:/opt/conda/bin:$PATH

RUN conda install -y -c conda-forge emacs libnetcdf openmpi

RUN groupadd cm1 -g 1000
RUN useradd -u 1000 -g cm1 -M -d /base cm1user

RUN mkdir /base \
 && chmod 6755 /base \
 && chown -R cm1user:cm1 /base

# 
# Finished with root tasks
#
USER cm1user
WORKDIR /base

RUN echo export 'PS1="\e[0;92m\u\e[0;95m \$PWD \e[m"' >> /base/.bashrc \
 && echo 'alias l="ls -l"' >> /base/.bashrc \
 && echo 'alias em="emacs -nw"' >> /base/.bashrc \
 && echo 'alias cls="clear"' >> /base/.bashrc \
 && echo 'alias nobak="rm -rf *~"' >> /base/.bashrc

ENV LDFLAGS -lm
ENV EDITOR emacs
ENV PATH .:/opt/conda/bin:$PATH

CMD ["/bin/bash"]


