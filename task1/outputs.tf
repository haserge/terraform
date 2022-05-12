output "aws_vpc_id" {
  value = data.aws_vpc.current.id
}

output "aws_subnets" {
  value = data.aws_subnets.current.ids
}

output "aws_security_groups" {
  value = data.aws_security_groups.current.ids
}
