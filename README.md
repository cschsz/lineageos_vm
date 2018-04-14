# lineageos_vm
Setting up the VM to compile LineageOS

13.0 (setup_cm130.txt):
* espresso3g
* golden

14.1 (setup_cm141.txt):
* gtaxllte+gtaxlwifi
* kminilte
* santoswifi

### operating system
ubuntu-mate-16.04.4-desktop-amd64.iso  
sudo apt-get install mailutils ssmtp vim cifs-utils

### setup vim
git clone https://github.com/cschsz/cfg ~/cfg  
cd ~/cfg  
./install.sh  
cd ~  

### setup network (host-only adapter)
sudo mkdir /media/upload  
sudo mkdir /media/roms  
sudo vim /etc/fstab  
//192.168.56.1/upload /media/upload  cifs  guest,uid=1000,iocharset=utf8  0  0  
//192.168.56.1/roms /media/roms  cifs  guest,uid=1000,iocharset=utf8  0  0  
sudo mount -a  

### setup email
sudo vim /etc/ssmtp/ssmtp.conf  
sudo vim /etc/ssmtp/revaliases  

### vim ~/.bashrc
export GITHUB_USER_EMAIL=  
export GITHUB_USER_NAME=  
export BUILD_DONE_EMAIL=  
