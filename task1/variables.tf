variable "aws_region" {
  type = map(any)
  default = {
    "Frankfurt" = "eu-central-1"
  }
}
