require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  erb 'Can you handle a <a href="/secure/place">secret</a>?'
end

get '/login/form' do
  erb :login_form
end

post '/login/form' do
  @login = params[:username]
  @password = params[:password]
  if @login == 'admin' && @password == 'secret'
  session[:identity] = params[:username]
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
  else
   erb 'Доступ запрещен!'
  end
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end

get '/about' do
  erb :about
end

get '/order' do
  erb :order
end

post '/order' do
  username = params[:username]
  phone = params[:phone]
  datetime = params[:datetime]
  master = params[:master]

  output = File.open('./public/order.txt', 'a')
  output.puts "Имя: #{username}, телефон: #{phone}, время визита: #{datetime}, парикмахер: #{master}"
  output.close
  erb "#{username}, будем ждать вас #{datetime}, ваш парикмахер: #{master}"
end

get '/contact' do
  erb :contact  
end




