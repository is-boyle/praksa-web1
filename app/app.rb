require 'sinatra'
require 'sinatra/flash'
require 'amazing_print'
require './lib/comment'
require './lib/user'

enable :sessions

get '/' do
    erb :comments, locals: {comments: Comment::COMMENTS["comments"], user: session[:email]}
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
    erb :users, locals: {users: User::USERS}
end

get '/user-select/:email' do
    session[:email] = params[:email]
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
    User.add(params[:email], params[:name])
    redirect '/user-select'
end