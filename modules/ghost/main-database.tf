
resource "mysql_database" "db" {
  name = local.database_name
}

resource "mysql_user" "ghost" {
  user               = local.database_username
  plaintext_password = local.database_password
  host               = "%"
}

resource "mysql_grant" "ghost" {
  user       = mysql_user.ghost.user
  database   = mysql_database.db.name
  host       = "%"
  privileges = ["ALL"]
}
