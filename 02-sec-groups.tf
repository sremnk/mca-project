module "lb_sg" {
  source = "terraform-in-action/sg/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [{
    port        = 443
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

module "websvr_sg" {
  source = "terraform-in-action/sg/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port            = 8000
      security_groups = [module.lb_sg.security_group.id]
    },
    {
      port        = 22
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]
}

module "db_sg" {
  source = "terraform-in-action/sg/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [{
    port            = 3306
    security_groups = [module.websvr_sg.security_group.id]
  },
  {
      port        = 22
      cidr_blocks = ["10.0.0.0/16"]
  }
  ]
}

module "bastion_sg" {
  source = "terraform-in-action/sg/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port        = 22
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}