module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  
  ami = data.aws_ami.joindevops.id
  name = local.resource_name
  
  create_security_group    = false
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  subnet_id     = local.private_subnet_id

  tags = merge(
var.common_tags,
var.backend_tags,
{
  Name = local.resource_name
}
  )
}

resource "null_resource" "backend" {
  triggers = {
    instance_id = module.backend.id
  }

  connection {
    host = module.backend.private_ip
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
  }

   provisioner "file" {
   source = "${var.backend_tags.component}.sh"
   destination = "/tmp/backend.sh"
   }  

  provisioner "remote-exec" {
    inline = [ 
    "chmod +x /tmp/backend.sh",
    "sudo sh /tmp/backend.sh ${var.backend_tags.component} ${var.environment}"
    
    ]

    
  }
   
  }


  resource "aws_ec2_instance_state" "backend" {
   instance_id = module.backend.id
   state = "stopped"
   depends_on = [null_resource.backend]    
  }
   resource "aws_ami_from_instance" "backend" {
    name = local.resource_name
    source_instance_id = module.backend.id
    depends_on = [ aws_ec2_instance_state.backend ]
     
   }


   resource "null_resource" "backend_delete" {
  triggers = {
    instance_id = module.backend.id
  }

  provisioner "local-exec" {
  
  command = "aws ec2 terminate-instances --region us-east-1 --instance-ids ${module.backend.id}"
    
  }
   depends_on = [ aws_ami_from_instance.backend ]
  }

  resource "aws_lb_target_group" "backend" {
    name = local.resource_name
    port = 8080
    protocol = "HTTP"
    vpc_id = local.vpc_id

    health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      interval = 5
      matcher = "200-299"
      path = "/health"
      port = 8080
      protocol = "HTTP"
      timeout = 4


    }
    
  }

resource "aws_launch_template" "backend" {
  name = local.resource_name
  image_id = aws_ami_from_instance.backend.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  update_default_version = true
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.resource_name
    }
  }
}














