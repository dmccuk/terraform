# This a basic Terraform setup to launch one AWS EC2 instance.
---
## Pre-Requisites:

1. Install Terraform
2. Have an account on AWS (free Tier if possible)
3. Some basic knowledge of AWS.
  * Creating and using .pem file
  * Setting up basic security groups
  * Creating Access keys and access secrets


## Now on your server (where you have installed Terraform)

```$ git clone 	https://github.com/dmccuk/terraform.git ```

Make the following changes to these files:

Change these values:
  * main.tf:    ```security_groups = ["VALUE"]``` # Use the group-name NOT groupID.
  * main.tf:    ```private_key = "${file("VALUE.pem")}"``` # Use your .pem key to ssh onto the server once created.
  * terraform.tfvars: ```access_key = "VALUE_YOUR_ACCESS_KEY"```
  * terraform.tfvars: ```secret_key = "VALUE_YOUR_SECRET_KEY"```
  * files/script.sh: ```MAIL=`sudo cat /tmp/ip.dm | mailx -s "Hello from "$HOSTNAME your@email.com````
  * Update the region you want to build in:
```  
variable "region" {
    default = "eu-west-1"
}
```

## Running Terraform to build in AWS

```$ terraform plan
$ terraform apply```


Once it's created and you set up and email, you will be able to visit the public webpage from the IP address you've been sent.

 * Ubuntu AMI's users are either ubuntu or root
 * Red Hat AMI user is ec2-user
Login like this:

ssh ec2-user@IPADDR -i /path/to/your/.pem
ssh ubuntu@IPADDR -i /path/to/your/.pem

When you're finished, remember to remove the instance:

 terraform destroy

Enjoy...
