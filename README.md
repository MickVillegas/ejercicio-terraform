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
Aqui le estamos diciendo que el nombre de la variable que crea el rol de los grupos de seguridad se llama "ingress", que el tipo es de ingreso, que el tipo de protocolo es tcp y que está expuesto a todos los puertos, en "count" asta "to_port" pasa lo siguiente, si te fijas ñe estamos pasando variables con un index, y es que en el archivo de variables hemos creado lo siguiente
```
variable "allowed_ingress_ports_back" {
  description = "Puertos de entrada del grupo de seguridad"
  type        = list(number)
  default     = [3386]
}
```
El tipo de variable es una lista cullo valor guarda una lista de datos, entonces podemos comprender que el recurso está recorriendo cada dato de la lista como si de un for se tratara donde:
- count crea multibles instancias segun el numero de elementos de la lista
- ength(var.allowed_ingress_ports_back) es la longitud de la lista
- from_port  va a recorrer desde el primer puerto de la lista
- to_port es el ultimo elemento dfe la lista
- var.allowed_ingress_ports_back[count.index] esd el index actual de la lista, o mejor dico el puerto actual que se encuentra en el index actual de la lista

Despues dfe este recurso creamos el siguiente que son las reglas de salida: 
```
resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.sg_backend.id
  type              = "egress"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
```

El siguiente recurso es la ami que utiliza la instancia el cual es el siguiente
```
resource "aws_instance" "backend" {
  ami             = var.ami_id_back
  instance_type   = var.instance_type_back
  key_name        = var.key_name_back
  security_groups = [aws_security_group.sg_backend.name]

  tags = {
    Name = var.instance_name_back
  }
}
```
Aqui indicamos que el tipo de recurso es aws_instance y que se llama backend, en el:
- indicamos la ami de la instancia con ami
- decimos el tipo de instancia
- le damos el nombre de la key
- y mostramos cual es el grupo de seguridad que hemos creado en la instancia el cual se indica con [aws_security_group.sg_backend.name] donde sg_backend es literalmente el nombre del recurso del gurupo de seguridad que hemos creado antes, .name coje el nombre

Las variables que hemos creado para este recurso son los siguientes 
```
variable "ami_id_back" {
  description = "Identificador de la AMI"
  type        = string
  default     = "ami-04b4f1a9cf54c11d0"
}
```
Para ponerle el nombre de la ami he hecho lo siguiente
imagenes
```
variable "instance_type_back" {
  description = "Tipo de instancia"
  type        = string
  default     = "t2.medium"
}
```
Esta variable guarda el tipo de instancia, en este caso vamos a crear uno t2.medium
```
variable "key_name_back" {
  description = "Nombre de la clave pública"
  type        = string
  default     = "vockey"
}
```
Aquí seleccionamos el par de claves de la instancia, en este caso es vockey
```
variable "instance_name_back" {
  description = "Nombre de la instancia"
  type        = string
  default     = "backend"
}
```
Esta variable guarda el nombre de la instancia, en este caso lo vamos a llamar backend

Por ultimo en nuestro archivo backend.tf vamos a crear dos recursos para crear una ip elastica y para asociarlo a nuestra instancia, lo hacemos de la siguiente manera
```
resource "aws_eip" "b" {
  instance = aws_instance.backend.id
}
```
En este recurso creamos la ip elastica indicandole quie la instancia a la que la vamos a asociar es a backend, el .id coge la id de la instancia
# Mostramos la IP pública de la instancia
```
output "elastic_ip" {
  value = aws_eip.b.public_ip
}
```
Por ultimo mostramos la ip publica de la instancia 

con lo cual El archivo backend.tf deberia verse asi
imagenes


