require_relative 'server_methods'
require 'sinatra'

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
  erb :login
end

get '/logout' do
  session.clear
  redirect '/'
end

post '/login' do
  user_name = params["user_name"]
  password = params["password"]
  user_id, @success = login(user_name,password)
  session["user_id"] = user_id
  if @success == 1
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
    new_article(title, url, description, @user_id)
    redirect "/"
  else
    erb :'submit'
  end
end

get '/new_user' do
  erb :new_user
end

post '/new_user' do
  @name = params["new_user"]
  @password = params["password"]
  @email = params["email"]
  @confirm = params["password_confirm"]
  @create = new_user(@name, @password, @email)
  if @confirm != @password || @create == 0
    #display error message
    erb :'/new_user'
  else
    redirect "/"
  end
end

