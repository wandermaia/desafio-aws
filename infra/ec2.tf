# # Instância na rede privada
# module "ec2-instance-private" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "5.7.1"

#   name = "ec2-private-web-${var.environment}"

#   instance_type          = "t2.micro"
#   subnet_id              = element(module.vpc.private_subnets, 0)
#   vpc_security_group_ids = [aws_security_group.security_group_ec2.id]

#   # Ubuntu 22.04 lts
#   ami      = "ami-084568db4383264d4"
#   key_name = "desafio-aws"

#   # ohio
#   # ami      = "ami-04f167a56786e4b09" # ohio
#   # key_name = "desafio-aws-ohio"

#   create_iam_instance_profile = true
#   iam_role_description        = "IAM role for EC2 instance"
#   iam_role_policies = {
#     AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   }

#   tags = merge(local.tags, {
#     Name = "ec2-private-web-${var.environment}"
#   })
# }








# # instância windows na rede pública
# module "ec2-instance-public" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "5.7.1"

#   name = "ec2-public-windows-${var.environment}"

#   instance_type               = "t3.micro"
#   subnet_id                   = element(module.vpc.public_subnets, 0)
#   vpc_security_group_ids      = [aws_security_group.security_group_ec2.id]
#   associate_public_ip_address = true

#   # Windows Server 2025 
#   ami      = "ami-02e3d076cbd5c28fa"
#   key_name = "desafio-aws"

#   # ohio
#   # ami      = "ami-06f239dc2703bfeb6"
#   # key_name = "desafio-aws-ohio"

#   create_iam_instance_profile = true
#   iam_role_description        = "IAM role for EC2 instance"
#   iam_role_policies = {
#     AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   }

#   tags = merge(local.tags, {
#     Name = "ec2-public-windows-${var.environment}"
#   })
# }




# resource "aws_instance" "instance_a" {

#   instance_type = "t2.micro"
#   subnet_id     = element(module.vpc.private_subnets, 0)
#   ami           = "ami-084568db4383264d4"
#   key_name      = "desafio-aws"
#   iam_instance_profile = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

#   security_groups = [aws_security_group.security_group_ec2.id]

#   user_data = <<-EOF
#              #!/bin/bash
#              sudo apt-get update
#              sudo apt-get install -y nginx
#              sudo systemctl start nginx
#              sudo systemctl enable nginx
#              echo '<!doctype html>
#              <html lang="en"><h1>Home page!</h1></br>
#              <h3>(Instance A)</h3>
#              </html>' | sudo tee /var/www/html/index.html
#              EOF

#   tags = merge(local.tags, {
#     Name = "ec2-private-web-${var.environment}"
#   })

# }