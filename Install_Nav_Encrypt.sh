#Install Nav encrypt
echo -e "[myrepo]\n\
name=myrepo\n\
baseurl=http://10.2.1.4/navenc/\n\
enabled=1\n\
gpgcheck=0" >/etc/yum.repos.d/sunrepo.repo

sudo rpm --import http://10.2.1.4/navenc/gpg_gazzang.asc


wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y epel-release-latest-7.noarch.rpm


sudo yum install -y kernel-headers-$(uname -r) kernel-devel-$(uname -r)
#sudo yum install -y kernel-uek-headers-$(uname -r) kernel-uek-devel-$(uname -r)

wget ftp://ftp.icm.edu.pl/vol/rzm6/linux-oracle-repo/OracleLinux/OL6/UEKR3/latest/x86_64/kernel-uek-headers-3.8.13-26.el6uek.x86_64.rpm

yum install -y kernel-uek-headers-3.8.13-26.el6uek.x86_64.rpm

wget http://yum.oracle.com/repo/OracleLinux/OL6/UEKR4/x86_64/getPackage/libdtrace-ctf-0.8.0-1.el6.x86_64.rpm
yum install  -y libdtrace-ctf-0.8.0-1.el6.x86_64.rpm

 wget ftp://ftp.icm.edu.pl/vol/rzm6/linux-oracle-repo/OracleLinux/OL7/UEKR4/x86_64/kernel-uek-devel-4.1.12-94.8.3.el7uek.x86_64.rpm

 sudo yum install -y kernel-uek-devel-4.1.12-94.8.3.el7uek.x86_64.rpm

#wget http://rpmfind.net/linux/epel/testing/7/ppc64le/Packages/d/dkms-2.6.1-1.el7.noarch.rpm
#yum install -y dkms-2.6.1-1.el7.noarch.rpm
# sudo yum install gcc

#Make sure no errors return from below.May have to install gcc.DKMS may not be required
sudo yum -y install navencrypt
sudo chkconfig --level 235 navencrypt-mount on
sudo chkconfig --level 235 ntpd on

echo -e "mypasswordiscloudera\n""mypasswordiscloudera"|sudo navencrypt register --server=https://kts-63e1d7f9.cdh-cluster.suntest:11371 --passive-server=https://kts-f9a97ea9.cdh-cluster.suntest:11371 --org="SunTestOrg" --auth="6sCALE2NmoHXZzpst7H3WA==" --skip-ssl-check --key-type=single-passphrase

#Attach disks to machine
# Check new devices with command" dmesg | grep SCSI "

mkdir -p /navencrypt/secure_yarn
echo -e "mypasswordiscloudera"|sudo /usr/sbin/navencrypt-prepare /dev/sdn /navencrypt/secure_yarn


# Move YARN data

echo -e "mypasswordiscloudera"| sudo navencrypt-move encrypt @yarn_usercache /data1/yarn/usercache/ /navencrypt/secure_yarn/

#Repeat for all

 navencrypt set -m permissive