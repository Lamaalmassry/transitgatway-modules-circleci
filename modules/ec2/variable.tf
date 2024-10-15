variable "key_name" {
  description = "The name for the SSH key pair."
  type        = string
  default     = "my-key-pair"
}

variable "public_key_path" {
  description = "Path to your public SSH key."
  type        = string
}


variable "vpc_3_subnet_id" {
  description = "The private subnet ID for VPC_1."
  type        = string
}

variable "vpc_2_subnet_id" {
  description = "The private subnet ID for VPC_2."
  type        = string
}

variable "vpc_3_id" {
  
}
variable "vpc_2_id" {
  
}