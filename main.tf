provider "aws" {
  region = var.region
}

resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = "t2.micro"

  tags = {
    Name = "PythonAppInstance"
  }
}

#  provisioner "remote-exec" {
#    inline = [
#      "docker run -d -p 80:80 python-app"
#    ]
#  }
#}

  provisioner "remote-exec" {
    inline = [
      "sudo chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys",
      "sudo chmod 0600 /home/ec2-user/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
    }
  }

resource "aws_key_pair" "ec2-user" {
  key_name   = "ec2-user"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwOnTVCci4sIM4Gt52UuqwapklWlMy4eogKOsdlmRc0b9KyM4QrqqWrDNMt1MvII1yIfM0GvvyAS0UOGR5QUfhvNmaHZY1pKH0s0DooFEkYSrUQpeznxozcpcWQ3ko1HG2O66T+VVRrhVgSrgpfGPacnJqjc7B1lLu/YaAPR0TGIPV0nYWr+XSAuFbpiNl124MAfR2oHOdOY5UO0aGFIuzyyHnxN1m9TekRvOhOnYx/gu+3WRvf2AQkSdZMCdEsXgkqcYxhaf3rfl5aELsuEze+sEEyJqADP/jtrfcezsVGNYO/LH0bqqx4LtxPDzvKJcObetjZK4ayFF5e/Acpk/F9HIccVcB96yKKg3PVVr8cCv/mAQ5uzbTgbxcY8AxOt9H3GVcHu5xB7uPtSgOLOn0cYGI3COClwYHrpKc+zN2zNaTXLvpYBu0sLuhFNmdx+nfaxMMysJb/M5n3kqyI6UsHmyAHpz0X6hpKrSiWAtYvXSDQcwitRjKixR3Ei9NQRk= ec2-user@01UVMDev"
}

variable "region" {
  default = "eu-central-1"
}

variable "ami_id" {
  default = "ami-0b5673b5f6e8f7fa7" # AMI z Linux
}
