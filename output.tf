output "mariadb_username" {
  value = aws_db_instance.mariadb.username
}

output "mariadb_password" {
  value = random_string.root_password.result
}

output "mariadb_arn" {
  value = aws_db_instance.mariadb.arn
}

output "mariadb_id" {
  value = aws_db_instance.mariadb.id
}