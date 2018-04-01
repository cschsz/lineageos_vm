# lineageos_vm
Setting up the VM to compile LineageOS

### operating system
ubuntu-mate-16.04.4-desktop-amd64.iso  
sudo apt-get install mailutils ssmtp vim  

### setup vim
git clone https://github.com/cschsz/cfg ~/cfg  
cd ~/cfg  
./install.sh  
cd ~  

### setup email
sudo vim /etc/ssmtp/ssmtp.conf  
sudo vim /etc/ssmtp/revaliases  

### vim ~/.bashrc
export GITHUB_USER_EMAIL=  
export GITHUB_USER_NAME=  
export BUILD_DONE_EMAIL=  
