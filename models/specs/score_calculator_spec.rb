require_relative '../score_calculator.rb'
require_relative '../coffees.rb'

require_relative '../../fixtures/coffees.rb'

describe ScoreCalculator do

  before(:each) do
    @one_day = 86400;
    @db = SQLite3::Database.new "./sqlite/coffee_machine_testing.db"
    create_table_coffees @db

    coffees_model = Coffees.new @db
    @score_calculator = ScoreCalculator.new coffees_model
  end

  describe "user_score()" do
    describe "when talking with someone for the first time ever" do
      it "it adds the maximum points" do
        @db.execute "INSERT INTO coffees (host_id, participant_id, date) VALUES (1, 2, 0)"
        expect(@score_calculator.user_score 1).to eq(@score_calculator.max_score)
      end

      it "it adds the maximum points also for other persons" do
        @db.execute "INSERT INTO coffees (host_id, participant_id, date) VALUES (1, 2, 0)"
        @db.execute "INSERT INTO coffees (host_id, participant_id, date) VALUES (1, 3, 0)"
        expect(@score_calculator.user_score 1).to eq(@score_calculator.max_score * 2)
      end
    end

    describe "next times you speak with someone" do

      it "gives you min points times days since last time" do
        @db.execute "INSERT INTO coffees (host_id, participant_id, date) VALUES (1, 2, 0)"
        @db.execute "INSERT INTO coffees (host_id, participant_id, date) VALUES (1, 2, 0)"

        expected_score = (@score_calculator.max_score) + (@score_calculator.min_score)

        expect(@score_calculator.user_score 1).to eq(expected_score)
      end

      it "gives you min points times days since last time" do
        two_days = @one_day * 2;
        @db.execute "INSERT INTO coffees (host_id, participant_id, date) VALUES (1, 2, 0)"
        @db.execute "INSERT INTO coffees (host_id, participant_id, date) VALUES (1, 3, 0)"
        @db.execute "INSERT INTO coffees (host_id, participant_id, date) VALUES (1, 2, #{two_days})"
        @db.execute "INSERT INTO coffees (host_id, participant_id, date) VALUES (1, 3, #{two_days})"

        expected_score = (@score_calculator.max_score * 2) + (@score_calculator.min_score * 4)

        expect(@score_calculator.user_score 1).to eq(expected_score)
      end
    end

    describe "when you didn't talk for a very long time with someone" do
      it "gives you points never exceeding the max score limit" do
        two_hundred_days = @one_day * 200;
        @db.execute "INSERT INTO coffees (host_id, participant_id, date) VALUES (1, 2, 0)"
        @db.execute "INSERT INTO coffees (host_id, participant_id, date) VALUES (1, 2, #{two_hundred_days})"

        expected_score = (@score_calculator.max_score * 2)

        expect(@score_calculator.user_score 1).to eq(expected_score)
      end

    end

  end

  describe "previous_coffee" do
    it "should return the previous coffee" do
      coffees = [{:id => 1, :user_id => 1, :participant_id => 2, :date => 0},
                 {:id => 2, :user_id => 1, :participant_id => 3, :date => @one_day},
                 {:id => 3, :user_id => 1, :participant_id => 2, :date => @one_day * 3},
                 {:id => 4, :user_id => 1, :participant_id => 3, :date => @one_day * 4},
                 {:id => 5, :user_id => 1, :participant_id => 2, :date => @one_day * 4},
                 {:id => 6, :user_id => 1, :participant_id => 3, :date => @one_day * 9}]
      coffee = coffees[5]
      expected_coffee = coffees[3]
      expect(@score_calculator.previous_coffee(coffees, coffee)).to eq(expected_coffee)
    end

    it "should return the prevous coffee" do
      coffees = [{:id => 1, :user_id => 1, :participant_id => 2, :date => 0},
                 {:id => 2, :user_id => 1, :participant_id => 2, :date => 0}]
      coffee = coffees[1]
      expected_coffee = coffees[0]
      expect(@score_calculator.previous_coffee(coffees, coffee)).to eq(expected_coffee)
    end
  end

end
