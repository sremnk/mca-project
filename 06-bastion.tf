resource "aws_instance" "bastion_server" {
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[0]
  key_name = "group11-key"
  #user_data   = filebase64("db.sh")
  vpc_security_group_ids = [module.bastion_sg.security_group.id]

  tags = {
    Name = "group11-bastion"
  }
}