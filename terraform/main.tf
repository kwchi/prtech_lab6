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
    dynamodb_table = "lab-my-tf-lockid"
  }
}

# Configure the AWS provider
provider "aws" {
  region     = "eu-central-1"
}

resource "random_id" "instance_id" {
  byte_length = 8
}
resource "aws_security_group" "web_app" {
  name        = "web_app_${random_id.instance_id.hex}"
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

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y python3
    python3 test_app.py
  EOF

  tags = {
    Name = "webapp_instance"
  }
  depends_on = [aws_security_group.web_app]
}

output "instance_public_ip" {
  value     = aws_instance.webapp_instance.public_ip
  sensitive = true
}
