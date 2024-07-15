require 'bundler/setup'
Bundler.require(:default)

require './lib/comment'
require './lib/user'
require './lib/database'

enable :sessions

Mail.defaults do
    delivery_method :smtp, address: "localhost", port: 1025
end

Database.initialize()

get '/' do
    erb :comments, locals: {comments: Comment.get, user: session[:email]}
end

post '/add-comment' do
    if (session[:email].nil?)
        flash[:error] = "You need to be logged in to comment."
    else
        body = params[:body]
        Comment.add(session[:email], body)
    end
    redirect '/'
end

get '/user-select' do
    erb :users, locals: {users: User.get}
end

get '/user-select/:id' do
    session[:email] = User.get_user_by_id(params[:id])
    redirect '/'
end

get '/log-out' do
    session[:email] = nil
    redirect '/'
end

get '/user-add' do
    erb :useradd
end

post '/user-add' do
    if User.exists(params[:email])
        flash[:error] = "E-mail taken."
        redirect back
    else
        User.add(params[:email], params[:name], params[:password])
        session[:email] = params[:email]
        redirect '/'
    end
end

get '/log-in' do
    erb :login
end

post '/log-in' do
    email = params[:email]
    password = params[:password]
    if !User.exists(email)
        flash[:error] = "Not a valid e-mail address."
        redirect back
    elsif !User.checkpwd(email, password)
        flash[:error] = "Incorrect password."
        redirect back
    end
    session[:email] = params[:email]
    redirect '/'
end

get '/log-in/email' do
    erb :emaillogin
end

post '/login-via-email' do
    secret = "jifjoimyiomiofmesy"
    hash = { "email" => params[:email] }
    body = "http://localhost:4567/login-via-email?hash=#{JWT.encode hash, nil, 'none'}"
    Mail.deliver do
        from     'comments@site.com'
        to       hash["email"]
        subject  'Log in via e-mail'
        body     body
    end
    redirect '/'
end

get '/login-via-email' do
    begin
        hash = JWT.decode params[:hash], nil, false
        email = hash[0]["email"]
        if User.exists(email)
            session[:email] = email
        end
        redirect '/'
    rescue JWT::DecodeError
        flash[:error] = "Invalid login link."
        redirect '/'
    end
end