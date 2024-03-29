FROM centos:7
MAINTAINER nick@centanni.com

# Set up base OS environment
RUN yum -y update && yum -y install scl file gcc gcc-gfortran gcc-c++ glibc.i686 libgcc.i686 \
 libpng-devel hostname m4 make perl tar bash time wget which zlib \
 zlib-devel openssh-clients openssh-server net-tools libgfortran  \
 sudo epel-release git emacs-nox ack fftw-devel

# Get 3rd party EPEL builds of netcdf and openmpi dependencies
#RUN yum -y install netcdf-openmpi-devel.x86_64
#RUN yum -y install netcdf-fortran-openmpi-devel.x86_64
#RUN yum -y install netcdf-fortran-openmpi.x86_64 
#RUN yum -y install openmpi.x86_64 
#RUN yum -y install openmpi-devel.x86_64

# For M1 hardware
RUN yum -y install netcdf-openmpi-devel.aarch64
RUN yum -y install netcdf-fortran-openmpi-devel.aarch64
RUN yum -y install netcdf-fortran-openmpi.aarch64
RUN yum -y install openmpi.aarch64
RUN yum -y install openmpi-devel.aarch64

RUN yum -y install gdb
RUN yum clean all

RUN groupadd cm1 -g 1000
RUN useradd -u 1000 -g cm1 -G wheel -M -d /base cm1user

RUN mkdir -p /base \
 && chmod 6755 /base 

RUN git clone https://github.com/enjaysea/cm1r21.0.git /base/cm1
RUN chown -R cm1user:cm1 /base

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

# Intel hardware
#RUN mkdir /base/.netcdf_links \
# && ln -sf /usr/include/openmpi-x86_64/ /base/.netcdf_links/include \
# && ln -sf /usr/lib64/openmpi/lib /base/.netcdf_links/lib 

# ARM hardware
RUN mkdir /base/.netcdf_links \
 && ln -sf /usr/include/openmpi-aarch64/ /base/.netcdf_links/include \
 && ln -sf /usr/lib64/openmpi/lib /base/.netcdf_links/lib 

ENV LD_LIBRARY_PATH /usr/lib64/openmpi/lib
ENV PATH .:/usr/lib64/openmpi/bin:$PATH
ENV NETCDF /base/.netcdf_links
ENV LDFLAGS -lm
ENV EDITOR emacs

RUN cd /base/cm1/src \
 && sed -i '80s/$/ -g -fbacktrace/' Makefile \
 && make \
 && make clean \
 && mv /base/cm1/run/cm1.exe /base/cm1/run/cm1
 
CMD ["/bin/bash"]
