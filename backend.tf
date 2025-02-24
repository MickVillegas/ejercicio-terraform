# Creamos un grupo de seguridad
resource "aws_security_group" "sg_backend" {
  name        = var.sg_name_back
  description = var.sg_description_back
}

resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.sg_backend.id
  type              = "ingress"

  count       = length(var.allowed_ingress_ports_back)
  from_port   = var.allowed_ingress_ports_back[count.index]
  to_port     = var.allowed_ingress_ports_back[count.index]
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Creamos las reglas de salida del grupo de seguridad.
resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.sg_backend.id
  type              = "egress"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_instance" "backend" {
  ami             = var.ami_id_back
  instance_type   = var.instance_type_back
  key_name        = var.key_name_back
  security_groups = [aws_security_group.sg_backend.name]

  tags = {
    Name = var.instance_name_back
  }
}

# Creamos una IP elástica y la asociamos a la instancia
resource "aws_eip" "b" {
  instance = aws_instance.backend.id
}

# Mostramos la IP pública de la instancia
output "elastic_ip" {
  value = aws_eip.b.public_ip
}


