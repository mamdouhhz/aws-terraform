vpc_cidr          = "172.16.0.0/16"
sub_pub_cidr_list = ["172.16.1.0/24", "172.16.2.0/24"]
sub_prv_cidr_list = ["172.16.10.0/24", "172.16.11.0/24"]
region            = "us-east-2"
azs               = ["us-west-2a", "us-west-2b"]

ami               = "ami-0c02fb55956c7d316"
instance_type     = "t2.micro"
key_name          = "mamdouh-key"
private_key_path  = "/Users/mamdouhhazem/mamdouh-key.pem"