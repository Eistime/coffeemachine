require './models/users.rb'
require './models/coffees.rb'
require './models/score_calculator.rb'
require_relative '../controllers/user.rb'
require 'sinatra'

users_model = Users.new DB
coffees_model = Coffees.new DB
score_calculator = ScoreCalculator.new coffees_model

user_controller = UserController.new coffees_model, users_model, score_calculator

get '/user/:id' do
  view_locals = user_controller.get_user params[:id]
  erb :user, :locals => view_locals
end

post '/user/:id' do

  user_controller.register_coffee params
  redirect "/user/#{params[:id]}"

end
