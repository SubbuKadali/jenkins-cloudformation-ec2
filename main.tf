provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins_ec2" {
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2 in us-east-1
  instance_type = "t2.micro"
  
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  
  tags = {
    Name        = "Jenkins-EC2-Instance"
    CreatedBy   = "Jenkins-Pipeline"
    Environment = "Production"
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_ec2_sg"
  description = "Security group for Jenkins-created EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-ec2-security-group"
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
