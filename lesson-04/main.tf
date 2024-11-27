terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-2"
  profile = "iamadmin-general" // reference the API key in .aws/credentials
}

resource "aws_instance" "lesson_04" {
  ami           = "ami-0c7c4e3c6b4941f0f"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.sg_ssh.id,
    aws_security_group.sg_https.id
  ]

  tags = {
    Name = "Lesson-04-VM-SG"
  }
}

resource "aws_security_group" "sg_ssh" {
  description = "SSH_Access"

  tags = {
    Name = "SSH_Access"
  }
}

resource "aws_security_group" "sg_https" {
  description = "HTTPS Access"
  tags = {
    Name = "HTTPS_Access"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg_ssh" {
  security_group_id = aws_security_group.sg_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "SSH access from any destination"

  tags = {
    Name = "SSH_Any"
  }
}

resource "aws_vpc_security_group_egress_rule" "sg_ssh_any_out" {
  security_group_id = aws_security_group.sg_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Full access to any destination"

  tags = {
    Name = "Any_Out"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg_https" {
  security_group_id = aws_security_group.sg_https.id
  cidr_ipv4         = "192.168.0.0/16"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "HTTPS access from 192.168.0.0/16"

  tags = {
    Name = "HTTP_192.168/16"
  }
}

resource "aws_vpc_security_group_egress_rule" "sg_https_any_out" {
  security_group_id = aws_security_group.sg_https.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Full access to any destination"

  tags = {
    Name = "Any_Out"
  }
}