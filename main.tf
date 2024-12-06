provider "aws" {
  region = var.region
}

resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = "t2.micro"

  tags = {
    Name = "PythonAppInstance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo useradd ec2-user"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = "${file("yourkey.pem")}"
    }
  }

  provisioner "file" {
    source      = "authorized_keys"
    destination = "/home/ec2-user/.ssh/authorized_keys"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("yourkey.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys",
      "sudo chmod 0600 /home/ec2-user/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("yourkey.pem")}"
    }
  }

#  provisioner "remote-exec" {
#    inline = [
#      "docker run -d -p 80:80 python-app"
#    ]
#  }
}

variable "region" {
  default = "eu-central-1"
}

variable "ami_id" {
  default = "ami-0b5673b5f6e8f7fa7" # AMI z Linux
}
