provider "aws" {
  region = "ap-southeast-2"  # Sydney region
}
  
# Use Sydney-specific AMI (Amazon Linux 2)
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
 
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "jenkins_ec2" {
  ami           = data.aws_ami.amazon_linux_2.id  # Use Sydney AMI
  instance_type = "t2.micro"
  
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  
  tags = {
    Name        = "Jenkins-EC2-Sydney"
    CreatedBy   = "Jenkins-Pipeline"
    Environment = "Production"
    Owner       = "SubbuKadali"
    Region      = "ap-southeast-2"
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_ec2_sg_sydney"
  description = "Security group for Jenkins-created EC2 instance in Sydney"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Outbound traffic"
  }

  tags = {
    Name    = "jenkins-ec2-security-group-sydney"
    Region  = "ap-southeast-2"
  }
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.jenkins_ec2.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.jenkins_ec2.id
}

output "instance_region" {
  description = "AWS region of the instance"
  value       = "ap-southeast-2 (Sydney)"
}
