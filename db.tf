resource "aws_security_group" "database" {
  name        = "database"
  description = "Used for RDS"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "database"
  }

  # MySQL access
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.vpc.cidr_block}"]
  }

  ingress {
    from_port   = 33060
    to_port     = 33060
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.vpc.cidr_block}"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "db" {
  name       = "main"
  subnet_ids = aws_subnet.public.*.id

  tags = {
    Name = "db_subnet_group"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage                   = 20
  storage_type                        = "gp2"
  engine                              = "mysql"
  engine_version                      = "5.7"
  instance_class                      = "db.t2.micro"
  name                                = "mydb"
  username                            = "foo"
  password                            = var.db_password
  parameter_group_name                = "default.mysql5.7"
  db_subnet_group_name                = aws_db_subnet_group.db.id
  availability_zone                   = aws_subnet.public[0].availability_zone
  skip_final_snapshot                 = true
  iam_database_authentication_enabled = true
  vpc_security_group_ids              = ["${aws_security_group.database.id}"]
  tags = {
    Name = "database"
  }
}
