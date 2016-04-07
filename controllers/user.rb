class UserController

  def initialize coffees_model, users_model, score_calculator
    @coffees_model = coffees_model
    @users_model = users_model
    @score_calculator = score_calculator
  end

  def get_user user_id

    user = @users_model.get user_id
    score = @score_calculator.user_score user_id
    user_coffees = @coffees_model.get_user_coffees user_id
    users = @users_model.get_list
    participants = users.delete_if { |user| user_id.to_i == user[:id] }

    user_coffees.each do |coffee|

      coffee.merge!(participant_name: participants.find { |participant| participant[:id] == coffee[:participant_id]}[:username])

    end

    user_data = {
      username: user[:username],
      score: score,
      user_coffees: user_coffees,
      participants: participants
    }

    user_data

  end

  def register_coffee params

    @coffees_model.create params['id'], params['participant'], date = Time.parse(params['date']).to_time.to_i

  end


end
