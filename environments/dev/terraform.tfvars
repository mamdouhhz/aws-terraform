vpc_cidr          = "10.0.0.0/16"
sub_pub_cidr_list = ["10.0.1.0/24", "10.0.3.0/24"]
sub_prv_cidr_list = ["10.0.2.0/24", "10.0.4.0/24"]
region            = "us-east-2"
azs               = ["us-east-2a", "us-east-2b"]

ami               = "ami-0c02fb55956c7d316"
instance_type     = "t2.micro"
key_name          = "mamdouh-key"
private_key_path  = "/Users/mamdouhhazem/mamdouh-key.pem"
