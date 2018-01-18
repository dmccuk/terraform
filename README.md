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
  * files/script.sh: ```MAIL=`sudo cat /tmp/ip.dm | mailx -s "Hello from "$HOSTNAME your@email.com` ```
  * Update the region you want to build in:
```
variable "region" {
    default = "eu-west-1"
}
```

## Running Terraform to build in AWS

First we should run Terraform plan. This will check our code for syntax and report any issue. If it runs clean it will give you some outout showing you you are ready to proceed.

```
# terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed. Cyan entries are data sources to be read.

Note: You didn't specify an "-out" parameter to save this plan, so when
"apply" is called, Terraform can't guarantee this is what will execute.

+ aws_instance.web
    ami:                          "ami-c90195b0"
    associate_public_ip_address:  "<computed>"
    availability_zone:            "<computed>"
    ebs_block_device.#:           "<computed>"
    ephemeral_block_device.#:     "<computed>"
    instance_state:               "<computed>"
    instance_type:                "t2.micro"
    ipv6_addresses.#:             "<computed>"
    key_name:                     "dmccuk"
    network_interface.#:          "<computed>"
    network_interface_id:         "<computed>"
    placement_group:              "<computed>"
    primary_network_interface_id: "<computed>"
    private_dns:                  "<computed>"
    private_ip:                   "<computed>"
    public_dns:                   "<computed>"
    public_ip:                    "<computed>"
    root_block_device.#:          "<computed>"
    security_groups.#:            "1"
    security_groups.1894743826:   "ssh_and_web"
    source_dest_check:            "true"
    subnet_id:                    "<computed>"
    tags.%:                       "1"
    tags.Name:                    "opsmotion"
    tenancy:                      "<computed>"
    vpc_security_group_ids.#:     "<computed>"


Plan: 1 to add, 0 to change, 0 to destroy.
[root@fed-25 terraform]# 
```

Now, once the plan completes successfully, we can run terraform apply and 
$ terraform apply
```

Once it's created and you set up and email, you will be able to visit the public webpage from the IP address you've been sent.

 * Ubuntu AMI's users are either ubuntu or root
 * Red Hat AMI user is ec2-user
Login like this:

ssh ec2-user@IPADDR -i /path/to/your/.pem
ssh ubuntu@IPADDR -i /path/to/your/.pem

When you're finished, remember to remove the instance:

 terraform destroy

Enjoy...
