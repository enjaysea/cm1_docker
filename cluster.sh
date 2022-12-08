# Set up base OS environment
yum -y update && yum -y install scl file gcc gcc-gfortran gcc-c++ glibc.i686 libgcc.i686 \
 libpng-devel hostname m4 make perl tar bash time wget which zlib \
 zlib-devel openssh-clients openssh-server net-tools libgfortran  \
 sudo epel-release git emacs-nox ack fftw-devel

# Get 3rd party EPEL builds of netcdf and openmpi dependencies
yum -y install netcdf-openmpi-devel.x86_64 netcdf-fortran-openmpi-devel.x86_64 \
 netcdf-fortran-openmpi.x86_64 openmpi.x86_64 openmpi-devel.x86_64 \
 && yum clean all

# Get the cm1 source code
#git clone https://github.com/enjaysea/cm1r21 /home/centos/cm1

mkdir -p /home/centos/.openmpi 
echo 'btl=tcp,self' > /home/centos/.openmpi/mca-params.conf
echo 'plm_rsh_no_tree_spawn=1' >> /home/centos/.openmpi/mca-params.conf
echo 'btl_base_warn_component_unused=0' >> /home/centos/.openmpi/mca-params.conf
echo 'pml=ob1' >> /home/centos/.openmpi/mca-params.conf 
		   
# Build the root .bashrc file
echo 'export PS1="\e[0;92m\u\e[0;95m \$PWD \e[m"' >> /root/.bashrc
echo 'export EDITOR=emacs' >> /root/.bashrc
echo 'alias l="ls -l"' >> /root/.bashrc 
echo 'alias em="emacs -nw"' >> /root/.bashrc 
echo 'alias cls="clear"' >> /root/.bashrc 
echo 'alias nobak="rm -rf *~"' >> /root/.bashrc 

# Change to the normal user
su centos
cd ~

# Build the user .bashrc file
echo 'export PS1="\e[0;92m\u\e[0;95m \$PWD \e[m"' >> /home/centos/.bashrc
echo 'export NETCDF=/home/centos/.netcdf_links' >> /home/centos/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/lib64/openmpi/lib' >> /home/centos/.bashrc
echo 'export LDFLAGS=-lm' >> /home/centos/.bashrc
echo 'export EDITOR=emacs' >> /home/centos/.bashrc
echo 'alias l="ls -l"' >> /home/centos/.bashrc 
echo 'alias em="emacs -nw"' >> /home/centos/.bashrc 
echo 'alias cls="clear"' >> /home/centos/.bashrc 
echo 'alias nobak="rm -rf *~"' >> /home/centos/.bashrc 

# Set up netcdf
mkdir /home/centos/.netcdf_links 
ln -sf /usr/include/openmpi-x86_64/ /home/centos/.netcdf_links/include 
ln -sf /usr/lib64/openmpi/lib /home/centos/.netcdf_links/lib 


