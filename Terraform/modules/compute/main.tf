resource "aws_instance" "server" {
  for_each = local.servers

  ami           = var.ami_id
  instance_type = "t3.medium"
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  vpc_security_group_ids = [
    var.security_groups[each.key]
  ]

  iam_instance_profile = each.key == "ansible_master" ? var.iam_instance_profile : null


  associate_public_ip_address = true

  root_block_device {
    volume_size = 25
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = each.value.name
    Role = each.key
  }
}
