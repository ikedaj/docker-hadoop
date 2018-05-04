#!/bin/sh

# generate /etc/ssh/ssh_host_*
ssh-keygen -A

# create hadoop user
useradd -c 'hadoop user' hadoop
su - hadoop -c 'ssh-keygen -q -N "" -t rsa -f /home/hadoop/.ssh/id_rsa'
cp /home/hadoop/.ssh/id_rsa.pub /home/hadoop/.ssh/authorized_keys
chmod 600 /home/hadoop/.ssh/authorized_keys

cat << EOF > /home/hadoop/.ssh/config 
Host *
  User hadoop
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  LogLevel quiet
EOF

chmod 600 /home/hadoop/.ssh/config 
chown -R hadoop:hadoop /home/hadoop/.ssh

# modify pam
sed -i '/pam_loginuid\.so/s/required/optional/' /etc/pam.d/sshd

# modify sshd_config
sed -i 's/.?GSSAPIAuthentication.*$/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/.?PasswordAuthentication.*$/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/.?PermitRootLogin.*$/PermitRootLogin no/g' /etc/ssh/sshd_config

