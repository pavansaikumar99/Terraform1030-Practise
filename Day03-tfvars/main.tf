resource "aws_instance" "dev" {
  ami = var.ami_id
  instance_type = var.instancetype
}


resource "aws_instance" "test" {
  ami = var.ami_id
  instance_type = var.instancetype
}


