# Meetup Churrops on DevOps


### AWS AccessKey e SecretAccessKey

Para iniciar o projeto é necessário que exportar as seguintes variáveis:

* export AWS_ACCESS_KEY_ID=""
* export AWS_SECRET_ACCESS_KEY=""
* export AWS_DEFAULT_REGION=""

### Scritp deploy.sh 

* Para executar o projeto AWS Terraform será necessário utilizar o script deploy.sh.
* Para executá-lo, basta informar os seguintes parâmetros:

    - diretório: (vpc - ec2-vault - ec2-churrops - ec2-swarm)
    - Comando: (init - plan - apply)
        
### Create - AWS VPC (Criando a VPC) 

#### Terraform

Create


    ./deploy.sh vpc init
    ./deploy.sh vpc plan
    ./deploy.sh vpc apply



#### Launch - ec2-vault (Vault Server)
 
Keys

    ./deploy.sh ec2-vault/key-pairs/ init
    ./deploy.sh ec2-vault/key-pairs/ plan
    ./deploy.sh ec2-vault/key-pairs/ apply
    
    
EC2

    ./deploy.sh ec2-vault/ init
    ./deploy.sh ec2-vault/ plan
    ./deploy.sh ec2-vault/ apply
    

#### Ansible

Orquetrando o ambiente do Vault

    python vault.py
    cd ansible/vault/
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts ./tasks/main.yml
  

#### Vault Server

Configurando o Vault Server

    cd ../../
    ssh -i ec2-vault/key-pairs/vault.pem ubuntu@54.210.216.229
    sudo su
    cd /docker-compose/vault/
    export VAULT_ADDR='https://vault.churrops.com:8200'
    
Vault - init 
    
    vault init -tls-skip-verify
    
    Unseal Key 1: EFDCNqb659qFKtj8A5vUFzIUcWolkVMy9kNSNz7aoJHw
    Unseal Key 2: Fv9nLeH8u4NkLjJml8YpYJmyjYPXpFSR8e5vAB2i1Mhj
    Unseal Key 3: 8vqwecS67PL+4tJkHUo64LF/8K9ZDP4hpTk1J9pqnBcZ
    Unseal Key 4: 3qs9wkAW3ZQdSFeR/Qo3GWc5jgroVuWuANUkFFHhwGWW
    Unseal Key 5: 2D0va6DCfIMl8vq2v2+BxJEhDsFw3EPr9Pk+sVhBL1yM
    Initial Root Token: 49623e42-d9a8-488c-03e4-dd49149563f0

    Vault initialized with 5 keys and a key threshold of 3. Please
    securely distribute the above keys. When the vault is re-sealed,
    restarted, or stopped, you must provide at least 3 of these keys
    to unseal it again.

    Vault does not store the master key. Without at least 3 keys,
    your vault will remain permanently sealed.
    
Vault - unseal 

    vault unseal -tls-skip-verify EFDCNqb659qFKtj8A5vUFzIUcWolkVMy9kNSNz7aoJHw
    vault unseal -tls-skip-verify Fv9nLeH8u4NkLjJml8YpYJmyjYPXpFSR8e5vAB2i1Mhj
    vault unseal -tls-skip-verify 8vqwecS67PL+4tJkHUo64LF/8K9ZDP4hpTk1J9pqnBcZ

Vault - auth 
    
    vault auth -tls-skip-verify 49623e42-d9a8-488c-03e4-dd49149563f0
    
Vault - Mount backend aws

    vault mount -tls-skip-verify aws
    
    
Vault - Importando para o backend aws o Access_Key Secret_Key 

    vault write -tls-skip-verify aws/config/root access_key="" secret_key="" region="us-east-1"
    
    
Vault - Acessando o diretório build-vault
    
    cd build-vault/

Vault - Importando a policy awspolicy.json para o Vault
    
    vault write -tls-skip-verify aws/roles/awspolicy policy=@awspolicy.json

Vault - Definindo o tempo de concessão (lease) do backend aws
    
    vault write -tls-skip-verify aws/config/lease lease=2h lease_max=2h

Vault - Solicitando/Criando um Access Key/Secret Key na AWS IAM
    
    vault read -tls-skip-verify aws/creds/awspolicy
    
    Key            	Value
    ---            	-----
    lease_id       	aws/creds/awspolicy/c99fb4b7-6606-db3d-a214-81712e156411
    lease_duration 	2h0m0s
    lease_renewable	true
    access_key     	AKIAJX4XENGGD5PGYF4Q
    secret_key     	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
    security_token 	<nil>
    
Vault - Criando o secret jenkins-pass 

    vault write -tls-skip-verify secret/jenkins-pass value=password
    Success! Data written to: secret/jenkins-pass
    
Vault - Criando o secret registry

    vault write -tls-skip-verify secret/registry-pass value=password
    
Vault - Criando o secret jenkinsnode-pass

    vault write -tls-skip-verify secret/jenkinsnode-pass value=password
    


#### Launch - ec2-churrops (Jenkins - Registry)


Keys

    cd ../../
    ./deploy.sh ec2-churrops/key-pairs/ init
    ./deploy.sh ec2-churrops/key-pairs/ plan
    ./deploy.sh ec2-churrops/key-pairs/ apply


EC2


    ./deploy.sh ec2-churrops/ init
    ./deploy.sh ec2-churrops/ plan
    ./deploy.sh ec2-churrops/ apply


# Ansible 

Orquestrando o ambiente do Churrops (jenkins - Registry)

    $ vim churrops.py
  
OBS: Altere a variável ipvault, inserindo o ip privado do Vault Server

Após a orquestração do Ansible, teremos os seguintes serviço disponíveis:

Containers: Jenkins - Registry

    python churrops.py 
    cd ansible/churrops/
    export VAULT_ADDR=https://vault.churrops.com:8200
    vault auth -tls-skip-verify 49623e42-d9a8-488c-03e4-dd49149563f0
    export JPASS=$(vault read -tls-skip-verify -format=json secret/jenkins-pass | jq -r .data.value)
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts ./tasks/main.yml --extra-vars jenkinspass=$JPASS

#### Launch - ec2-swarm (Cluster Docker Swarm)


Voltando dois níveis abaixo:


    cd ../../

Keys

    ./deploy.sh ec2-swarm/key-pairs/ init
    ./deploy.sh ec2-swarm/key-pairs/ plan
    ./deploy.sh ec2-swarm/key-pairs/ apply


EC2

    ./deploy.sh ec2-swarm/ init
    ./deploy.sh ec2-swarm/ plan
    ./deploy.sh ec2-swarm/ apply


ELB
  
    ./deploy.sh ec2-swarm/elb-swarm/ init
    ./deploy.sh ec2-swarm/elb-swarm/ plan
    ./deploy.sh ec2-swarm/elb-swarm/ apply
  
# Ansible

Orquestrando o ambiente do Churrops (jenkins - Registry)

Antes de executar o playbook, altere a variável ipvault e ipregistry

    $ vim churrops.py
  
Gerando o arquivos hosts 

    python swarm.py

Executando o playbook
 
    cd ansible/swarm/
    REGISTRY=$(vault read -tls-skip-verify -format=json secret/registry-pass | jq -r .data.value)
    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts ./tasks/main.yml --extra-vars dockerpass=$REGISTRY
    

# Vault

Carregando a chave swarm.pem (privada)para dentro do Vault Server
 
    cd ../../ec2-swarm/key-pairs/
    vault mount -tls-skip-verify ssh
    vault write -tls-skip-verify ssh/keys/swarm key=@swarm.pem
    vault write -tls-skip-verify ssh/roles/swarm key_type=dynamic key=swarm admin_user=ubuntu default_user=ubuntu cidr_list=10.0.0.0/21
    vault write -tls-skip-verify -format=json ssh/creds/swarm ip=10.0.1.177 ttl=1h | jq -r .data.key > jenkins-vault.pem
    chmod 400 jenkins-vault.pem
    ssh -i jenkins-vault.pem ubuntu@52.207.144.99











