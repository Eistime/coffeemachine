class Coffees

  def initialize db
    @db = db
  end

  def get_user_coffees user_id
    coffees = []

    @db.execute( "select * from coffees WHERE host_id = #{user_id} OR participant_id = #{user_id} ORDER BY date ASC" ) do |row|
      coffee = row_to_coffee row, user_id
      coffees << coffee
    end
    coffees
  end

  def row_to_coffee row, user_id

    if row[1].to_i == user_id.to_i
    return {:id => row[0], :user_id => row[1], :participant_id => row[2], :date => row[3]}
    end
    {:id => row[0], :user_id => row[2], :participant_id => row[1], :date => row[3]}
  end

  def create user_id, participant_id, date
    @db.execute <<-SQL
        INSERT INTO coffees (host_id, participant_id, date)
        VALUES ("#{user_id}", "#{participant_id}", "#{date}")
    SQL
  end

  def delete(id)
    @db.execute <<-SQL
        DELETE FROM coffees WHERE id = "#{id}";
    SQL
  end

end
