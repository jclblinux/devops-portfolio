variable "project_name" {
  description = "nazev projektu"
  type        = string
}

variable "vpc_cidr" {
  description = "cidr blok VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "cidr blok subnetu"
  type        = string
}

variable "availability_zone" {
  description = "zona"
  type        = string
}