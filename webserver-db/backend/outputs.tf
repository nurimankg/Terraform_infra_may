output "rds_db_password" {
    value = random_password.password.result
    sensitive = true
}

output "rds_db_name" {
    value = aws_db_instance.rds.name
}

output "rds_db_endpoint" {
    value = aws_db_instance.rds.address
}