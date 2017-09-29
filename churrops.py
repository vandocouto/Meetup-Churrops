import subprocess
import re

# get command
command_terraform = subprocess.Popen(["./deploy.sh", "ec2-churrops/", "output"], stdout=subprocess.PIPE)
output=str(command_terraform.communicate())
ips=str(output.split(','))

replaced = re.sub('[n|a-z|A-Z|\'=\[()\\\\/\],'']', '', ips).split(' ')
lan=(replaced[2][0:-1])
wan=(replaced[4][0:-1])

print (lan, wan)

 # generate file hosts
file = open("ansible/churrops/hosts", "w")
file.write("[docker-engine]\n\
%s  hostname=churrops\n\
[all:vars]\n\
docker_swarm_port=2377\n\
ansible_ssh_user=ubuntu\n\
ansible_ssh_private_key_file=../../ec2-churrops/key-pairs/churrops.pem\n\
##\n\
vaultaddr=https://vault.churrops.com:8200\n\
ipvault=10.0.1.66\n\
vault=vault.churrops.com\n\
##\n\
registry=registry.churrops.com\n\
jenkinsuser=admin\n\
lan=%s\n\
" %(wan,lan
   ))
