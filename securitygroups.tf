######################################################
# Web Server Security Group for our Production VPC
######################################################
resource "aws_security_group" "WebServer" {
  vpc_id      = "${aws_vpc.Production-VPC.id}"
  description = "WebServer SG"
  name        = "WebServerSG"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
######################################################
# Change ingress cidr_blocks from "0.0.0.0/0" 
# to "24.55.20.32/32"
######################################################
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

