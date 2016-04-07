require_relative '../coffees.rb'
require_relative '../../fixtures/coffees.rb'


describe Coffees do

  before(:each) do
    @db = SQLite3::Database.new "./sqlite/coffee_machine_testing.db"
    create_table_coffees @db
    @coffees_model = Coffees.new @db
    @one_day = 86400
    @db.execute <<-SQL
        INSERT INTO coffees (host_id, participant_id, date)
        VALUES (1, 2, 0),
                (1, 2, #{@one_day});
    SQL
  end

  describe "get_user_coffees()" do
    it "Should return user coffees ordered by date" do
      @coffees_model.create(1, 2, 2)
      expected_coffees = [{ id: 1, user_id: 1, participant_id: 2,  date: 0},
                          { id: 3, user_id: 1, participant_id: 2,  date: 2},
                          { id: 2, user_id: 1, participant_id: 2, date: @one_day}]
      expect(@coffees_model.get_user_coffees(1)).to eq(expected_coffees)
    end

  end

  describe "create()" do
    it "Should create a coffee with provided data" do
      @coffees_model.create(1, 2, 1457379281)
      count = @db.execute("SELECT count(*) FROM coffees WHERE id = 3")[0][0]
      expect(count).to eq(1)
    end
  end

  describe "delete()" do
    it "Should delete a coffee with provided id" do
      @coffees_model.delete(1)
      count = @db.execute("SELECT count(*) FROM coffees WHERE id = 1")[0][0]
      expect(count).to eq(0)
    end
  end
end
