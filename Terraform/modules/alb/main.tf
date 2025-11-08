#################################################################
# Create Application Load Balancer                              #
#################################################################

resource "aws_lb" "applicationLoadBalancer" {
  name               = "${var.ProjectName}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.appLoadBalancerSecurityGroupID]
  subnets            = concat(var.PublicSubnetIDs)

}

################################################################
# Create Target Group For Container                            #
################################################################

resource "aws_lb_target_group" "fargateTargetGroup" {
  name            = "FargateTargetGroup"
  target_type     = "ip" # "instance", "lambda"
  port            = 3000 # container port
  protocol        = "HTTP"
  ip_address_type = "ipv4"
  vpc_id          = var.vpcID
  health_check {
    protocol            = "HTTP"
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

################################################################
# Create Http Listener For Frontend                            #
################################################################

resource "aws_lb_listener" "fargateHttpListener" {
  load_balancer_arn = aws_lb.applicationLoadBalancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect" #forward
    # target_group_arn = aws_lb_target_group.fargateTargetGroup.arn

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

################################################################
# Create Https Listener For Conatiner                          #
################################################################

resource "aws_lb_listener" "fargateHttpsListener" {
  load_balancer_arn = aws_lb.applicationLoadBalancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  # Default certificate
  certificate_arn = var.defaultSSLCertificateARN


  default_action {
    type = "fixed-response"   # 
    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }

}


################################################################
# Create Listener Rules for Container                          #
################################################################

resource "aws_lb_listener_rule" "containerRule" {
  listener_arn = aws_lb_listener.fargateHttpsListener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fargateTargetGroup.arn
  }

  condition {
    host_header {
      values = [var.frontendDomain]
    }
  }
}


