VPCID="vpc-0419802ed12eec58a"
account_id="215691912540"

#EC2 instances to be added as target group
instance=["i-0ec4d4521d56ade9b","i-0859a07abf9002a20"]      
SUBNET_ID=["subnet-0b86a94123ccf1094","subnet-04eff055558594bd7"]
existing_security_group_ids=["sg-0fa3f7060ad66d3be"]
stick_session=true
s3_bucket_for_logs="egalbdemo2023"
certificate_id="5c4a4330-e55d-47e2-8654-f7f836a1be3e"

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


