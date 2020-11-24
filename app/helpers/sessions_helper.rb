module SessionsHelper
  
  # Logs in the given User.
  def log_in(user)
    session[:user_id] = User.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    User.remember
    cookies.permanent.encrypted[:user_id] = User.id
    cookies.permanent[:remember_token] = User.remember_token
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && User.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
  end
end
