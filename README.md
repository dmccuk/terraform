![Alt text](terraform_472.png?raw=true)
# Getting started with Terraform

In my example, we are going to setup and launch one AWS EC2 instance. Please read the Pre-requisites below and make sure you are happy to proceed.
---
## Pre-Requisites:

1. Install Terraform. (link)[https://www.terraform.io/intro/getting-started/install.html]
2. Have an account on AWS (free Tier if possible).
3. Some basic knowledge of AWS.
  * Creating and download your .pem file.
  * Set up a security group.
  * Create your Access key and access secret (one time creation).
  * Familiarity with the AWS console.

## Now on your server (where you have installed Terraform)

Take a copy of my git repo. It contains all the files you need for this example.

```$ git clone 	https://github.com/dmccuk/terraform.git ```

Make the following changes to these files in the code you have cloned from me in Git:

Change these values:
  * main.tf:    ```security_groups = ["CHANGE_ME"]``` # Use the group-name NOT groupID.
  * main.tf:    ```private_key = "${file("VALUE.pem")}"``` # Use your .pem key here. /dir/name.pem.
  * main.tf:    ```key_name        = "CHANGE_ME"``` # Insert your key name.
  * terraform.tfvars: ```access_key = "VALUE_YOUR_ACCESS_KEY"``` # Add your access key
  * terraform.tfvars: ```secret_key = "VALUE_YOUR_SECRET_KEY"``` # Add your secret key
  * files/script.sh: ```MAIL=`sudo cat /tmp/ip.dm | mailx -s "Hello from "$HOSTNAME your@email.com` ```
  * Update the region you want to build in. Check AWS for the syntax for each region:
```
variable "region" {
    default = "eu-west-1"
}
```

## The post build script.sh
I've created a post build script (files/script.sh) that does the following:
  * updates the software of the EC2 instance.
  * installs apache httpd and a couple of other useful programs.
  * Creates the index.html file with a message.
  * Collects your public IP address and emails it back to you (add your email address!)

## Running Terraform to build in AWS

First we should run Terraform plan. This will check our code for syntax and report any issue. If it runs clean it will give you some outout showing you you are ready to proceed. <b>Output below is based on my configuration</b>. If you get errors. please go back and check through your code. I am planning to update some common issues and the bottom of this page so go down and check.

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

Now, once the plan completes successfully, we can run terraform apply and watch our EC2 instance get created:
```
# terraform apply
aws_instance.web: Creating...
  ami:                          "" => "ami-c90195b0"
  associate_public_ip_address:  "" => "<computed>"
  availability_zone:            "" => "<computed>"
  ebs_block_device.#:           "" => "<computed>"
  ephemeral_block_device.#:     "" => "<computed>"
  instance_state:               "" => "<computed>"
  instance_type:                "" => "t2.micro"
  ipv6_addresses.#:             "" => "<computed>"
  key_name:                     "" => "dmccuk"
  network_interface.#:          "" => "<computed>"
  network_interface_id:         "" => "<computed>"
  placement_group:              "" => "<computed>"
  primary_network_interface_id: "" => "<computed>"
  private_dns:                  "" => "<computed>"
  private_ip:                   "" => "<computed>"
  public_dns:                   "" => "<computed>"
  public_ip:                    "" => "<computed>"
  root_block_device.#:          "" => "<computed>"
  security_groups.#:            "" => "1"
  security_groups.1894743826:   "" => "ssh_and_web"
  source_dest_check:            "" => "true"
  subnet_id:                    "" => "<computed>"
  tags.%:                       "" => "1"
  tags.Name:                    "" => "opsmotion"
  tenancy:                      "" => "<computed>"
  vpc_security_group_ids.#:     "" => "<computed>"
aws_instance.web: Still creating... (10s elapsed)
aws_instance.web: Still creating... (20s elapsed)
aws_instance.web: Provisioning with 'file'...
aws_instance.web: Still creating... (30s elapsed)
aws_instance.web: Still creating... (40s elapsed)
aws_instance.web: Still creating... (50s elapsed)
aws_instance.web: Still creating... (1m0s elapsed)
aws_instance.web: Still creating... (1m10s elapsed)
aws_instance.web: Still creating... (1m20s elapsed)
aws_instance.web: Still creating... (1m30s elapsed)
aws_instance.web: Provisioning with 'remote-exec'...
aws_instance.web (remote-exec): Connecting to remote host via SSH...
aws_instance.web (remote-exec):   Host: 59.124.211.129
aws_instance.web (remote-exec):   User: ec2-user
aws_instance.web (remote-exec):   Password: false
aws_instance.web (remote-exec):   Private key: true
aws_instance.web (remote-exec):   SSH Agent: false
aws_instance.web (remote-exec): Connected!
aws_instance.web: Still creating... (1m40s elapsed)
aws_instance.web (remote-exec): Loaded plugins: amazon-id, rhui-lb,
aws_instance.web (remote-exec):               : search-disabled-repos
aws_instance.web (remote-exec): rhui-REGION-clie | 2.9 kB     00:00
aws_instance.web (remote-exec): rhui-REGION-rhel | 3.5 kB     00:00
aws_instance.web (remote-exec): rhui-REGION-rhel | 3.8 kB     00:00
aws_instance.web: Still creating... (1m50s elapsed)
aws_instance.web (remote-exec): (2/7): rhui-REG 0% |    0 B   --:-- ETA

<REDACTED>...

aws_instance.web (remote-exec): Installed:
aws_instance.web (remote-exec):   httpd.x86_64 0:2.4.6-67.el7_4.6
aws_instance.web (remote-exec):   mailx.x86_64 0:12.5-16.el7
aws_instance.web (remote-exec):   mlocate.x86_64 0:0.26-6.el7
aws_instance.web (remote-exec):   wget.x86_64 0:1.14-15.el7_4.1

aws_instance.web (remote-exec): Dependency Installed:
aws_instance.web (remote-exec):   apr.x86_64 0:1.4.8-3.el7_4.1
aws_instance.web (remote-exec):   apr-util.x86_64 0:1.5.2-6.el7
aws_instance.web (remote-exec):   httpd-tools.x86_64 0:2.4.6-67.el7_4.6
aws_instance.web (remote-exec):   mailcap.noarch 0:2.1.41-2.el7
aws_instance.web (remote-exec):   redhat-logos.noarch 0:70.0.3-6.el7

aws_instance.web (remote-exec): Complete!
aws_instance.web (remote-exec): Redirecting to /bin/systemctl start httpd.service
aws_instance.web: Creation complete (ID: i-0b5032c1524883802)

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: 
# 
```
Once created, if you check the AWS console, you will see the EC2 instance available:
![Alt text](aws_console.PNG?raw=true)


Once your new EC2 instance is created you should receive an email. Check your spam filter if it doesn't turn up within a couple of minutes. Your EC2 instance IP address will be inside the email (you can also get the public IP address from the AWS console). Open up you internet browser (chrome :)) and enter the IP address. You should see the following:
![Alt text](aws_webapp.PNG?raw=true)


## Further information:

Depending on the OS you have decided to install (the AMI), you will need to use different users to logins.

 * Ubuntu AMI's users are either ubuntu or root
 * Red Hat AMI user is ec2-user

Login like this:

```$ ssh ec2-user@IPADDR -i /path/to/your/.pem```
```$ ssh ubuntu@IPADDR -i /path/to/your/.pem```

When you're finished, remember to remove the instance:

```# terraform destroy
Do you really want to destroy?
  Terraform will delete all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_instance.web: Refreshing state... (ID: i-0b5032c1524883802)
aws_instance.web: Destroying... (ID: i-0b5032c1524883802)
aws_instance.web: Still destroying... (ID: i-0b5032c1524883802, 10s elapsed)
aws_instance.web: Still destroying... (ID: i-0b5032c1524883802, 20s elapsed)
aws_instance.web: Still destroying... (ID: i-0b5032c1524883802, 30s elapsed)
aws_instance.web: Still destroying... (ID: i-0b5032c1524883802, 40s elapsed)
aws_instance.web: Still destroying... (ID: i-0b5032c1524883802, 50s elapsed)
aws_instance.web: Still destroying... (ID: i-0b5032c1524883802, 1m0s elapsed)
aws_instance.web: Destruction complete

Destroy complete! Resources: 1 destroyed.
# 

```
Checking the A=AWS console, you will see your instance shutdown, before being terminated:

![Alt text](aws_console1.PNG?raw=true)

![Alt text](aws_console2.PNG?raw=true)

Please share with your colleagues and let me know if you found this useful.

Dennis McCarthy
