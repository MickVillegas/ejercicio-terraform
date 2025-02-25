# Terraform

En este ejercicio usaremos terraform para hacer uns infraestructura backend y frontend, para ello he creado tres archivos con extension tf llamadas:
- frontend.tf
- backend.tf
- variables.tf
tabto frontend.tf y backend.tf usan una estructuracion similar, ya que se dividen en "estructuras" que indican el recurso que utilizan, cada recurso tiene un tipo de dato que va a guardar que son:
- crear un grupo de seguridad
- crear un rol de grupo de seguridad
- crear una instancia
- crear una ip
- crear una ip elastica

Para cada recurso se le pone un nombre unico quew los diferencie de otro recuso tanto del mismo archivo y de otros, es decir si a un recurso le llamo "ip_elastica" y en otro recurso de otro archivo que comparte mismo directorio tiene el miosmo nombre terraform se quejará poruqe los nombres son unicos

Para hacer el proyecto más seguro he almacenado la información que terraform necesita para crear las instancias en variables.tf, asique explicaré un recurso y explicaré sus variables.
Por ejemplo en el caso de bacjend.tf he hecho lo siguiente:

Primero decimops que el proovedor es amazon web service y culla region es el norte de virginia
```
provider "aws" {
  region = var.region
}
```
Para llamar a una variable usamos "var.NombreVariable" para que sepa que le estamos pasando una variable del archivo variables.tf, esta variable en el archivo de variables es el siguiente
```
variable "region" {
  description = "Región de AWS donde se creará la instancia"
  type        = string
  default     = "us-east-1"
}
```
Aqui le estamos diciendo que el nombre de la variable es "region" y que: 
- le pasamos una descripcion a la variable con "description"
- le decimos que es de tipo de string en "type"
- le pasamos el valor que guarda la variable en "default" el cual es el norte de virginia
Para crear una variable siempre se usa ese patrón.

Siguiendo con backend.tf la siguiente instruccion es el rol de grupo de seguriodad, usamos dos, uno de ingreso y otro de respuestadonde le decimos lo siguiente:
```
resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.sg_backend.id
  type              = "ingress"

  count       = length(var.allowed_ingress_ports_back)
  from_port   = var.allowed_ingress_ports_back[count.index]
  to_port     = var.allowed_ingress_ports_back[count.index]
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```
Aqui le estamos diciendo que el nombre de la variable que crea el rol de los grupos de seguridad se llama "ingress", que el tipo es de ingreso, que el tipo de protocolo es tcp y que está expuesto a todos los puertos
