helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  
  # Convert a hash to a querystring for form population
  def hash_to_query_string(hash)
    hash.delete "password"
    hash.delete "password_confirmation"
    hash.collect {|k,v| "#{k}=#{v}"}.join("&")
  end

  # Redirect to last page or root
  def redirect_last
    if session[:redirect_to]
      redirect_url = session[:redirect_to]
      session[:redirect_to] = nil
      redirect redirect_url
    else
      redirect "/"
    end  
  end

  # Require login to view page
  def login_required
    if session[:user]
      return true
    else
      flash[:notice] =  "Login required to view this page"
      session[:redirect_to] = request.fullpath
      redirect "/login"
      return false
    end
  end

  def current_user
    return @current_user ||= User.first(:token => request.cookies["user"]) if request.cookies["user"]
    @current_user ||= User.first(:token => session[:user]) if session[:user]
  end

  def logged_in?
    !!session[:user]
  end

  # Pluralize any word (2, post) (5, dice, die)
  def pluralize(n, singular, plural=nil)
    if n == 1 
      "1 #{singular}"
    elsif plural
      "#{n} #{plural}"
    else
      "#{n} #{singular}s"
    end
  end

  # Loads partial view into template. Required vriables into locals
  def partial(template, locals = {})
    erb(template, :layout => false, :locals => locals)
  end

end

# Clear out sessions
at_exit do
  session[:errors] = nil
end
