require_relative 'server_methods'
require 'sinatra'
require 'pry'

enable :sessions

get '/' do
  @user_id = session["user_id"]
  @articles = get_articles()
  @index = 0
  erb :index
end

get '/articles' do
  redirect '/'
end

get '/login' do
  @success = true
  erb :login
end

post '/login' do
  user_name = params["user_name"]
  password = params["password"]
  user_id, success = login(user_name,password)
  session["user_id"] = user_id
  @success = success
  if success
    redirect "/"
  else
    erb :'/login'
  end
end

get '/articles/new' do
  @user_id = session["user_id"]
  erb :submit
end

post '/articles/new' do
  title = params["title"]
  url = params["url"]
  description = params["description"]
  @user_id = session["user_id"]
  if @user_id != nil
    new_article(title, url, description, user_id)
    redirect "/"
  else
    erb :'/articles/new'
  end
end

get '/new_user' do
  erb :new_user
end

post '/new_user' do
  name = params["user_name"]
  password = params["password"]
  email = params["email"]
  @create = new_user(name, password, email)
  if !@create
    #display error message
    erb :'/new_user'
  else
    redirect "/"
  end
end

