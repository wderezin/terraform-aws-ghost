
output database_info {
  value = {
    DATABASE_NAME = mysql_database.db.name
    DATABASE_USER = mysql_user.ghost.user
  }
}