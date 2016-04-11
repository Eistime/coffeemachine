class Users

  def initialize db
    @db = db
  end

  def get_list
    users = []
    @db.execute( "select * from users" ) do |row|
      users << row_to_user(row)
    end
    users
  end

  def create(new_user, new_user_password, user_quote)

    if (user_exists? new_user)
      return false
    end

    @db.execute <<-SQL
        INSERT INTO users (username, password, quote)
        VALUES ("#{new_user}", "#{new_user_password}", "#{user_quote}")
    SQL

    result = @db.execute <<-SQL
        SELECT * FROM users WHERE username = "#{new_user}";
    SQL

    created_user = row_to_user result[0]
  end

  def row_to_user row
    {:id => row[0], :username => row[1], :quote => row[3]}
  end

  def user_exists? username
    @db.execute("SELECT username FROM users WHERE username = '#{username}'") == [[username]]
  end

  def delete id
    @db.execute <<-SQL
        DELETE FROM users WHERE id = "#{id}";
    SQL
  end

  def edit id, new_password
    @db.execute <<-SQL
        UPDATE users SET password = "#{new_password}" WHERE id = "#{id}";
    SQL
  end

  def get id
    result = @db.execute <<-SQL
        SELECT * FROM users WHERE id = "#{id}";
    SQL
    row_to_user result[0]
  end
end
