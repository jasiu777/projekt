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
        "sudo adduser --disabled-password --gecos '' myuser",
        "sudo mkdir -p /home/myuser/.ssh",
        "sudo touch /home/myuser/.ssh/authorized_keys",
        "sudo echo '${var.MY_USER_PUBLIC_KEY}' > authorized_keys",
        "sudo mv authorized_keys /home/myuser/.ssh",
        "sudo chown -R myuser:myuser /home/myuser/.ssh",
        "sudo chmod 700 /home/myuser/.ssh",
        "sudo chmod 600 /home/myuser/.ssh/authorized_keys",
        "sudo usermod -aG sudo myuser"
   ]

    connection {
     user     = "ubuntu"
    }

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
