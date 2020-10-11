
resource mysql_database db {
  name = local.database_name
}

resource mysql_user ghost {
  user               = local.database_username
  plaintext_password = local.database_password
  host               = "%"
}

resource mysql_grant ghost {
  user       = mysql_user.ghost.user
  database   = mysql_database.db.name
  host       = "%"
  privileges = ["ALL"]
}

//resource "mysql_user" "kadamb-test-iam-user" {
//  provider = "mysql.kadamb-test"
//  user = "kadamb_test_user"
//  host = "%"
//  auth_plugin = "AWSAuthenticationPlugin"
//  tls_option = "NONE"
//}