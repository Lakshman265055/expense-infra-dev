resource "aws_key_pair" "openvpn" {
  key_name = "openvpn"
  public_key = file("~/.ssh/openvpn.pub")
}



# module "vpn" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   key_name = aws_key_pair.openvpn.key_name
#   ami = data.aws_ami.joindevops.id
#   name = local.resource_name
  
#   create_security_group    = false
#   instance_type = "t3.micro"
#   vpc_security_group_ids = [local.vpn_sg_id]
#   subnet_id     = local.public_subnet_id

#   tags = merge(
# var.common_tags,
# var.vpn_tags,
# {
#   Name = local.resource_name
# }
#   )
# }

# resource "aws_key_pair" "openvpn" {
#   key_name = "openvpn"
#   public_key = file("/.ssh/openvpn.pub")
# }


resource "aws_instance" "vpn" {
  ami           = data.aws_ami.joindevops.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.vpn_sg_id]
  subnet_id = local.public_subnet_id
  #key_name = "daws-84s" # make sure this key exist in AWS
  key_name = aws_key_pair.openvpn.key_name
  user_data = file("openvpn.sh")

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}

resource "aws_route53_record" "vpn" {
  zone_id = var.zone_id
  name    = "vpn-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.vpn.public_ip]
  allow_overwrite = true
}