class ScoreCalculator

  attr_reader :max_score
  attr_reader :min_score

  def initialize coffees_model
    @coffees_model = coffees_model
    @max_score = 1000
    @min_score = 50
    @one_day = 86400
  end


  def user_score user_id

    user_id = user_id
    score = 0
    users_already_spoken_with = []
    coffees = @coffees_model.get_user_coffees user_id

    coffees.each do |coffee|

      if !users_already_spoken_with.include? coffee[:participant_id]
        score += @max_score
        users_already_spoken_with << coffee[:participant_id]
        next
      end


      if users_already_spoken_with.include? coffee[:participant_id]
        previous_coffee = previous_coffee(coffees, coffee)
        seconds_since_last_coffee = coffee[:date] - previous_coffee[:date]

        days = (seconds_since_last_coffee / @one_day)
        days = 1 if days == 0

        points_to_add = days * @min_score
        score += Score_clampdown points_to_add
      end
    end
    score
  end

  def previous_coffee coffees, coffee

    coffees.reverse.each do |a_previous_coffee|

      same_participant = a_previous_coffee[:participant_id] == coffee[:participant_id]
      previous_or_same_day = a_previous_coffee[:date] <= coffee[:date]
      not_the_same_coffe = a_previous_coffee[:id] != coffee[:id]

      if previous_or_same_day && same_participant && not_the_same_coffe
        return a_previous_coffee
      end

    end

  end

  def Score_clampdown points_to_add
    if points_to_add > @max_score
      points_to_add = @max_score
      return points_to_add
    end
    points_to_add
  end

end
