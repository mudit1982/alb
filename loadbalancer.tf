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

# module "security_group" {
#   source      = "./modules/security_group"
#   name        = lookup(var.awsprops, "secgroupname")
#   description = lookup(var.awsprops, "secgroupname")
#   vpc_id      = lookup(var.awsprops, "vpc")

# }


module "aws_security_group" {
  source      = "./modules/security_group"
  # sg_count = length(var.security_groups)
  name = var.security_groups
  description = var.secgroupdescription
  vpc_id      = var.VPCID

} 


resource "aws_security_group_rule" "ingress_rules" {

  count = length(var.ingress_rules)

  type              = "ingress"
  from_port         = var.ingress_rules[count.index].from_port
  to_port           = var.ingress_rules[count.index].to_port
  protocol          = var.ingress_rules[count.index].protocol
  cidr_blocks       = [var.ingress_rules[count.index].cidr_block]
  description       = var.ingress_rules[count.index].description
  # security_group_id = module.aws_security_group.id[count.index]
  security_group_id = module.aws_security_group.id
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "front" {
  name               = "front"
  # count     = length(var.SUBNET_ID)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.aws_security_group.id]
  # security_groups     = [module.security_group.id]
  # subnets            = [for subnet in var.SUBNET_ID : subnet.id]
  subnets            = ["subnet-0b86a94123ccf1094","subnet-04eff055558594bd7"]
  # subnets             =      element(var.SUBNET_ID[*],count.index)

  enable_deletion_protection = false

  tags = {
    Environment = "front"
  }
}