# Configuramos el proveedor de AWS
provider "aws" {
  region = var.region
}

# Creamos un grupo de seguridad
resource "aws_security_group" "sg_fontend" {
  name        = var.sg_name_front
  description = var.sg_description_front
}

resource "aws_security_group_rule" "ingreso" {
  security_group_id = aws_security_group.sg_fontend.id
  type              = "ingress"

  count       = length(var.allowed_ingress_ports_front)
  from_port   = var.allowed_ingress_ports_front[count.index]
  to_port     = var.allowed_ingress_ports_front[count.index]
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Creamos las reglas de salida del grupo de seguridad.
resource "aws_security_group_rule" "salida" {
  security_group_id = aws_security_group.sg_fontend.id
  type              = "egress"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_instance" "frontend" {
  ami             = var.ami_id_front
  instance_type   = var.instance_type_front
  key_name        = var.key_name_front
  security_groups = [aws_security_group.sg_fontend.name]

  tags = {
    Name = var.instance_name_front
  }
}

# Creamos una IP elástica y la asociamos a la instancia
resource "aws_eip" "f" {
  instance = aws_instance.frontend.id
}

# Mostramos la IP pública de la instancia
output "ip_elastica" {
  value = aws_eip.f.public_ip
}
