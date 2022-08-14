# EC2 Instance running Django
resource "aws_instance" "django-pollserver" {
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  tags = {
    "Name" : "pollserver"
  }
}

# EC2 Application Load Balancer with listeners for API calls from cloudfront
resource "aws_lb" "main" {
  name               = "externallb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-097b4a2075b09625f", aws_security_group.alb-sg.id, aws_security_group.ec2-sg.id]
  subnets = [
    aws_subnet.us-east-1a.id,
    aws_subnet.us-east-1b.id,
    aws_subnet.us-east-1c.id,
    aws_subnet.us-east-1d.id,
    aws_subnet.us-east-1e.id,
    aws_subnet.us-east-1f.id,
  ]
}

resource "aws_lb_target_group" "http" {
  name        = "tglbex"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_default_vpc.default.id
  target_type = "instance"
  tags        = {}
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = 301
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "ec2-target" {
  target_group_arn = aws_lb_target_group.http.arn
  target_id        = aws_instance.django-pollserver.id
  port             = 8000
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}



resource "aws_lb_target_group" "https-a" {
  name        = "tgexhttps"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = aws_default_vpc.default.id
  target_type = "instance"
  tags        = {}
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = 301
    path                = "/auth"
    port                = "traffic-port"
    protocol            = "HTTPS"
    timeout             = 5
    unhealthy_threshold = 2
  }
}
resource "aws_lb_target_group_attachment" "https-a-ec2-target" {
  target_group_arn = aws_lb_target_group.https-a.arn
  target_id        = aws_instance.django-pollserver.id
  port             = 8000
}

resource "aws_lb_listener" "https-a" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.pollinone.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.https-a.arn
  }
}


resource "aws_lb_target_group" "https-b" {
  name        = "backendtghttps"
  port        = 8000
  protocol    = "HTTPS"
  vpc_id      = aws_default_vpc.default.id
  target_type = "instance"
  tags        = {}
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = 301
    path                = "/admin"
    port                = "8000"
    protocol            = "HTTPS"
    timeout             = 5
    unhealthy_threshold = 2
  }
}
resource "aws_lb_target_group_attachment" "https-b-ec2-target" {
  target_group_arn = aws_lb_target_group.https-a.arn
  target_id        = aws_instance.django-pollserver.id
  port             = 8000
}

resource "aws_lb_listener" "https-b" {
  load_balancer_arn = aws_lb.main.arn
  port              = "8000"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.api-pollinone.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.https-b.arn
  }
}



