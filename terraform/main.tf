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


variable "REPOSITORY_URI" {
  type = string
}


resource "aws_lightsail_container_service" "application" {
  name = "app"
  power = "nano"
  scale = 1

  private_registry_access {
    ecr_image_puller_role {
      is_active = true
    }
  }


  tags = {
    version = "1.0.0"
  }
}

resource "aws_lightsail_container_service_deployment_version" "app_deployment" {
  timeout = "20m"
  container {
    container_name = "application"

    image = "${var.REPOSITORY_URI}:latest"
    
    ports = {
      # Consistent with the port exposed by the Dockerfile and app.py
      8080 = "HTTP"
    }
  }

  public_endpoint {
    container_name = "application"
    # Consistent with the port exposed by the Dockerfile and app.py
    container_port = 8080

    health_check {
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout_seconds     = 2
      interval_seconds    = 5
      path                = "/"
      success_codes       = "200-499"
    }
  }

  service_name = aws_lightsail_container_service.application.name
}
