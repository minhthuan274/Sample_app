class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
     if user.activated?
       log_in user
       params[:session][:remember_me] == "1" ? remember(user) : forget(user)
       redirect_back_or user
     else
       url = edit_account_activation_url(user.activation_token, email: user.email)
       message  = "Account not activated. "
       message += "Check your email for the activation link."
       message += "<%= url %>"
       flash[:warning] = message
       redirect_to root_url
     end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy 
    log_out if logged_in?
    redirect_to root_url
  end
end
