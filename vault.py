import subprocess
import re

# get command
command_terraform = subprocess.Popen(["./deploy.sh", "ec2-vault/", "output"], stdout=subprocess.PIPE)
output=str(command_terraform.communicate())
ips=str(output.split(','))

replaced = re.sub('[n|a-z|A-Z|\'=\[()\\\\/\],'']', '', ips).split(' ')
lan=(replaced[2][0:-1])
wan=(replaced[4][0:-1])

print (lan, wan)

 # generate file hosts
file = open("ansible/vault/hosts", "w")
file.write("[vault]\n\
%s  hostname=vault\n\
[all:vars]\n\
ansible_ssh_user=ubuntu\n\
ansible_ssh_private_key_file=../../ec2-vault/key-pairs/vault.pem\n\
lan=%s\n\
fqdn=vault.churrops.com\n\
" %(wan,lan
   ))