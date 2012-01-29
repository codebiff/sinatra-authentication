get "/" do
  erb :index
end

get "/signup" do
  erb :signup
end

post "/signup" do
  user = User.create(params[:user])
  user.password_salt = BCrypt::Engine.generate_salt
  user.password_hash = BCrypt::Engine.hash_secret(params[:user][:password], user.password_salt)
  if user.save
    flash[:info] = "Thank you for registering #{user.email}" 
    session[:user] = user.id
    redirect "/" 
  else
    session[:errors] = user.errors.full_messages
    redirect "/signup?" + hash_to_query_string(params[:user])
  end
end

get "/login" do
  if session[:user]
    redirect_last
  else
    erb :login
  end
end

post "/login" do
  if user = User.first(:email => params[:email])
    if user.password_hash == BCrypt::Engine.hash_secret(params[:password], user.password_salt)
    session[:user] = user.id 
    response.set_cookie "user", {:value => user.id, :expires => (Time.now + 52*7*24*60*60)} if params[:remember_me]
    redirect_last
    else
      flash[:error] = "Email/Password combination does not match"
      redirect "/login?email=#{params[:email]}"
    end
  else
    flash[:error] = "That email address is not recognised"
    redirect "/login?email=#{params[:email]}"
  end
end

get "/logout" do
  flash[:info] = "Successfully logged out"
  response.delete_cookie "user"
  session[:user] = nil
  redirect "/"
end

get "/secret" do
  login_required
  "This is a secret secret"
end

