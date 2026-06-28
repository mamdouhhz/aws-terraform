vpc_cidr          = "10.20.0.0/16"
sub_pub_cidr_list = ["10.20.0.0/20", "10.20.16.0/20"]
sub_prv_cidr_list = ["10.20.32.0/20", "10.20.48.0/20"]
region            = "us-east-1"
azs               = ["us-east-1a", "us-east-1b"]

ami               = "ami-0c02fb55956c7d316"
instance_type     = "t2.micro"
key_name          = "mamdouh-key"
private_key_path  = "/Users/mamdouhhazem/mamdouh-key.pem"
