VPCID="vpc-0419802ed12eec58a"
#EC2 instances to be added as target group
instance=["i-09b8d6cf9951d36f0","i-036266f11264351fe"]
SUBNET_ID=["subnet-0b86a94123ccf1094","subnet-04eff055558594bd7"]
existing_security_group_ids=["sg-0fa3f7060ad66d3be"]
# port = ["80","8080"]
# protocol=["HTTP","HTTP"]
port="80"
protocol="HTTP"
stick_session=true
s3_bucket_for_logs="egalbdemo2023"

#True for Internal Load Balancer and False for External Load Balancer
internal_load_balancer=true

##ID of the WAF to be associated with the External Load Balancer 
web_acl_id=""





# stickiness_duration=600

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


## Modify Rules per Internal or External Load Balancer
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


