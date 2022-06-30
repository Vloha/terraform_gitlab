module "Network" {
    source = "./Modules/Network/"
}

module "Bastion_instances" {
    source = "./Modules/Bastion_instances/"
    vpc_id = module.Network.vpc_id
    public_subnet_id = module.Network.PublicBsubnet
}

module "Gitlab_instances" {
    source = "./Modules/Gitlab_instances/"
    vpc_id = module.Network.vpc_id
    public_subnet_id = module.Network.PublicGsubnet
    private_runner_subnet_id = module.Network.PrivateSubnetRunner
    Bastion_runner_privateIP = module.Bastion_instances.BastionRunnerIp
}