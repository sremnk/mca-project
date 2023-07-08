resource "aws_launch_template" "template" {
  name                  = "ec2-template"
  image_id               = "ami-0507f77897697c4ba"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sg1.id}", "${aws_security_group.sg2.id}"]
  ebs_optimized          = false #t2.micro doesn;t support
  update_default_version = true
  user_data              = filebase64("http.sh")
  key_name               = "demo-key"

  # block_device_mappings {
  #   device_name = "/dev/sda1"

  #   ebs {
  #     volume_size           = 12
  #     delete_on_termination = true
  #     volume_type           = "gp2"
  #   }
  # }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "test"
    }
  }
}


resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "centos" {
  key_name   = "demo-key"
  public_key = "${tls_private_key.example.public_key_openssh}"
}

resource "local_file" "cloud_pem" { 
  filename = "${path.module}/demo-key.pem"
  content = tls_private_key.example.private_key_pem
}