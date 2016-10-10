This a basic Terraform setup to launch one AWS ec2 instance.

Pre-Requisites:

  * Install Terraform
  * Have an account on AWS (free Tier if possible)

# git clone ...

Change these values:
  * main.tf:    security_groups = ["VALUE"]
  * main.tf:      private_key = "${file("VALUE.pem")}"
  * terraform.tfvars:access_key = "VALUE_YOUR_ACCESS_KEY"
  * terraform.tfvars:secret_key = "VALUE_YOUR_SECRET_KEY"
Now run:

# terraform plan
# terraform apply

Once it's created and you set up and email, you will be able to visit the public webpage from the IP address you've been sent.

Login like this:

ssh ec2-user@IPADDR -i /path/to/your/.pem

When you're finished, remember to remove the instance:

# terraform destroy
