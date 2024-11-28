terraform {
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
}
  backend "s3" {
    bucket = "lab6-tf"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

# Configure the AWS provider
provider "aws" {
  region     = "eu-central-1"
}

variable "process_id" {
  default = "default-pid"
}
resource "aws_security_group" "web_app" {
  name        = "web_app_${var.process_id}"
  description = "security group"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = "web_app"
  }
}

resource "aws_instance" "webapp_instance" {
  ami           = "ami-0669b163befffbdfc"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_app.id]
  tags = {
    Name = "webapp_instance"
  }
  depends_on = [aws_security_group.web_app]
}

resource "null_resource" "cleanup_security_groups" {
  provisioner "local-exec" {
    command = <<EOT
      aws ec2 describe-security-groups --query "SecurityGroups[?GroupName=='web_app*'].GroupId" --output text |
      xargs -n1 -I{} aws ec2 delete-security-group --group-id {}
    EOT
  }
}

output "instance_public_ip" {
  value     = aws_instance.webapp_instance.public_ip
  sensitive = true
}
