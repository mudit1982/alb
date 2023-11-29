VPCID="vpc-0777935da25d06fe3"
account_id="215691912540"

#EC2 instances to be added as target group
instance=["i-09c60224997151113","i-0eae77ac8a59c19d8"]
SUBNET_ID=["subnet-03585b0505602f1a7","subnet-03585b0505602f1a7"]
existing_security_group_ids=["sg-0bd541cafc1955479"]
stick_session=true
s3_bucket_for_logs="egalbdemo2023"
certificate_id="edd0bad0-21c4-410a-907d-32efac02f8b8"

#True for Internal Load Balancer and False for External Load Balancer
internal_load_balancer=false

##ARN of the WAF to be associated with the External Load Balancer 
web_acl_arn="arn:aws:wafv2:us-east-2:215691912540:regional/webacl/WebACL_Demo/adc73673-2072-4295-bfd7-3747ee5777db"

# stickiness_duration=600
##Name of the ALB
Name_ALB = "EG-ALB-Test"

alb_tags = {
      TicketReference            = "CHG0050760"
      DNSEntry                   = "csdasd"
      DesignDocumentLink         = "acbv"
}


##Tags to be passed as variables. These would be appended to the pre defined tags in variables.tf
Environment="Dev"
ApplicationFunctionality = "Test"
ApplicationName="Test"
ApplicationOwner="abc@hotmail.com"
ApplicationTeam="Team1"
BusinessOwner="abc@gmail.com"
BusinessTower="abc@gmail.com"
ServiceCriticality="Medium"


## Modify Rules for Security Group per Internal or External Load Balancer
ingress_rules =[
 
{
      from_port   = "80"
      to_port     = "80"
      protocol    = "tcp"
      cidr_block  = "192.168.161.215/32"
      description = "ELB"
    },

    {
      from_port   = "8080"
      to_port     = "8080"
      protocol    = "tcp"
      cidr_block  = "192.168.161.215/32"
      description = "ELB Port 8080"
    },
{
      from_port   = "1234"
      to_port     = "1234"
      protocol    = "tcp"
      cidr_block  = "192.168.161.215/32"
      description = "ELB Port 1234"
    }
]



target_group = {
    healthy_threshold   =  3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
    }


