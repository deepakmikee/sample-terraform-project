provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bad_bucket" {
  bucket = "checkov-insecure-bucket-demo"
  acl    = "public-read"  # ❌ Public bucket
}

resource "aws_security_group" "open_sg" {
  name        = "open-ssh"
  description = "Security group with open SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ❌ Open to the world
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Example AMI
  instance_type = "t2.micro"

  tags = {
    Name = "InsecureEC2"
  }

  user_data = <<EOF
#!/bin/bash
echo "API_KEY=12345" >> /etc/environment  # ❌ Hardcoded secret
EOF
}
