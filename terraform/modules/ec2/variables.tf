variable "ami_id" {
  description = "amazon machine image id"
  type        = string
}

variable "instance_type" {
  description = "typ ec2 instance"
  type        = string
}

variable "subnet_id" {
  description = "id subnetu"
  type        = string
}

variable "vpc_id" {
  description = "id vpc"
  type        = string
}

variable "key_name" {
  description = "nazev ssh klice"
  type        = string
}

variable "project_name" {
  description = "nazev projektu pro tagy"
  type        = string
}

variable "root_volume_size" {
  description = "velikost root disku (GB)"
  type        = number
}