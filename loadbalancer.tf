##All these should be used as variables
resource "aws_lb_target_group" "front" {
  name     = "application-front"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.VPCID

##Enable/Disable stickiness  
  stickiness {
    enabled = var.stick_session
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    healthy_threshold   = lookup ( var.target_group , "healthy_threshold")
    interval            = lookup ( var.target_group , "interval") 
    matcher             = lookup ( var.target_group , "matcher")
    path                = lookup ( var.target_group , "path")
    port                = lookup ( var.target_group , "port")
    protocol            = lookup ( var.target_group , "protocol")
    timeout             = lookup  ( var.target_group , "timeout")
    unhealthy_threshold = lookup ( var.target_group , "unhealthy_threshold")
    
  }
}



resource "aws_lb_target_group_attachment" "attach-app1" {
  count            = length(var.instance)
  target_group_arn = aws_lb_target_group.front.arn
  target_id        = element(var.instance[*], count.index)
  port             = 80
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.front.arn
  port              = 80
  protocol          = "HTTP"
  # count = length(var.port)
  # port    = var.port[count.index]
  # protocol  = var.protocol[count.index]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front.arn
  }

}


resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.front.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn = "arn:aws:acm:${var.region}:${var.account_id}:certificate/${var.certificate_id}"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front.arn
    
  }
}


# module "aws_security_group" {
#   source      = "./modules/security_group"
#   # sg_count = length(var.security_groups)
#   name = var.security_groups
#   description = var.secgroupdescription
#   vpc_id      = var.VPCID

# } 


module "new_security_group" {
  source = "./modules/security_group_new"
  # security_rules = var.security_rules  
  security_rules = local.security_rules
  vpc_id = var.VPCID
  # depends_on = [random_integer.ri]
}

# resource "aws_security_group_rule" "ingress_rules" {

#   count = length(var.ingress_rules)

#   type              = "ingress"
#   from_port         = var.ingress_rules[count.index].from_port
#   to_port           = var.ingress_rules[count.index].to_port
#   protocol          = var.ingress_rules[count.index].protocol
#   cidr_blocks       = [var.ingress_rules[count.index].cidr_block]
#   description       = var.ingress_rules[count.index].description
#   # security_group_id = module.aws_security_group.id[count.index]
#   security_group_id = module.aws_security_group.id
# }


##Provision External/Internal based on variable internal_load_balancer load balancer
resource "aws_lb" "front" {
  # count = "${var.internal_load_balancer ? 0 : 1}"
  name               = var.Name_ALB
  internal           = var.internal_load_balancer
  load_balancer_type = "application"
  # security_groups    = [module.aws_security_group.id]
  security_groups    =  concat(module.new_security_group.id[*],var.existing_security_group_ids[*])
  # security_groups     = [module.security_group.id]
  subnets            = [for subnet in var.SUBNET_ID : subnet]

# If enabled Terraform would not be able to delete the LB
  enable_deletion_protection = false

  access_logs { 
    bucket  = var.s3_bucket_for_logs
    prefix  = "test-lb"
    enabled = true
  }

  tags = merge(tomap(var.alb_tags),{ApplicationFunctionality = var.ApplicationFunctionality, 
      Name = var.Name_ALB,
      ApplicationOwner = var.ApplicationOwner, 
      ApplicationTeam = var.ApplicationTeam, 
      BusinessOwner = var.BusinessOwner,
      BusinessTower = var.BusinessTower,
      ServiceCriticality = var.ServiceCriticality,
      VPC-id = var.VPCID})
  }


resource "aws_wafv2_web_acl_association" "web_acl_external_lb" {
  resource_arn = aws_lb.front.arn
  web_acl_arn  = var.web_acl_arn
}

  
