module AuthenticatedSystem
protected
  # Returns true or false if the user is logged in.
  # Preloads @current_user with the user model if they're logged in.
  # current_user is a method, not a local variable
  def logged_in?
    facebook_session
  end

  def current_user_id
    facebook_uid
  end

  # Included in the controller to double check if the user is actually logged in
  def admin?
    logged_in? && current_user_id == 'qweq'
  end

  # Check if the user is authorized.
  #
  # Override this method in your controllers if you want to restrict access
  # to only a few actions or if you want to check if the user
  # has the correct rights.
  #
  # Example:
  #
  #  # only allow nonbobs
  #  def authorize?
  #    current_user.username != "bob"
  #  end
  def authorized?
    true
  end

  # Filter method to enforce a login requirement.
  #
  # To require logins for all actions, use this in your controllers:
  #
  #   before_filter :login_required
  #
  # To require logins for specific actions, use this in your controllers:
  #
  #   before_filter :login_required, :only => [ :edit, :update ]
  #
  # To skip this in a subclassed controller:
  #
  #   skip_before_filter :login_required
  #
  def login_required
    logged_in? && authorized? ? true : access_denied
  end

  # Redirect as appropriate when an access request fails.
  #
  # The default action is to redirect to the login screen.
  #
  # Override this method in your controllers if you want to have special
  # behavior in case the user is not authorized
  # to access the requested action.  For example, a popup window might
  # simply close itself.
  def access_denied
    respond_to do |accepts|
      accepts.html do
        store_location
        flash[:notice] = "Sorry we couldn't authenticate you!"
        redirect_to login_path
      end
      accepts.any(:xml, :rss, :json, :text) do
        headers["Status"]           = "Unauthorized"
        headers["WWW-Authenticate"] = %(Basic realm="SoundCloud Password")
        render :text => "<error>Sorry we couldn't authenticate you!</error>", :status => '401 Unauthorized'
      end
    end
    false
  end

  # Store the URI of the current request in the session.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = request.request_uri
  end

  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.
  def redirect_back_or_default(default)
    redirect_to(params[:to] || params[:return_to] || session[:return_to] || default)
    session[:return_to] &&= nil
  end

end
