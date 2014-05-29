require_relative 'server_methods'
require 'sinatra'

get '/' do
  @articles = get_articles()
  @index = 0
  erb :index
end


get '/submit' do
  erb :submit
end

post '/submit' do
  title = params["title"]
  url = params["url"]
  description = params["description"]
  redirect "/"
end

get '/new_user' do
  erb :new_user
end

post '/new_user' do
  @name = params["user_name"]
  @password = params["password"]
  @email = params["email"]
  @create = new_user(@name, @password, @email)
  if !@create
    #display error message
    erb :'/new_user'
  else
    redirect "/"
  end
end

