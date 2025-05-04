resource "aws_instance" "name" {
  ami = var.ami_id
  instance_type = var.instancetype

  tags = {
    Name="dev"
  }
}