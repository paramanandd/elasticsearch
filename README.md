# elasticsearch
## elasticsearch implemntation using Terraform

**Prerequisites:**
```
- AWS account with access keys and secret access key generated for same
- Terraform installed onto machine
- AWS cli installed onto machine
```
###### Steps to implement elasticsearch using terraform on aws account

1. Configure aws credentials on your machine

2. Clone this repo [elasticsearch](https://github.com/paramanandd/elasticsearch)

3. Make sure you generate a ssh key using command ssh-keygen onto the server, the public key should be used while creating the instance Key, and private key should be used for accessing the instance. please refer [SSH-KEYGEN](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-2)

> ![](/files/images/tree.png)

4. `Terraform init` to initialize your resources


5. `terraform plan` will show you the resources which will be created

6.  `terraform apply --auto-approve` will create all the resources


7. Use the `IP` provided by apply command to access the elasticsearch home page for installation

**Note:**
```
1. The resources created are for aws account in us-east reagion, if you make the change please consider using proper ami.
2. I have used t2.micro instance, which leads to 10-15 mins for user data to fully execute and elasticsearch to be accessible over instance IP
```