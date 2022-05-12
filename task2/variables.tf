variable "aws_region" {
  type = map(any)
  default = {
    "Frankfurt" = "eu-central-1"
  }
}

variable "username" {
  description = "DB username"
}

variable "password" {
  description = "DB password"
}

variable "dbname" {
  description = "DB name"
}
