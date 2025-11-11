########################################
# Use DEFAULT VPC (no custom VPC/CIDR)
########################################
data "aws_vpc" "default" {
  default = true
}

########################################
# Security Group (open to anywhere)
########################################
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-sg"
  description = "Open HTTP/SSH (insecure demo)"
  vpc_id      = data.aws_vpc.default.id

  # HTTP from anywhere
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH from anywhere (NOT recommended for prod)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

########################################
# AMI (Ubuntu 22.04 LTS)
########################################
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical official AWS account

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

########################################
# EC2 Instance (Ubuntu, default subnet)
########################################
resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  # No subnet specified → AWS chooses a default subnet in the default VPC

  tags = {
    Name = "${var.project_name}-ubuntu-ec2"
  }
}
