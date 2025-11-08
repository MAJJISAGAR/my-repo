module "vpc" {
  source = "../child"
  avesham = var.avesham
}

resource "aws_subnet" "nukayya" {
  vpc_id = module.vpc.vpc-id
  cidr_block = var.sub-cidr
  map_public_ip_on_launch = true
  depends_on = [ module.vpc ]
  tags = {Name = "${var.avesham}-subnet"}
}

resource "aws_internet_gateway" "pista" {
  vpc_id = module.vpc.vpc-id
  tags = {Name = "${var.avesham}-igw"}
}

resource "aws_route_table" "rupai" {
  vpc_id = module.vpc.vpc-id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pista.id
  }
  tags = {Name = "${var.avesham}-rtb"}
}

resource "aws_route_table_association" "pilla" {
  subnet_id = aws_subnet.nukayya.id
  route_table_id = aws_route_table.rupai.id
}

resource "aws_security_group" "zamindar" {
  vpc_id = module.vpc.vpc-id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "lokam" {
  ami = "ami-0157af9aea2eef346"
  key_name = "sagar-key"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.zamindar.id]
  subnet_id = aws_subnet.nukayya.id
  depends_on = [ aws_security_group.zamindar ]
  tags = {Name = "${var.avesham}-ec2"}
}