locals {
  count_subnet_id = length(var.SUBNET_ID)
 
  }



# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "front" {
  name     = "application-front"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.VPCID
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
  }
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
resource "aws_lb_target_group_attachment" "attach-app1" {
  count            = length(var.instance)
  target_group_arn = aws_lb_target_group.front.arn
  target_id        = element(var.instance[*], count.index)
  port             = 80
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front.arn
  }
}

module "security_group" {
  source      = "./modules/security_group"
  name        = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")
  vpc_id      = lookup(var.awsprops, "vpc")

}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "front" {
  name               = "front"
  # count     = length(var.SUBNET_ID)
  internal           = false
  load_balancer_type = "application"
  # security_groups    = [aws_security_group.lb.id]
  security_groups     = [module.security_group.id]
  # subnets            = [for subnet in aws_subnet.public : subnet.id]
  subnets            = ["subnet-08e0979ae4f944994","subnet-0f30253c5144b9cbe"]
  # subnets             =      element(var.SUBNET_ID[*],count.index)

  enable_deletion_protection = false

  tags = {
    Environment = "front"
  }
}