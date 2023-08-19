 locals {
      DB_IP      = aws_instance.db_server.private_ip
 }

resource "aws_launch_template" "template" {
  name                  = "group11-ec2-template"
  image_id               = "ami-08a52ddb321b32a8c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.websvr_sg.security_group.id]
  ebs_optimized          = false #t2.micro doesn;t support
  update_default_version = true
  #user_data              = filebase64("http.sh")
  user_data     = base64encode(templatefile("${path.module}/http.yaml", {
    DB_IP = local.DB_IP
  }))
  key_name               = "group11-key"


  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "group11-webserver"
    }
  }
}


resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "centos" {
  key_name   = "group11-key"
  public_key = "${tls_private_key.example.public_key_openssh}"
}

resource "local_file" "cloud_pem" { 
  filename = "${path.module}/group11-key.pem"
  content = tls_private_key.example.private_key_pem
}