variable "region" {
  description = "Región de AWS donde se creará la instancia"
  type        = string
  default     = "us-east-1"
}

variable "sg_name_front" {
  description = "Nombre del grupo de seguridad"
  type        = string
  default     = "sg_fontend"
}

variable "sg_description_front" {
  description = "Descripción del grupo de seguridad"
  type        = string
  default     = "Grupo de seguridad para la instancia frontend"
}

variable "allowed_ingress_ports_front" {
  description = "Puertos de entrada del grupo de seguridad"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "ami_id_front" {
  description = "Identificador de la AMI"
  type        = string
  default     = "ami-00874d747dde814fa"
}

variable "instance_type_front" {
  description = "Tipo de instancia"
  type        = string
  default     = "t2.small"
}

variable "key_name_front" {
  description = "Nombre de la clave pública"
  type        = string
  default     = "vockey"
}

variable "instance_name_front" {
  description = "Nombre de la instancia"
  type        = string
  default     = "frontend"
}


#backend



variable "sg_name_back" {
  description = "Nombre del grupo de seguridad"
  type        = string
  default     = "sg_backend"
}

variable "sg_description_back" {
  description = "Descripción del grupo de seguridad"
  type        = string
  default     = "Grupo de seguridad para la instancia backend"
}

variable "allowed_ingress_ports_back" {
  description = "Puertos de entrada del grupo de seguridad"
  type        = list(number)
  default     = [3386]
}

variable "ami_id_back" {
  description = "Identificador de la AMI"
  type        = string
  default     = "ami-04b4f1a9cf54c11d0"
}

variable "instance_type_back" {
  description = "Tipo de instancia"
  type        = string
  default     = "t2.medium"
}

variable "key_name_back" {
  description = "Nombre de la clave pública"
  type        = string
  default     = "vockey"
}

variable "instance_name_back" {
  description = "Nombre de la instancia"
  type        = string
  default     = "backend"
}
