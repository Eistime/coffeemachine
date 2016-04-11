require_relative '../user.rb'
require_relative '../../models/users.rb'
require_relative '../../fixtures/users.rb'
require_relative '../../models/coffees.rb'
require_relative '../../fixtures/coffees.rb'
require_relative '../../models/score_calculator.rb'


describe UserController do

  before(:each) do
    @db = SQLite3::Database.new "./sqlite/coffee_machine_testing.db"
    create_table_coffees @db
    create_table_users @db
    @coffees_model = Coffees.new @db
    @users_model = Users.new @db
    @score_calculator = ScoreCalculator.new @coffees_model
    @user_controller = UserController.new @coffees_model, @users_model, @score_calculator
    @one_day = 86400;
    @db.execute <<-SQL
        INSERT INTO users (username, password, quote)
        VALUES ("Galactus", "user_password", "How can one such as you help one such as I?"),
                ("Sabertooth", "user_password", "You owe me a scream.");
    SQL

    @db.execute <<-SQL
        INSERT INTO coffees (host_id, participant_id, date)
        VALUES (1, 2, 0),
                (1, 2, #{@one_day});
    SQL

  end

  describe "get_user()" do

    it "should return the username of user_id passed on params" do
      user_id = 1
      expect((@user_controller.get_user user_id)[:username] ).to eq('Galactus')
    end

    it "should return the user quote of user_id passed on params" do
      user_id = 1
      expect((@user_controller.get_user user_id)[:quote]).to eq('How can one such as you help one such as I?')
    end

    it "should return the user score" do
      user_id = 1
      expected_score = 1050
      expect((@user_controller.get_user user_id)[:score] ).to eq(expected_score)
    end

    it "should return the coffees of the user showing participant names" do
      user_id = 1
      expected_coffees = [{:id=>1, :user_id=>1, :participant_id=>2, :date=>0, :participant_name=>"Sabertooth"},
                          {:id=>2, :user_id=>1, :participant_id=>2, :date=>86400, :participant_name=>"Sabertooth"}]
      expect((@user_controller.get_user user_id)[:user_coffees]).to eq(expected_coffees)

    end

    it "should return the participants without the current user" do
      user_id = 1
      participants = [{id: 2, username: "Sabertooth", quote: 'You owe me a scream.'}]
      expect((@user_controller.get_user user_id)[:participants]).to eq(participants)

    end

  end

  describe "register_coffee()" do
    it "should create a coffee with provided data" do

      params = {"participant"=>"2", "date"=>"2016-04-06", "id"=>"1"}

      @user_controller.register_coffee params
      count = @db.execute("SELECT count(*) FROM coffees WHERE id = 3")[0][0]
      expect(count).to eq(1)
    end
  end

end
