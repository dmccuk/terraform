![Alt text](terraform_472.png?raw=true)
# Getting started with Terraform

In my example, we are going to setup and launch one AWS EC2 instance. Please read the Pre-requisites below and make sure you are happy to proceed.
---
## Pre-Requisites:

1. Install Terraform. [link](https://www.terraform.io/intro/getting-started/install.html)
2. Have an account on AWS (free Tier if possible). [link](https://aws.amazon.com/free)
3. Some basic knowledge of AWS.
  * Creating and download your key pair (.pem file). [link](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
    * Create your Access key and access secret (one time creation). [link](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey)
  * Familiarity with the AWS console.
  * AWS training - I recommend Ryan Kroonemburg on Udemy. [link](https://www.udemy.com/user/ryankroonenburg/)

## Setup instructions

### On your server (where you have installed Terraform)

Create /opt/demo:
````
# mkdir -p /opt/demo
````

Take a copy of my git repo. It contains all the files you need for this example.

```
$ git clone 	https://github.com/opsmotion/terraform.git
```

Make the following changes to these files in the code you have cloned from me in Git:

Change these values:
  * main.tf:    ```private_key = "${file("VALUE.pem")}"``` # Use your .pem key here. /dir/name.pem.
  * main.tf:    ```key_name = "Add_Your_Keypair_name"``` # Insert your pre-configured key name.
  * terraform.tfvars: ```access_key = "VALUE_YOUR_ACCESS_KEY"``` # Add your access key
  * terraform.tfvars: ```secret_key = "VALUE_YOUR_SECRET_KEY"``` # Add your secret key
Optional:
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
  * installs httpd and openscap + a couple of other useful programs.
  * Creates the index.html file with a holding page.
  * Collects your EC2 public IP address and emails it back to you (add your email address!)
  * Run openscap and produces a report (both Pre and post report under .../html/reports

## Running Terraform to build in AWS

First, initiate Terraform in your working directory:
````
# terraform init

Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "aws" (1.8.0)...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.aws: version = "~> 1.8"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
````

Next we run Terraform plan. This will check our code for syntax and report any issue. If it runs clean it will give you some outout showing you you are ready to proceed. <b>Output below is based on my configuration</b>. If you get errors. please go back and check through your code. I am planning to update some common issues and the bottom of this page so go down and check.

<details>
 <summary>Expand for output</summary>
  <p>
   
```
# terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

aws_instance.web: Refreshing state... (ID: i-6188dced)

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + aws_instance.web
      id:                                    <computed>
      ami:                                   "ami-c90195b0"
      associate_public_ip_address:           <computed>
      availability_zone:                     <computed>
      ebs_block_device.#:                    <computed>
      ephemeral_block_device.#:              <computed>
      instance_state:                        <computed>
      instance_type:                         "t2.micro"
      ipv6_address_count:                    <computed>
      ipv6_addresses.#:                      <computed>
      key_name:                              "dmccuk.pem"
      network_interface.#:                   <computed>
      network_interface_id:                  <computed>
      placement_group:                       <computed>
      primary_network_interface_id:          <computed>
      private_dns:                           <computed>
      private_ip:                            <computed>
      public_dns:                            <computed>
      public_ip:                             <computed>
      root_block_device.#:                   <computed>
      security_groups.#:                     "1"
      security_groups.3682336097:            "terraform-fw"
      source_dest_check:                     "true"
      subnet_id:                             <computed>
      tags.%:                                "1"
      tags.Name:                             "Terraform-test"
      tenancy:                               <computed>
      volume_tags.%:                         <computed>
      vpc_security_group_ids.#:              <computed>

  + aws_security_group.ssh_web
      id:                                    <computed>
      description:                           "Managed by Terraform"
      egress.#:                              "1"
      egress.482069346.cidr_blocks.#:        "1"
      egress.482069346.cidr_blocks.0:        "0.0.0.0/0"
      egress.482069346.description:          ""
      egress.482069346.from_port:            "0"
      egress.482069346.ipv6_cidr_blocks.#:   "0"
      egress.482069346.prefix_list_ids.#:    "0"
      egress.482069346.protocol:             "-1"
      egress.482069346.security_groups.#:    "0"
      egress.482069346.self:                 "false"
      egress.482069346.to_port:              "0"
      ingress.#:                             "2"
      ingress.2214680975.cidr_blocks.#:      "1"
      ingress.2214680975.cidr_blocks.0:      "0.0.0.0/0"
      ingress.2214680975.description:        ""
      ingress.2214680975.from_port:          "80"
      ingress.2214680975.ipv6_cidr_blocks.#: "0"
      ingress.2214680975.protocol:           "tcp"
      ingress.2214680975.security_groups.#:  "0"
      ingress.2214680975.self:               "false"
      ingress.2214680975.to_port:            "80"
      ingress.2541437006.cidr_blocks.#:      "1"
      ingress.2541437006.cidr_blocks.0:      "0.0.0.0/0"
      ingress.2541437006.description:        ""
      ingress.2541437006.from_port:          "22"
      ingress.2541437006.ipv6_cidr_blocks.#: "0"
      ingress.2541437006.protocol:           "tcp"
      ingress.2541437006.security_groups.#:  "0"
      ingress.2541437006.self:               "false"
      ingress.2541437006.to_port:            "22"
      name:                                  "terraform-fw"
      owner_id:                              <computed>
      revoke_rules_on_delete:                "false"
      vpc_id:                                <computed>


Plan: 2 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.

```
</p></details>

If there are any typo's or you forgot to add update your personal settings you will get am error. Fix the error and repeat.

Now, once the plan completes successfully, we can run terraform apply and watch our EC2 instance get created:
<details>
 <summary>Expand for output</summary>
  <p>
   
````
Add output for terraform apply...

````
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
