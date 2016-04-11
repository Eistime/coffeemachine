require_relative '../users.rb'
require_relative '../../fixtures/users.rb'

describe Users do

  before(:each) do
    @db = SQLite3::Database.new "./sqlite/coffee_machine_testing.db"
    create_table_users @db
    @users_model = Users.new @db
    @db.execute <<-SQL
        INSERT INTO users (username, password, quote)
        VALUES ("Galactus", "user_password", "How can one such as you help one such as I?"),
                ("Sabertooth", "user_password", "You owe me a scream.");
    SQL
  end

  describe "create()" do
    it "Should create a user with provided data" do
      @users_model.create("Batman", "user_password", "I AM THE GODDAMN BATMAN!!!")
      count = @db.execute("SELECT count(*) FROM users WHERE username = 'Batman' AND password = 'user_password' and quote = 'I AM THE GODDAMN BATMAN!!!'")[0][0]
      expect(count).to eq(1)
    end

    it "Should return the created user" do
      created_user = @users_model.create("Logan", "user_password", "This far I haven't met a problem I could'nt solve with my fist.")
      expected_user_data = {id: 3, username: "Logan", quote: "This far I haven't met a problem I could'nt solve with my fist."}
      expect(created_user).to eq(expected_user_data)
    end

    it "Should return false when duplicated user" do
      created_user = @users_model.create("Galactus", "user_password", "How can one such as you help one such as I?")
      expect(created_user).to eq(false)
    end

  end

  describe "get_list()" do
    it "Should return the list of users" do
      expected_user_list = [{ id: 1, username: 'Galactus', quote: 'How can one such as you help one such as I?'},
                  { id: 2, username: 'Sabertooth', quote: 'You owe me a scream.'}]
      expect(@users_model.get_list).to eq(expected_user_list)
    end
  end

  describe "get()" do
    it "Should return the user id, username and quote by id" do
      user = @users_model.get(1)
      expect(user).to eq({ id: 1, username: 'Galactus', quote: 'How can one such as you help one such as I?'})
    end
  end

  describe "delete()" do
    it "Should delete one user from users" do
      @users_model.delete('2')
      count = @db.execute("SELECT count(*) FROM users WHERE id = '2'")[0][0]
      expect(count).to eq(0)
    end
  end

  describe "edit()" do
    it "Should update user details" do
      @users_model.edit("1", "admin1234")
      count = @db.execute("SELECT count(*) FROM users WHERE id = '1' AND password = 'admin1234'")[0][0]
      expect(count).to eq(1)
    end
  end

end
