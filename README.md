This a basic Terraform setup to launch one AWS ec2 instance.

Pre-Requisites:

  * Install Terraform
  * Have an account on AWS (free Tier if possible)

# git clone ...

Change these values:
  * main.tf:    security_groups = ["VALUE"] //Use the group name NOT groupID
  * main.tf:      private_key = "${file("VALUE.pem")}"
  * terraform.tfvars:access_key = "VALUE_YOUR_ACCESS_KEY"
  * terraform.tfvars:secret_key = "VALUE_YOUR_SECRET_KEY"
  * files/script.sh: Add your email!

Now run:

#> terraform plan
#> terraform apply

Once it's created and you set up and email, you will be able to visit the public webpage from the IP address you've been sent.

 * Ubuntu AMI's users are either ubuntu or root
 * Red Hat AMI user is ec2-user
Login like this:

ssh ec2-user@IPADDR -i /path/to/your/.pem
ssh ubuntu@IPADDR -i /path/to/your/.pem

When you're finished, remember to remove the instance:

 terraform destroy

Enjoy...
