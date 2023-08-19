resource "aws_instance" "db_server" {
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.database_subnets[0]
  key_name = "group11-key"
  user_data   =  base64encode(templatefile("${path.module}/db.yaml", {
    
  }))
  vpc_security_group_ids = [module.db_sg.security_group.id]

  tags = {
    Name = "group11-database"
  }
  depends_on = [
    module.vpc
  ]
}