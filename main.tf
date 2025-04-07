# provider "aws" {
#   region = "us-east-1"
# }
# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
#   enable_dns_support = true
#   enable_dns_hostnames = true
# }
# resource "aws_subnet" "subnet_public" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true
# }
# resource "aws_ecs_cluster" "medusa_cluster" {
#   name = "medusa-cluster"
# }
# resource "aws_iam_role" "ecs_execution_role" {
#   name = "ecs-execution-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action    = "sts:AssumeRole"
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#         Effect    = "Allow"
#         Sid       = ""
#       },
#     ]
#   })
# }


# resource "aws_ecs_task_definition" "medusa_task" {
#   family                   = "medusa-task"
#   execution_role_arn       = aws_iam_role.ecs_execution_role.arn
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "256"
#   memory                   = "512"

#   container_definitions = jsonencode([{
#     name      = "medusa-backend"
#     image     = "my_image"  
#     essential = true
#     portMappings = [
#       {
#         containerPort = 9000     #this is port mapping
#         hostPort      = 9000
#         protocol      = "tcp"
#       }
#     ]
#   }])
# }
# resource "aws_ecs_service" "medusa_service" {
#   name            = "medusa-service"
#   cluster         = aws_ecs_cluster.medusa_cluster.id
#   task_definition = aws_ecs_task_definition.medusa_task.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"
#   network_configuration {
#     subnets          = [aws_subnet.subnet_public.id]
#     assign_public_ip = true
#   }
# }

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Ensure the AWS provider is within version 4.x.x
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# VPC Creation with a unique name
resource "aws_vpc" "medusa_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Subnet Creation with a unique name
resource "aws_subnet" "medusa_subnet_public" {
  vpc_id                  = aws_vpc.medusa_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# ECS Cluster with a unique name
resource "aws_ecs_cluster" "medusa_cluster_unique" {
  name = "medusa-cluster-unique-12345"
}

# IAM Role with a unique name
resource "aws_iam_role" "medusa_ecs_execution_role" {
  name = "medusa-ecs-execution-role-unique-12345"  # Unique role name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}

# ECS Task Definition with a unique family name
resource "aws_ecs_task_definition" "medusa_task_unique" {
  family                   = "medusa-task-unique-12345"
  execution_role_arn       = aws_iam_role.medusa_ecs_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "medusa-backend"
    image     = "medusajs/medusa:latest"  # Pre-built Medusa Docker image from Docker Hub
    essential = true
    portMappings = [
      {
        containerPort = 9000     # Port mapping for Medusa backend
        hostPort      = 9000
        protocol      = "tcp"
      }
    ]
  }])
}

# ECS Service with a unique name
resource "aws_ecs_service" "medusa_service_unique" {
  name            = "medusa-service-unique-12345"
  cluster         = aws_ecs_cluster.medusa_cluster_unique.id
  task_definition = aws_ecs_task_definition.medusa_task_unique.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.medusa_subnet_public.id]
    assign_public_ip = true
  }
}
