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
# cd /opt/demo
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
### The post build script.sh
I've created a post build script (files/script.sh) that does the following:
  * updates the software of the EC2 instance.
  * installs httpd and openscap + a couple of other useful programs.
  * Creates the index.html file with a holding page.
  * Collects your EC2 public IP address and emails it back to you (add your email address!)
  * Run openscap and produces a report (both Pre and post report under .../html/reports

### Running Terraform to build in AWS
First, initiate Terraform in your working directory:
<details>
 <summary>Terraform init output</summary>
  <p>


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
</p></details>


Next we run Terraform plan. This will check our code for syntax and report any issue. If it runs clean it will give you some outout showing you you are ready to proceed. <b>Output below is based on my configuration</b>. If you get errors. please go back and check through your code. I am planning to update some common issues and the bottom of this page so go down and check.

<details>
 <summary>Terraform plan output</summary>
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
 <summary>Terraform apply output</summary>
  <p>
   
````
# terraform apply

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
      key_name:                              "dmccuk"
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

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_instance.web: Creating...
  ami:                          "" => "ami-c90195b0"
  associate_public_ip_address:  "" => "<computed>"
  availability_zone:            "" => "<computed>"
  ebs_block_device.#:           "" => "<computed>"
  ephemeral_block_device.#:     "" => "<computed>"
  instance_state:               "" => "<computed>"
  instance_type:                "" => "t2.micro"
  ipv6_address_count:           "" => "<computed>"
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
  security_groups.3682336097:   "" => "terraform-fw"
  source_dest_check:            "" => "true"
  subnet_id:                    "" => "<computed>"
  tags.%:                       "" => "1"
  tags.Name:                    "" => "Terraform-test"
  tenancy:                      "" => "<computed>"
  volume_tags.%:                "" => "<computed>"
  vpc_security_group_ids.#:     "" => "<computed>"
aws_security_group.ssh_web: Creating...
  description:                           "" => "Managed by Terraform"
  egress.#:                              "" => "1"
  egress.482069346.cidr_blocks.#:        "" => "1"
  egress.482069346.cidr_blocks.0:        "" => "0.0.0.0/0"
  egress.482069346.description:          "" => ""
  egress.482069346.from_port:            "" => "0"
  egress.482069346.ipv6_cidr_blocks.#:   "" => "0"
  egress.482069346.prefix_list_ids.#:    "" => "0"
  egress.482069346.protocol:             "" => "-1"
  egress.482069346.security_groups.#:    "" => "0"
  egress.482069346.self:                 "" => "false"
  egress.482069346.to_port:              "" => "0"
  ingress.#:                             "" => "2"
  ingress.2214680975.cidr_blocks.#:      "" => "1"
  ingress.2214680975.cidr_blocks.0:      "" => "0.0.0.0/0"
  ingress.2214680975.description:        "" => ""
  ingress.2214680975.from_port:          "" => "80"
  ingress.2214680975.ipv6_cidr_blocks.#: "" => "0"
  ingress.2214680975.protocol:           "" => "tcp"
  ingress.2214680975.security_groups.#:  "" => "0"
  ingress.2214680975.self:               "" => "false"
  ingress.2214680975.to_port:            "" => "80"
  ingress.2541437006.cidr_blocks.#:      "" => "1"
  ingress.2541437006.cidr_blocks.0:      "" => "0.0.0.0/0"
  ingress.2541437006.description:        "" => ""
  ingress.2541437006.from_port:          "" => "22"
  ingress.2541437006.ipv6_cidr_blocks.#: "" => "0"
  ingress.2541437006.protocol:           "" => "tcp"
  ingress.2541437006.security_groups.#:  "" => "0"
  ingress.2541437006.self:               "" => "false"
  ingress.2541437006.to_port:            "" => "22"
  name:                                  "" => "terraform-fw"
  owner_id:                              "" => "<computed>"
  revoke_rules_on_delete:                "" => "false"
  vpc_id:                                "" => "<computed>"
aws_security_group.ssh_web: Creation complete after 3s (ID: sg-6db46d17)
aws_instance.web: Still creating... (10s elapsed)
aws_instance.web: Still creating... (20s elapsed)
aws_instance.web: Still creating... (30s elapsed)
aws_instance.web: Still creating... (40s elapsed)
aws_instance.web: Provisioning with 'file'...
aws_instance.web: Still creating... (50s elapsed)
aws_instance.web: Provisioning with 'remote-exec'...
aws_instance.web (remote-exec): Connecting to remote host via SSH...
aws_instance.web (remote-exec):   Host: 34.244.115.167
aws_instance.web (remote-exec):   User: ec2-user
aws_instance.web (remote-exec):   Password: false
aws_instance.web (remote-exec):   Private key: true
aws_instance.web (remote-exec):   SSH Agent: false
aws_instance.web (remote-exec): Connected!
aws_instance.web (remote-exec): Loaded plugins: amazon-id, rhui-lb,
aws_instance.web (remote-exec):               : search-disabled-repos
aws_instance.web (remote-exec): rhui-REGION-clie | 2.9 kB     00:00
aws_instance.web (remote-exec): rhui-REGION-rhel | 3.5 kB     00:00
aws_instance.web (remote-exec): rhui-REGION-rhel | 3.8 kB     00:00
aws_instance.web (remote-exec): (2/7): rhui-REG 0% |    0 B   --:-- ETA
aws_instance.web (remote-exec): (1/7): rhui-REGION | 2.5 kB   00:00
aws_instance.web (remote-exec): (2/7): rhui-REGION | 709 kB   00:00
aws_instance.web (remote-exec): (3/7): rhui-REGION |  104 B   00:00
aws_instance.web (remote-exec): (4/7): rhui-REGION | 120 kB   00:00
aws_instance.web (remote-exec): (5/7): rhui-REGION | 2.5 MB   00:00
aws_instance.web (remote-exec): (7/7): rhui-REG 6% | 3.3 MB   --:-- ETA
aws_instance.web (remote-exec): (6/7): rhui-REGION |  33 kB   00:00
aws_instance.web (remote-exec): (7/7): rhui-RE 49% |  25 MB   00:00 ETA
aws_instance.web (remote-exec): (7/7): rhui-RE 77% |  39 MB   00:00 ETA
aws_instance.web (remote-exec): (7/7): rhui-REGION |  47 MB   00:01
aws_instance.web: Still creating... (1m0s elapsed)
aws_instance.web (remote-exec): Resolving Dependencies
aws_instance.web (remote-exec): --> Running transaction check
aws_instance.web (remote-exec): ---> Package bind-libs-lite.x86_64 32:9.9.4-51.el7_4.1 will be updated
aws_instance.web (remote-exec): ---> Package bind-libs-lite.x86_64 32:9.9.4-51.el7_4.2 will be an update
aws_instance.web (remote-exec): ---> Package bind-license.noarch 32:9.9.4-51.el7_4.1 will be updated
aws_instance.web (remote-exec): ---> Package bind-license.noarch 32:9.9.4-51.el7_4.2 will be an update
aws_instance.web (remote-exec): ---> Package binutils.x86_64 0:2.25.1-32.base.el7_4.1 will be updated
aws_instance.web (remote-exec): ---> Package binutils.x86_64 0:2.25.1-32.base.el7_4.2 will be an update
aws_instance.web (remote-exec): ---> Package cloud-init.x86_64 0:0.7.9-9.el7_4.1 will be updated
aws_instance.web (remote-exec): ---> Package cloud-init.x86_64 0:0.7.9-9.el7_4.2 will be an update
aws_instance.web (remote-exec): ---> Package dhclient.x86_64 12:4.2.5-58.el7 will be updated
aws_instance.web (remote-exec): ---> Package dhclient.x86_64 12:4.2.5-58.el7_4.1 will be an update
aws_instance.web (remote-exec): ---> Package dhcp-common.x86_64 12:4.2.5-58.el7 will be updated
aws_instance.web (remote-exec): ---> Package dhcp-common.x86_64 12:4.2.5-58.el7_4.1 will be an update
aws_instance.web (remote-exec): ---> Package dhcp-libs.x86_64 12:4.2.5-58.el7 will be updated
aws_instance.web (remote-exec): ---> Package dhcp-libs.x86_64 12:4.2.5-58.el7_4.1 will be an update
aws_instance.web (remote-exec): ---> Package glibc.x86_64 0:2.17-196.el7 will be updated
aws_instance.web (remote-exec): ---> Package glibc.x86_64 0:2.17-196.el7_4.2 will be an update
aws_instance.web (remote-exec): ---> Package glibc-common.x86_64 0:2.17-196.el7 will be updated
aws_instance.web (remote-exec): ---> Package glibc-common.x86_64 0:2.17-196.el7_4.2 will be an update
aws_instance.web (remote-exec): ---> Package initscripts.x86_64 0:9.49.39-1.el7 will be updated
aws_instance.web (remote-exec): ---> Package initscripts.x86_64 0:9.49.39-1.el7_4.1 will be an update
aws_instance.web (remote-exec): ---> Package iwl7265-firmware.noarch 0:22.0.7.0-57.el7_4 will be updated
aws_instance.web (remote-exec): ---> Package iwl7265-firmware.noarch 0:22.0.7.0-58.el7_4 will be an update
aws_instance.web (remote-exec): ---> Package kernel.x86_64 0:3.10.0-693.17.1.el7 will be installed
aws_instance.web (remote-exec): --> Processing Dependency: linux-firmware >= 20170606-55 for package: kernel-3.10.0-693.17.1.el7.x86_64
aws_instance.web (remote-exec): ---> Package kernel-tools.x86_64 0:3.10.0-693.11.6.el7 will be updated
aws_instance.web (remote-exec): ---> Package kernel-tools.x86_64 0:3.10.0-693.17.1.el7 will be an update
aws_instance.web (remote-exec): ---> Package kernel-tools-libs.x86_64 0:3.10.0-693.11.6.el7 will be updated
aws_instance.web (remote-exec): ---> Package kernel-tools-libs.x86_64 0:3.10.0-693.17.1.el7 will be an update
aws_instance.web (remote-exec): ---> Package kmod.x86_64 0:20-15.el7_4.6 will be updated
aws_instance.web (remote-exec): ---> Package kmod.x86_64 0:20-15.el7_4.7 will be an update
aws_instance.web (remote-exec): ---> Package kmod-libs.x86_64 0:20-15.el7_4.6 will be updated
aws_instance.web (remote-exec): ---> Package kmod-libs.x86_64 0:20-15.el7_4.7 will be an update
aws_instance.web (remote-exec): ---> Package kpartx.x86_64 0:0.4.9-111.el7 will be updated
aws_instance.web (remote-exec): ---> Package kpartx.x86_64 0:0.4.9-111.el7_4.2 will be an update
aws_instance.web (remote-exec): ---> Package libdb.x86_64 0:5.3.21-20.el7 will be updated
aws_instance.web (remote-exec): ---> Package libdb.x86_64 0:5.3.21-21.el7_4 will be an update
aws_instance.web (remote-exec): ---> Package libdb-utils.x86_64 0:5.3.21-20.el7 will be updated
aws_instance.web (remote-exec): ---> Package libdb-utils.x86_64 0:5.3.21-21.el7_4 will be an update
aws_instance.web (remote-exec): ---> Package libgudev1.x86_64 0:219-42.el7_4.4 will be updated
aws_instance.web (remote-exec): ---> Package libgudev1.x86_64 0:219-42.el7_4.7 will be an update
aws_instance.web (remote-exec): ---> Package microcode_ctl.x86_64 2:2.1-22.2.el7 will be updated
aws_instance.web (remote-exec): ---> Package microcode_ctl.x86_64 2:2.1-22.5.el7_4 will be an update
aws_instance.web (remote-exec): ---> Package python-dmidecode.x86_64 0:3.12.2-1.el7 will be updated
aws_instance.web (remote-exec): ---> Package python-dmidecode.x86_64 0:3.12.2-1.1.el7 will be an update
aws_instance.web (remote-exec): ---> Package python-perf.x86_64 0:3.10.0-693.11.6.el7 will be updated
aws_instance.web (remote-exec): ---> Package python-perf.x86_64 0:3.10.0-693.17.1.el7 will be an update
aws_instance.web (remote-exec): ---> Package rh-amazon-rhui-client.noarch 0:2.2.133-1.el7 will be updated
aws_instance.web (remote-exec): ---> Package rh-amazon-rhui-client.noarch 0:2.2.141-1.el7 will be an update
aws_instance.web (remote-exec): ---> Package systemd.x86_64 0:219-42.el7_4.4 will be updated
aws_instance.web (remote-exec): ---> Package systemd.x86_64 0:219-42.el7_4.7 will be an update
aws_instance.web (remote-exec): ---> Package systemd-libs.x86_64 0:219-42.el7_4.4 will be updated
aws_instance.web (remote-exec): ---> Package systemd-libs.x86_64 0:219-42.el7_4.7 will be an update
aws_instance.web (remote-exec): ---> Package systemd-sysv.x86_64 0:219-42.el7_4.4 will be updated
aws_instance.web (remote-exec): ---> Package systemd-sysv.x86_64 0:219-42.el7_4.7 will be an update
aws_instance.web (remote-exec): ---> Package tuned.noarch 0:2.8.0-5.el7 will be updated
aws_instance.web (remote-exec): ---> Package tuned.noarch 0:2.8.0-5.el7_4.2 will be an update
aws_instance.web (remote-exec): ---> Package tzdata.noarch 0:2017c-1.el7 will be updated
aws_instance.web (remote-exec): ---> Package tzdata.noarch 0:2018c-1.el7 will be an update
aws_instance.web (remote-exec): --> Running transaction check
aws_instance.web (remote-exec): ---> Package linux-firmware.noarch 0:20170606-58.gitc990aae.el7_4 will be installed
aws_instance.web (remote-exec): --> Finished Dependency Resolution

aws_instance.web (remote-exec): Dependencies Resolved

aws_instance.web (remote-exec): ========================================
aws_instance.web (remote-exec):  Package               Arch   Version
aws_instance.web (remote-exec):                                 Repository
aws_instance.web (remote-exec):                                    Size
aws_instance.web (remote-exec): ========================================
aws_instance.web (remote-exec): Installing:
aws_instance.web (remote-exec):  kernel                x86_64 3.10.0-693.17.1.el7
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                    43 M
aws_instance.web (remote-exec): Updating:
aws_instance.web (remote-exec):  bind-libs-lite        x86_64 32:9.9.4-51.el7_4.2
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   733 k
aws_instance.web (remote-exec):  bind-license          noarch 32:9.9.4-51.el7_4.2
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                    84 k
aws_instance.web (remote-exec):  binutils              x86_64 2.25.1-32.base.el7_4.2
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   5.4 M
aws_instance.web (remote-exec):  cloud-init            x86_64 0.7.9-9.el7_4.2
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   625 k
aws_instance.web (remote-exec):  dhclient              x86_64 12:4.2.5-58.el7_4.1
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   282 k
aws_instance.web (remote-exec):  dhcp-common           x86_64 12:4.2.5-58.el7_4.1
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   174 k
aws_instance.web (remote-exec):  dhcp-libs             x86_64 12:4.2.5-58.el7_4.1
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   130 k
aws_instance.web (remote-exec):  glibc                 x86_64 2.17-196.el7_4.2
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   3.6 M
aws_instance.web (remote-exec):  glibc-common          x86_64 2.17-196.el7_4.2
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                    11 M
aws_instance.web (remote-exec):  initscripts           x86_64 9.49.39-1.el7_4.1
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   436 k
aws_instance.web (remote-exec):  iwl7265-firmware      noarch 22.0.7.0-58.el7_4
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   3.5 M
aws_instance.web (remote-exec):  kernel-tools          x86_64 3.10.0-693.17.1.el7
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   5.1 M
aws_instance.web (remote-exec):  kernel-tools-libs     x86_64 3.10.0-693.17.1.el7
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   5.1 M
aws_instance.web (remote-exec):  kmod                  x86_64 20-15.el7_4.7
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   121 k
aws_instance.web (remote-exec):  kmod-libs             x86_64 20-15.el7_4.7
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                    50 k
aws_instance.web (remote-exec):  kpartx                x86_64 0.4.9-111.el7_4.2
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                    73 k
aws_instance.web (remote-exec):  libdb                 x86_64 5.3.21-21.el7_4
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   719 k
aws_instance.web (remote-exec):  libdb-utils           x86_64 5.3.21-21.el7_4
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   132 k
aws_instance.web (remote-exec):  libgudev1             x86_64 219-42.el7_4.7
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                    84 k
aws_instance.web (remote-exec):  microcode_ctl         x86_64 2:2.1-22.5.el7_4
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   786 k
aws_instance.web (remote-exec):  python-dmidecode      x86_64 3.12.2-1.1.el7
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                    83 k
aws_instance.web (remote-exec):  python-perf           x86_64 3.10.0-693.17.1.el7
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   5.1 M
aws_instance.web (remote-exec):  rh-amazon-rhui-client noarch 2.2.141-1.el7
aws_instance.web (remote-exec):                                 rhui-REGION-client-config-server-7
aws_instance.web (remote-exec):                                    54 k
aws_instance.web (remote-exec):  systemd               x86_64 219-42.el7_4.7
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   5.2 M
aws_instance.web (remote-exec):  systemd-libs          x86_64 219-42.el7_4.7
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   376 k
aws_instance.web (remote-exec):  systemd-sysv          x86_64 219-42.el7_4.7
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                    71 k
aws_instance.web (remote-exec):  tuned                 noarch 2.8.0-5.el7_4.2
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   234 k
aws_instance.web (remote-exec):  tzdata                noarch 2018c-1.el7
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                   479 k
aws_instance.web (remote-exec): Installing for dependencies:
aws_instance.web (remote-exec):  linux-firmware        noarch 20170606-58.gitc990aae.el7_4
aws_instance.web (remote-exec):                                 rhui-REGION-rhel-server-releases
aws_instance.web (remote-exec):                                    35 M

aws_instance.web (remote-exec): Transaction Summary
aws_instance.web (remote-exec): ========================================
aws_instance.web (remote-exec): Install   1 Package  (+1 Dependent package)
aws_instance.web (remote-exec): Upgrade  28 Packages

aws_instance.web (remote-exec): Total download size: 128 M
aws_instance.web (remote-exec): Downloading packages:
aws_instance.web (remote-exec): Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
aws_instance.web (remote-exec): (1/30): bind-licen |  84 kB   00:00
aws_instance.web (remote-exec): (2/30): bind-libs- | 733 kB   00:00
aws_instance.web (remote-exec): (3/30): cloud-init | 625 kB   00:00
aws_instance.web (remote-exec): (4/30): binutils-2 | 5.4 MB   00:00
aws_instance.web (remote-exec): (5/30): dhclient-4 | 282 kB   00:00
aws_instance.web (remote-exec): (6/30): dhcp-commo | 174 kB   00:00
aws_instance.web (remote-exec): (7/30): dhcp-libs- | 130 kB   00:00
aws_instance.web (remote-exec): (8/30): glibc-2.17 | 3.6 MB   00:00
aws_instance.web (remote-exec): (9/30): initscript | 436 kB   00:00
aws_instance.web (remote-exec): (11/30): iwl72 16% |  21 MB   --:-- ETA
aws_instance.web (remote-exec): (10/30): glibc-com |  11 MB   00:00
aws_instance.web (remote-exec): (11/30): iwl7265-f | 3.5 MB   00:00
aws_instance.web (remote-exec): (13/30): kerne 27% |  35 MB   00:09 ETA
aws_instance.web (remote-exec): (12/30): kernel-to | 5.1 MB   00:00
aws_instance.web (remote-exec): (14/30): kerne 39% |  51 MB   00:06 ETA
aws_instance.web (remote-exec): (15/30): kmod- 41% |  53 MB   00:06 ETA
aws_instance.web (remote-exec): (13/30): kernel-3. |  43 MB   00:01
aws_instance.web (remote-exec): (16/30): kmod- 59% |  76 MB   00:03 ETA
aws_instance.web (remote-exec): (14/30): kmod-20-1 | 121 kB   00:00
aws_instance.web (remote-exec): (15/30): kernel-to | 5.1 MB   00:00
aws_instance.web (remote-exec): (16/30): kmod-libs |  50 kB   00:00
aws_instance.web (remote-exec): (17/30): kpartx-0. |  73 kB   00:00
aws_instance.web (remote-exec): (18/30): libdb-5.3 | 719 kB   00:00
aws_instance.web (remote-exec): (19/30): libdb-uti | 132 kB   00:00
aws_instance.web (remote-exec): (20/30): libgudev1 |  84 kB   00:00
aws_instance.web (remote-exec): (21/30): microcode | 786 kB   00:00
aws_instance.web (remote-exec): (22/30): python-dm |  83 kB   00:00
aws_instance.web (remote-exec): (25/30): rh-am 67% |  87 MB   00:02 ETA
aws_instance.web (remote-exec): (23/30): rh-amazon |  54 kB   00:00
aws_instance.web (remote-exec): (24/30): python-pe | 5.1 MB   00:00
aws_instance.web (remote-exec): (25/30): linux 79% | 102 MB   00:01 ETA
aws_instance.web (remote-exec): (25/30): systemd-2 | 5.2 MB   00:00
aws_instance.web (remote-exec): (26/30): systemd-l | 376 kB   00:00
aws_instance.web (remote-exec): (27/30): linux 91% | 118 MB   00:00 ETA
aws_instance.web (remote-exec): (27/30): systemd-s |  71 kB   00:00
aws_instance.web (remote-exec): (28/30): tuned-2.8 | 234 kB   00:00
aws_instance.web (remote-exec): (29/30): tzdata-20 | 479 kB   00:00
aws_instance.web (remote-exec): (30/30): linux-fir |  35 MB   00:01
aws_instance.web (remote-exec): ----------------------------------------
aws_instance.web (remote-exec): Total       32 MB/s | 128 MB  00:03
aws_instance.web (remote-exec): Running transaction check
aws_instance.web (remote-exec): Running transaction test
aws_instance.web (remote-exec): Transaction test succeeded
aws_instance.web (remote-exec): Running transaction
aws_instance.web (remote-exec):   Updating   : tzdata- [        ]  1/58
aws_instance.web (remote-exec):   Updating   : tzdata- [#       ]  1/58
aws_instance.web (remote-exec):   Updating   : tzdata- [##      ]  1/58
aws_instance.web (remote-exec):   Updating   : tzdata- [###     ]  1/58
aws_instance.web (remote-exec):   Updating   : tzdata- [####    ]  1/58
aws_instance.web (remote-exec):   Updating   : tzdata- [#####   ]  1/58
aws_instance.web (remote-exec):   Updating   : tzdata- [######  ]  1/58
aws_instance.web (remote-exec):   Updating   : tzdata- [####### ]  1/58
aws_instance.web (remote-exec):   Updating   : tzdata-2018c-1.e    1/58
aws_instance.web: Still creating... (1m10s elapsed)
aws_instance.web (remote-exec):   Updating   : glibc-2 [        ]  2/58
aws_instance.web (remote-exec):   Updating   : glibc-2 [#       ]  2/58
aws_instance.web (remote-exec):   Updating   : glibc-2 [##      ]  2/58
aws_instance.web (remote-exec):   Updating   : glibc-2 [###     ]  2/58
aws_instance.web (remote-exec):   Updating   : glibc-2 [####    ]  2/58
aws_instance.web (remote-exec):   Updating   : glibc-2 [#####   ]  2/58
aws_instance.web (remote-exec):   Updating   : glibc-2 [######  ]  2/58
aws_instance.web (remote-exec):   Updating   : glibc-2 [####### ]  2/58
aws_instance.web (remote-exec):   Updating   : glibc-2.17-196.e    2/58
aws_instance.web (remote-exec):   Updating   : glibc-c [        ]  3/58
aws_instance.web (remote-exec):   Updating   : glibc-c [#       ]  3/58
aws_instance.web (remote-exec):   Updating   : glibc-c [##      ]  3/58
aws_instance.web (remote-exec):   Updating   : glibc-c [###     ]  3/58
aws_instance.web (remote-exec):   Updating   : glibc-c [####    ]  3/58
aws_instance.web (remote-exec):   Updating   : glibc-c [#####   ]  3/58
aws_instance.web (remote-exec):   Updating   : glibc-c [######  ]  3/58
aws_instance.web (remote-exec):   Updating   : glibc-c [####### ]  3/58
aws_instance.web (remote-exec):   Updating   : glibc-common-2.1    3/58
aws_instance.web (remote-exec):   Updating   : systemd [        ]  4/58
aws_instance.web (remote-exec):   Updating   : systemd [#       ]  4/58
aws_instance.web (remote-exec):   Updating   : systemd [##      ]  4/58
aws_instance.web (remote-exec):   Updating   : systemd [###     ]  4/58
aws_instance.web (remote-exec):   Updating   : systemd [####    ]  4/58
aws_instance.web (remote-exec):   Updating   : systemd [#####   ]  4/58
aws_instance.web (remote-exec):   Updating   : systemd [######  ]  4/58
aws_instance.web (remote-exec):   Updating   : systemd [####### ]  4/58
aws_instance.web (remote-exec):   Updating   : systemd-libs-219    4/58
aws_instance.web (remote-exec):   Updating   : 12:dhcp [        ]  5/58
aws_instance.web (remote-exec):   Updating   : 12:dhcp [#       ]  5/58
aws_instance.web (remote-exec):   Updating   : 12:dhcp [####    ]  5/58
aws_instance.web (remote-exec):   Updating   : 12:dhcp [####### ]  5/58
aws_instance.web (remote-exec):   Updating   : 12:dhcp-libs-4.2    5/58
aws_instance.web (remote-exec):   Updating   : 12:dhcp [        ]  6/58
aws_instance.web (remote-exec):   Updating   : 12:dhcp [###     ]  6/58
aws_instance.web (remote-exec):   Updating   : 12:dhcp [#####   ]  6/58
aws_instance.web (remote-exec):   Updating   : 12:dhcp [####### ]  6/58
aws_instance.web (remote-exec):   Updating   : 12:dhcp-common-4    6/58
aws_instance.web (remote-exec):   Updating   : kmod-li [        ]  7/58
aws_instance.web (remote-exec):   Updating   : kmod-li [#####   ]  7/58
aws_instance.web (remote-exec):   Updating   : kmod-li [####### ]  7/58
aws_instance.web (remote-exec):   Updating   : kmod-libs-20-15.    7/58
aws_instance.web (remote-exec):   Updating   : kernel- [        ]  8/58
aws_instance.web (remote-exec):   Updating   : kernel- [####### ]  8/58
aws_instance.web (remote-exec):   Updating   : kernel-tools-lib    8/58
aws_instance.web (remote-exec):   Updating   : python- [        ]  9/58
aws_instance.web (remote-exec):   Updating   : python- [#       ]  9/58
aws_instance.web (remote-exec):   Updating   : python- [###     ]  9/58
aws_instance.web (remote-exec):   Updating   : python- [####    ]  9/58
aws_instance.web (remote-exec):   Updating   : python- [######  ]  9/58
aws_instance.web (remote-exec):   Updating   : python- [####### ]  9/58
aws_instance.web (remote-exec):   Updating   : python-perf-3.10    9/58
aws_instance.web (remote-exec):   Updating   : binutil [        ] 10/58
aws_instance.web (remote-exec):   Updating   : binutil [#       ] 10/58
aws_instance.web: Still creating... (1m20s elapsed)
aws_instance.web (remote-exec):   Updating   : binutil [##      ] 10/58
aws_instance.web (remote-exec):   Updating   : binutil [###     ] 10/58
aws_instance.web (remote-exec):   Updating   : binutil [####    ] 10/58
aws_instance.web (remote-exec):   Updating   : binutil [#####   ] 10/58
aws_instance.web (remote-exec):   Updating   : binutil [######  ] 10/58
aws_instance.web (remote-exec):   Updating   : binutil [####### ] 10/58
aws_instance.web (remote-exec):   Updating   : binutils-2.25.1-   10/58
aws_instance.web (remote-exec):   Updating   : kmod-20 [        ] 11/58
aws_instance.web (remote-exec):   Updating   : kmod-20 [##      ] 11/58
aws_instance.web (remote-exec):   Updating   : kmod-20 [####    ] 11/58
aws_instance.web (remote-exec):   Updating   : kmod-20 [#####   ] 11/58
aws_instance.web (remote-exec):   Updating   : kmod-20 [######  ] 11/58
aws_instance.web (remote-exec):   Updating   : kmod-20 [####### ] 11/58
aws_instance.web (remote-exec):   Updating   : kmod-20-15.el7_4   11/58
aws_instance.web (remote-exec):   Updating   : systemd [        ] 12/58
aws_instance.web (remote-exec):   Updating   : systemd [#       ] 12/58
aws_instance.web (remote-exec):   Updating   : systemd [##      ] 12/58
aws_instance.web (remote-exec):   Updating   : systemd [###     ] 12/58
aws_instance.web (remote-exec):   Updating   : systemd [####    ] 12/58
aws_instance.web (remote-exec):   Updating   : systemd [#####   ] 12/58
aws_instance.web (remote-exec):   Updating   : systemd [######  ] 12/58
aws_instance.web (remote-exec):   Updating   : systemd [####### ] 12/58
aws_instance.web (remote-exec):   Updating   : systemd-219-42.e   12/58
aws_instance.web (remote-exec):   Updating   : initscr [        ] 13/58
aws_instance.web (remote-exec):   Updating   : initscr [#       ] 13/58
aws_instance.web (remote-exec):   Updating   : initscr [##      ] 13/58
aws_instance.web (remote-exec):   Updating   : initscr [###     ] 13/58
aws_instance.web (remote-exec):   Updating   : initscr [####    ] 13/58
aws_instance.web (remote-exec):   Updating   : initscr [#####   ] 13/58
aws_instance.web (remote-exec):   Updating   : initscr [######  ] 13/58
aws_instance.web (remote-exec):   Updating   : initscr [####### ] 13/58
aws_instance.web (remote-exec):   Updating   : initscripts-9.49   13/58
aws_instance.web (remote-exec):   Updating   : libdb-5 [        ] 14/58
aws_instance.web (remote-exec):   Updating   : libdb-5 [#       ] 14/58
aws_instance.web (remote-exec):   Updating   : libdb-5 [##      ] 14/58
aws_instance.web (remote-exec):   Updating   : libdb-5 [###     ] 14/58
aws_instance.web (remote-exec):   Updating   : libdb-5 [####    ] 14/58
aws_instance.web (remote-exec):   Updating   : libdb-5 [#####   ] 14/58
aws_instance.web (remote-exec):   Updating   : libdb-5 [######  ] 14/58
aws_instance.web (remote-exec):   Updating   : libdb-5 [####### ] 14/58
aws_instance.web (remote-exec):   Updating   : libdb-5.3.21-21.   14/58
aws_instance.web (remote-exec):   Updating   : 32:bind [        ] 15/58
aws_instance.web (remote-exec):   Updating   : 32:bind [####### ] 15/58
aws_instance.web (remote-exec):   Updating   : 32:bind-license-   15/58
aws_instance.web (remote-exec):   Updating   : 32:bind [        ] 16/58
aws_instance.web (remote-exec):   Updating   : 32:bind [#       ] 16/58
aws_instance.web (remote-exec):   Updating   : 32:bind [##      ] 16/58
aws_instance.web (remote-exec):   Updating   : 32:bind [###     ] 16/58
aws_instance.web (remote-exec):   Updating   : 32:bind [####    ] 16/58
aws_instance.web (remote-exec):   Updating   : 32:bind [#####   ] 16/58
aws_instance.web (remote-exec):   Updating   : 32:bind [######  ] 16/58
aws_instance.web (remote-exec):   Updating   : 32:bind [####### ] 16/58
aws_instance.web (remote-exec):   Updating   : 32:bind-libs-lit   16/58
aws_instance.web (remote-exec):   Installing : linux-f [        ] 17/58
aws_instance.web (remote-exec):   Installing : linux-f [#       ] 17/58
aws_instance.web (remote-exec):   Installing : linux-f [##      ] 17/58
aws_instance.web (remote-exec):   Installing : linux-f [###     ] 17/58
aws_instance.web (remote-exec):   Installing : linux-f [####    ] 17/58
aws_instance.web (remote-exec):   Installing : linux-f [#####   ] 17/58
aws_instance.web (remote-exec):   Installing : linux-f [######  ] 17/58
aws_instance.web (remote-exec):   Installing : linux-f [####### ] 17/58
aws_instance.web (remote-exec):   Installing : linux-firmware-2   17/58
aws_instance.web (remote-exec):   Installing : kernel- [        ] 18/58
aws_instance.web: Still creating... (1m30s elapsed)
aws_instance.web (remote-exec):   Installing : kernel- [#       ] 18/58
aws_instance.web (remote-exec):   Installing : kernel- [##      ] 18/58
aws_instance.web (remote-exec):   Installing : kernel- [###     ] 18/58
aws_instance.web (remote-exec):   Installing : kernel- [####    ] 18/58
aws_instance.web (remote-exec):   Installing : kernel- [#####   ] 18/58
aws_instance.web (remote-exec):   Installing : kernel- [######  ] 18/58
aws_instance.web (remote-exec):   Installing : kernel- [####### ] 18/58
aws_instance.web (remote-exec):   Installing : kernel-3.10.0-69   18/58
aws_instance.web (remote-exec):   Updating   : 12:dhcl [        ] 19/58
aws_instance.web (remote-exec):   Updating   : 12:dhcl [#       ] 19/58
aws_instance.web (remote-exec):   Updating   : 12:dhcl [##      ] 19/58
aws_instance.web (remote-exec):   Updating   : 12:dhcl [###     ] 19/58
aws_instance.web (remote-exec):   Updating   : 12:dhcl [####    ] 19/58
aws_instance.web (remote-exec):   Updating   : 12:dhcl [#####   ] 19/58
aws_instance.web (remote-exec):   Updating   : 12:dhcl [######  ] 19/58
aws_instance.web (remote-exec):   Updating   : 12:dhcl [####### ] 19/58
aws_instance.web (remote-exec):   Updating   : 12:dhclient-4.2.   19/58
aws_instance.web (remote-exec):   Updating   : libdb-u [        ] 20/58
aws_instance.web (remote-exec):   Updating   : libdb-u [#       ] 20/58
aws_instance.web (remote-exec):   Updating   : libdb-u [##      ] 20/58
aws_instance.web (remote-exec):   Updating   : libdb-u [###     ] 20/58
aws_instance.web (remote-exec):   Updating   : libdb-u [####    ] 20/58
aws_instance.web (remote-exec):   Updating   : libdb-u [#####   ] 20/58
aws_instance.web (remote-exec):   Updating   : libdb-u [######  ] 20/58
aws_instance.web (remote-exec):   Updating   : libdb-u [####### ] 20/58
aws_instance.web (remote-exec):   Updating   : libdb-utils-5.3.   20/58
aws_instance.web (remote-exec):   Updating   : cloud-i [        ] 21/58
aws_instance.web (remote-exec):   Updating   : cloud-i [#       ] 21/58
aws_instance.web (remote-exec):   Updating   : cloud-i [##      ] 21/58
aws_instance.web (remote-exec):   Updating   : cloud-i [###     ] 21/58
aws_instance.web (remote-exec):   Updating   : cloud-i [####    ] 21/58
aws_instance.web (remote-exec):   Updating   : cloud-i [#####   ] 21/58
aws_instance.web (remote-exec):   Updating   : cloud-i [######  ] 21/58
aws_instance.web (remote-exec):   Updating   : cloud-i [####### ] 21/58
aws_instance.web (remote-exec):   Updating   : cloud-init-0.7.9   21/58
aws_instance.web (remote-exec):   Updating   : 2:micro [        ] 22/58
aws_instance.web (remote-exec):   Updating   : 2:micro [#       ] 22/58
aws_instance.web (remote-exec):   Updating   : 2:micro [##      ] 22/58
aws_instance.web (remote-exec):   Updating   : 2:micro [###     ] 22/58
aws_instance.web (remote-exec):   Updating   : 2:micro [####    ] 22/58
aws_instance.web (remote-exec):   Updating   : 2:micro [#####   ] 22/58
aws_instance.web (remote-exec):   Updating   : 2:micro [######  ] 22/58
aws_instance.web (remote-exec):   Updating   : 2:micro [####### ] 22/58
aws_instance.web (remote-exec):   Updating   : 2:microcode_ctl-   22/58
aws_instance.web (remote-exec):   Updating   : systemd [        ] 23/58
aws_instance.web (remote-exec):   Updating   : systemd [####### ] 23/58
aws_instance.web (remote-exec):   Updating   : systemd-sysv-219   23/58
aws_instance.web (remote-exec):   Updating   : tuned-2 [        ] 24/58
aws_instance.web (remote-exec):   Updating   : tuned-2 [#       ] 24/58
aws_instance.web (remote-exec):   Updating   : tuned-2 [##      ] 24/58
aws_instance.web (remote-exec):   Updating   : tuned-2 [###     ] 24/58
aws_instance.web (remote-exec):   Updating   : tuned-2 [####    ] 24/58
aws_instance.web (remote-exec):   Updating   : tuned-2 [#####   ] 24/58
aws_instance.web (remote-exec):   Updating   : tuned-2 [######  ] 24/58
aws_instance.web (remote-exec):   Updating   : tuned-2 [####### ] 24/58
aws_instance.web (remote-exec):   Updating   : tuned-2.8.0-5.el   24/58
aws_instance.web (remote-exec):   Updating   : kernel- [        ] 25/58
aws_instance.web (remote-exec):   Updating   : kernel- [##      ] 25/58
aws_instance.web (remote-exec):   Updating   : kernel- [###     ] 25/58
aws_instance.web (remote-exec):   Updating   : kernel- [#####   ] 25/58
aws_instance.web (remote-exec):   Updating   : kernel- [######  ] 25/58
aws_instance.web (remote-exec):   Updating   : kernel- [####### ] 25/58
aws_instance.web (remote-exec):   Updating   : kernel-tools-3.1   25/58
aws_instance.web (remote-exec):   Updating   : libgude [        ] 26/58
aws_instance.web (remote-exec):   Updating   : libgude [#       ] 26/58
aws_instance.web (remote-exec):   Updating   : libgude [####### ] 26/58
aws_instance.web (remote-exec):   Updating   : libgudev1-219-42   26/58
aws_instance.web (remote-exec):   Updating   : kpartx- [        ] 27/58
aws_instance.web (remote-exec):   Updating   : kpartx- [####### ] 27/58
aws_instance.web (remote-exec):   Updating   : kpartx-0.4.9-111   27/58
aws_instance.web (remote-exec):   Updating   : python- [        ] 28/58
aws_instance.web (remote-exec):   Updating   : python- [##      ] 28/58
aws_instance.web (remote-exec):   Updating   : python- [####    ] 28/58
aws_instance.web (remote-exec):   Updating   : python- [#####   ] 28/58
aws_instance.web (remote-exec):   Updating   : python- [######  ] 28/58
aws_instance.web (remote-exec):   Updating   : python- [####### ] 28/58
aws_instance.web (remote-exec):   Updating   : python-dmidecode   28/58
aws_instance.web (remote-exec):   Updating   : rh-amaz [        ] 29/58
aws_instance.web (remote-exec):   Updating   : rh-amaz [#       ] 29/58
aws_instance.web (remote-exec):   Updating   : rh-amaz [##      ] 29/58
aws_instance.web (remote-exec):   Updating   : rh-amaz [###     ] 29/58
aws_instance.web (remote-exec):   Updating   : rh-amaz [####    ] 29/58
aws_instance.web (remote-exec):   Updating   : rh-amaz [#####   ] 29/58
aws_instance.web (remote-exec):   Updating   : rh-amaz [######  ] 29/58
aws_instance.web (remote-exec):   Updating   : rh-amaz [####### ] 29/58
aws_instance.web (remote-exec):   Updating   : rh-amazon-rhui-c   29/58
aws_instance.web (remote-exec): [INFO:choose_repo] choose_repo:39 2018-02-08 10:06:57,454: Zone [eu-west-1b]
aws_instance.web (remote-exec): [INFO:choose_repo] choose_repo:67 2018-02-08 10:06:57,454: Enabling binary repos in redhat-rhui.repo
aws_instance.web (remote-exec): [INFO:choose_repo] choose_repo:86 2018-02-08 10:06:57,455: Enabling load balancer plugin
aws_instance.web (remote-exec): [INFO:choose_repo] choose_repo:88 2018-02-08 10:06:57,455: Executing [sed -i 's/enabled=0/enabled=1/' /etc/yum/pluginconf.d/rhui-lb.conf]
aws_instance.web (remote-exec): [INFO:choose_repo] choose_repo:92 2018-02-08 10:06:57,460: Setting region in load balancer config
aws_instance.web (remote-exec): [INFO:choose_repo] choose_repo:94 2018-02-08 10:06:57,460: Executing [sed -i 's/REGION/eu-west-1/' /etc/yum.repos.d/rhui-load-balancers.conf]
aws_instance.web (remote-exec): [INFO:choose_repo] choose_repo:98 2018-02-08 10:06:57,464: Enabling client config repo
aws_instance.web (remote-exec): [INFO:choose_repo] choose_repo:101 2018-02-08 10:06:57,464: Executing [sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/redhat-rhui-client-config.repo]
aws_instance.web (remote-exec):   Updating   : iwl7265 [        ] 30/58
aws_instance.web (remote-exec):   Updating   : iwl7265 [#       ] 30/58
aws_instance.web (remote-exec):   Updating   : iwl7265 [##      ] 30/58
aws_instance.web (remote-exec):   Updating   : iwl7265 [###     ] 30/58
aws_instance.web (remote-exec):   Updating   : iwl7265 [####    ] 30/58
aws_instance.web (remote-exec):   Updating   : iwl7265 [#####   ] 30/58
aws_instance.web (remote-exec):   Updating   : iwl7265 [######  ] 30/58
aws_instance.web (remote-exec):   Updating   : iwl7265 [####### ] 30/58
aws_instance.web (remote-exec):   Updating   : iwl7265-firmware   30/58
aws_instance.web (remote-exec):   Cleanup    : 12:dhclient-4.2.   31/58
aws_instance.web (remote-exec):   Cleanup    : tuned-2.8.0-5.el   32/58
aws_instance.web (remote-exec):   Cleanup    : 12:dhcp-common-4   33/58
aws_instance.web (remote-exec):   Cleanup    : 12:dhcp-libs-4.2   34/58
aws_instance.web (remote-exec):   Cleanup    : systemd-sysv-219   35/58
aws_instance.web (remote-exec):   Cleanup    : cloud-init-0.7.9   36/58
aws_instance.web (remote-exec):   Cleanup    : initscripts-9.49   37/58
aws_instance.web (remote-exec):   Cleanup    : libgudev1-219-42   38/58
aws_instance.web (remote-exec):   Cleanup    : kernel-tools-3.1   39/58
aws_instance.web (remote-exec):   Cleanup    : 32:bind-libs-lit   40/58
aws_instance.web (remote-exec):   Cleanup    : libdb-utils-5.3.   41/58
aws_instance.web (remote-exec):   Cleanup    : 2:microcode_ctl-   42/58
aws_instance.web (remote-exec):   Cleanup    : 32:bind-license-   43/58
aws_instance.web (remote-exec):   Cleanup    : rh-amazon-rhui-c   44/58
aws_instance.web (remote-exec):   Cleanup    : iwl7265-firmware   45/58
aws_instance.web (remote-exec):   Cleanup    : systemd-219-42.e   46/58
aws_instance.web (remote-exec):   Cleanup    : kmod-20-15.el7_4   47/58
aws_instance.web (remote-exec):   Cleanup    : binutils-2.25.1-   48/58
aws_instance.web (remote-exec):   Cleanup    : kmod-libs-20-15.   49/58
aws_instance.web (remote-exec):   Cleanup    : systemd-libs-219   50/58
aws_instance.web (remote-exec):   Cleanup    : libdb-5.3.21-20.   51/58
aws_instance.web (remote-exec):   Cleanup    : kernel-tools-lib   52/58
aws_instance.web (remote-exec):   Cleanup    : python-perf-3.10   53/58
aws_instance.web (remote-exec):   Cleanup    : python-dmidecode   54/58
aws_instance.web (remote-exec):   Cleanup    : kpartx-0.4.9-111   55/58
aws_instance.web (remote-exec):   Cleanup    : glibc-common-2.1   56/58
aws_instance.web (remote-exec):   Cleanup    : glibc-2.17-196.e   57/58
aws_instance.web (remote-exec):   Cleanup    : tzdata-2017c-1.e   58/58
aws_instance.web: Still creating... (1m40s elapsed)
aws_instance.web: Still creating... (1m50s elapsed)
aws_instance.web: Still creating... (2m0s elapsed)
aws_instance.web: Still creating... (2m10s elapsed)
aws_instance.web: Still creating... (2m20s elapsed)
aws_instance.web: Still creating... (2m30s elapsed)
aws_instance.web: Still creating... (2m40s elapsed)
aws_instance.web: Still creating... (2m50s elapsed)
aws_instance.web: Still creating... (3m0s elapsed)
aws_instance.web: Still creating... (3m10s elapsed)
aws_instance.web: Still creating... (3m20s elapsed)
aws_instance.web: Still creating... (3m30s elapsed)
aws_instance.web: Still creating... (3m40s elapsed)
aws_instance.web: Still creating... (3m50s elapsed)
aws_instance.web (remote-exec):   Verifying  : kmod-20-15.el7_4    1/58
aws_instance.web (remote-exec):   Verifying  : linux-firmware-2    2/58
aws_instance.web (remote-exec):   Verifying  : cloud-init-0.7.9    3/58
aws_instance.web (remote-exec):   Verifying  : 12:dhclient-4.2.    4/58
aws_instance.web (remote-exec):   Verifying  : 2:microcode_ctl-    5/58
aws_instance.web (remote-exec):   Verifying  : kmod-libs-20-15.    6/58
aws_instance.web (remote-exec):   Verifying  : libdb-utils-5.3.    7/58
aws_instance.web (remote-exec):   Verifying  : iwl7265-firmware    8/58
aws_instance.web (remote-exec):   Verifying  : systemd-sysv-219    9/58
aws_instance.web (remote-exec):   Verifying  : tuned-2.8.0-5.el   10/58
aws_instance.web (remote-exec):   Verifying  : kernel-3.10.0-69   11/58
aws_instance.web (remote-exec):   Verifying  : 32:bind-libs-lit   12/58
aws_instance.web (remote-exec):   Verifying  : kpartx-0.4.9-111   13/58
aws_instance.web (remote-exec):   Verifying  : initscripts-9.49   14/58
aws_instance.web (remote-exec):   Verifying  : kernel-tools-3.1   15/58
aws_instance.web (remote-exec):   Verifying  : 12:dhcp-common-4   16/58
aws_instance.web (remote-exec):   Verifying  : kernel-tools-lib   17/58
aws_instance.web (remote-exec):   Verifying  : 32:bind-license-   18/58
aws_instance.web (remote-exec):   Verifying  : 12:dhcp-libs-4.2   19/58
aws_instance.web (remote-exec):   Verifying  : systemd-libs-219   20/58
aws_instance.web (remote-exec):   Verifying  : python-perf-3.10   21/58
aws_instance.web (remote-exec):   Verifying  : tzdata-2018c-1.e   22/58
aws_instance.web (remote-exec):   Verifying  : binutils-2.25.1-   23/58
aws_instance.web (remote-exec):   Verifying  : systemd-219-42.e   24/58
aws_instance.web (remote-exec):   Verifying  : libdb-5.3.21-21.   25/58
aws_instance.web (remote-exec):   Verifying  : libgudev1-219-42   26/58
aws_instance.web (remote-exec):   Verifying  : glibc-2.17-196.e   27/58
aws_instance.web (remote-exec):   Verifying  : glibc-common-2.1   28/58
aws_instance.web (remote-exec):   Verifying  : rh-amazon-rhui-c   29/58
aws_instance.web (remote-exec):   Verifying  : python-dmidecode   30/58
aws_instance.web (remote-exec):   Verifying  : rh-amazon-rhui-c   31/58
aws_instance.web (remote-exec):   Verifying  : 32:bind-libs-lit   32/58
aws_instance.web (remote-exec):   Verifying  : cloud-init-0.7.9   33/58
aws_instance.web (remote-exec):   Verifying  : tuned-2.8.0-5.el   34/58
aws_instance.web (remote-exec):   Verifying  : binutils-2.25.1-   35/58
aws_instance.web (remote-exec):   Verifying  : kernel-tools-lib   36/58
aws_instance.web (remote-exec):   Verifying  : 2:microcode_ctl-   37/58
aws_instance.web (remote-exec):   Verifying  : python-perf-3.10   38/58
aws_instance.web (remote-exec):   Verifying  : 12:dhcp-common-4   39/58
aws_instance.web (remote-exec):   Verifying  : 12:dhclient-4.2.   40/58
aws_instance.web (remote-exec):   Verifying  : 12:dhcp-libs-4.2   41/58
aws_instance.web (remote-exec):   Verifying  : initscripts-9.49   42/58
aws_instance.web (remote-exec):   Verifying  : libdb-5.3.21-20.   43/58
aws_instance.web (remote-exec):   Verifying  : 32:bind-license-   44/58
aws_instance.web (remote-exec):   Verifying  : systemd-libs-219   45/58
aws_instance.web (remote-exec):   Verifying  : python-dmidecode   46/58
aws_instance.web (remote-exec):   Verifying  : kmod-20-15.el7_4   47/58
aws_instance.web (remote-exec):   Verifying  : systemd-219-42.e   48/58
aws_instance.web (remote-exec):   Verifying  : libdb-utils-5.3.   49/58
aws_instance.web (remote-exec):   Verifying  : libgudev1-219-42   50/58
aws_instance.web (remote-exec):   Verifying  : iwl7265-firmware   51/58
aws_instance.web (remote-exec):   Verifying  : kernel-tools-3.1   52/58
aws_instance.web (remote-exec):   Verifying  : kmod-libs-20-15.   53/58
aws_instance.web (remote-exec):   Verifying  : systemd-sysv-219   54/58
aws_instance.web (remote-exec):   Verifying  : tzdata-2017c-1.e   55/58
aws_instance.web (remote-exec):   Verifying  : glibc-2.17-196.e   56/58
aws_instance.web (remote-exec):   Verifying  : kpartx-0.4.9-111   57/58
aws_instance.web (remote-exec):   Verifying  : glibc-common-2.1   58/58

aws_instance.web (remote-exec): Installed:
aws_instance.web (remote-exec):   kernel.x86_64 0:3.10.0-693.17.1.el7

aws_instance.web (remote-exec): Dependency Installed:
aws_instance.web (remote-exec):   linux-firmware.noarch 0:20170606-58.gitc990aae.el7_4

aws_instance.web (remote-exec): Updated:
aws_instance.web (remote-exec):   bind-libs-lite.x86_64 32:9.9.4-51.el7_4.2
aws_instance.web (remote-exec):   bind-license.noarch 32:9.9.4-51.el7_4.2
aws_instance.web (remote-exec):   binutils.x86_64 0:2.25.1-32.base.el7_4.2
aws_instance.web (remote-exec):   cloud-init.x86_64 0:0.7.9-9.el7_4.2
aws_instance.web (remote-exec):   dhclient.x86_64 12:4.2.5-58.el7_4.1
aws_instance.web (remote-exec):   dhcp-common.x86_64 12:4.2.5-58.el7_4.1
aws_instance.web (remote-exec):   dhcp-libs.x86_64 12:4.2.5-58.el7_4.1
aws_instance.web (remote-exec):   glibc.x86_64 0:2.17-196.el7_4.2
aws_instance.web (remote-exec):   glibc-common.x86_64 0:2.17-196.el7_4.2
aws_instance.web (remote-exec):   initscripts.x86_64 0:9.49.39-1.el7_4.1
aws_instance.web (remote-exec):   iwl7265-firmware.noarch 0:22.0.7.0-58.el7_4
aws_instance.web (remote-exec):   kernel-tools.x86_64 0:3.10.0-693.17.1.el7
aws_instance.web (remote-exec):   kernel-tools-libs.x86_64 0:3.10.0-693.17.1.el7
aws_instance.web (remote-exec):   kmod.x86_64 0:20-15.el7_4.7
aws_instance.web (remote-exec):   kmod-libs.x86_64 0:20-15.el7_4.7
aws_instance.web (remote-exec):   kpartx.x86_64 0:0.4.9-111.el7_4.2
aws_instance.web (remote-exec):   libdb.x86_64 0:5.3.21-21.el7_4
aws_instance.web (remote-exec):   libdb-utils.x86_64 0:5.3.21-21.el7_4
aws_instance.web (remote-exec):   libgudev1.x86_64 0:219-42.el7_4.7
aws_instance.web (remote-exec):   microcode_ctl.x86_64 2:2.1-22.5.el7_4
aws_instance.web (remote-exec):   python-dmidecode.x86_64 0:3.12.2-1.1.el7
aws_instance.web (remote-exec):   python-perf.x86_64 0:3.10.0-693.17.1.el7
aws_instance.web (remote-exec):   rh-amazon-rhui-client.noarch 0:2.2.141-1.el7
aws_instance.web (remote-exec):   systemd.x86_64 0:219-42.el7_4.7
aws_instance.web (remote-exec):   systemd-libs.x86_64 0:219-42.el7_4.7
aws_instance.web (remote-exec):   systemd-sysv.x86_64 0:219-42.el7_4.7
aws_instance.web (remote-exec):   tuned.noarch 0:2.8.0-5.el7_4.2
aws_instance.web (remote-exec):   tzdata.noarch 0:2018c-1.el7

aws_instance.web (remote-exec): Complete!
aws_instance.web (remote-exec): Loaded plugins: amazon-id, rhui-lb,
aws_instance.web (remote-exec):               : search-disabled-repos
aws_instance.web (remote-exec): rhui-REGION-clie | 2.9 kB     00:00
aws_instance.web (remote-exec): rhui-REGION-rhel | 3.5 kB     00:00
aws_instance.web (remote-exec): rhui-REGION-rhel | 3.8 kB     00:00
aws_instance.web (remote-exec): Package curl-7.29.0-42.el7_4.1.x86_64 already installed and latest version
aws_instance.web (remote-exec): Resolving Dependencies
aws_instance.web (remote-exec): --> Running transaction check
aws_instance.web (remote-exec): ---> Package git.x86_64 0:1.8.3.1-12.el7_4 will be installed
aws_instance.web (remote-exec): --> Processing Dependency: perl-Git = 1.8.3.1-12.el7_4 for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl >= 5.008 for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: /usr/bin/perl for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Error) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Exporter) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(File::Basename) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(File::Copy) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(File::Find) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(File::Path) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(File::Spec) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(File::Temp) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(File::stat) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Getopt::Long) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Git) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Term::ReadKey) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(lib) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(strict) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(vars) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(warnings) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: libgnome-keyring.so.0()(64bit) for package: git-1.8.3.1-12.el7_4.x86_64
aws_instance.web (remote-exec): ---> Package httpd.x86_64 0:2.4.6-67.el7_4.6 will be installed
aws_instance.web (remote-exec): --> Processing Dependency: httpd-tools = 2.4.6-67.el7_4.6 for package: httpd-2.4.6-67.el7_4.6.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: system-logos >= 7.92.1-1 for package: httpd-2.4.6-67.el7_4.6.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: /etc/mime.types for package: httpd-2.4.6-67.el7_4.6.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: libapr-1.so.0()(64bit) for package: httpd-2.4.6-67.el7_4.6.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: libaprutil-1.so.0()(64bit) for package: httpd-2.4.6-67.el7_4.6.x86_64
aws_instance.web (remote-exec): ---> Package mailx.x86_64 0:12.5-16.el7 will be installed
aws_instance.web (remote-exec): ---> Package mlocate.x86_64 0:0.26-6.el7 will be installed
aws_instance.web (remote-exec): ---> Package openscap-scanner.x86_64 0:1.2.14-2.el7 will be installed
aws_instance.web (remote-exec): --> Processing Dependency: openscap(x86-64) = 1.2.14-2.el7 for package: openscap-scanner-1.2.14-2.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: libopenscap.so.8()(64bit) for package: openscap-scanner-1.2.14-2.el7.x86_64
aws_instance.web (remote-exec): ---> Package scap-security-guide.noarch 0:0.1.33-6.el7_4 will be installed
aws_instance.web (remote-exec): --> Processing Dependency: xml-common for package: scap-security-guide-0.1.33-6.el7_4.noarch
aws_instance.web (remote-exec): ---> Package wget.x86_64 0:1.14-15.el7_4.1 will be installed
aws_instance.web (remote-exec): --> Running transaction check
aws_instance.web (remote-exec): ---> Package apr.x86_64 0:1.4.8-3.el7_4.1 will be installed
aws_instance.web (remote-exec): ---> Package apr-util.x86_64 0:1.5.2-6.el7 will be installed
aws_instance.web (remote-exec): ---> Package httpd-tools.x86_64 0:2.4.6-67.el7_4.6 will be installed
aws_instance.web (remote-exec): ---> Package libgnome-keyring.x86_64 0:3.12.0-1.el7 will be installed
aws_instance.web (remote-exec): ---> Package mailcap.noarch 0:2.1.41-2.el7 will be installed
aws_instance.web (remote-exec): ---> Package openscap.x86_64 0:1.2.14-2.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl.x86_64 4:5.16.3-292.el7 will be installed
aws_instance.web (remote-exec): --> Processing Dependency: perl-libs = 4:5.16.3-292.el7 for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Scalar::Util) >= 1.10 for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Socket) >= 1.3 for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Carp) for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Filter::Util::Call) for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Pod::Simple::Search) for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Pod::Simple::XHTML) for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Scalar::Util) for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Socket) for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Storable) for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Time::HiRes) for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(Time::Local) for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(constant) for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(threads) for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl(threads::shared) for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl-libs for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: perl-macros for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): --> Processing Dependency: libperl.so()(64bit) for package: 4:perl-5.16.3-292.el7.x86_64
aws_instance.web (remote-exec): ---> Package perl-Error.noarch 1:0.17020-2.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-Exporter.noarch 0:5.68-3.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-File-Path.noarch 0:2.09-2.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-File-Temp.noarch 0:0.23.01-3.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-Getopt-Long.noarch 0:2.40-2.el7 will be installed
aws_instance.web (remote-exec): --> Processing Dependency: perl(Pod::Usage) >= 1.14 for package: perl-Getopt-Long-2.40-2.el7.noarch
aws_instance.web (remote-exec): --> Processing Dependency: perl(Text::ParseWords) for package: perl-Getopt-Long-2.40-2.el7.noarch
aws_instance.web (remote-exec): ---> Package perl-Git.noarch 0:1.8.3.1-12.el7_4 will be installed
aws_instance.web (remote-exec): ---> Package perl-PathTools.x86_64 0:3.40-5.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-TermReadKey.x86_64 0:2.30-20.el7 will be installed
aws_instance.web (remote-exec): ---> Package redhat-logos.noarch 0:70.0.3-6.el7 will be installed
aws_instance.web (remote-exec): ---> Package xml-common.noarch 0:0.6.3-39.el7 will be installed
aws_instance.web (remote-exec): --> Running transaction check
aws_instance.web (remote-exec): ---> Package perl-Carp.noarch 0:1.26-244.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-Filter.x86_64 0:1.49-3.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-Pod-Simple.noarch 1:3.28-4.el7 will be installed
aws_instance.web (remote-exec): --> Processing Dependency: perl(Pod::Escapes) >= 1.04 for package: 1:perl-Pod-Simple-3.28-4.el7.noarch
aws_instance.web (remote-exec): --> Processing Dependency: perl(Encode) for package: 1:perl-Pod-Simple-3.28-4.el7.noarch
aws_instance.web (remote-exec): ---> Package perl-Pod-Usage.noarch 0:1.63-3.el7 will be installed
aws_instance.web (remote-exec): --> Processing Dependency: perl(Pod::Text) >= 3.15 for package: perl-Pod-Usage-1.63-3.el7.noarch
aws_instance.web (remote-exec): --> Processing Dependency: perl-Pod-Perldoc for package: perl-Pod-Usage-1.63-3.el7.noarch
aws_instance.web (remote-exec): ---> Package perl-Scalar-List-Utils.x86_64 0:1.27-248.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-Socket.x86_64 0:2.010-4.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-Storable.x86_64 0:2.45-3.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-Text-ParseWords.noarch 0:3.29-4.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-Time-HiRes.x86_64 4:1.9725-3.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-Time-Local.noarch 0:1.2300-2.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-constant.noarch 0:1.27-2.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-libs.x86_64 4:5.16.3-292.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-macros.x86_64 4:5.16.3-292.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-threads.x86_64 0:1.87-4.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-threads-shared.x86_64 0:1.43-6.el7 will be installed
aws_instance.web (remote-exec): --> Running transaction check
aws_instance.web (remote-exec): ---> Package perl-Encode.x86_64 0:2.51-7.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-Pod-Escapes.noarch 1:1.04-292.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-Pod-Perldoc.noarch 0:3.20-4.el7 will be installed
aws_instance.web (remote-exec): --> Processing Dependency: perl(HTTP::Tiny) for package: perl-Pod-Perldoc-3.20-4.el7.noarch
aws_instance.web (remote-exec): --> Processing Dependency: perl(parent) for package: perl-Pod-Perldoc-3.20-4.el7.noarch
aws_instance.web (remote-exec): ---> Package perl-podlators.noarch 0:2.5.1-3.el7 will be installed
aws_instance.web (remote-exec): --> Running transaction check
aws_instance.web (remote-exec): ---> Package perl-HTTP-Tiny.noarch 0:0.033-3.el7 will be installed
aws_instance.web (remote-exec): ---> Package perl-parent.noarch 1:0.225-244.el7 will be installed
aws_instance.web (remote-exec): --> Finished Dependency Resolution

aws_instance.web (remote-exec): Dependencies Resolved

aws_instance.web (remote-exec): ========================================
aws_instance.web (remote-exec):  Package
aws_instance.web (remote-exec):        Arch   Version           Repository
aws_instance.web (remote-exec):                                    Size
aws_instance.web (remote-exec): ========================================
aws_instance.web (remote-exec): Installing:
aws_instance.web (remote-exec):  git   x86_64 1.8.3.1-12.el7_4  rhui-REGI

````
</p></details>


Once created, if you check the AWS console, you will see the EC2 instance available:
![Alt text](aws_console.PNG?raw=true)

Once your new EC2 instance is created you should receive an email. Check your spam filter if it doesn't turn up within a couple of minutes. Your EC2 instance IP address will be inside the email (you can also get the public IP address from the AWS console). Open up you internet browser (chrome :)) and enter the IP address. You should see the following:
![Alt text](aws_webapp.PNG?raw=true)

Openscap pre & Post reports will have been created. Let's take a look.
![Alt text](openscap_reports.PNG?raw=true)

The PRE report:
![Alt text](openscap_reports_pre.PNG?raw=true)

The POST report:
![Alt text](openscap_reports_post.PNG?raw=true)


As you can see the difference between the PRE and POST reports. You server has been hardened for the purposes of this demo.

## Further information:

Depending on the OS you have decided to install (the AMI), you will need to use different users to logins.

 * Ubuntu AMI's users are either ubuntu or root
 * Red Hat AMI user is ec2-user

Login like this:

```$ ssh ec2-user@IPADDR -i /path/to/your/.pem```
```$ ssh ubuntu@IPADDR -i /path/to/your/.pem```

When you're finished, remember to remove the instance:
````
# terraform destroy
aws_instance.web: Refreshing state... (ID: i-0f3ff443018600702)
aws_security_group.ssh_web: Refreshing state... (ID: sg-6db46d17)

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  - aws_instance.web

  - aws_security_group.ssh_web


Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_instance.web: Destroying... (ID: i-0f3ff443018600702)
aws_security_group.ssh_web: Destroying... (ID: sg-6db46d17)
aws_instance.web: Still destroying... (ID: i-0f3ff443018600702, 10s elapsed)
aws_security_group.ssh_web: Still destroying... (ID: sg-6db46d17, 10s elapsed)
aws_instance.web: Still destroying... (ID: i-0f3ff443018600702, 20s elapsed)
aws_security_group.ssh_web: Still destroying... (ID: sg-6db46d17, 20s elapsed)
aws_instance.web: Still destroying... (ID: i-0f3ff443018600702, 30s elapsed)
aws_security_group.ssh_web: Still destroying... (ID: sg-6db46d17, 30s elapsed)
aws_instance.web: Still destroying... (ID: i-0f3ff443018600702, 40s elapsed)
aws_security_group.ssh_web: Still destroying... (ID: sg-6db46d17, 40s elapsed)
aws_security_group.ssh_web: Destruction complete after 49s
aws_instance.web: Still destroying... (ID: i-0f3ff443018600702, 50s elapsed)
aws_instance.web: Destruction complete after 51s

Destroy complete! Resources: 2 destroyed.

````

Checking the A=AWS console, you will see your instance shutdown, before being terminated:

![Alt text](aws_console1.PNG?raw=true)

![Alt text](aws_console2.PNG?raw=true)

Please share with your colleagues and let me know if you found this useful.

Dennis McCarthy
