provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_instance" "web" {
    ami             = "ami-f9dd458a"
    instance_type   = "t2.micro"
    tags { Name     = "Terraform-test" }
    security_groups = ["CHANGE_ME"]
    key_name        = "CHANGE_ME"
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
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("VALUE.pem")}"
      timeout = "2m"
      agent = false
    }
}
