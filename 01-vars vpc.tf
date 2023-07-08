variable "cidr" {
  type = string
  default = "192.168.0.0/24"
}

variable "azs" {
  type = list(string)
  default = [   "us-west-2a", 
                "us-west-2b", 
                "us-west-2c"    ]
}

variable "subnets-ips" {
  type = list(string)
  default = [   "192.168.0.0/26",
                "192.168.0.64/26",
                "192.168.0.128/26"  ]
}
