FROM centos:7
MAINTAINER nick@centanni.com

# Set up base OS environment
RUN yum -y update && yum -y install scl file gcc gcc-gfortran gcc-c++ glibc.i686 libgcc.i686 \
 libpng-devel hostname m4 make perl tar bash time wget which zlib \
 zlib-devel openssh-clients openssh-server net-tools libgfortran  \
 sudo epel-release git emacs-nox ack

# Get 3rd party EPEL builds of netcdf and openmpi dependencies
RUN yum -y install netcdf-openmpi-devel.x86_64 netcdf-fortran-openmpi-devel.x86_64 \
 netcdf-fortran-openmpi.x86_64 openmpi.x86_64 openmpi-devel.x86_64 \
 && yum clean all

RUN groupadd cm1 -g 1000
RUN useradd -u 1000 -g cm1 -G wheel -M -d /cm1 cm1user

RUN git clone https://github.com/enjaysea/cm1 /cm1 

RUN mkdir -p /cm1/.openmpi 
RUN echo btl=tcp,self > /cm1/.openmpi/mca-params.conf \
 && echo plm_rsh_no_tree_spawn=1 >> /cm1/.openmpi/mca-params.conf \
 && echo btl_base_warn_component_unused=0 >> /cm1/.openmpi/mca-params.conf \
 && echo pml=ob1 >> /cm1/.openmpi/mca-params.conf 

COPY README.md /cm1/README.md

RUN sed -i '11,14 s/^ *#//' /cm1/src/Makefile \
 && sed -i '79,82 s/^ *#//' /cm1/src/Makefile 

RUN mkdir -p /cm1/output \
 && chmod 6755 /cm1/output \
 && chown -R cm1user:cm1 /cm1 

# 
# Finished with root tasks
#
USER cm1user
WORKDIR /cm1

RUN echo export 'PS1="\e[0;92m\u\e[0;95m \$PWD \e[m"' >> /cm1/.bashrc \
 && echo 'alias l="ls -l"' >> /cm1/.bashrc \
 && echo 'alias em="emacs -nw"' >> /cm1/.bashrc \
 && echo 'alias cls="clear"' >> /cm1/.bashrc \
 && echo 'alias nobak="rm -rf *~"' >> /cm1/.bashrc 

RUN mkdir /cm1/.netcdf_links \
 && ln -sf /usr/include/openmpi-x86_64/ /cm1/.netcdf_links/include \
 && ln -sf /usr/lib64/openmpi/lib /cm1/.netcdf_links/lib 

ENV LD_LIBRARY_PATH /usr/lib64/openmpi/lib
ENV PATH .:/usr/lib64/openmpi/bin:$PATH
ENV NETCDF /cm1/.netcdf_links
ENV LDFLAGS -lm
ENV EDITOR emacs

RUN cd /cm1/src \
 && make \
 && make clean \
 && mv /cm1/run/cm1.exe /cm1/run/cm1
 
CMD ["/bin/bash"]

