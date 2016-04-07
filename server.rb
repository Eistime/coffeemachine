require 'sinatra'
require 'sqlite3'

DB = SQLite3::Database.new "./sqlite/coffee_machine.db"

require './routes/user.rb'
require './routes/users.rb'
