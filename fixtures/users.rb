require 'SQLite3'

def create_table_users db
  # Create a database
  db.execute <<-SQL
    DROP TABLE IF EXISTS users
  SQL
  rows = db.execute <<-SQL
    create table users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username VARCHAR(255),
      password VARCHAR(255),
      quote VARCHAR(255)
    );
  SQL
end
