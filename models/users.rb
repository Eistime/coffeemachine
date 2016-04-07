class Users

  def initialize db
    @db = db
  end

  def get_list
    users = []
    @db.execute( "select id, username from users" ) do |row|
      user = row_to_user row
      users << user
    end
    users
  end

  def create(new_user, new_user_password)

    if (user_exists? new_user)
      return false
    end

    @db.execute <<-SQL
        INSERT INTO users (username, password)
        VALUES ("#{new_user}", "#{new_user_password}")
    SQL

    result = @db.execute <<-SQL
        SELECT id, username FROM users WHERE username = "#{new_user}";
    SQL

    created_user = row_to_user result[0]
  end

  def row_to_user row
    {:id => row[0], :username => row[1]}
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
