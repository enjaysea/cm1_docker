FROM ubuntu:20.04
MAINTAINER nick@centanni.com

#scl file hostname m4 openssh-clients openssh-server net-tools epel-release
#gcc-gfortran
#glibc.i686
#libpng-devel
#zlib 
#zlib-devel
#netcdf-openmpi-devel.x86_64
#netcdf-fortran-openmpi-devel.x86_64
#netcdf-fortran-openmpi.x86_64
#openmpi.x86_64 openmpi-devel.x86_64

RUN apt update 
RUN apt install -y curl build-essential

RUN curl -o ./miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN chmod +x ./miniconda.sh
RUN ./miniconda.sh -b -p /opt/conda
ENV PATH .:/opt/conda/bin:$PATH

RUN conda install -y -c conda-forge emacs libnetcdf openmpi bash libgfortran gfortran_linux-64 netcdf-fortran

RUN groupadd cm1 -g 1000
RUN useradd -u 1000 -g cm1 -M -d /base cm1user

RUN mkdir /base \
 && chmod 6755 /base \
 && chown -R cm1user:cm1 /base

RUN mkdir -p /base/.openmpi
RUN echo btl=tcp,self > /base/.openmpi/mca-params.conf \
 && echo plm_rsh_no_tree_spawn=1 >> /base/.openmpi/mca-params.conf \
 && echo btl_base_warn_component_unused=0 >> /base/.openmpi/mca-params.conf \
 && echo pml=ob1 >> /base/.openmpi/mca-params.conf
   
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

RUN mkdir /base/.netcdf_links \
 && ln -sf /opt/conda/include/openmpi /base/.netcdf_links/include \
 && ln -sf /opt/conda/lib/openmpi /base/.netcdf_links/lib 

ENV EDITOR emacs
ENV LD_LIBRARY_PATH /opt/conda/lib
ENV LDFLAGS -lm
ENV NETCDF /base/.netcdf_links

CMD ["/bin/bash"]


