require 'sinatra'
require 'sinatra/activerecord'
require './models'

set :database, "sqlite3:users.sqlite3"
set :sessions, true

########GET DATA#########
get '/' do
	erb :index
end

get '/contact' do
	puts "THE PARAMS ARE !!!!!..."
	puts params.inspect
	erb :contact
end

get '/signup' do
	erb :signup
end

get '/users' do
	@user = User.all
	erb :users
end

get '/welcome' do
	#if session user id is not nil, user @user
	if current_user
		@user = User.find(session[:user_id])
		"Welcome #{current_user.fname}"
	else
		"Please go back to login and login"
	end
end

########POST DATA#########
post '/contact' do
	puts "CONTACT PARAMS ARE ..."
	puts params.inspect
	puts params[:subject]
	erb :index
end

post '/login' do
	#grab a user out of a database check that they've entered the correct password and then log them in.
	#find them based on their username
	username = params[:username]
	password = params[:password]
	@user = User.where(username: username).first
	#checks if the password is correct
	if @user.password == password
		session[:user_id] = @user.id
		redirect '/welcome'
	else
		"LOG IN ERROR!"
	end
end

post '/signup' do
	puts "SIGN UP PARAMS ARE ..."
	puts params.inspect

	# # @new_user = User.create(params[:id])
	# # puts @new_user
	erb :signup
end


########DEF DATA#########
#checks to see if there is a user_id in a session. if there is it returns the current user based on the record on the database
def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end