require 'SQLite3'
require_relative './users.rb'
require_relative './coffees.rb'

# test_db = SQLite3::Database.new "./sqlite/coffee_machine_testing.db"
db = SQLite3::Database.new "./sqlite/coffee_machine.db"

create_table_users db
create_table_coffees db
# create_table_users test_db
# create_table_coffees test_db
