import subprocess
import re

# get command
command_terraform = subprocess.Popen(["./deploy.sh", "ec2-swarm/", "output"], stdout=subprocess.PIPE)
output=str(command_terraform.communicate())
ips=str(output.split(','))
print (ips)

replaced = re.sub('[n|a-z|A-Z|\'=\[()\\\\/\],'']', '', ips).split(' ')
masterip1=(replaced[2][0:-1])
managerip1=(replaced[3])
managerip2=(replaced[4][0:-1])
workerip1=(replaced[6])
workerip2=(replaced[7])
workerip3=(replaced[8][0:-1])
masteriplocal=(replaced[10])

print (masteriplocal)


# generate file hosts
file = open("ansible/swarm/hosts", "w")
file.write("[docker-engine]\n\
%s  hostname=master1\n\
%s  hostname=master2\n\
%s  hostname=master3\n\
%s  hostname=worker1\n\
%s  hostname=worker2\n\
%s  hostname=worker3\n\
[master]\n\
%s\n\
[manager]\n\
%s\n\
%s\n\
[worker]\n\
%s\n\
%s\n\
%s\n\
[all:children]\n\
docker-engine\n\
master\n\
manager\n\
worker\n\
[all:vars]\n\
docker_swarm_addr=%s\n\
docker_swarm_port=2377\n\
jenkinsuser=admin\n\
ipvault=10.0.1.66\n\
vault=vault.churrops.com\n\
ipregistry=10.0.1.174\n\
registry=registry.churrops.com\n\
dockerlogin=churrops\n\
ansible_ssh_user=ubuntu\n\
ansible_ssh_private_key_file=../../ec2-swarm/key-pairs/swarm.pem\n\
" %(masterip1,
    managerip1,
    managerip2,
    workerip1,
    workerip2,
    workerip3,
    masterip1,
    managerip1,
    managerip2,
    workerip1,
    workerip2,
    workerip3,
    masteriplocal
    ))
