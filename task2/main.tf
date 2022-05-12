terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region["Frankfurt"]
  default_tags {
    tags = {
      owner = "sergei_khianikiainen@epam.com"
    }
  }
}

# create security group for web server
resource "aws_security_group" "web_server" {
  name = "web server sg"
  # inbound rules
  dynamic "ingress" {
    for_each = ["22", "80"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  # outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web access to server"
  }
}

# find the latest ubuntu distro
data "aws_ami" "ubuntu_latest" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# create an instance
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_server.id]
  key_name               = "sergei_khianikiainen_root_frankfurt"
  user_data              = file("user_data.sh")
}

# create security group for RDS database
resource "aws_security_group" "db" {
  name = "database sg"
  # inbound rules
  dynamic "ingress" {
    for_each = ["5432"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  # outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "access to database"
  }
}

# create POSTGRESQL database
resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "14.1"
  instance_class         = "db.t3.micro"
  db_name                = var.dbname
  username               = var.username
  password               = var.password
  vpc_security_group_ids = [aws_security_group.db.id]
  skip_final_snapshot    = true
  apply_immediately      = true
}
