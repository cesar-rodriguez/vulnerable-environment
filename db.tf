resource "aws_db_subnet_group" "db" {
  name       = local.prefix.value
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
  vpc_security_group_ids              = [aws_security_group.database.id]
  tags = {
    Name = "${local.prefix.value}-db"
  }
  storage_encrypted = true
}
