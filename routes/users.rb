require 'sinatra'
require './models/users.rb'
require_relative '../controllers/users.rb'

users_model = Users.new DB
users_controller = UsersController.new users_model

get '/users' do

  view_locals = users_controller.get_users
  erb :users, :locals => view_locals

end

get '/users/edit/:id' do

  view_locals = users_controller.get_users_edit params
  erb :edit, :locals => view_locals

end

post '/users/edit/:id' do

  users_controller.post_users_edit params
  redirect '/users'

end

post '/users/delete/:id' do

  users_controller.post_users_delete params
  redirect '/users'

end

get '/users/new' do
  view_locals = users_controller.get_users_new
  erb :new, :locals => view_locals
end

post '/users/new' do

  view_locals = users_controller.post_users_new params
  erb :new, :locals => view_locals

end
