provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_security_group" "ssh_web" {
  name = "terraform-fw"

  # Inbound HTTP from anywhere
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound ssh from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Outbound to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
    ami             = "ami-c90195b0" #Red Hat 7.4
    instance_type   = "t2.micro"
    tags { Name     = "Terraform-test" }
    security_groups = ["terraform-fw"]
    # key_name is your AWS keypair to allow you access
    key_name        = "Add_Your_Keypair_name"
    provisioner "file" {
        source      = "files/scripts.sh"
        destination = "/tmp/scripts.sh"
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x /tmp/scripts.sh",
          "sudo /tmp/scripts.sh"
        ]
    }
    # Setup user access via SSH
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("/location/of/your/.pem")}"
      timeout = "2m"
      agent = false
    }
}
