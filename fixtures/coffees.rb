require 'SQLite3'

def create_table_coffees db
  # Create a database
  db.execute <<-SQL
    DROP TABLE IF EXISTS coffees
  SQL
  rows = db.execute <<-SQL
    create table coffees (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      host_id INTEGER,
      participant_id INTEGER,
      date INTEGER
    );
  SQL
end
