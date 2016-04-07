require_relative '../users.rb'
require_relative '../../models/users.rb'
require_relative '../../fixtures/users.rb'

describe UsersController do

  before(:each) do
    @db = SQLite3::Database.new "./sqlite/coffee_machine_testing.db"
    create_table_users @db
    @users_model = Users.new @db
    @users_controller = UsersController.new @users_model

    @db.execute <<-SQL
        INSERT INTO users (username, password)
        VALUES ("Galactus", "user_password"),
                ("Sabertooth", "user_password");
    SQL

  end

  describe "get_users()" do

    it "should return the users list to params" do
      expected_view_values = {users: [{:id => 1, :username=> 'Galactus'},
                                      {:id => 2, :username=> 'Sabertooth'}]}
      expect((@users_controller.get_users)).to eq(expected_view_values)
    end

  end

  describe "get_users_edit()" do

    it "should return the user id and username" do
      params = {"id" => "1"}
      view_values = {:id => 1, :username=> 'Galactus'}
      expect(@users_controller.get_users_edit params).to eq(view_values)
    end

  end

  describe "post_users_edit()" do

    it "should update user password" do
      params = {"id" => "1" , "password" => "new_password"}
      @users_controller.post_users_edit params
      count = @db.execute("SELECT count(*) FROM users WHERE id = '1' AND password = 'new_password'")[0][0]
      expect(count).to eq(1)
    end

  end

  describe "post_users_delete()" do

    it "should delete the selected user" do
      params = {"id" => "1"}
      @users_controller.post_users_delete params
      count = @db.execute("SELECT count(*) FROM users WHERE id = '1'")[0][0]
      expect(count).to eq(0)
    end
  end

  describe "get_users_new()" do

    it "should return user_duplicated and user_created both false" do
      expected_boolean_values = {:user_duplicated => false, :user_created => false}
      expect(@users_controller.get_users_new).to eq(expected_boolean_values)
    end

  end

  describe "post_users_new()" do

    it "Should return user_duplicated false and user_created details" do
      params = {"username" => "Deathstroke", "password" => "deadlypassword"}
      success = @users_controller.post_users_new params

      if count = @db.execute("SELECT count(*) FROM users WHERE username = 'Deathstroke'")[0][0] == 1
        created_user_details = {:id=>3, :username=>"Deathstroke"}
      end

      expected_view_locals = {:user_duplicated => false, :user_created => created_user_details}
      expect(success).to eq(expected_view_locals)
    end

    it "Should return user_duplicated true and user_created false" do
      params = {"username" => "Galactus", "password" => "user_password"}
      success = @users_controller.post_users_new params

      expected_view_locals = {:user_duplicated => true, :user_created => false}
      expect(success).to eq(expected_view_locals)
    end

  end
end
