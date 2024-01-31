resource "aws_alb" "alb" {
  name               = "${var.environment}-lbl-public"
  security_groups    =  var.alb-security-group-ids
  subnets            =  var.aws-subnet-id
  internal           =  var.alb-internal
  load_balancer_type =  var.alb-type


}

resource "aws_alb_target_group" "lbs_target_group" {
  name     = "${var.environment}-lbl-public"
  port            = var.alb-target-group-port
  protocol        = var.alb-target-group-protocol
  vpc_id          = var.aws-vpc-id
  target_type     = var.alb-target-type
 

  # Alter the destination of the health check to be the login page.
  health_check {
    path = var.alb-health-check-path
    port = var.alb-health-check-port
  }
}


resource "aws_alb_listener" "listener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              =  var.alb-target-group-port
  protocol          =  var.alb-target-group-protocol

  default_action {
    target_group_arn = aws_alb_target_group.lbs_target_group.arn
    type             = "forward"
  }
}


resource "aws_lb_target_group_attachment" "alb_attachment" {
  count            = length(var.alb-instance-ids)
  target_group_arn = aws_alb_target_group.lbs_target_group.arn
  target_id        = var.alb-instance-ids[count.index]
}

/* resource "aws_alb_listener_rule" "listener_rule" {
  depends_on   = ["aws_alb_target_group.alb_target_group"]  
  listener_arn = "${aws_alb_listener.alb_listener.arn}"  
  priority     = "${var.priority}"   
  action {    
    type             = "forward"    
    target_group_arn = "${aws_alb_target_group.alb_target_group.id}"  
  }   
  condition {    
    field  = "path-pattern"    
    values = ["${var.alb_path}"]  
  }
} */